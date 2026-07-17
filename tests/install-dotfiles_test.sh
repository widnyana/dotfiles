#!/usr/bin/env bash
#──────────────────────────────────────────────────────────────────────────────
# Hermetic regression suite for bin/install-dotfiles.sh.
#
# Runs the installer against a throwaway sandbox (temporary HOME + a minimal
# repo fixture) with every external command stubbed (brew, dnf, sudo, git, curl,
# go, mise, uname). No real network, package manager, or installer is invoked.
#
#   bash tests/install-dotfiles_test.sh
#
# Exits nonzero if any scenario fails.

#: ── Tiny test framework ─────────────────────────────────────────────────────
PASS=0
FAIL=0

ok()   { printf '  \033[32mPASS\033[0m %s\n' "$1"; PASS=$((PASS + 1)); }
bad()  { printf '  \033[31mFAIL\033[0m %s\n' "$1"; FAIL=$((FAIL + 1)); }

assert_rc()        { if [[ "$2" == "$3" ]]; then ok "$1"; else bad "$1 (rc=$2 want=$3)"; fi; }
assert_symlink_to() { # name target label
  local name="$1" target="$2" label="$3"
  if [[ -L "$name" && "$(readlink "$name")" == "$target" ]]; then ok "$label"
  else bad "$label (got: $(readlink "$name" 2>/dev/null || echo 'not a symlink'))"; fi
}
assert_exists()    { if [[ -e "$2" || -L "$2" ]]; then ok "$1"; else bad "$1 (missing: $2)"; fi; }
assert_absent()    { if [[ ! -e "$2" && ! -L "$2" ]]; then ok "$1"; else bad "$1 (present: $2)"; fi; }
assert_match()     { if printf '%s' "$2" | grep -qE -- "$3"; then ok "$1"; else bad "$1 (no match for /$3/)"; fi; }
assert_no_match()  { if ! printf '%s' "$2" | grep -qE -- "$3"; then ok "$1"; else bad "$1 (unexpected match /$3/)"; fi; }

#: ── Paths ──────────────────────────────────────────────────────────────────
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALLER="$ROOT/bin/install-dotfiles.sh"
STUBS="$(mktemp -d)/stubs"
mkdir -p "$STUBS"

#: ── Build command stubs (once) ─────────────────────────────────────────────
#: Control surface — touch a file under $SANDBOX/ctl/ to force a stub outcome:
#:   fzf_fail / zshcomp_fail / ohmyzsh_fail / brew_fail / brew_pkg_fail /
#:   rust_fail / vimplug_fail / mise_fail / dnf_fail / go_fail   -> step fails
#:   sudo_ok        -> sudo preflight passes AND sudo -n <cmd> runs (else fail-fast)
#:   mise_fail_<id> -> that one mise tool install fails
#:   mise_ls_fail   -> `mise ls` exits 1 (discovery failure)
#:   mise_ls_output -> replaces the default `mise ls` text
build_stubs() {
  cat > "$STUBS/uname" <<'EOF'
#!/usr/bin/env bash
echo "${TEST_UNAME:-Darwin 25.0.0}"
EOF

  cat > "$STUBS/git" <<'EOF'
#!/usr/bin/env bash
if [[ "$1" == "ls-files" ]]; then
  # emulate a registered gitlink (mode 160000) for the themes submodule so
  # init_submodule proceeds to the (stubbed) update instead of failing fast.
  case "$*" in
    *config/alacritty/themes*)
      echo "160000 0000000000000000000000000000000000000000 0	config/alacritty/themes" ;;
  esac
  exit 0
fi
if [[ "$1" == "submodule" ]]; then
  # git submodule update --init <path>  ->  populate $4 (relative to cwd)
  mkdir -p "$4" && touch "$4/.populated" && exit 0
fi
if [[ "$1" == "clone" ]]; then
  dest="${@: -1}"
  case "$*" in
    *junegunn/fzf*)
      [[ -e "$SANDBOX/ctl/fzf_fail" ]] && exit 1
      mkdir -p "$dest"
      printf '#!/usr/bin/env bash\nexit 0\n' > "$dest/install"
      chmod +x "$dest/install"; exit 0 ;;
    *zsh-completions*)
      [[ -e "$SANDBOX/ctl/zshcomp_fail" ]] && exit 1
      mkdir -p "$dest"; exit 0 ;;
    *) mkdir -p "$dest"; exit 0 ;;
  esac
fi
exit 0
EOF

  cat > "$STUBS/curl" <<'EOF'
#!/usr/bin/env bash
case "$*" in
  *ohmyzsh*ohmyzsh*)    [[ -e "$SANDBOX/ctl/ohmyzsh_fail" ]] && exit 1 ;;
  *Homebrew/install*)   [[ -e "$SANDBOX/ctl/brew_fail" ]] && exit 1 ;;
  *sh.rustup.rs*)       [[ -e "$SANDBOX/ctl/rust_fail" ]] && exit 1 ;;
  *vim-plug*plug.vim*)  [[ -e "$SANDBOX/ctl/vimplug_fail" ]] && exit 1 ;;
  *mise.jdx.dev*)       [[ -e "$SANDBOX/ctl/mise_fail" ]] && exit 1 ;;
esac
exit 0
EOF

  cat > "$STUBS/brew" <<'EOF'
#!/usr/bin/env bash
[[ -e "$SANDBOX/ctl/brew_pkg_fail" ]] && exit 1
exit 0
EOF

  cat > "$STUBS/dnf" <<'EOF'
#!/usr/bin/env bash
echo "dnf $*" >> "$SANDBOX/ctl/dnf_log"
[[ -e "$SANDBOX/ctl/dnf_fail" ]] && exit 1
exit 0
EOF

  cat > "$STUBS/sudo" <<'EOF'
#!/usr/bin/env bash
if [[ "$1" == "-n" ]]; then
  shift
  if [[ "$1" == "true" ]]; then
    # preflight probe (sudo -n true): respect sudo_ok
    [[ -e "$SANDBOX/ctl/sudo_ok" ]] && exit 0 || exit 1
  fi
  # sudo -n <cmd>: fail fast (no hang) when creds are not cached
  [[ -e "$SANDBOX/ctl/sudo_ok" ]] || exit 1
  [[ -e "$SANDBOX/ctl/dnf_fail" ]] && exit 1
  "$@"; exit $?
fi
[[ -e "$SANDBOX/ctl/dnf_fail" ]] && exit 1
"$@"
EOF

  cat > "$STUBS/go" <<'EOF'
#!/usr/bin/env bash
[[ -e "$SANDBOX/ctl/go_fail" ]] && exit 1
exit 0
EOF

  cat > "$STUBS/mise" <<'EOF'
#!/usr/bin/env bash
if [[ "$1" == "completion" ]]; then
  echo "# fake mise completions"; exit 0
fi
if [[ "$1" == "ls" ]]; then
  [[ -e "$SANDBOX/ctl/mise_ls_fail" ]] && exit 1
  if [[ "$2" == "--missing" ]]; then
    # tools configured but not installed. Default: all declared are "missing"
    # (preserves existing scenarios). mise_missing_output overrides to model
    # a machine where some tools are already installed (and thus skipped).
    cat "$SANDBOX/ctl/mise_missing_output" 2>/dev/null || \
      printf 'helm   3.16\ngo     1.23\nrust   1.97\n'
    exit 0
  fi
  cat "$SANDBOX/ctl/mise_ls_output" 2>/dev/null || \
    printf 'Tool   Version  Source\nhelm   3.16     cfg\ngo     1.23     cfg\nrust   1.97     cfg\n'
  exit 0
fi
if [[ "$1" == "install" ]]; then
  [[ -e "$SANDBOX/ctl/mise_fail_$2" ]] && exit 1
  exit 0
fi
exit 0
EOF

  cat > "$STUBS/xcode-select" <<'EOF'
#!/usr/bin/env bash
exit 1
EOF

  chmod +x "$STUBS"/*
}
build_stubs

#: ── Sandbox + fixture ──────────────────────────────────────────────────────
SANDBOX=""
FIXTURE=""
RP_PATH=""                #: optional PATH prefix for run_installer (defaults to $STUBS)
CLEANUP_DIRS=()
trap 'rm -rf "${CLEANUP_DIRS[@]}" 2>/dev/null' EXIT

new_sandbox() {
  SANDBOX="$(mktemp -d)"; CLEANUP_DIRS+=("$SANDBOX")
  RP_PATH=""
  mkdir -p "$SANDBOX/home" "$SANDBOX/ctl"
  FIXTURE="$SANDBOX/repo"
  # minimal repo fixture: the paths the installer links/reads
  mkdir -p "$FIXTURE"/{config/{git,nvim,ghostty,zellij,atuin,k9s,fish,glow,opentofu,uv,pnpm,pypoetry,yamlfmt,kitty,hypr,fluxbox,nixpkgs},config/alacritty/themes,config/ripgrep,config/mise,config/tmux,vim,vendor/oh-my-zsh/completions}
  : > "$FIXTURE/config/alacritty/alacritty.toml"
  : > "$FIXTURE/config/ripgrep/ripgreprc"
  : > "$FIXTURE/config/mise/config.toml"
  : > "$FIXTURE/config/tmux/tmux.conf"
  : > "$FIXTURE/config/tmux/tmux.conf.local"
  : > "$FIXTURE/config/starship.toml"
  : > "$FIXTURE/config/electron-flags.conf"
  : > "$FIXTURE/vim/vimrc"
}

# run_installer [args...] — invokes the installer in the current sandbox env.
# Set RP_PATH to override the PATH prefix (e.g. to drop a stub from PATH).
run_installer() {
  env -i \
    HOME="$SANDBOX/home" \
    XDG_CONFIG_HOME="$SANDBOX/home/.config" \
    DOTFILES_DIR="$FIXTURE" \
    PATH="${RP_PATH:-$STUBS}:/usr/bin:/bin" \
    TEST_UNAME="${TEST_UNAME:-Darwin 25.0.0}" \
    SANDBOX="$SANDBOX" \
    RETRY_ATTEMPTS="${RETRY_ATTEMPTS:-1}" \
    RETRY_BACKOFF="${RETRY_BACKOFF:-0}" \
    SHELL=/bin/bash \
    "$INSTALLER" "$@"
}

cfg() { printf '%s' "$SANDBOX/home/.config/$1"; }

#: ════════════════════════════════════════════════════════════════════════════
#: Scenarios
#:
#: AEx labels reference the Acceptance Examples in
#: docs/plans/2026-07-17-001-feat-install-script-reliability-plan.md.
#: ════════════════════════════════════════════════════════════════════════════

echo "== argument handling =="

new_sandbox
out="$("$INSTALLER" --bogus 2>&1)"; rc=$?
assert_rc "unknown flag exits 2" "$rc" 2

new_sandbox
out="$("$INSTALLER" --help 2>&1)"; rc=$?
assert_rc "--help exits 0" "$rc" 0
assert_match "help mentions --dry-run" "$out" "--dry-run"


echo "== unsupported platform =="

new_sandbox
TEST_UNAME="Plan9 forever" out="$(run_installer 2>&1)"; rc=$?
assert_rc "unsupported platform exits 1" "$rc" 1
assert_match "reports unsupported platform" "$out" "Unsupported platform"


echo "== AE4: Linux without sudo stops before mutation =="

new_sandbox
TEST_UNAME="Linux 6.5.0" out="$(run_installer 2>&1)"; rc=$?
assert_rc "linux no-sudo exits 1" "$rc" 1
assert_match "explains sudo requirement" "$out" "sudo"
assert_absent "no config touched (git)" "$(cfg git)"
assert_absent "no config touched (ghostty)" "$(cfg ghostty)"


echo "== AE5: --dry-run previews without mutating =="

new_sandbox
TEST_UNAME="Darwin 25.0.0" out="$(run_installer --dry-run 2>&1)"; rc=$?
assert_rc "dry-run exits 0" "$rc" 0
assert_match "dry-run announces planned link" "$out" "\[dry-run\] would:"
assert_match "dry-run banner shows dry-run tag" "$out" "platform: mac \(dry-run\)"
assert_absent "dry-run creates no ghostty link" "$(cfg ghostty)"
assert_absent "dry-run creates no zellij link" "$(cfg zellij)"


echo "== happy path: mac reconciles all managed links =="

new_sandbox
TEST_UNAME="Darwin 25.0.0" out="$(run_installer 2>&1)"; rc=$?
assert_rc "happy path exits 0" "$rc" 0
assert_match "reports no failures" "$out" "No failures"
assert_no_match "real-run banner omits dry-run tag" "$out" "platform: mac \(dry-run\)"
assert_symlink_to "$(cfg git)"     "$FIXTURE/config/git"     "git linked"
assert_symlink_to "$(cfg ghostty)" "$FIXTURE/config/ghostty" "ghostty linked"
assert_symlink_to "$(cfg zellij)"  "$FIXTURE/config/zellij"  "zellij linked"
assert_symlink_to "$(cfg nvim)"    "$FIXTURE/config/nvim"    "nvim linked"
assert_symlink_to "$(cfg atuin)"   "$FIXTURE/config/atuin"   "atuin linked"
assert_symlink_to "$(cfg k9s)"     "$FIXTURE/config/k9s"     "k9s linked"
assert_symlink_to "$(cfg mise)"      "$FIXTURE/config/mise"      "mise linked (whole dir)"
assert_symlink_to "$(cfg tmux)"      "$FIXTURE/config/tmux"      "tmux linked (whole dir)"
assert_symlink_to "$(cfg alacritty)" "$FIXTURE/config/alacritty" "alacritty linked (whole dir)"
assert_symlink_to "$SANDBOX/home/.vimrc" "$FIXTURE/vim/vimrc" "vimrc linked"
assert_symlink_to "$SANDBOX/home/.ripgreprc" "$FIXTURE/config/ripgrep/ripgreprc" "ripgreprc linked"
assert_symlink_to "$(cfg fish)"     "$FIXTURE/config/fish"     "fish linked"
assert_symlink_to "$(cfg glow)"     "$FIXTURE/config/glow"     "glow linked"
assert_symlink_to "$(cfg opentofu)" "$FIXTURE/config/opentofu" "opentofu linked"
assert_symlink_to "$(cfg uv)"       "$FIXTURE/config/uv"       "uv linked"
assert_symlink_to "$(cfg pnpm)"     "$FIXTURE/config/pnpm"     "pnpm linked"
assert_symlink_to "$(cfg pypoetry)" "$FIXTURE/config/pypoetry" "poetry linked"
assert_symlink_to "$(cfg yamlfmt)"  "$FIXTURE/config/yamlfmt"  "yamlfmt linked"
assert_symlink_to "$(cfg kitty)"    "$FIXTURE/config/kitty"    "kitty linked"
assert_symlink_to "$(cfg hypr)"     "$FIXTURE/config/hypr"     "hyprland linked"
assert_symlink_to "$(cfg fluxbox)"  "$FIXTURE/config/fluxbox"  "fluxbox linked"
assert_symlink_to "$(cfg nixpkgs)"  "$FIXTURE/config/nixpkgs"  "nixpkgs linked"
assert_symlink_to "$(cfg starship.toml)"        "$FIXTURE/config/starship.toml"        "starship linked"
assert_symlink_to "$(cfg electron-flags.conf)"  "$FIXTURE/config/electron-flags.conf"  "electron flags linked"
assert_exists "alacritty themes populated" "$FIXTURE/config/alacritty/themes/.populated"


echo "== re-run is a no-op (already healthy) =="

out2="$(run_installer 2>&1)"; rc=$?
assert_rc "second run exits 0" "$rc" 0
assert_match "second run reports no failures" "$out2" "No failures"


echo "== AE3: dangling / wrong-target symlinks are repaired =="

# source-level: precise control over link_path
# shellcheck source=/dev/null
source "$INSTALLER"
# DRY_RUN and FAILURES are globals consumed by the sourced installer's link_path.
# shellcheck disable=SC2034
DRY_RUN=0
# shellcheck disable=SC2034
FAILURES=()
T="$(mktemp -d)";_tgt="$T/target"; mkdir -p "$_tgt"

# dangling symlink (wrong target)
ln -s /nonexistent/xyz "$T/dangling"
link_path "$_tgt" "$T/dangling"
assert_symlink_to "$T/dangling" "$_tgt" "dangling symlink repaired"

# wrong-target symlink
ln -sfn "$_tgt" "$T/link1"; ln -sfn /wrong "$T/link1"
link_path "$_tgt" "$T/link1"
assert_symlink_to "$T/link1" "$_tgt" "wrong-target symlink replaced"

# healthy symlink untouched
ln -sfn "$_tgt" "$T/healthy"
link_path "$_tgt" "$T/healthy"
assert_symlink_to "$T/healthy" "$_tgt" "healthy symlink left intact"

rm -rf "$T"


echo "== AE3: conflicting real directory is backed up, not destroyed =="

T="$(mktemp -d)"; _tgt="$T/target"; mkdir -p "$_tgt" "$T/zellij/inner"
echo precious > "$T/zellij/inner/file"
link_path "$_tgt" "$T/zellij"
assert_symlink_to "$T/zellij" "$_tgt" "conflict replaced with symlink"
assert_exists "backup created" "$T/zellij.bak"
assert_exists "backup contents preserved" "$T/zellij.bak/inner/file"

# a pre-existing backup must not be overwritten
mkdir -p "$T/dir2"; mkdir -p "$T/dir2.bak"; echo keepme > "$T/dir2.bak/old"
rc=0; link_path "$_tgt" "$T/dir2" || rc=$?
assert_rc "backup collision returns nonzero" "$rc" 1
assert_exists "original dir untouched on collision" "$T/dir2"
assert_match "backup not overwritten" "$(cat "$T/dir2.bak/old")" "keepme"
rm -rf "$T"


echo "== self-repo guard: refuse a link that resolves inside DOT_DIR =="

# Reproduces the mise/tmux self-referential-symlink bug: a whole-directory
# symlink into the repo makes a per-file LINK_NAME resolve back into DOT_DIR.
# link_path must refuse rather than back up / self-link a tracked file.
T="$(mktemp -d)"; mkdir -p "$T/repo/config/tool"; echo tracked > "$T/repo/config/tool/file"
ln -s "$T/repo/config/tool" "$T/cfg_tool"          # ~/.config/tool -> repo/config/tool
_saved_dot="$DOT_DIR"; DOT_DIR="$T/repo"           # point the guard at the fake repo
rc=0; out="$(link_path "$T/repo/config/tool/file" "$T/cfg_tool/file" 2>&1)" || rc=$?
DOT_DIR="$_saved_dot"
assert_rc "link into repo refused" "$rc" 1
assert_match "guard explains the refusal" "$out" "resolves inside the repo"
assert_no_match "no self-referential symlink created" "$(readlink "$T/repo/config/tool/file" 2>/dev/null || echo none)" "config/tool/file"
assert_absent "no backup written inside the repo" "$T/repo/config/tool/file.bak"
assert_match "tracked file content intact" "$(cat "$T/repo/config/tool/file")" "tracked"
rm -rf "$T"


echo "== init_submodule: fail fast (no retry) when not registered =="

# An unregistered path is a deterministic pathspec error, not a transient
# network fault — it must be skipped immediately, never retried or updated.
# shellcheck disable=SC2034
DRY_RUN=0
rc=0; out="$(init_submodule config/nonexistent-submodule-xyz 2>&1)" || rc=$?
assert_rc "unregistered submodule fails fast" "$rc" 1
assert_match "explains not registered" "$out" "not registered"
assert_no_match "did not attempt a retry" "$out" "retrying"


echo "== AE1: oh-my-zsh (critical) failure stops the run =="

new_sandbox
touch "$SANDBOX/ctl/ohmyzsh_fail"
TEST_UNAME="Darwin 25.0.0" out="$(run_installer 2>&1)"; rc=$?
assert_rc "critical oh-my-zsh failure exits 1" "$rc" 1
assert_match "names the critical failure" "$out" "oh-my-zsh: failed"
assert_match "summary marks critical" "$out" "critical"
assert_absent "run stopped before linking ghostty" "$(cfg ghostty)"


echo "== AE2: non-critical failure is reported, run continues =="

new_sandbox
touch "$SANDBOX/ctl/fzf_fail"
TEST_UNAME="Darwin 25.0.0" out="$(run_installer 2>&1)"; rc=$?
assert_rc "non-critical failure exits 0" "$rc" 0
assert_match "fzf failure printed inline" "$out" "fzf"
assert_match "fzf listed in summary" "$out" "re-run"
assert_exists "independent work continued (ghostty)" "$(cfg ghostty)"


echo "== mise: per-tool failure recorded granularly, others continue =="

new_sandbox
touch "$SANDBOX/ctl/mise_fail_go"
TEST_UNAME="Darwin 25.0.0" out="$(run_installer 2>&1)"; rc=$?
assert_rc "per-tool mise failure exits 0" "$rc" 0
assert_match "names the failed tool" "$out" "mise tool: go"
assert_match "other tool still ok" "$out" "mise: helm"


echo "== mise: already-installed tools are skipped, only missing installed =="

new_sandbox
printf 'go   1.23\n' > "$SANDBOX/ctl/mise_missing_output"   # only 'go' is missing
TEST_UNAME="Darwin 25.0.0" out="$(run_installer 2>&1)"; rc=$?
assert_rc "skip-installed run exits 0" "$rc" 0
assert_match "installs the missing tool" "$out" "mise: go"
assert_no_match "skips already-installed helm" "$out" "mise: helm"
assert_no_match "skips already-installed rust" "$out" "mise: rust"

new_sandbox
: > "$SANDBOX/ctl/mise_missing_output"                      # nothing missing
TEST_UNAME="Darwin 25.0.0" out="$(run_installer 2>&1)"; rc=$?
assert_rc "all-installed run exits 0" "$rc" 0
assert_match "reports all already installed" "$out" "all declared tools already installed"
assert_no_match "no per-tool install when none missing" "$out" "mise: go"


echo "== mise: discovery failure is explicit, no silent batch fallback =="

new_sandbox
touch "$SANDBOX/ctl/mise_ls_fail"
TEST_UNAME="Darwin 25.0.0" out="$(run_installer 2>&1)"; rc=$?
assert_rc "discovery failure exits 0 (non-critical)" "$rc" 0
assert_match "explains enumeration failure" "$out" "could not enumerate mise tools"
assert_no_match "no batch fallback attempted" "$out" "mise install \(per tool\)"


echo "== AE4 (positive): linux with sudo proceeds and uses dnf =="

new_sandbox
touch "$SANDBOX/ctl/sudo_ok"
TEST_UNAME="Linux 6.5.0" out="$(run_installer 2>&1)"; rc=$?
assert_rc "linux with sudo exits 0" "$rc" 0
assert_match "mkcert uses dnf on linux" "$(cat "$SANDBOX/ctl/dnf_log" 2>/dev/null)" "mkcert"
assert_no_match "linux never invokes homebrew" "$out" "brew install"


#: ── Report ─────────────────────────────────────────────────────────────────
echo
echo "────────────────────────────────────────────"
printf 'total: %d  passed: \033[32m%d\033[0m  failed: \033[31m%d\033[0m\n' \
  "$((PASS + FAIL))" "$PASS" "$FAIL"
[[ "$FAIL" -eq 0 ]] && { printf '\033[32mALL GREEN\033[0m\n'; exit 0; }
printf '\033[31mFAILURES PRESENT\033[0m\n'; exit 1

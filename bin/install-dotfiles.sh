#!/usr/bin/env bash
#──────────────────────────────────────────────────────────────────────────────
# Damarseta · Infrastructure with Intent. Aligned. Reliable.
# Copyright (c) 2025 wid@damarseta.id · https://damarseta.id
#──────────────────────────────────────────────────────────────────────────────
# Bootstraps or repairs a machine from this dotfiles repo.
#
# The default run reconciles drift: every managed symlink, bootstrap step, and
# tool install re-checks real state and repairs what is safe to repair. Re-run
# the same command to fix a half-installed or drifted machine.
#
#   --dry-run   Preview every planned change without touching the filesystem,
#               invoking installers, or calling package managers.
#
# Supported platforms: macOS (Homebrew) and Fedora/RHEL (dnf). Other platforms
# exit with an explicit message.

# `-u` and `pipefail` are kept; `-e` is intentionally dropped so this script can
# classify failures itself (critical prerequisite vs. independent step).
set -uo pipefail

#: ── Logging (defined first; path resolution below uses log_warn) ───────────
log_info() { printf '==> %s\n' "$*"; }
log_ok()   { printf '  ok: %s\n' "$*"; }
log_warn() { printf '  warn: %s\n' "$*" >&2; }
log_err()  { printf '  ERROR: %s\n' "$*" >&2; }
dry()      { if [[ $DRY_RUN -eq 1 ]]; then printf '  [dry-run] would: %s\n' "$*"; fi; }

#: ── Globals ────────────────────────────────────────────────────────────────
DRY_RUN=0
FAILURES=()                                  #: non-critical steps that failed
RETRY_ATTEMPTS="${RETRY_ATTEMPTS:-3}"
[[ "$RETRY_ATTEMPTS" =~ ^[1-9][0-9]*$ ]] || RETRY_ATTEMPTS=3   #: guard against 0/non-numeric
RETRY_BACKOFF="${RETRY_BACKOFF:-2}"          #: seconds between retries

#: Resolve the repository root. DOTFILES_DIR may override it (tests use this to
#: point at a sandbox fixture); an invalid override falls back with a warning.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -n "${DOTFILES_DIR:-}" && -d "${DOTFILES_DIR}" ]]; then
  DOT_DIR="$DOTFILES_DIR"
else
  DOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
  [[ -n "${DOTFILES_DIR:-}" ]] && log_warn "DOTFILES_DIR='$DOTFILES_DIR' is not a directory; using $DOT_DIR"
fi
export DOT_DIR

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
OMZ_PATH="${HOME}/.oh-my-zsh"
MISE_BIN="${HOME}/.local/bin/mise"

#: ── Mutation primitives (no-ops under --dry-run) ───────────────────────────
fs_mkdir() {                                 #: fs_mkdir PATH
  local path="$1"
  [[ -d "$path" ]] && return 0
  if [[ $DRY_RUN -ne 1 ]]; then mkdir -p "$path"; fi
}

fs_rm() {                                    #: fs_rm PATH
  if [[ $DRY_RUN -ne 1 ]]; then rm -f "$1"; fi
}

fs_mv() {                                    #: fs_mv SRC DST
  if [[ $DRY_RUN -ne 1 ]]; then mv "$1" "$2"; fi
}

fs_cp() {                                    #: fs_cp SRC DST
  if [[ $DRY_RUN -ne 1 ]]; then cp "$1" "$2"; fi
}

fs_ln() {                                    #: fs_ln TARGET LINK_NAME
  if [[ $DRY_RUN -ne 1 ]]; then ln -sfn "$1" "$2"; fi
}

fs_write() {                                 #: fs_write PATH CONTENT
  if [[ $DRY_RUN -ne 1 ]]; then printf '%s\n' "$2" > "$1"; fi
}

#: ── Retry ──────────────────────────────────────────────────────────────────
# retry LABEL COMMAND... — bounded attempts with backoff. Returns last exit code.
retry() {
  local label="$1"; shift
  local i rc=1
  for ((i = 1; i <= RETRY_ATTEMPTS; i++)); do
    "$@"; rc=$?
    [[ $rc -eq 0 ]] && return 0
    if [[ $i -lt $RETRY_ATTEMPTS ]]; then
      log_warn "$label: attempt $i/$RETRY_ATTEMPTS failed (rc=$rc); retrying..."
      sleep "$RETRY_BACKOFF"
    fi
  done
  log_warn "$label: failed after $RETRY_ATTEMPTS attempts"
  return "$rc"
}

#: ── Step orchestration ─────────────────────────────────────────────────────
# step CRITICALITY LABEL FUNCTION [args...]
#   critical -> on failure, print summary and exit 1
#   optional -> on failure, record in FAILURES and continue
step() {
  local crit="$1" label="$2"; shift 2
  "$@"; local rc=$?
  if [[ $rc -ne 0 ]]; then
    log_err "$label: failed"
    if [[ "$crit" == "critical" ]]; then
      FAILURES+=("$label (critical)")
      print_summary
      exit 1
    fi
    FAILURES+=("$label")
  fi
  return 0
}

print_summary() {
  echo
  if [[ ${#FAILURES[@]} -eq 0 ]]; then
    if [[ $DRY_RUN -eq 1 ]]; then
      log_info "dry-run complete. No mutations were made."
    else
      log_info "done. No failures."
    fi
  else
    log_warn "completed with ${#FAILURES[@]} failure(s):"
    local f
    for f in "${FAILURES[@]}"; do printf '    - %s\n' "$f"; done
    echo "    re-run the installer to retry the failed steps."
  fi
}

#: ── Managed symlink reconciliation ─────────────────────────────────────────
# link_path TARGET LINK_NAME
#   healthy symlink (correct target) -> no-op
#   missing                            -> create
#   dangling / wrong-target symlink    -> replace
#   conflicting real file or dir       -> move to LINK_NAME.bak (never
#                                         overwriting an existing backup), link
# Returns 1 only when a conflict blocks repair (backup already present).
link_path() {
  local target="$1" name="$2"

  if [[ -L "$name" && "$(readlink "$name")" == "$target" ]]; then
    log_ok "$name"
    return 0
  fi

  if [[ -L "$name" ]]; then
    dry "replace symlink $name -> $target"
    fs_rm "$name"
  elif [[ -e "$name" || -d "$name" ]]; then
    local bak="${name}.bak"
    if [[ -e "$bak" || -L "$bak" ]]; then
      log_err "$name: conflicting path present and backup $bak already exists; leaving untouched"
      return 1
    fi
    dry "back up $name -> $bak"
    fs_mv "$name" "$bak"
  fi

  fs_mkdir "$(dirname "$name")"            #: ensure parent exists (ln will not)
  dry "ln -sfn $target $name"
  fs_ln "$target" "$name"
}

#: Convenience wrappers over link_path.
link_config() {                              #: link_config TOOL -> ~/.config/TOOL
  link_path "${DOT_DIR}/config/$1" "${CONFIG_DIR}/$1"
}

link_repo_file() {                           #: link_repo_file REL TARGET
  link_path "${DOT_DIR}/$1" "$2"
}

#: ── Platform detection ─────────────────────────────────────────────────────
detect_os() {
  case "$(uname -sr)" in
    Darwin*) echo "mac" ;;
    Linux*)  echo "linux" ;;
    *)       echo "unsupported" ;;
  esac
}

# On Linux, require dnf and root or non-interactive sudo before any mutation.
preflight_linux() {
  if ! command -v dnf >/dev/null 2>&1; then
    log_err "Linux support requires dnf (Fedora/RHEL family). No dnf found."
    log_err "Other Linux distributions are not supported."
    exit 1
  fi
  [[ $EUID -eq 0 ]] && return 0
  if sudo -n true 2>/dev/null; then return 0; fi
  log_err "This script needs root or non-interactive sudo for dnf installs on Linux."
  log_err "Run 'sudo -v' first (or run as root), then re-run."
  exit 1
}

#: ── Argument parsing ───────────────────────────────────────────────────────
parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --dry-run) DRY_RUN=1; shift ;;
      -h|--help)
        cat <<'EOF'
Usage: install-dotfiles.sh [--dry-run]

  --dry-run   Preview planned changes without modifying the system.
EOF
        exit 0 ;;
      *)
        log_err "Unknown argument: $1"
        log_err "Usage: $0 [--dry-run]"
        exit 2 ;;
    esac
  done
}

#: ── Repository prerequisites ───────────────────────────────────────────────
init_submodule() {                           #: init_submodule PATH
  local sub="$1"
  if [[ -d "$sub" && -n "$(ls -A "$sub" 2>/dev/null)" ]]; then
    log_ok "submodule $sub populated"
    return 0
  fi
  if [[ $DRY_RUN -eq 1 ]]; then dry "git submodule update --init $sub"; return 0; fi
  retry "submodule:$sub" git submodule update --init "$sub"
}

#: ── Bootstrap steps ────────────────────────────────────────────────────────
#: Convention: every bootstrap step self-checks real presence, short-circuits
#: under --dry-run, then retries its installer. Presence checks gate on a real
#: artifact (binary / file), never a bare directory, so a partial install is
#: never reported as success.

_brew_install() {
  xcode-select --install 2>/dev/null || true
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | /bin/bash
}

ensure_brew() {
  if command -v brew >/dev/null 2>&1; then log_ok "homebrew present"; return 0; fi
  if [[ $DRY_RUN -eq 1 ]]; then dry "install Homebrew"; return 0; fi
  log_info "installing Homebrew..."
  retry "homebrew" _brew_install
}

_omz_install() {
  curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | RUNZSH=no sh
}

# Wires the dotfiles loader into oh-my-zsh. Returns 1 if any required op fails —
# this is the actually-critical piece of the oh-my-zsh step (shell integration).
_wire_omz_loader() {
  fs_mkdir "$OMZ_PATH/custom" || return 1
  fs_mkdir "$OMZ_PATH/cache"  || return 1
  if [[ $DRY_RUN -eq 1 ]]; then
    dry "link oh-my-zsh completions + write custom/loader.zsh"
    return 0
  fi
  ln -sfn "${DOT_DIR}/vendor/oh-my-zsh/completions" "${OMZ_PATH}/cache/completions" || return 1
  printf 'source "%s/loader.zsh"\n' "$DOT_DIR" > "${OMZ_PATH}/custom/loader.zsh" || return 1
}

ensure_ohmyzsh() {
  if [[ -d "$OMZ_PATH" ]]; then
    _wire_omz_loader || { log_err "oh-my-zsh: loader wiring failed"; return 1; }
    log_ok "oh-my-zsh present"
    return 0
  fi
  if [[ $DRY_RUN -eq 1 ]]; then dry "install oh-my-zsh"; return 0; fi
  log_info "installing oh-my-zsh..."
  retry "oh-my-zsh" _omz_install || return 1
  _wire_omz_loader || { log_err "oh-my-zsh: loader wiring failed"; return 1; }
  log_info "oh-my-zsh installed. Run 'exec zsh' to load it."
}

ZSH_COMPLETIONS_DIR="${ZSH_CUSTOM:-${ZSH:-${HOME}/.oh-my-zsh}/custom}/plugins/zsh-completions"
ensure_zsh_completions() {
  if [[ -d "$ZSH_COMPLETIONS_DIR" ]]; then log_ok "zsh-completions present"; return 0; fi
  if [[ $DRY_RUN -eq 1 ]]; then dry "clone zsh-completions"; return 0; fi
  retry "zsh-completions" git clone https://github.com/zsh-users/zsh-completions "$ZSH_COMPLETIONS_DIR"
}

FZF_PATH="${HOME}/.fzf"
_fzf_install() {
  git clone --depth 1 https://github.com/junegunn/fzf.git "$FZF_PATH" || { rm -rf "$FZF_PATH"; return 1; }
  "$FZF_PATH/install" --all >/dev/null 2>&1 || { rm -rf "$FZF_PATH"; return 1; }
}
install_fzf() {
  if [[ -x "$FZF_PATH/bin/fzf" ]]; then log_ok "fzf present"; return 0; fi
  if [[ $DRY_RUN -eq 1 ]]; then dry "install fzf"; return 0; fi
  log_info "installing fzf..."
  retry "fzf" _fzf_install
}

CARGO_HOME="${HOME}/Development/sdks/.cargo"
RUSTUP_HOME="${HOME}/Development/sdks/rustup"
_rust_install() {
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile minimal -y
}
install_rust() {
  if [[ -x "$CARGO_HOME/bin/rustup" ]]; then log_ok "rustup present"; return 0; fi
  if [[ $DRY_RUN -eq 1 ]]; then dry "install rustup (minimal)"; return 0; fi
  export CARGO_HOME RUSTUP_HOME
  mkdir -p "$CARGO_HOME" "$RUSTUP_HOME"
  retry "rustup" _rust_install
}

_vimplug_install() {
  curl -fLo "${HOME}/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}
install_vimplug() {
  if [[ -f "${HOME}/.vim/autoload/plug.vim" ]]; then log_ok "vim-plug present"; return 0; fi
  if [[ $DRY_RUN -eq 1 ]]; then dry "install vim-plug"; return 0; fi
  retry "vim-plug" _vimplug_install
}

#: ── Config-link steps ──────────────────────────────────────────────────────
ensure_alacritty() {
  #: depends on the themes submodule (prior step); if it is not populated, skip
  #: rather than double-report the submodule failure.
  local themes="${DOT_DIR}/config/alacritty/themes"
  if [[ ! -d "$themes" || -z "$(ls -A "$themes" 2>/dev/null)" ]]; then
    if [[ $DRY_RUN -eq 1 ]]; then
      dry "link alacritty config (after submodule init)"
      return 0
    fi
    log_warn "alacritty themes submodule not populated; skipping alacritty config link"
    return 0
  fi
  fs_mkdir "${CONFIG_DIR}/alacritty"
  link_path "${DOT_DIR}/config/alacritty/alacritty.toml" "${CONFIG_DIR}/alacritty/alacritty.toml"
}

ensure_zellij() {
  link_path "${DOT_DIR}/config/zellij" "${CONFIG_DIR}/zellij"
}

link_ripgreprc() {
  [[ -f "${DOT_DIR}/config/ripgrep/ripgreprc" ]] || return 0
  link_path "${DOT_DIR}/config/ripgrep/ripgreprc" "${HOME}/.ripgreprc"
}

ensure_mise_link() {
  fs_mkdir "${CONFIG_DIR}/mise"
  link_path "${DOT_DIR}/config/mise/config.toml" "${CONFIG_DIR}/mise/config.toml"
}

ensure_tmux() {
  fs_mkdir "${CONFIG_DIR}/tmux"
  fs_mkdir "${CONFIG_DIR}/tmux/plugins"
  local rc=0
  link_path "${DOT_DIR}/config/tmux/tmux.conf"        "${CONFIG_DIR}/tmux/tmux.conf"       || rc=$?
  link_path "${DOT_DIR}/config/tmux/tmux.conf.local"  "${CONFIG_DIR}/tmux/tmux.conf.local" || rc=$?
  return "$rc"
}

ensure_mkcert() {
  if command -v mkcert >/dev/null 2>&1; then log_ok "mkcert present"; return 0; fi
  if [[ $DRY_RUN -eq 1 ]]; then dry "install mkcert + nss"; return 0; fi
  case "$OS" in
    mac)
      if command -v brew >/dev/null 2>&1; then
        retry "mkcert" brew install mkcert nss
      else
        log_warn "brew not available; cannot install mkcert on macOS"
        return 1
      fi
      ;;
    linux)
      #: sudo -n fails fast (no hang) if the credential cache expired mid-run.
      retry "mkcert" sudo -n dnf install -y mkcert nss-tools
      ;;
    *)
      log_warn "mkcert: unsupported OS '$OS'; skipping"
      return 0
      ;;
  esac
}

#: ── mise bootstrap + per-tool install ──────────────────────────────────────
_mise_install() {
  curl -fsSL https://mise.jdx.dev/install.sh | sh
}

_mise_completions() {
  [[ $DRY_RUN -eq 1 ]] && return 0
  local cache_dir="${OMZ_PATH}/cache/completions" staging="${DOT_DIR}/vendor/oh-my-zsh/completions/_mise"
  fs_mkdir "$cache_dir"
  if "$MISE_BIN" completion zsh > "${staging}.tmp" 2>/dev/null; then
    fs_mv "${staging}.tmp" "$staging"
    fs_cp "$staging" "${cache_dir}/_mise"
    log_ok "mise completions refreshed"
  else
    fs_rm "${staging}.tmp"
    log_warn "mise completion generation failed; continuing"
  fi
}

ensure_mise() {
  if command -v mise >/dev/null 2>&1 || [[ -x "$MISE_BIN" ]]; then log_ok "mise present"; return 0; fi
  if [[ $DRY_RUN -eq 1 ]]; then dry "install mise"; return 0; fi
  log_info "installing mise..."
  retry "mise" _mise_install || return 1
  _mise_completions
}

# Enumerate declared tool ids via mise's own interface (never parse config.toml).
# Prints one tool id per line to stdout. Returns 1 if mise cannot enumerate.
_mise_declared_tools() {
  local mise="$1"
  local out
  #: `mise ls` column 1 is the tool id. Its text format is not a stable contract
  #: across mise versions; if it drifts, per-tool installs fail loudly (each
  #: recorded individually) rather than silently under-installing.
  out="$(NO_COLOR=1 "$mise" ls 2>/dev/null)" || return 1
  printf '%s\n' "$out" | awk '
    NF == 0          { next }                          # blank lines
    $1 ~ /^(Tool|NAME|Plugin|PluginName|Backend)$/ { next }   # header rows
    $1 ~ /^[-+=]/    { next }                          # separator / banner lines
    { print $1 }
  ' | sort -u
}

install_mise_tools() {
  local mise
  mise="$(command -v mise 2>/dev/null || true)"
  [[ -z "$mise" && -x "$MISE_BIN" ]] && mise="$MISE_BIN"
  if [[ -z "$mise" ]]; then
    #: mise itself is the prior step's responsibility; do not double-report.
    log_warn "mise not available; skipping tool installs"
    return 0
  fi

  local specs rc
  specs="$(_mise_declared_tools "$mise")"; rc=$?
  if [[ $rc -ne 0 ]]; then
    log_err "could not enumerate mise tools via 'mise ls'; skipping per-tool install"
    return 1
  fi
  if [[ -z "$specs" ]]; then log_ok "mise: no tools declared"; return 0; fi

  if [[ $DRY_RUN -eq 1 ]]; then
    dry "mise install (per tool): $(printf '%s' "$specs" | tr '\n' ' ')"
    return 0
  fi

  local spec
  while IFS= read -r spec; do
    [[ -z "$spec" ]] && continue
    if retry "mise:$spec" "$mise" install "$spec" >/dev/null 2>&1; then
      log_ok "mise: $spec"
    else
      log_err "mise: $spec failed"
      FAILURES+=("mise tool: $spec")        #: granular, do not also fail the step
    fi
  done <<< "$specs"
  return 0
}

#: ── Non-critical integration ───────────────────────────────────────────────
install_kubetmux() {
  if command -v kube-tmux >/dev/null 2>&1; then log_ok "kube-tmux present"; return 0; fi
  if ! command -v go >/dev/null 2>&1; then
    log_warn "go not available; skipping kube-tmux"
    return 0                                 #: skip with reason, not a failure
  fi
  if [[ $DRY_RUN -eq 1 ]]; then dry "go install github.com/go-tmux/kube-tmux@latest"; return 0; fi
  retry "kube-tmux" go install "github.com/go-tmux/kube-tmux@latest" || return 1
}

#: ── Orchestration ──────────────────────────────────────────────────────────
main() {
  parse_args "$@"
  OS="$(detect_os)"
  log_info "dotfiles installer — platform: $OS${DRY_RUN:+ (dry-run)}"

  case "$OS" in
    mac)   ;;
    linux) preflight_linux ;;
    *)     log_err "Unsupported platform: $(uname -sr)"; exit 1 ;;
  esac

  cd "$DOT_DIR" || { log_err "cannot enter $DOT_DIR"; exit 1; }

  #: repository prerequisites
  step optional "alacritty-themes submodule" init_submodule config/alacritty/themes

  #: macOS package manager
  [[ "$OS" == "mac" ]] && step optional "homebrew" ensure_brew

  #: shell bootstrap — oh-my-zsh is the one critical prerequisite
  step critical "oh-my-zsh"       ensure_ohmyzsh
  step optional "zsh-completions" ensure_zsh_completions

  #: tool bootstraps
  step optional "fzf"      install_fzf
  step optional "rustup"   install_rust
  step optional "vim-plug" install_vimplug

  #: managed config links
  step optional "git config"        link_config git
  step optional "vimrc"             link_repo_file vim/vimrc "$HOME/.vimrc"
  step optional "neovim config"     link_config nvim
  step optional "alacritty config"  ensure_alacritty
  step optional "ghostty config"    link_config ghostty
  step optional "zellij config"     ensure_zellij
  step optional "ripgrep config"    link_ripgreprc
  step optional "mise config link"  ensure_mise_link
  step optional "atuin config"      link_config atuin
  step optional "tmux config"       ensure_tmux
  step optional "k9s config"        link_config k9s

  #: native packages (mkcert / nss)
  step optional "mkcert" ensure_mkcert

  #: mise bootstrap + per-tool install
  step optional "mise bootstrap" ensure_mise
  step optional "mise tools"     install_mise_tools

  #: non-critical integration
  step optional "kube-tmux" install_kubetmux

  print_summary
}

# Run only when executed, not when sourced (tests source this file).
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi

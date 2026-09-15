# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles, symlink-based. `config/<tool>/` in this repo is the source of truth; `bin/install-dotfiles.sh` symlinks each one into `~/.config/<tool>` (or elsewhere, e.g. `~/.vimrc`). There is no build step — editing a file under `config/` changes the live config immediately via the symlink, once it's been created once by the install script.

## Common commands

- `bin/install-dotfiles.sh` — self-healing bootstrap **and** repair. The same run works on a fresh machine or fixes drift: it re-checks real state every time, repairs managed symlinks, and bootstraps missing tools. oh-my-zsh is the only **critical** prerequisite (its failure stops the run); every other step retries a bounded number of times, then degrades to skip-and-report so the run finishes and prints a summary of what to re-run. Supported platforms: macOS (Homebrew) and Fedora Workstation (`dnf`, interactive `sudo` — you are prompted for the password) — this is a personal desktop dotfiles setup, never a headless RHEL/CentOS/Alma/Rocky server provisioning tool, which is why desktop configs are in scope. Linux-desktop-only configs (`hypr`, `fluxbox`) link only on Linux; `kitty` is cross-platform.
- `bin/install-dotfiles.sh --dry-run` — preview what a run would install, repair, back up, or link without touching the filesystem or invoking package managers/installers.
- `bash tests/install-dotfiles_test.sh` — hermetic regression suite for the installer. Stubs every external command (`brew`, `dnf`, `sudo`, `git`, `curl`, `go`, `mise`, `uname`) against a throwaway sandbox; no network or real installs. Run it after editing `bin/install-dotfiles.sh`. On Linux the installer now uses **interactive `sudo`** (prompts for the password); it does not require passwordless sudo.
- `bin/refresh-completions.sh` — regenerates cached zsh completion files under `completions/` (see `core`). Run after upgrading a tool whose completions are cached instead of generated live on every shell start.
- `exec zsh` — reload the shell after editing anything sourced by `loader.zsh` (`aliases`, `core`, `paths`, `functions.sh`, or any per-domain file).
- Ghostty (`config/ghostty/config`) — hot-reloaded by the running terminal on save, no command needed.
- Zellij (`config/zellij/config.kdl`) — **not** hot-reloaded mid-session; start a new session (or `zellij kill-all-sessions` then reattach) to pick up config changes. Layouts/themes (`layout_dir`/`theme_dir` in `config.kdl`) are read fresh per session from `config/zellij/layouts` and `config/zellij/themes`.

There is no Makefile/Taskfile/pre-commit config. `shellcheck`, `shfmt`, and `yamllint` are pinned in `config/mise/config.toml` and available on `$PATH` via mise; `shellcheck -x bin/install-dotfiles.sh` is the lint gate for the installer, and `bash tests/install-dotfiles_test.sh` is its test gate.

## Architecture

### Shell load order (`loader.zsh`)

`bin/install-dotfiles.sh` wires `~/.oh-my-zsh/custom/loader.zsh` to `source ${DOT_DIR}/loader.zsh`, which then sources, in this order:

1. `global_env` (TERM, XDG base dirs, tmux-plugin vars, locale), `common/colors`, `auth_keys` (gitignored secrets — auto-generated with empty tokens on first run if missing, chmod 600)
2. `functions.sh`, `paths` (builds `$PATH`), `core` (GPG_TTY, direnv, ruby gems, starship + atuin init)

`MISE_*` env (data dir + behaviour flags) is **not** in this chain — it lives in `vendor/oh-my-zsh/dot-zshrc` before `source $ZSH/oh-my-zsh.sh`, because the oh-my-zsh `mise` plugin runs `mise activate` during that call and the load chain is sourced too late to affect it. Kept in sync with `bin/install-dotfiles.sh`. Activation itself is the `mise` plugin's job; `core` must not run `mise activate`.
3. Per-domain env files: `android`, `blockchain`, `devs`, `golang`, `nodejs`, `python`, `rust`, `aliases`, `infrastructure`
4. `workaround` if present, then the OS fragment — `mac` on Darwin, `linux` on Linux (symmetric; keep OS-agnostic settings in `core`/`global_env`, not in these two)
5. `office/golang` and `office/devs` if `office/` exists (gitignored, machine-local)
6. Final `$PATH` dedupe via `bin/_pathnodupe.py` (skipped safely if `python3` is absent), then `$FPATH` gets `completions/` appended

When asked to add a new env var, alias, or tool init, place it in the matching per-domain file rather than `loader.zsh` itself. Gate on `command -v <tool>` by default; only use a `WID_ENABLE_<x>` env flag (read from `office/flags`) when a presence check can't express the condition — see `FEATURE_FLAGS.md`.

### Symlink model (`bin/install-dotfiles.sh`)

All managed links go through one helper, `link_path TARGET LINK_NAME`, which reconciles real state every run: a healthy symlink (correct target) is a no-op; a missing, dangling, or wrong-target link is replaced; a conflicting real file/dir is moved to `LINK_NAME.bak` (never overwritten) before linking. Two wrappers cover the two shapes — `link_config TOOL` links a whole `config/<tool>` dir into `~/.config/<tool>`, and `link_repo_file REL TARGET` links an individual file (tmux, mise config, vimrc). To add a new managed config, add a `step optional "<label>" link_config <tool>` line in `main()`; every platform/bootstrap/tool step is its own `ensure_*`/`install_*` function routed through `step <critical|optional>`, so criticality and retry behavior come for free.

`~/.zshrc` is repo-managed too: it symlinks to `vendor/oh-my-zsh/dot-zshrc` (oh-my-zsh setup only — the portable config is the `loader.zsh` chain, sourced via `~/.oh-my-zsh/custom/loader.zsh`). Machine-specific lines go in `~/.zshrc.local` (git-ignored), which `dot-zshrc` sources last and the installer seeds once from `dot-zshrc.local.example` (`ensure_zshrc_local`, same pattern as `ensure_git_local`). Tools that append to `~/.zshrc` write into the tracked file — move those lines to a fragment or to `~/.zshrc.local`.

### Package management (`packages/README.md`)

Three layers: **mise** (`config/mise/config.toml`) owns every CLI it can install, same list on both OSes; **`Brewfile`** (`brew bundle`, macOS only) for GPG/casks/fonts; **`packages/fedora.txt`** (`dnf`, Fedora only) for `zsh`/GPG/pinentry/NSS. The installer drives all three (`install_brew_bundle`, `install_dnf_packages`). Linux `sudo` is interactive — the installer prompts for the password; it no longer requires passwordless `sudo`.

## Ghostty (`config/ghostty/`)

Single flat `config` file, no includes/conditionals. Currently: `Rapture` theme, `background-opacity`/`background-blur` (macOS glass), one keybind (`shift+enter` → newline).

## Zellij (`config/zellij/`)

- `config.kdl` is the single entrypoint: keybinds, theme (`catppuccin-frappe`), `default_layout "calisia"`, and the `zjstatus` statusbar block (Catppuccin Macchiato colors, kube-context segments).
- `config/zellij/docs/*.md` (`keybindings.md`, `zellij-options.md`, `zellij-layouts.md`, `room-plugin.md`) are maintained reference docs — check these before re-deriving behavior from `config.kdl` directly.
- Keybinds layer a tmux-style prefix mode (`Ctrl a` → `tmux` mode with familiar `%`/`"`/`c`/`,` bindings) on top of the native vim-style (`hjkl`) mode bindings. `Ctrl y` opens the `zellij_forgot.wasm` cheatsheet plugin; `Ctrl t` then `f` opens the `room.wasm` fuzzy tab switcher.
- Plugins are loaded two ways: vendored `.wasm` binaries under `plugins/` (referenced via `file:~/.config/zellij/plugins/...`) for `room` and `zjstatus`/`zellij_forgot`, *and* remote URLs in the `load_plugins` block (`zjframes`, `zellij-forgot` pulled from GitHub releases at startup). Check which mechanism a given plugin already uses before adding a new one, and don't assume both are always in sync.
- `layouts/*.kdl` has several named layouts; `calisia` is the one actually active per `config.kdl`'s `default_layout`.

## Neovim (`config/nvim/`)

LazyVim-based config (`~/.config/nvim` symlink target). `config/nvim/docs/plugins.md` and
`config/nvim/docs/keybindings.md` are maintained reference docs — check these before re-deriving
plugin purpose or keymap behavior from the Lua source directly; they cover only what this repo adds
or changes on top of stock LazyVim, not LazyVim's own defaults. A retired, no-longer-active config
lives at `config/_archive/nvim-v2/` for historical reference only — do not treat it as current.

## Conventions

- Commit messages follow Conventional Commits with a scope, e.g. `feat(zellij): ...`, `fix(shell): ...`, `docs(zellij): ...`.
- Larger changes get a dated plan doc under `docs/plans/` named `YYYY-MM-DD-NNN-<slug>-plan.md`.
- Secrets and machine-specific values live only in gitignored files (`auth_keys`, `office/*` incl. `office/flags`, `~/.zshrc.local`, `~/.config/git/config.local`, `vps`, `vpn/*`) — never hardcode credentials or machine-specific paths into tracked files.
- Removals go to `.trash/` (gitignored, path preserved), not `rm` — restore with a plain `mv`.

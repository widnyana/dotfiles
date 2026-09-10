# Package management

Three layers, in order of preference:

1. **mise** (`config/mise/config.toml`) — every CLI tool it can install. The
   installer runs `mise install` for anything `mise ls --missing` reports.
   This is the same list on macOS and Fedora.
2. **Homebrew** (`../Brewfile`, macOS only) — `brew bundle` for what mise should
   not own: GPG, casks, fonts, GUI apps. Run by `install_brew_bundle`.
3. **dnf** (`fedora.txt`, Fedora only) — system components: `zsh` itself, GPG,
   pinentry, NSS. Run by `install_dnf_packages` with interactive `sudo` (you are
   prompted for your password).

Adding a tool: if mise has it, put it in `config/mise/config.toml`. Only reach
for `Brewfile` / `fedora.txt` when it must come from the OS.

#!/usr/bin/env bash
#──────────────────────────────────────────────────────────────────────────────
# Damarseta · Infrastructure with Intent. Aligned. Reliable.
# Copyright (c) 2025 wid@damarseta.id · https://damarseta.id
#──────────────────────────────────────────────────────────────────────────────
# Bootstraps a machine from this dotfiles repo: installs oh-my-zsh, fzf, rust,
# vim-plug, mise, tmux, and related tool configs/symlinks. Safe to re-run.

set -euo pipefail

unameOut="$(uname -sr)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    MSYS_NT*)   machine=Git;;
    *)          machine="UNKNOWN:${unameOut}"
esac

if [[ $machine == "Mac" ]]; then
  if ! [[ -x $(command -v "brew") ]]; then
    # install homebrew
    xcode-select --install || true
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | /bin/bash
  fi
fi

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
DOT_DIR="${HOME}/.dotfiles"

pushd "${DOT_DIR}"

### Git
ln -sfn "${HOME}/.dotfiles/config/git" "${CONFIG_DIR}/git"


## oh-my-zsh
OMZ_PATH="${HOME}/.oh-my-zsh"
if [[ ! -d "${OMZ_PATH}" ]]; then
    echo "installing oh-my-zsh..."
    curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | RUNZSH=no sh

    mkdir -p "${OMZ_PATH}/cache"
    ln -sfn  "${DOT_DIR}/vendor/oh-my-zsh/completions" "${OMZ_PATH}/cache/"

    #: attach custom loader
    echo "source ${DOT_DIR}/loader.zsh" > "${OMZ_PATH}/custom/loader.zsh"
    echo "oh-my-zsh installed. Restart your shell (or run 'exec zsh') to load it."
fi

## ZSH Completions
ZSH_COMPLETIONS_DIR="${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions"
if [[ ! -d "${ZSH_COMPLETIONS_DIR}" ]]; then
    git clone https://github.com/zsh-users/zsh-completions "${ZSH_COMPLETIONS_DIR}"
fi

### fzf - A command-line fuzzy finder
FZF_PATH="${HOME}/.fzf"
if [[ ! -d "${FZF_PATH}" ]]; then
    echo "installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git "${FZF_PATH}"
    "${FZF_PATH}/install"
fi

### Rust
export CARGO_HOME="${HOME}/Development/sdks/.cargo"
export RUSTUP_HOME="${HOME}/Development/sdks/rustup" 
export PATH="${CARGO_HOME}/bin:${PATH}"

if [[ ! -d "${CARGO_HOME}" ]]; then
    mkdir -p "${CARGO_HOME}"
    mkdir -p "${RUSTUP_HOME}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile minimal
fi

### VIM and NeoVIm
if [[ ! -d "${HOME}/.vim/autoload" ]]; then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

ln -sfn "${HOME}/.dotfiles/vim/vimrc"       "${HOME}/.vimrc"
ln -sfn "${HOME}/.dotfiles/config/nvim"         "${CONFIG_DIR}/nvim"

#  ▄▖▜       ▘▗ ▗   
#  ▌▌▐ ▀▌▛▘▛▘▌▜▘▜▘▌▌
#  ▛▌▐▖█▌▙▖▌ ▌▐▖▐▖▙▌
#
if [[ ! -d "${CONFIG_DIR}/alacritty" ]]; then 
    mkdir -p        "${CONFIG_DIR}/alacritty"
    mkdir -p        "${CONFIG_DIR}/alacritty/themes"
    ln -sfn         "${DOT_DIR}/config/alacritty/alacritty.toml"  "${CONFIG_DIR}/alacritty/alacritty.toml"
fi

#    ▌     ▗ ▗   
#  ▛▌▛▌▛▌▛▘▜▘▜▘▌▌
#  ▙▌▌▌▙▌▄▌▐▖▐▖▙▌
#  ▄▌          ▄▌
if [[ ! -d "${CONFIG_DIR}/ghostty" ]]; then
    ln -sfn         "${DOT_DIR}/config/ghostty"  "${CONFIG_DIR}/ghostty"
fi

#  ▀▌     ▘  ▘
#  ▄▌▛▘▌▌▌▌▛▌
#  ▙▌▙▖▙▌▌▌▌▌
#
if [[ ! -L "${CONFIG_DIR}/zellij" ]]; then
    [[ -d "${CONFIG_DIR}/zellij" ]] && mv "${CONFIG_DIR}/zellij" "${CONFIG_DIR}/zellij.bak"
    ln -sfn         "${DOT_DIR}/config/zellij"  "${CONFIG_DIR}/zellij"
fi

### mkcert
if ! command -v mkcert > /dev/null 2>&1; then
    echo -e "installing FiloSottile/mkcert..."
    if [[ $machine == "Mac" ]]; then
        brew install mkcert nss
    fi
fi

### burntsushi/ripgrep
if [[ -f "$DOT_DIR/config/ripgrep/ripgreprc" ]]; then
  ln -sfn "$DOT_DIR/config/ripgrep/ripgreprc"  "$HOME/.ripgreprc"
fi

### mise - https://mise.jdx.dev
if [[ ! -f "${HOME}/.local/bin/mise" ]]; then
    echo -e "Installing mise - https://mise.jdx.dev"
    mkdir -p "${CONFIG_DIR}/mise"
    ln -sfn "${DOT_DIR}/config/mise/config.toml"  "${CONFIG_DIR}/mise/config.toml"

    curl https://mise.jdx.dev/install.sh | sh
    MISE_CACHE_DIR="${ZSH_CACHE_DIR:-${OMZ_PATH}/cache}"
    mkdir -p "${MISE_CACHE_DIR}/completions"
    "${HOME}/.local/bin/mise" completion zsh 2> /dev/null | tee \
        "${MISE_CACHE_DIR}/completions/_mise" \
        "$DOT_DIR/vendor/oh-my-zsh/completions/_mise" > /dev/null
fi

#    ▗   ▘  
#  ▀▌▜▘▌▌▌▛▌
#  █▌▐▖▙▌▌▌▌
#
if [[ ! -d "${CONFIG_DIR}/atuin" ]]; then 
    ln -sfn "${DOT_DIR}/config/atuin"  "${CONFIG_DIR}/atuin"
fi


### Tmux
if [[ ! -d "${CONFIG_DIR}/tmux" ]]; then 
    mkdir -p    "${CONFIG_DIR}/tmux"
    mkdir -p    "${CONFIG_DIR}/tmux/plugins/"
    ln -sn -f   "${DOT_DIR}/config/tmux/tmux.conf"        "${CONFIG_DIR}/tmux/tmux.conf"
    ln -sn -f   "${DOT_DIR}/config/tmux/tmux.conf.local"  "${CONFIG_DIR}/tmux/tmux.conf.local"
fi

### install all required tools via mise
"$(command -v mise)" install -y

# =====================================================================================================================


### kube-tmux: kubernetes-context integration for tmux
if ! command -v kube-tmux > /dev/null 2>&1; then
  go install "github.com/go-tmux/kube-tmux@latest"
fi

ln -sfn "${DOT_DIR}/config/k9s" "${CONFIG_DIR}/k9s"

popd

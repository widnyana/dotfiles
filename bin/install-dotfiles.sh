#!/usr/bin/env bash
set -euo pipefail
set -x

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
DOT_DIR="${HOME}/.dotfiles"

pushd "${DOT_DIR}"

### Git
ln -sfn "${HOME}/.dotfiles/git/gitconfig"   "${HOME}/.gitconfig"
ln -sfn "${HOME}/.dotfiles/git/gitignore"   "${HOME}/.gitignore"

## oh-my-zsh
OMZ_PATH="${HOME}/.oh-my-zsh"
if [[ ! -d "${OMZ_PATH}" ]]; then
    echo "installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    mkdir -p "${OMZ_PATH}/cache"
    ln -sfn  "${DOT_DIR}/vendor/oh-my-zsh/completions" "${OMZ_PATH}/cache/"

    #: attach custom loader
    echo "source ${DOT_DIR}/loader.zsh" > "${OMZ_PATH}/custom/loader.zsh"
    # shellcheck source=/dev/null
    source ~/.zshrc
fi

## ZSH Completions
ZSH_COMPLETIONS_DIR="${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions"
if [[ ! -d $ZSH_COMPLETIONS_DIR ]]; then 
  git clone https://github.com/zsh-users/zsh-completions "${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions"
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
ln -sfn "${HOME}/.dotfiles/vim/vimrc"       "${HOME}/.vimrc"
ln -sfn "${HOME}/.dotfiles/config/nvim-v2"         "${CONFIG_DIR}/nvim"

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

### mkcert
if [[ ! -f "$HOME/.local/bin/mkcert" ]]; then
    echo -e "installing FiloSottile/mkcert..."
    sudo dnf install nss-tools -y -q
    wget   -q --show-progress --progress=bar-O /tmp/mkcert "https://dl.filippo.io/mkcert/latest?for=linux/amd64"
    chmod +x "/tmp/mkcert"
    mv "/tmp/mkcert" "${HOME}/.local/bin/mkcert"
fi

### mise - https://mise.jdx.dev
if [[ ! -f "${HOME}/.local/bin/mise" ]]; then
    echo -e "Installing mise - https://mise.jdx.dev"
    mkdir -p "${CONFIG_DIR}/mise"
    ln -sfn "${DOT_DIR}/config/mise/config.toml"  "${CONFIG_DIR}/mise/config.toml"

    curl https://mise.jdx.dev/install.sh | sh
    "${HOME}/.local/bin/mise" completion zsh 2> /dev/null | tee \
        "$ZSH_CACHE_DIR/completions/_mise" \
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
$(which mise) install -y

# =====================================================================================================================

### kube-tmux: kubernetes-context integration for tmux
go install "github.com/go-tmux/kube-tmux@latest"

ln -sfn "${DOT_DIR}/config/k9s" "${CONFIG_DIR}/k9s"

popd

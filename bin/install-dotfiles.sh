#!/usr/bin/env bash
set -euo pipefail

OMZ_PATH="${HOME}/.oh-my-zsh"
FZF_PATH="${HOME}/.fzf"


CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
DOT_DIR="${HOME}/.dotfiles"

pushd $DOT_DIR

ln -sfn ${HOME}/.dotfiles/zsh/zfunc         "${HOME}/.zfunc"

### Git
ln -sfn "${HOME}/.dotfiles/git/gitconfig"   "${HOME}/.gitconfig"
ln -sfn "${HOME}/.dotfiles/git/gitignore"   "${HOME}/.gitignore"

## oh-my-zsh
if [[ ! -d "${OMZ_PATH}" ]]; then
    echo "installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "source ${DOT_DIR}/loader.zsh" > "${OMZ_PATH}/custom/loader.zsh"
    source ~/.zshrc
fi

### fzf - A command-line fuzzy finder
if [[ ! -d "${FZF_PATH}" ]]; then
    echo "installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git "${FZF_PATH}"
    "${FZF_PATH}/install"
fi

### pull the submodules
# git submodule update --init --recursive --rebase -f

### Rust
export CARGO_HOME="${HOME}/Development/sdks/.cargo"
export RUSTUP_HOME="${HOME}/Development/sdks/rustup" 

if [[ ! -d "${CARGO_HOME}" ]]; then
    mkdir -p "${CARGO_HOME}"
    mkdir -p "${RUSTUP_HOME}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile minimal
fi

### VIM and NeoVIm
ln -sfn "${HOME}/.dotfiles/vim/vimrc"       "${HOME}/.vimrc"
ln -sfn "${HOME}/.dotfiles/nvim-v2"         "${HOME}/.config/nvim"

### Alacritty
mkdir -p        "${CONFIG_DIR}/alacritty"
mkdir -p        "${CONFIG_DIR}/alacritty/themes"

### mkcert
if [[ ! -f "/usr/local/bin/mkcert" ]]; then
    echo -e "installing FiloSottile/mkcert..."
    sudo dnf install nss-tools -y
    curl -JLO "https://dl.filippo.io/mkcert/latest?for=linux/amd64"
    chmod +x "mkcert-v*-linux-amd64"
    sudo cp "mkcert-v*-linux-amd64" /usr/local/bin/mkcert
fi

### mise - https://mise.jdx.dev
mkdir   "${CONFIG_DIR}/mise"
ln -sfn "${DOT_DIR}/config/mise/config.toml"  "${CONFIG_DIR}/mise"

### Tmux
mkdir -p    "${CONFIG_DIR}/tmux"
mkdir -p    "${CONFIG_DIR}/tmux/plugins/"
ln -sn -f   "${DOT_DIR}/config/tmux/tmux.conf.local"  "${CONFIG_DIR}/tmux/tmux.conf.local"

### kube-tmux: kubernetes-context integration for tmux
go install "github.com/go-tmux/kube-tmux@latest"


popd

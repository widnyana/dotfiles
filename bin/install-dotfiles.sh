#!/usr/bin/env bash
set -euo pipefail

OMZ_PATH="${HOME}/oh-my-zsh"
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
fi

### fzf - A command-line fuzzy finder
if [[ ! -d "${FZF_PATH}" ]]; then
    echo "installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git "${FZF_PATH}"
    "${FZF_PATH}/install"
fi

### pull the submodules
# git submodule update --init --recursive --rebase -f

### Golang
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
$HOME/.gvm/bin/gvm install go1 --prefer-binary --with-build-tools

### Rust
export CARGO_HOME="${HOME}/Development/sdks/.cargo"
export RUSTUP_HOME="${HOME}/Development/sdks/rustup" 
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile minimal


### VIM and NeoVIm
ln -sfn "${HOME}/.dotfiles/vim/vimrc"       "${HOME}/.vimrc"
ln -sfn "${HOME}/.dotfiles/nvim-v2"         "${HOME}/.config/nvim"

### Alacritty
mkdir -p        "${CONFIG_DIR}/alacritty"
mkdir -p        "${CONFIG_DIR}/alacritty/themes"
ln    -sfn      "${DOT_DIR}/config/alacritty/alacritty.yml"         "${CONFIG_DIR}/alacritty/alacritty.yml"



### Tmux
mkdir -p    "${CONFIG_DIR}/tmux"
mkdir -p    "${CONFIG_DIR}/tmux/plugins/"
ln -sn -f   "${DOT_DIR}/vendor/.tmux/.tmux.conf"      "${HOME}/.tmux.conf"
ln -sn -f   "${DOT_DIR}/config/tmux/tmux.conf.local"  "${HOME}/.tmux.conf.local"

## kube-tmux: kubernetes-context integration for tmux
go install "github.com/go-tmux/kube-tmux@latest"


popd



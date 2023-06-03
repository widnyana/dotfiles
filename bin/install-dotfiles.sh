#!/usr/bin/env bash
CONFIG_DIR="${XDG_CONFIG:-$HOME/.config}"
DOT_DIR="${HOME}/.dotfiles"

### Git
ln -sfn "${HOME}/.dotfiles/git/gitconfig"   "${HOME}/.gitconfig"
ln -sfn "${HOME}/.dotfiles/git/gitignore"   "${HOME}/.gitignore"


### Tmux
if [ ! -d "$HOME}/.tmux" ]; then
    echo -e "cloning github.com/gpakosz/.tmux"
    git clone https://github.com/gpakosz/.tmux.git "${HOME}/.tmux"
fi
ln -sfn "${HOME}/.dotfiles/tmux/.tmux.conf.local"   "${HOME}/.tmux.conf.local"

### VIM
ln -sfn "${HOME}/.dotfiles/vim/vimrc"       "${HOME}/.vimrc"

### Alacritty
ln -sfn "${HOME}/.dotfiles/alacritty/alacritty.yml"  "${CONFIG_DIR}/alacritty/alacritty.yml"
mkdir -p "${CONFIG_DIR}/alacritty/themes"
git submodule add https://github.com/alacritty/alacritty-theme.git "${DOT_DIR}/alacritty/themes" || echo -e "Alacritty themes already initialized"


### Finalize
git submodule update --init --recursive

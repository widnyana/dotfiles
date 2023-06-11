#!/usr/bin/env bash
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
DOT_DIR="${HOME}/.dotfiles"

### pull the submodules
git submodule update --init --recursive --rebase -f


### Git
ln -sfn "${HOME}/.dotfiles/git/gitconfig"   "${HOME}/.gitconfig"
ln -sfn "${HOME}/.dotfiles/git/gitignore"   "${HOME}/.gitignore"


### Tmux
mkdir -p    "${CONFIG_DIR}/tmux"
mkdir -p    "${HOME}/.tmux/plugins/"
ln -sn -f   "${DOT_DIR}/submodule/tmux/.tmux.conf"      "${CONFIG_DIR}/tmux/tmux.conf"
ln -sn -f   "${DOT_DIR}/config/tmux/tmux.conf.local"    "${CONFIG_DIR}/tmux/tmux.conf.local"




### VIM
ln -sfn "${HOME}/.dotfiles/vim/vimrc"       "${HOME}/.vimrc"

### Alacritty
mkdir -p        "${CONFIG_DIR}/alacritty"
mkdir -p        "${CONFIG_DIR}/alacritty/themes"
ln    -sfn      "${DOT_DIR}/config/alacritty/alacritty.yml"         "${CONFIG_DIR}/alacritty/alacritty.yml"

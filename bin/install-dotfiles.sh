#!/usr/bin/env bash

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


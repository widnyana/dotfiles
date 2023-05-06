#!/bin/bash
set -e

cd ~/.dotfiles/vim_runtime

echo 'set runtimepath+=~/.dotfiles/vim_runtime

source ~/.dotfiles/vim_runtime/vimrcs/basic.vim

try
source ~/.dotfiles/vim_runtime/custom_rc.vim
catch
endtry' > ~/.vimrc

echo -e 'Done'


#!/bin/sh

p="$(pwd)"

set -x
ln -s "$p/gitconfig" ~/.gitconfig
ln -s "$p/profile" ~/.profile
ln -s "$p/zprofile" ~/.zprofile
ln -s "$p/zshrc" ~/.zshrc

if mkdir ~/.vim; then
	ln -s "$p/vim/colors" ~/.vim/
	ln -s "$p/vim/gvimrc" ~/.vim/
	ln -s "$p/vim/pack" ~/.vim/
	ln -s "$p/vim/syntax" ~/.vim/
	ln -s "$p/vim/vimrc" ~/.vim/
fi

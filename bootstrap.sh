#!/bin/sh

#This will become a much better provisioning system later
pushd ~
git clone git@github.com:davidjb/dotfiles.git 
ln -s dotfiles/.vimrc .

mkdir -p .vim/bundle
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

mkdir -p ~/.vim/ftdetect/
ln -s ~/.vim/bundle/ultisnips/ftdetect/* ~/.vim/ftdetect/

#Not working yet
wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf -O ~/.fonts/PowerlineSymbols.otf

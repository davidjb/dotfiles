#!/bin/bash
#   git clone git@github.com:davidjb/dotfiles.git; cd dotfiles; ./bootstrap.sh
# Inspired by https://github.com/inlineblock/DotFiles

#This will become a much better provisioning system later

cd "$(dirname "$0")"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#Change ~ to be wherever we want
HOME="$1"

vundle ()
{
    if [ -d ~/.vim/bundle/vundle ]; then
		cd ~/.vim/bundle/vundle
		git pull origin master
    else
		mkdir -p ~/.vim/bundle
		git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
    fi

    ln -s $DIR/vimrc ~/.vimrc
    vim +BundleInstall +qall

    mkdir -p ~/.vim/ftdetect/
    ln -s ~/.vim/bundle/ultisnips/ftdetect/* ~/.vim/ftdetect/
}

install () {
    ln -s $DIR/bashrc ~/.bashrc
}

dependencies () {
    sudo apt-get install vim cmake git
}

dependencies
vundle
install

#Not working yet
#wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf -O ~/.fonts/PowerlineSymbols.otf

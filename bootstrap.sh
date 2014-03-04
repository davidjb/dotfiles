#!/bin/bash -x
#   git clone git@github.com:davidjb/dotfiles.git; cd dotfiles; ./bootstrap.sh
# Inspired by https://github.com/inlineblock/DotFiles

#This will become a much better provisioning system later

cd "$(dirname "$0")"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#Change ~ to be wherever we want, if set
if [ $1 ]; then
	HOME="$1"
fi

if [ ! -d ~ ]; then
	mkdir -p ~
fi

install_update_git () {
    repository=$1
    path=$2
    if [ -d $path ]; then
        cd $path 
        git pull origin master
    else
        mkdir -p $path
        git clone $repository $path
    fi
}

dependencies () {
    sudo apt-get install -y \
		vim \
		cmake \
		git \
		xclip
    install_update_git https://github.com/kennethreitz/autoenv.git ~/.autoenv
}

vundle ()
{
    install_update_git https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle 

    ln -s $DIR/vimrc ~/.vimrc
    vim +BundleInstall +qall

    mkdir -p ~/.vim/ftdetect/
    ln -s ~/.vim/bundle/ultisnips/ftdetect/* ~/.vim/ftdetect/

	pushd ~/.vim/bundle/YouCompleteMe
	./install.sh --clang-completer
	popd
}

install () {
    ln -s $DIR/bashrc ~/.bashrc
    ln -s $DIR/bash_aliases ~/.bash_aliases
    ln -s $DIR/bash_logout ~/.bash_logout
    ln -s $DIR/environment ~/.environment
    ln -s $DIR/gitconfig ~/.gitconfig
    ln -s $DIR/profile ~/.profile
    ln -s $DIR/pypirc ~/.pypirc
    ln -s $DIR/zopeskel ~/.zopeskel

    mkdir -p ~/.buildout/{eggs,downloads,configs}
    cp $DIR/buildout/* ~/.buildout/
    sed -i "s/\${whoami}/`whoami`/g" ~/.buildout/default.cfg
   
    mkdir -p ~/.ssh
    cp $DIR/ssh/* ~/.ssh/
}


dependencies
vundle
install

#Not working yet
#wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf -O ~/.fonts/PowerlineSymbols.otf

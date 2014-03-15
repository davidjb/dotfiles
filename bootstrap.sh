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
	mono-xbuild \
	mono-dmcs \
	git \
	mercurial \
	node \
	npm \
	libxml2-utils \ #xmllint
	tidy

    sudo apt-get install -y \
		xclip \
		pngcrush

    install_update_git https://github.com/kennethreitz/autoenv.git ~/.autoenv
    
    # Global Python-based tools
    sudo pip install --upgrade ipython grin

    # Local Python-based tools
    mkdir -p $DIR/tools
    virtualenv $DIR/tools/python
    pushd $DIR/tools/python
    . bin/activate
    pip install --upgrade \
	py3kwarn \
	pylama \
	rstcheck \
	nodeenv
    popd

    # Local Node.js based tools
    mkdir -p $DIR/tools/nodejs
    pushd $DIR/tools/nodejs
    npm install \
	csslint \
	jsonlint \
	jslint \
	js-yaml
    popd
}

remove () {
    rm -rf ~/.bashrc ~/.bash_aliases ~/.bash_logout ~/.environment \
       ~/.gitconfig ~/.profile ~/.pypirc ~/.zopeskel ~/.vimrc ~/.vim \
       ~/.config/powerline ~/.gvimrc
}

vundle ()
{
    #Dependencies for Powerline
    pip install --user mercurial psutil
    echo 'fs.inotify.max_user_watches=16384' | sudo tee --append /etc/sysctl.conf
    echo 16384 | sudo tee /proc/sys/fs/inotify/max_user_watches

    # Install all Vundle bundles
    install_update_git https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle 
    vim +BundleInstall +qall

    # Powerline configuration
    mkdir ~/.config/powerline
    cp -R ~/.vim/bundle/powerline/powerline/config_files/* ~/.config/powerline/
    rm -rf ~/.config/powerline/config.json
    ln -s $DIR/powerline/config.json ~/.config/powerline/
    rm -rf ~/.config/powerline/colorschemes/vim/default.json
    ln -s $DIR/powerline/colorschemes/vim/default.json ~/.config/powerline/colorschemes/vim/default.json

    # Snippets and type detection
    mkdir -p ~/.vim/ftdetect/
    ln -s ~/.vim/bundle/ultisnips/ftdetect/* ~/.vim/ftdetect/

    # Compile YCM support
    pushd ~/.vim/bundle/YouCompleteMe
    ./install.sh --clang-completer --omnisharp-completer
    popd
}

install () {
    ln -s $DIR/bashrc ~/.bashrc
    ln -s $DIR/bash_aliases ~/.bash_aliases
    ln -s $DIR/bash_logout ~/.bash_logout
    ln -s $DIR/environment ~/.environment
    ln -s $DIR/gitconfig ~/.gitconfig
    ln -s $DIR/vimrc ~/.gvimrc
    ln -s $DIR/profile ~/.profile
    ln -s $DIR/vimrc ~/.vimrc
    ln -s $DIR/zopeskel ~/.zopeskel


    # Contain local data 
    mkdir -p ~/.bash_private
    cp -s $DIR/pypirc ~/.pypirc

    mkdir -p ~/.buildout/{eggs,downloads,configs}
    cp $DIR/buildout/* ~/.buildout/
    sed -i "s/\${whoami}/`whoami`/g" ~/.buildout/default.cfg
   
    mkdir -p ~/.ssh
    cp $DIR/ssh/* ~/.ssh/

    # Initialise vim and configuration
    vundle
}

#Run the install script
dependencies

while true; do
    read -p "Do you want to remove existing files? " yn
    case $yn in
        [Yy]* ) remove; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

install
install_tools

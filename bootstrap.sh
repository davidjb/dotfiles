#!/bin/bash -x
#   git clone git@github.com:davidjb/dotfiles.git; cd dotfiles; ./bootstrap.sh
# Inspired by https://github.com/inlineblock/DotFiles
# vim:tw=78:ft=sh

##########################
#  Installation helpers  #
##########################
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
cp_if_missing () {
    original=$1
    target=$2
    if [ ! -e $target ]; then
        cp $1 $2
    fi
}

install_step () {
    while true; do
        read -p "$1 (y/n) " yn
        case $yn in
            [Yy]* ) $2; break;;
            [Nn]* ) break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

#########################
#  Configuration steps  #
#########################
dependencies () {
    #libxml2-utils provides xmllint
    sudo apt-get install -y \
        vim \
        gvim \
        cmake \
        mono-xbuild \
        mono-dmcs \
        git \
        mercurial \
        xclip \
        node \
        npm \
        libxml2-utils \
        tidy

    install_update_git https://github.com/kennethreitz/autoenv.git ~/.autoenv

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

applications () {
    # Skype installation is fairly evil.
    sudo dpkg --add-architecture i386
    sudo add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
    sudo apt-get update

    sudo apt-get install -y \
        ldap-utils \
        htop \
        lynx \
        pngcrush \
        pidgin \
        pidgin-skype \
        skype

    # Global Python-based tools
    sudo pip install --upgrade ipython grin
}

remove () {
    rm -rf \
        ~/.bashrc \
        ~/.config/powerline \
        ~/.bash_aliases \
        ~/.bash_logout \
        ~/.environment \
        ~/.gitconfig \
        ~/.gitignore-global \
        ~/.gvimrc \
        ~/.profile \
        ~/.pypirc \
        ~/.screenrc \
        ~/.vimrc \
        ~/.vim \
        ~/.zopeskel
}

vundle () {
    install_update_git https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle 
    vim +BundleInstall +qall
}

vim_configuration () {
    #Dependencies for Powerline
    pip install --user mercurial psutil
    echo 'fs.inotify.max_user_watches=16384' | sudo tee --append /etc/sysctl.conf
    echo 16384 | sudo tee /proc/sys/fs/inotify/max_user_watches

    # Install all Vundle bundles
    vundle

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
    ln -s $DIR/gitignore-global ~/.gitignore-global
    ln -s $DIR/vimrc ~/.gvimrc
    ln -s $DIR/profile ~/.profile
    ln -s $DIR/screenrc ~/.screenrc
    ln -s $DIR/vimrc ~/.vimrc
    ln -s $DIR/zopeskel ~/.zopeskel

    # Contain local data 
    mkdir -p ~/.bash_private
    cp_if_missing $DIR/pypirc ~/.pypirc

    mkdir -p ~/.buildout/{eggs,downloads,configs}
    cp_if_missing $DIR/buildout/default.cfg ~/.buildout/default.cfg
    sed -i "s/\${whoami}/`whoami`/g" ~/.buildout/default.cfg

    mkdir -p ~/.ssh
    cp_if_missing $DIR/ssh/config ~/.ssh/config

    # Initialise vim and configuration
    vim_configuration
}

#########################
#  Execute instalation  #
#########################
cd "$(dirname "$0")"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#Change ~ to be wherever we want, if set via first argument
if [ $1 ]; then
    HOME="$1"
fi

if [ ! -d ~ ]; then
    mkdir -p ~
fi

install_step "Do you want to install dependencies?" dependencies
install_step "Do you want to remove existing files?" remove 
install_step "Do you want to install the configuration?" install
install_step "Re-run Vim's plugin installation?" vundle
install_step "Do you want to install applications?" applications


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
command_exists () {
    command -v $1 &> /dev/null
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
        vim-gtk \
        exuberant-ctags \
        cmake \
        mono-xbuild \
        mono-dmcs \
        git \
        mercurial \
        xclip \
        nodejs \
        nodejs-legacy \
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
        pygments \
        dotfiles \
        nodeenv
    popd

    # Local Node.js based tools
    mkdir -p $DIR/tools/nodejs
    pushd $DIR/tools/nodejs
    npm install \
        less \
        csslint \
        jsonlint \
        jslint \
        js-yaml \
        grunt-cli
    popd
}

applications () {
    # Skype installation is fairly evil.
    if ! command_exists skype; then
        sudo dpkg --add-architecture i386
        sudo add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
    fi

    # Wine
    if ! command_exists wine; then
        sudo apt-add-repository ppa:ubuntu-wine/ppa
    fi

    # Virtualbox
    if ! command_exists VirtualBox; then
        sudo add-apt-repository "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib"
        wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -
    fi

    # Insync
    if ! command_exists insync; then
        sudo add-apt-repository "deb http://apt.insynchq.com/ubuntu $(lsb_release -sc) non-free contrib"
        wget -qO - https://d2t3ff60b2tol4.cloudfront.net/services@insynchq.com.gpg.key | sudo apt-key add -
    fi


    # Update all package information!
    sudo apt-get update

    # Install all the packages!
    sudo apt-get install -y \
        gnome-raw-thumbnailer \
        pwgen \
        screen \
        tmux \
        rsnapshot \
        ldap-utils \
        htop \
        libav-tools \
        libjpeg-turbo-progs \
        v4l-utils \
        uvcdynctrl \
        guvcview \
        optipng \
        pngcrush \
        lynx \
        pidgin \
        pidgin-skype \
        skype \
        dosbox \
        wine1.7 \
        virtualbox-4.3 \
        insync

    if ! command_exists vagrant; then
        # Vagrant
        wget https://dl.bintray.com/mitchellh/vagrant/vagrant_1.5.3_x86_64.deb -O /tmp/vagrant.deb
        sudo dpkg -i /tmp/vagrant.deb
    fi

    # Global Python-based tools
    sudo pip install --upgrade ipython grin zest.releaser
}

google_drive () {
    # Symlink all home sub-directories
    for dir in ~/google-drive/Working-Environment/*
    do
        ln -s $dir .
    done
}

remove () {
    rm -rf \
        ~/.config/powerline \
        ~/.pypirc \
        ~/.vim
}

vundle () {
    install_update_git https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle 
    vim +BundleInstall +qall
}

vim_configuration () {
    #Dependencies for Powerline
    pip install --user mercurial psutil
    if ! grep -q ^fs.inotify.max_user_watches /etc/sysctl.conf
    then
        echo 'fs.inotify.max_user_watches=16384' | sudo tee --append /etc/sysctl.conf
        echo 16384 | sudo tee /proc/sys/fs/inotify/max_user_watches
    fi

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

    # Term for Vim support
    pushd ~/.vim/bundle/tern_for_vim
    npm install
    popd

    # Compile YCM support
    pushd ~/.vim/bundle/YouCompleteMe
    ./install.sh --clang-completer --omnisharp-completer
    popd
}

sync_dotfiles() {
    dotfiles --sync --force
}

install () {
    ln -s $DIR/dotfilesrc ~/.dotfilesrc
    dotfiles --check
    install_step "Are you sure you wish to replace these files?" sync_dotfiles

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
install_step "Do you want to configure Google Drive aliases?" google_drive


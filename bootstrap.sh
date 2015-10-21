#!/bin/bash
#   git clone git@github.com:davidjb/dotfiles.git; cd dotfiles; ./bootstrap.sh
# Inspired by https://github.com/inlineblock/DotFiles
# vim:tw=78:ft=sh

##########################
#  Installation helpers  #
##########################
install_update_git () {
    repository=$1
    path=$2
    if [ -d "$path" ]; then
        cd "$path"
        git pull origin master
    else
        mkdir -p "$path"
        git clone "$repository" "$path"
    fi
}
cp_if_missing () {
    original=$1
    target=$2
    if [ ! -e "$target" ]; then
        cp "$original" "$target"
    fi
}
ln_if_missing () {
    original=$1
    target=$2
    if [ ! -e "$target" ]; then
        ln "$original" "$target"
    fi
}
command_exists () {
    command -v "$1" &> /dev/null
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
        tidy \
        libgnome2-bin \
        virtualenv \
        python-dev \
        python3-dev \
        python-setuptools \
        python-pip \
        ruby-dev \
        ruby-sass \
        shellcheck
    sudo apt-get install -f

    install_update_git https://github.com/kennethreitz/autoenv.git ~/.autoenv

    # Local Python-based tools
    mkdir -p "$DIR/tools"
    virtualenv "$DIR/tools/python"
    pushd "$DIR/tools/python"
    . bin/activate
    easy_install -U \
        py3kwarn \
        pylama \
        rstcheck \
        pygments \
        dotfiles \
        nodeenv \
        thefuck \
        caniusepython3
    pip install http://projects.bigasterisk.com/grepedit-1.0.tar.gz
    deactivate
    popd

    # Local Node.js based tools
    mkdir -p "$DIR/tools/nodejs"
    pushd "$DIR/tools/nodejs"
    npm install \
        less \
        csslint \
        jsonlint \
        jslint \
        jshint \
        js-yaml \
        grunt-cli \
        bower \
        yo \
        gulp \
        keybase-installer \
        jpm # Jetpack package manager for Firefox

    # Local Ruby-based tools
    mkdir -p "$DIR/tools/ruby"
    pushd "$DIR/tools/ruby"
    export GEM_HOME=$(pwd)
    echo "export GEM_HOME=$GEM_HOME" > .env
    gem install \
        scss_lint \
        compass \
        mdl
    popd
    unset GEM_HOME


    # Keybase setup
    keybase-installer -p .
    popd


    # Global gitignore
    install_update_git https://github.com/github/gitignore.git "$DIR/tools/gitignore"
}

applications () {
    # Ubuntu Tweak
    if ! command_exists ubuntu-tweak; then
        sudo add-apt-repository ppa:tualatrix/ppa
    fi

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

    # Nagstamon
    if ! command_exists nagstamon; then
        wget -O /tmp/nagstamon.deb https://nagstamon.ifw-dresden.de/files-nagstamon/stable/nagstamon_1.0.1_all.deb
        sudo dpkg -i /tmp/nagstamon.deb
    fi


    # Update all package information!
    sudo apt-get update

    # Install all the packages!
    sudo apt-get install -y \
        molly-guard \
        apt-file \
        nmap \
        gcolor2 \
        apache2-utils \
        pavucontrol \
        openjdk-8-jre \
        whois \
        compizconfig-settings-manager \
        indicator-multiload \
        gnome-raw-thumbnailer \
        pwgen \
        pass \
        screen \
        tmux \
        vlc \
        gimp \
        gimp-gmic \
        gmic \
        rsnapshot \
        smbnetfs \
        ldap-utils \
        htop \
        libav-tools \
        libjpeg-turbo-progs \
        v4l-utils \
        uvcdynctrl \
        guvcview \
        optipng \
        librsvg2-bin \
        wakeonlan \
        lynx \
        pngcrush \
        lynx \
        pidgin \
        pidgin-skype \
        skype \
        inkscape \
        dosbox \
        wine1.7 \
        salt-ssh \
        insync \
        ubuntu-tweak \
        exfat-utils \
        libimage-exiftool-perl \ # exiftool for EXIF tags
        discount \      # Markdown tools -- get it?
        smbclient \     # Client for SMB resources (printers, etc)
        nethogs \       # Per-process network activity monitoring
        wajig \         # Package management
        calibre \       # eBook reader
        darktable \     # Photograph editing
        audacity \      # Audio editing
        ncdu \          # Terminal-based disk usage analyser
        bleachbit \     # File cleaner for Linux
        sshfs           # SSH filesystem support
        #virtualbox-4.3

    # Install Asian language support for EPS and Inkscape
    sudo apt-get install texlive-lang-cjk --no-install-recommends

    # Update files in packages
    sudo apt-file update

    if ! command_exists vagrant; then
        # Vagrant
        wget https://dl.bintray.com/mitchellh/vagrant/vagrant_1.6.5_x86_64.deb -O /tmp/vagrant.deb
        sudo dpkg -i /tmp/vagrant.deb
    fi

    if ! command_exists ipscan; then
        # Angry IP scanner
        wget http://github.com/angryziber/ipscan/releases/download/3.3.2/ipscan_3.3.2_amd64.deb -O /tmp/angry.deb
        sudo dpkg -i /tmp/angry.deb
    fi


    # Global Python-based tools
    sudo easy_install -U ipython grin zest.releaser

    # Tmux plugins
    install_update_git https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    tmux run-shell ~/.tmux/plugins/tpm/scripts/install_plugins.sh
}

google_drive () {
    # Symlink all home sub-directories
    for dir in ~/google-drive/Working-Environment/*
    do
        ln_if_missing "$dir" .
    done
}

remove () {
    rm -rf \
        ~/.config/powerline \
        ~/.pypirc \
        ~/.vim
}

vim_plug () {
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    vim +PlugInstall +qall
}

compile_ycm () {
    pushd ~/.vim/bundle/YouCompleteMe
    git submodule update --init --recursive
    ./install.sh --clang-completer
    popd
}

vim_configuration () {
    #Dependencies for Powerline
    pip install --user mercurial psutil
    if ! grep -q ^fs.inotify.max_user_watches /etc/sysctl.conf
    then
        echo 'fs.inotify.max_user_watches=16384' | sudo tee --append /etc/sysctl.conf
        echo 16384 | sudo tee /proc/sys/fs/inotify/max_user_watches
    fi

    # Install all plugins and plugin manager
    vim_plug

    # Tern for Vim
    pushd ~/.vim/bundle/tern_for_vim
    npm install
    ln_if_missing ~/.vim/bundle/tern-meteor/meteor.js node_modules/tern/plugin/
    popd

    # Powerline configuration
    sudo pip install -e ~/.vim/bundle/powerline
    mkdir ~/.config/powerline
    cp -R ~/.vim/bundle/powerline/powerline/config_files/* ~/.config/powerline/
    rm -rf ~/.config/powerline/config.json
    ln_if_missing "$DIR/powerline/config.json" ~/.config/powerline/
    rm -rf ~/.config/powerline/colorschemes/vim/default.json
    ln_if_missing "$DIR/powerline/colorschemes/vim/default.json" ~/.config/powerline/colorschemes/vim/default.json
    rm -rf ~/.config/powerline/themes/tmux/default.json
    ln_if_missing "$DIR/powerline/themes/tmux/default.json" ~/.config/powerline/themes/tmux/default.json

    # Powerline font install
    mkdir -p ~/.fonts
    wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf -O ~/.fonts/PowerlineSymbols.otf
    fc-cache -vf ~/.fonts/
    mkdir -p ~/.config/fontconfig/conf.d
    wget https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf -O ~/.config/fontconfig/conf.d/10-powerline-symbols.conf


    # Snippets and type detection
    mkdir -p ~/.vim/ftdetect/
    ln_if_missing -s ~/.vim/bundle/ultisnips/ftdetect/* ~/.vim/ftdetect/

    # Term for Vim support
    pushd ~/.vim/bundle/tern_for_vim
    npm install
    popd

    # Compile YCM support
    compile_ycm

    # Spelling
    vim +"mkspell $DIR/vim-spelling.utf-8.add" +qall
}

sync_dotfiles() {
    dotfiles --sync --force
}

install () {
    ln_if_missing "$DIR/dotfilesrc" ~/.dotfilesrc
    dotfiles --check
    install_step "Are you sure you wish to replace these files?" sync_dotfiles

    # Contain local data 
    mkdir -p ~/.bash_private
    cp_if_missing "$DIR/pypirc" ~/.pypirc

    mkdir -p ~/.buildout/{eggs,downloads,configs}
    cp_if_missing "$DIR/buildout/default.cfg" ~/.buildout/default.cfg
    sed -i "s/\${whoami}/$(whoami)/g" ~/.buildout/default.cfg

    mkdir -p ~/.ssh
    cp_if_missing "$DIR/ssh/config" ~/.ssh/config

    # Enable hiberantion option in menu
    sudo cp -f "$DIR/etc/com.ubuntu.enable-hibernate.pkla" /etc/polkit-1/localauthority/50-local.d/

    # Initialise vim and configuration
    vim_configuration
}

configure_firefox () {
    #user_pref("browser.cache.disk.parent_directory", "/run/user/1000/firefox-cache");
    sudo add-apt-repository ppa:ubuntu-mozilla-daily/firefox-aurora
    sudo apt-get update
    sudo apt-get install firefox -y

    tmp=$(mktemp -d)
    pushd "$tmp"
    # Adblock Plus
    wget https://addons.mozilla.org/firefox/downloads/latest/1865/addon-1865-latest.xpi
    # Session Manager
    wget https://addons.mozilla.org/firefox/downloads/latest/2324/addon-2324-latest.xpi
    # VimFx
    wget https://addons.mozilla.org/firefox/downloads/file/274214/vimfx-0.5.14-fx.xpi
    # Firebug
    wget https://addons.mozilla.org/firefox/downloads/latest/1843/addon-1843-latest.xpi
    # Media Keys
    wget https://addons.mozilla.org/firefox/downloads/latest/553354/platform:2/addon-553354-latest.xpi
    # Install
    firefox ./*.xpi
    rm -rf "$tmp"
    popd

}

#########################
#  Execute instalation  #
#########################
cd "$(dirname "$0")"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#Change ~ to be wherever we want, if set via first argument
if [ "$1" ]; then
    HOME="$1"
fi

if [ ! -d ~ ]; then
    mkdir -p ~
fi

install_step "Do you want to install dependencies?" dependencies
install_step "Do you want to remove existing files?" remove
install_step "Do you want to install the configuration?" install
install_step "Re-run Vim's plugin installation?" vim_plug
install_step "Re-run YouCompleteMe compilation?" compile_ycm
install_step "Do you want to install applications?" applications
install_step "Do you want to configure Google Drive aliases?" google_drive
install_step "Do you want to configure Firefox?" configure_firefox


#!/bin/bash
#   git clone git@github.com:davidjb/dotfiles.git; cd dotfiles; ./bootstrap.sh
# Inspired by https://github.com/inlineblock/DotFiles
# vim:tw=78:ft=sh

##########################
#  Global variables      #
##########################
[[ $OSTYPE == "linux-gnu" ]] && _IS_LINUX=yes
if [ $_IS_LINUX ]; then
    _IS_DEB=$(command -v apt-get)
    _IS_RPM=$(command -v yum)
fi
[[ $OSTYPE == "darwin"*  ]] && _IS_MAC=yes

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
    if [ $_IS_LINUX ]; then
        if command -v apt-get > /dev/null 2>&1; then
            #libxml2-utils provides xmllint
            sudo apt-get install -y \
                aspell \
                cmake \
                exuberant-ctags \
                git \
                libgnome2-bin \
                libxml2-utils \
                mercurial \
                mono-dmcs \
                mono-xbuild \
                nodejs \
                nodejs-legacy \
                npm \
                p7zip \
                phantomjs \
                python-dev \
                python-pip \
                python-setuptools \
                python3-dev \
                ruby-dev \
                ruby-sass \
                shellcheck \
                tidy \
                ttf-mscorefonts-installer \
                unrar \
                vim \
                vim-gtk \
                virtualenv \
                xclip
        elif command -v yum > /dev/null 2>&1; then
             echo 'No support yet.'
        fi
    elif [ $_IS_MAC ]; then
        #Install homebrew
        ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
        brew analytics off

        brew install \
            aspell \
            cmake \
            ctags \
            git \
            libxml2 \
            mercurial \
            node \
            p7zip \
            phantomjs \
            pyenv-virtualenv \
            python \
            python3 \
            sassc \
            shellcheck \
            tidy-html5 \
            unrar \
            vim
        brew cask install reactotron
    fi

    install_update_git https://github.com/kennethreitz/autoenv.git ~/.autoenv

    # Local Python-based tools
    mkdir -p "$DIR/tools"
    virtualenv "$DIR/tools/python"
    pushd "$DIR/tools/python"
    . bin/activate
    pip install -U \
        py3kwarn \
        pylama \
        rstcheck \
        pygments \
        dotfiles \
        nodeenv \
        thefuck \
        caniusepython3 \
        em-keyboard
    pip install http://projects.bigasterisk.com/grepedit-1.0.tar.gz
    deactivate
    popd

    # Local Node.js based tools, directory configured in ~/.npmrc
    ln_if_missing "$DIR/npmrc" ~/.npmrc
    npm install -g \
        linklocal \
        wml \
        less \
        csslint \
        jsonlint \
        jslint \
        jshint \
        js-yaml \
        js-beautify \
        remark \
        grunt-cli \
        gulp \
        typescript \
        keybase-installer \
        jpm # Jetpack package manager for Firefox

    # React Native
    npm install -g \
        standard
        eslint \
        babel-eslint \
        eslint-plugin-react \
        react-native \
        react-native-ignite \
        reactotron-cli

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

    # Global gitignore
    install_update_git https://github.com/github/gitignore.git "$DIR/tools/gitignore"
}

applications () {
    # Platform-specific tools and installation methods
    if [ $_IS_LINUX ]; then
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
            wget -O /tmp/nagstamon.deb https://nagstamon.ifw-dresden.de/files/stable/nagstamon_2.0_all.deb
            sudo dpkg -i /tmp/nagstamon.deb
        fi

        # Update all package information!
        sudo apt-get update

        # Install all the packages!
        packages=(
            apache2-utils                   # ab (Apache bench)
            apt-file                        # deb file searching
            alien                           # RPM to DEB conversion
            audacity                        # Audio editing
            bleachbit                       # File cleaner for Linux
            brasero                         # Disc burning software
            calibre                         # eBook reader
            chromium-browser                # Browser
            compizconfig-settings-manager   # Compiz settings UI
            darktable                       # Photograph editing
            dconf-editor                    # Configuration editor
            discount                        # Markdown tools -- get it?
            docker                          # Containers
            docker-compose                  # Container environment management
            dosbox                          # DOS environments
            exfat-utils                     # exFAT support
            figlet                          # ASCII art text
            gcolor2                         # GUI colour selector
            gimp                            # Raster graphics editor
            gimp-gmic                       # GIMP integration with gmic
            gmic                            # Image computing tools
            gnome-raw-thumbnailer           # RAW support for Nautilus
            gnome-tweak-tool                # GNOME option configuration
            gtk-recordmydesktop             # Screen recording
            guvcview                        # Web cam recording and config app
            htop                            # Top, powered up
            imagemagick                     # Image conversion and processing
            indicator-multiload             # System resource indicator
            inkscape                        # Vector graphics editing
            insync                          # Google Drive for Linux
            iotop                           # I/O monitoring
            ldap-utils                      # LDAP tools
            libav-tools                     # AV converters
            libimage-exiftool-perl          # exiftool for EXIF tags
            libjpeg-turbo-progs             # JPEG tools
            librsvg2-bin                    # SVG processing
            lynx                            # Terminal browsing
            molly-guard                     # Prevent shutdown over SSH
            ncdu                            # Terminal-based disk usage analyser
            nethogs                         # Per-process network activity monitoring
            nmap                            # Network probing and monitoring
            openjdk-8-jre                   # Java
            openshot                        # Video editing application
            optipng                         # PNG optimiser
            pass                            # Password management
            pavucontrol                     # GUI for PulseAudio
            pidgin                          # Instant messaging
            pidgin-skype                    # Skype for Pidgin
            pngcrush                        # PNG optimiser
            pwgen                           # Password generator
            rsnapshot                       # Backup manager via rsync
            salt-ssh                        # Salt configuration management
            screen                          # Terminal sessions (like tmux, but ancient)
            silversearcher-ag               # Super-fast searching
            skype                           # Calls and messaging
            smbclient                       # Client for SMB resources (printers, etc)
            smbnetfs                        # SMB network support
            sshfs                           # SSH filesystem support
            tmux                            # Terminal multiplexer
            uvcdynctrl                      # UVC controller for webcams
            v4l-utils                       # Video4Linux utilities
            vlc                             # Video plaer
            wajig                           # Package management
            wakeonlan                       # WOL tools to send magic packets
            whois                           # WHOIS client
            wine1.7                         # Wine is not an emulator
            virtualbox-5.1                  # Virtual machines
        )
        sudo apt-get install -y "${packages[@]}"

        # Install Asian language support for EPS and Inkscape
        sudo apt-get install texlive-lang-cjk --no-install-recommends

        # Update files in packages
        sudo apt-file update

        if ! command_exists vagrant; then
            # Vagrant
            wget https://releases.hashicorp.com/vagrant/1.8.6/vagrant_1.8.6_x86_64.deb -O /tmp/vagrant.deb
            sudo dpkg -i /tmp/vagrant.deb
        fi

        if ! command_exists ipscan; then
            # Angry IP scanner
            wget https://github.com/angryziber/ipscan/releases/download/3.4.2/ipscan_3.4.2_amd64.deb -O /tmp/angry.deb
            sudo dpkg -i /tmp/angry.deb
        fi

        # Global Python-based tools
        sudo easy_install -U ipython zest.releaser
    elif [ $_IS_MAC ]; then
        brew install \
            ag \
            docker \
            docker-compose \
            figlet \
            htop \
            imagemagick \
            ncdu \
            nmap \
            pass \
            pngcrush \
            pwgen \
            reattach-to-user-namespace \
            tmux \
            wakeonlan \
            youtube-dl

        # Global Python-based tools
        easy_install -U ipython zest.releaser
    fi

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
    python3 ./install.py --clang-complete  --tern-completer
    popd
}

vim_configuration () {
    # Install all plugins and plugin manager
    vim_plug

    # Undo directory
    mkdir -p ~/.vim/undo

    # Spelling
    vim +"mkspell $DIR/vim-spelling.utf-8.add" +qall

    # Powerline dependencies
    if [ $_IS_LINUX ]; then
        sudo pip install -e ~/.vim/bundle/powerline
        pip install --user mercurial psutil

        if ! grep -q ^fs.inotify.max_user_watches /etc/sysctl.conf
        then
            echo 'fs.inotify.max_user_watches=16384' | sudo tee --append /etc/sysctl.conf
            echo 16384 | sudo tee /proc/sys/fs/inotify/max_user_watches
        fi

        # Font configuration
        mkdir -p ~/.fonts
        wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf -O ~/.fonts/PowerlineSymbols.otf
        fc-cache -vf ~/.fonts/
        mkdir -p ~/.config/fontconfig/conf.d
        wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf -O ~/.config/fontconfig/conf.d/10-powerline-symbols.conf
    elif [ $_IS_MAC ]; then
        pip install mercurial psutil
        pip install ~/.vim/bundle/powerline

        # Font configuration
        install_update_git https://github.com/powerline/fonts.git "$DIR/tools/powerline-fonts"
        pushd "$DIR/tools-powerline-fonts"
        ./install.sh
        popd
        echo "Powerline: now select a suitable font in Terminal."
    fi

    # Powerline configuration
    mkdir ~/.config/powerline
    cp -R ~/.vim/bundle/powerline/powerline/config_files/* ~/.config/powerline/
    rm -rf ~/.config/powerline/config.json
    ln_if_missing "$DIR/powerline/config.json" ~/.config/powerline/
    rm -rf ~/.config/powerline/colorschemes/vim/default.json
    ln_if_missing "$DIR/powerline/colorschemes/vim/default.json" ~/.config/powerline/colorschemes/vim/default.json
    rm -rf ~/.config/powerline/themes/tmux/default.json
    ln_if_missing "$DIR/powerline/themes/tmux/default.json" ~/.config/powerline/themes/tmux/default.json

    # Snippets and type detection
    mkdir -p ~/.vim/ftdetect/
    ln_if_missing -s ~/.vim/bundle/ultisnips/ftdetect/* ~/.vim/ftdetect/

    # Tern for Vim
    pushd ~/.vim/bundle/tern_for_vim
    npm install
    ln_if_missing ~/.vim/bundle/tern-meteor/meteor.js node_modules/tern/plugin/
    popd

    # Compile YCM support
    compile_ycm
}

sync_dotfiles() {
    dotfiles --sync --force
}

install () {
    # Load the environment and PATH local tools
    ln_if_missing "$DIR/environment" ~/.environment
    source ~/.environment

    ln_if_missing "$DIR/dotfilesrc" ~/.dotfilesrc
    dotfiles --check
    install_step "Are you sure you wish to replace these files?" sync_dotfiles

    # User-local 'tmp' directory; more persistent than /tmp
    mkdir -p ~/tmp

    # Storage for local shell data
    mkdir -p ~/.bash_private
    cp_if_missing "$DIR/pypirc" ~/.pypirc

    # Default Buildout configuration
    mkdir -p ~/.buildout/{eggs,downloads,configs}
    cp_if_missing "$DIR/buildout/default.cfg" ~/.buildout/default.cfg
    sed -i "s/\${whoami}/$(whoami)/g" ~/.buildout/default.cfg

    # Default SSH configuration
    mkdir -p ~/.ssh
    cp_if_missing "$DIR/ssh/config" ~/.ssh/config

    # Initialise vim and configuration
    vim_configuration

    if [ $_IS_LINUX ]; then
        # Enable hiberantion option in menu
        sudo cp -f "$DIR/etc/com.ubuntu.enable-hibernate.pkla" /etc/polkit-1/localauthority/50-local.d/
    fi
}

configure_firefox () {
    # Install add-ons: Ublock Origin, Session Manager, VimFx, Media Keys
    #user_pref("browser.cache.disk.parent_directory", "/run/user/1000/firefox-cache");
    sudo add-apt-repository ppa:ubuntu-mozilla-daily/firefox-aurora
    sudo apt-get update
    sudo apt-get install firefox -y
}

setup_printing () {
    # Configure build dependencies
    sudo apt-get install -y build-essential libcups2-dev

    # Install FujiXerox drivers
    cp "$DIR./etc/fxlinuxprint-src-1.0.1.tar.gz" /tmp
    cd /tmp
    tar xf fxlinuxprint-src-1.0.1.tar.gz
    cd fxlinuxprint-src-1.0.1
    ./configure && make && sudo make install
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
#install_step "Do you want to remove existing files?" remove
install_step "Do you want to install the configuration?" install
install_step "Do you want to install applications?" applications
install_step "Re-run Vim's plugin installation?" vim_plug
install_step "Re-run YouCompleteMe compilation?" compile_ycm
if [ $_IS_LINUX ]; then
    install_step "Do you want to configure Google Drive aliases?" google_drive
    install_step "Do you want to configure Firefox?" configure_firefox
    install_step "Do you want to set up printing?" setup_printing
fi


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
        ln -s "$original" "$target"
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
        if command_exists apt-get; then
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
        elif command_exists yum; then
            echo 'No support yet.'
        else
            echo 'Probably no support, ever.'
        fi
    elif [ $_IS_MAC ]; then
        #Install homebrew
        if command_exists brew; then
            brew update
        else
            git clone https://github.com/Homebrew/install.git /tmp/homebrew-install
            pushd /tmp/homebrew-install
            git checkout b4079625e312723c2935c2c3cc4e37f15296158f
            if ! [ "$(echo 'c074dd3a2d2ff4187aacb46a52f1ddec83bedae9  install' | shasum -c)" ]; then
                echo "SHA sum validation failed for Homebrew. Aborting!"
                exit 1
            fi
            /usr/bin/ruby /tmp/homebrew-install/install
            rm -rf /tmp/homebrew-install
            brew update
        fi
        brew analytics off

        # Homebrew: install packages
        packages=(
            aspell                            # Spelling
            autossh                           # Auto-restart SSH
            bash                              # Updated shell
            bash-completion                   # Shell completion
            black                             # Python formatter
            cabextract                        # .cab file extraction with Wine
            cmake                             # Compilation
            corepack                          # Node.js package manager tool
            coreutils                         # GNU coreutils like grm
            ctags                             # Indexes for language objects
            curl                              # Updated curl
            entr                              # Run commands on fs change
            fd                                # Faster find
            fzf                               # Command-line fuzzy finder
            git                               # Version control
            git-lfs                           # Git Large File Storage
            grc                               # Generic colouriser
            go                                # Go programming language
            gpg2                              # Encryption
            gnu-sed                           # Normalised sed usage
            grep                              # GNU grep
            hub                               # GitHub tools
            java                              # Java programming language
            libxml2                           # XML library
            mas                               # Mac App Store CLI
            mercurial                         # Version control
            node                              # Node.js language
            oath-toolkit                      # OTP generator
            p7zip                             # 7zip archives
            phantomjs                         # JS webpage runner
            pipenv                            # Environments for Python
            pre-commit                        # Manage repo pre-commit hooks
            python3                           # Python 3 language
            rake-completion                   # Auto-complete for Rakefile
            rsync                             # GNU rsync
            sassc                             # SASS compiler
            shellcheck                        # Spelling
            shyaml                            # YAML parsing for shells
            spidermonkey                      # Mozilla's JS engine
            tidy-html5                        # HTML5 validation tool
            v8                                # Google's JS engine
            vim                               # Updated Vim
            wget                              # Internet file retriever
            yq                                # YAML processor CLI
        )
        brew install "${packages[@]}"
        if [ -d "/usr/local/lib/node_modules/npm/" ]; then
          pushd /usr/local/lib/node_modules/npm/
          npm uninstall update-notifier
          popd
        fi
        brew link python3

        brew tap caskroom/cask
        brew tap caskroom/drivers
        brew tap caskroom/versions
        brew tap caskroom/fonts

        pip3 install virtualenv
        brew cask install reactotron

        $(brew --prefix)/opt/fzf/install

    fi

    # Local Python-based tools
    mkdir -p "$DIR/tools/python"
    python3 -m venv "$DIR/tools/python"
    pushd "$DIR/tools/python"
    . bin/activate
    pip3 install -U \
        git+https://github.com/jbernard/dotfiles.git \
        autopep8 \
        caniusepython3 \
        em-keyboard \
        flake8 \
        grepedit \
        hg-git \
        nodeenv \
        py3kwarn \
        pycodestyle \
        pygments \
        pylama \
        rstcheck \
        thefuck \
        vim-vint

    deactivate
    popd

    # Local Node.js based tools, directory configured in ~/.npmrc
    ln_if_missing "$DIR/npmrc" ~/.npmrc
    yarn config set prefix ~/dotfiles/tools/nodejs/
    packages=(
        browserify                            # 'Browser' packaging for npm
        babel-eslint                          # Babel plugin for eslint
        csslint
        eslint                                # Customisable JS linting tool
        eslint-plugin-react
        grunt-cli
        gulp
        jpm                                   # Jetpack package manager for Firefox
        js-beautify
        js-yaml
        jshint
        jslint
        jsonlint
        less
        linklocal
        prettier                              # Opinionated code formatter
        remark
        standard                              # Style checker for JS
        stylelint
        stylelint-processor-styled-components
        stylelint-config-styled-components
        stylelint-config-standard
        svgo
        typescript
        wml
    )
    yarn global add "${packages[@]}"

    # Ruby-based tools
    gem install \
        scss_lint \
        mdl

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
            oathtool                        # Toolkit for one-time password auth
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
            youtube-dl                      # Media downloader
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
        # Update Homebrew and its package information
        brew update

        # Install all the packages!
        packages=(
            ag                              # Super-fast searching
            coffeescript                    # Programming language
            diff-pdf                        # PDF visual diffing
            direnv                          # Load/unload env variables depending on cd
            docker                          # Containers
            docker-compose                  # Container environment management
            figlet                          # ASCII art text
            ffmpeg                          # Multimedia converter
            gnupg                           # GPG support
            httpstat                        # Cleaner, beautiful curl
            htop                            # Top, powered up
            imagemagick                     # Image conversion and processing
            imhex                           # Hex editor
            discount                        # Markdown tools -- get it?
            ncdu                            # Terminal-based disk usage analyser
            nmap                            # Network probing and monitoring
            oath-toolkit                    # OTP toolkit
            optipng                         # PNG optimiser
            qrencode                        # QR code generator and library
            pass                            # Password management
            pinentry-mac                    # PIN entry interface for GPG/pass
            pngcrush                        # PNG optimiser
            pwgen                           # Password generator
            reattach-to-user-namespace      # Support for pbcopy in tmux
            saltstack                       # Remote systems orchestration
            tmux                            # Terminal multiplexer
            wakeonlan                       # WOL tools to send magic packets
            youtube-dl                      # Media downloader
            zbar                            # Barcode processing
        )
        brew install "${packages[@]}"

        # pass-otp support
        git clone https://github.com/tadfisher/pass-otp /tmp/pass-otp
        pushd /tmp/pass-otp
        make install PREFIX=/usr/local
        popd
        rm -rf /tmp/pass-otp

        # Caskroom: install all the applications!
        applications=(
            alacritty                       # Faster terminal emulator
            android-file-transfer           # For accessing files on Android devices
            angry-ip-scanner                # Port and host scanner
            avibrazil-rdm                   # High-resolution MacBook screen
            bettertouchtool                 # Input customisation (mouse, pad, etc)
            calibre                         # eBook reader
            cheatsheet                      # Hold ⌘ for shortcuts
            darktable                       # Photograph editing
            dbeaver-community               # Database GUI
            disk-inventory-x                # What's using my SSD?
            homebrew/cask/docker            # GUI to Docker
            homebrew/cask/dosbox            # DOS environments
            easy-move-plus-resize           # Move windows with Alt
            ext4fuse                        # EXT4 filesystem layer
            firefox                         # Freedom on the web
            homebrew/cask-versions/firefox-developer-edition         # For developers
            flux                            # Change screen colour with time
            gimp                            # Raster graphics editor
            ha-menu                         # Home Assistant menu
            inkscape                        # Vector graphics editing
            kap                             # Easy video capture
            libreoffice                     # Editing office documents
            little-snitch                   # Outgoing firewall
            macvim                          # GUI Vim for Mac
            macfuse                         # Userland filesystem support
            meld                            # Comparisons made easy
            namechanger                     # Change filenames en masse
            postman                         # HTTP request helper
            rectangle                       # Positioning for windows
            sshfs                           # SSH-based filesystem
            simple-comic                    # Comic reader
            slack                           # Chat and more for teams
            the-unarchiver                  # Archive extraction
            virtualbox-beta                 # Virtual machines (beta for ARM)
            wireshark                       # Network traffic monitor
            vagrant                         # Environment manager
            vlc                             # Video plaer
            wine-staging                    # Wine is not an emulator
        )
        brew install "${applications[@]}"

        # Mac App Store applications
        apps=(
            1451685025                      # WireGuard
            497799835                       # Xcode
        )
        mas install "${apps[@]}"

        # Global Python-based tools
        pip install ipython zest.releaser
        pip3 install ipython
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
        pip3 install psutil
        pip3 install --editable ~/.vim/bundle/powerline

        # Font configuration
        install_update_git https://github.com/powerline/fonts.git "$DIR/tools/powerline-fonts"
        pushd "$DIR/tools/powerline-fonts"
        ./install.sh
        popd
        echo "Powerline: now select a suitable font in Terminal."
    fi

    # Powerline configuration
    mkdir ~/.config/powerline
    cp -R ~/.vim/bundle/powerline/powerline/config_files/* ~/.config/powerline/
    rm -rf ~/.config/powerline/config.json
    ln_if_missing "$DIR/powerline/config.json" ~/.config/powerline/
    rm -rf ~/.config/powerline/themes/shell/default.json
    ln_if_missing "$DIR/powerline/themes/shell/default.json" ~/.config/powerline/themes/shell/default.json
    rm -rf ~/.config/powerline/themes/tmux/default.json
    ln_if_missing "$DIR/powerline/themes/tmux/default.json" ~/.config/powerline/themes/tmux/default.json
    rm -rf ~/.config/powerline/themes/vim/default.json
    ln_if_missing "$DIR/powerline/themes/vim/default.json" ~/.config/powerline/themes/vim/default.json
    rm -rf ~/.config/powerline/colorschemes/vim/default.json
    ln_if_missing "$DIR/powerline/colorschemes/vim/default.json" ~/.config/powerline/colorschemes/vim/default.json

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
    dotfiles --repos ~/dotfiles enable
}

install () {
    # Load the environment and PATH local tools
    ln_if_missing "$DIR/environment" ~/.environment
    source ~/.environment

    ln_if_missing "$DIR/dotfilesrc" ~/.dotfilesrc
    dotfiles link --debug
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

configure_general () {
    # Create developer directories
    mkdir -p ~/dev/src

    # Create private bash directory
    mkdir -p ~/.bash_private

    # Create SSH public key
    ssh-keygen -b 4096
}

configure_mac () {
    # Set default shell
    echo "$(which bash)" | sudo tee -a /etc/shells
    chsh -s "$(which bash)"

    # Increase file resource limits
    echo 'kern.maxfiles=20480' | sudo tee -a /etc/sysctl.conf
    echo -e 'limit maxfiles 8192 20480\nlimit maxproc 1000 2000' | sudo tee -a /etc/launchd.conf
    echo 'ulimit -n 8192' | sudo tee -a /etc/profile

    # Remap keyboard keys - keyboard brightness up/down
    sudo cp etc/com.local.KeyRemapping.plist /Library/LaunchAgents/com.local.KeyRemapping.plist
    echo 'Keyboard remapping installed. Ensure you reboot for this to take effect.'

    # Faster key repeats
    # See https://github.com/mathiasbynens/dotfiles/issues/687
    defaults write -g KeyRepeat -int 1
    defaults write -g InitialKeyRepeat -int 10

    # Disable animations (10.12 support?)
    defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
    defaults write -g NSScrollAnimationEnabled -bool NO

    # Finder: disable window animations and Get Info animations (?)
    defaults write com.apple.finder DisableAllAnimations -bool true

    # Disable bounce at end of scroll
    defaults write -g NSScrollViewRubberbanding -int 0

    # Ctrl + ⌘ Cmd + Mouse click in any window to move
    defaults write -g NSWindowShouldDragOnGesture -bool true

    # Paths in Finder title
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES

    # Enable Time Machine on unsupported volumes
    defaults write com.apple.systempreferences TMShowUnsupportedNetworkVolumes 1

    # Disable the captive portal for free wifi
    sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -bool false

    # Show all file extensions
    defaults write -g AppleShowAllExtensions -bool true

    # Disable Bonjour multicast advertisments
    sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool YES

    # Disable gamed daemon
    launchctl unload -w /System/Library/LaunchAgents/com.apple.gamed.plist

    # Disable geo services
    sudo launchctl remove com.apple.geod.xpc

    # Disable Airport base station agent
    launchctl remove com.apple.AirPortBaseStationAgent

    # Enforce hibernation and evict FileVault keys
    # See https://github.com/drduh/macOS-Security-and-Privacy-Guide#full-disk-encryption
    # and https://github.com/drduh/macOS-Security-and-Privacy-Guide/issues/124
    # Note: this seems to be working correctly on macOS 13 Ventura
    sudo pmset -a destroyfvkeyonstandby 1
    sudo pmset -a hibernatemode 25
    sudo pmset -a powernap 0
    sudo pmset -a standby 1
    sudo pmset -a standbydelay 180
    sudo pmset -a autopoweroff 0
    # Was womp 1 on old MacBook
    sudo pmset -a womp 0
    sudo pmset -a ttyskeepawake 0
    # Was lidwake 1 on old MacBook
    sudo pmset -a lidwake 0
    sudo pmset -a acwake 0

    # Set up screenshots and location
    mkdir -p ~/Pictures/Screenshots
    defaults write com.apple.screencapture location ~/Pictures/Screenshots
    defaults write com.apple.screencapture disable-shadow -bool true

    # Make TextEdit open a new file on launch
    defaults write -g NSShowAppCentricOpenPanelInsteadOfUntitledFile -bool false

    # Locatedb
    sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist

    # Install Command Line Tools without Xcode
    xcode-select --install

    # Disable Sudden Motion Sensor (because we use SSDs)
    sudo pmset -a sms 0

    # Unhide User Library Folder
    chflags nohidden ~/Library

    # Enable Quit Finder menu item
    defaults write com.apple.finder QuitMenuItem -bool true && killall Finder

    # Expand Save Panel by Default
    defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
    defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

    # Show Path Bar
    defaults write com.apple.finder ShowPathbar -bool true

    # Hide Status Bar
    defaults write com.apple.finder ShowStatusBar -bool false

    # Save to disk by default
    defaults write -g NSDocumentSaveNewDocumentsToCloud -bool false

    # Set Current Folder as Default Search Scope
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

    # Set Sidebar Icon Size to small
    defaults write -g NSTableViewDefaultSizeMode -int 1

    # Disable metadata files on external volumes
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

    # Disable infrared receiver
    defaults write /Library/Preferences/com.apple.driver.AppleIRController DeviceEnabled -int 0

    # Dock settings
    defaults write com.apple.dock tilesize -int 25
    defaults write com.apple.dock magnification -int 0
    defaults write com.apple.dock orientation -string "left"
    killall Dock

    # Terminal: shell opens with brew-installed bash
    defaults write com.apple.Terminal Shell -string "/opt/homebrew/bin/bash"

    # Xcode: always use spaces for indenting
    defaults write com.apple.dt.Xcode DVTTextIndentUsingTabs -bool false

    # macOS config checker
    install_update_git https://github.com/kristovatlas/osx-config-check "$DIR/tools/mac/osx-config-check"

    # Disable local SMB caching on a macOS client
    # https://support.apple.com/en-us/HT207520
    echo "[default]" | sudo tee -a /etc/nsmb.conf
    echo "dir_cache_max_cnt=0" | sudo tee -a /etc/nsmb.conf

    #############
    # Flux (still better than Night Shift)
    #############
    FLUX_DOMAIN="org.herf.Flux"

    defaults write "${FLUX_DOMAIN}" location "-19.257622,146.817879"
    defaults write "${FLUX_DOMAIN}" locationTextField "townsville"
    defaults write "${FLUX_DOMAIN}" locationType "L"

    # Evening temperature
    defaults write "${FLUX_DOMAIN}" nightColorTemp -int 3400

    # Late night temperature
    defaults write "${FLUX_DOMAIN}" lateColorTemp -int 1900

    # Wake up
    defaults write "${FLUX_DOMAIN}" wakeTime -int 420

    # Sleep late on weekends
    defaults write "${FLUX_DOMAIN}" sleepLate -bool true

    #############
    # Google Software Update prevention
    #############
    defaults write com.google.Keystone.Agent checkInterval 0
    ~/Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle/Contents/Resources/GoogleSoftwareUpdateAgent.app/Contents/Resources/ksinstall --nuke
    if ! [ -f ~/Library/Google/GoogleSoftwareUpdate ]; then
        touch ~/Library/Google/GoogleSoftwareUpdate && sudo chown -R root:wheel ~/Library/Google
    fi

    #############
    # Cyberduck
    #############

    # Stop the flood of Bonjour updates!
    defaults write ch.sudo.cyberduck rendezvous.enable false
}

##########################
#  Execute installation  #
##########################
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
install_step "Do you want to run general setup?" configure_general
if [ $_IS_LINUX ]; then
    install_step "Do you want to configure Google Drive aliases?" google_drive
    install_step "Do you want to configure Firefox?" configure_firefox
elif [ $_IS_MAC ]; then
    install_step "Do you want to configure this Mac?" configure_mac
fi

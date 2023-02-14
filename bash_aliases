#!/bin/bash
# vim:tw=78:ft=sh
[[ $OSTYPE == "linux-gnu" ]] && _IS_LINUX=yes
[[ $OSTYPE == "darwin"*  ]] && _IS_MAC=yes

# Enable color support of commands
if [ "$TERM" != "dumb" ]; then
    if [ -x /usr/bin/dircolors ]; then
        eval "$(dircolors -b)"
    fi
    alias ls='ls -F --color=auto'
    if [ $_IS_LINUX ]; then
        alias dir='ls --color=auto --format=vertical'
        alias vdir='ls --color=auto --format=long'

        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
    elif [ $_IS_MAC ]; then
        alias dir='ls --format=vertical'
        alias vdir='ls --format=long'
    fi

    alias less='less -r'
    alias tree='tree -C'
fi

# Custom aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias c='clear'
[ $_IS_LINUX ] && alias o='gnome-open'
[ $_IS_MAC ] && alias o='open'
[ $_IS_MAC ] && alias quicklook='qlmanage -p'
alias monitor-off='xset dpms force off'
alias path='echo "$PATH" | tr -s ":" "\n"' # Pretty print the PATH

alias ack='ACK_PAGER_COLOR="less -x4SRFX" /usr/bin/ack-grep -a -C 1 --follow'
alias aga='ag -a' #ag with everything
alias agh='ag --depth 0' #ag here, search only current folder
alias apt-whatprovides='apt-cache policy'
[ $_IS_MAC ] && alias bootstrap-macports='export PATH=/opt/local/bin:/opt/local/sbin:$PATH'
alias calc='gnome-calculator &'
[ $_IS_MAC ] && alias cdf="cd \"\$(osascript -e 'tell app \"Finder\" to POSIX path of (insertion location as alias)')\""
[ $_IS_MAC ] && alias dev-mode="sudo /usr/sbin/DevToolsSecurity -enable"
[ $_IS_MAC ] && alias eject='diskutil unmount'
[ $_IS_MAC ] && alias eject-time-machine='sudo diskutil unmount force /Volumes/com.apple.TimeMachine.Time\ Machine-*'
alias l='ls -FC'
alias la='ls -FAh'
alias ll='ls -Flh'
alias ff='findfile'
alias find='find -L'
alias findfile='find -L . -iname'
alias fix='tset'
[ $_IS_MAC ] && alias flush-dns="sudo killall -HUP mDNSResponder"
alias fuck='$(thefuck $(fc -ln -1))'
alias duck='$(THEFUCK_REQUIRE_CONFIRMATION=true thefuck $(fc -ln -1))'
alias gpg-forget='echo RELOADAGENT | gpg-connect-agent'
alias h1='history 10'
alias h2='history 20'
alias h3='history 30'
alias history-search='history | grep '
alias history-time='HISTTIMEFORMAT="%F %T " history'
alias lvl='echo $SHLVL'
alias nautilus-fallback='dbus-launch nautilus --no-desktop'
alias nautilus-mounts='cd "$XDG_RUNTIME_DIR/gvfs"'
[ $_IS_MAC ] && alias restart-audio='sudo killall coreaudiod'
[ $_IS_MAC ] && alias restart-camera='sudo killall VDCAssistant'
alias random-mac="sudo ifconfig en0 ether $(openssl rand -hex 6 | sed 's%\(..\)%\1:%g; s%.$%%')"
alias rcd='cd -P .' # Real cd
alias qrreader='zbarimg -q --raw'
alias scp-compressed='scp -C -o CompressionLevel=9'
alias shred='shred -u'
alias ssh-keygen='ssh-keygen -o'
alias ssh-once='ssh -o "UserKnownHostsFile=/dev/null"'
alias tmux-prefix='tmux set -g prefix C-a'
alias tmux-fix='tmux unbind -n n \; unbind -n N'
alias unquote='python3 -c "import urllib.parse, fileinput, sys; print(urllib.parse.unquote_plus(sys.argv[1])) if len(sys.argv) == 2 else [print(urllib.parse.unquote_plus(l)) for l in fileinput.input()];"'
alias vi='vim'
alias vimgit='vim . +Gstatus +"resize +5"'
#alias wget='wget --no-check-certificate'
alias wget-mirror='wget --no-parent --no-check-certificate --html-extension --convert-links --restrict-file-names=windows --recursive --level=inf --page-requisites -e robots=off --wait=0 --quota=inf'

jdk() {
    version=$1
    export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
    java -version
 }

# Kill Adobe cruft
killadobe() {
    sudo killall 'AdobeIPCBroker' 'Adobe Desktop Service' 'CCXProcess' 'Core Sync' 'Core Sync Helper' 'ACCFinderSync'
    #sudo mv \
        #'/Applications/Utilities/Adobe\ Creative\ Cloud\ Experience' \
        #'/Applications/Utilities/Adobe\ Sync' \
        #'/Applications/Utilities/Adobe\ Application\ Manager/IPC' \
        #'/Library/Application\ Support/Adobe/Adobe\ Desktop\ Common/ADS' \
        #~/.Trash/
}

# Handle crush-and-replace for PNG images
crushthis() {
    cp "$1" "/tmp/$1"
    destination=$1
    if [ "$2" ]; then
        destination=$2
    fi
    pngcrush --brute "/tmp/$1" "$destination"
    rm "/tmp/$1"
}
flac-conversion() {
    for file in *.flac
    do
        converted_name=$(echo "$file" | sed 's/flac/mp3/')
        ffmpeg -i "$file" -b:a 320k "$converted_name"
    done
}
aax-dedrm() {
    ffmpeg -activation_bytes "$AUDIBLE_ACTIVATION_BYTES" -i "$1" -vn -c:a copy -v debug "$2"
}

# Use with pipes as input or output
if [ $_IS_LINUX ]; then
    alias toclip='xclip -selection clipboard'
    alias fromclip='xclip -o'
elif [ $_IS_MAC ]; then
    alias toclip='pbcopy'
    alias fromclip='pbpaste'
    alias plainclip='pbpaste | textutil -convert txt -stdin -stdout -encoding 30 | pbcopy'
fi
catclip () {
   toclip < "$1"
}
alias pubkey="catclip ~/.ssh/id_rsa.pub"

# System administration
ssh-copy-public-key () {
    if [ -z "$1" ] || [[ "$1" == '--help' ]] || [[ "$1" == '-h' ]]; then
        echo 'Usage: ssh-copy-public-key key.pub hostname.example.org'
    fi
    ssh "$2" "cat >> .ssh/authorized_keys" < "$1"
}
alias serve='python3 -m http.server 8000'
alias ports='netstat -tulpn'
#alias port='netstat -tulpn | grep'
alias ssl-text='openssl x509 -text -noout -in'
ssl-self-signed() {
    openssl req -x509 -nodes -days 365 -sha256 -newkey rsa:4096 \
        -subj "/C=AU/ST=Queensland/L=Townsville/CN=$1" \
        -keyout "$1.key" -out "$1.crt"
}
alias hash-wpa2-passwd='python -c "import getpass; print(getpass.getpass())" | iconv -t utf16le | openssl md4'
csr-generate() {
    if [ -z "$1" ] || [[ "$1" == '--help' ]] || [[ "$1" == '-h' ]]; then
        echo 'Usage: csr-generate hostname.example.org [openssl-options]'
        echo 'Any arbitrary options passed to csr-generate will be passed'
        echo 'to the [openssl req] command.'
        return
    fi
    openssl req -out "$1.csr" -new -newkey rsa:4096 -nodes -keyout "$1.key" "${@:2}"
}

# Development
gemcd() {
    pushd $(bundle info "$1" | grep Path: | cut -w -f 3)
}
alias eggdoc='python setup.py --long-description | rst2html > foo.html; x-www-browser foo.html'
eggcd() {
    pushd "$(echo -n "$1" | sed -e 's/\./\//g')"
}
svn-authors() {
    svn log "$1" | grep -E '^r[0-9]+' | cut -d '|' -f2 | sort | uniq | xargs -I {} echo '{}= <>'
}
pcd() {
   dir="$(EDITOR=echo pipenv open "$1" | grep -v 'in your EDITOR')"
   pushd "$dir" || return
}

# Mac specific
if [ $_IS_MAC ]; then
    alias search="mdfind -name"
    bluetooth-disable() {
        sudo defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 0 && \
            sudo killall -HUP blued
    }
    bluetooth-enable() {
        sudo defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 1
    }
    bluetooth-status() {
        defaults read /Library/Preferences/com.apple.Bluetooth ControllerPowerState
    }
fi

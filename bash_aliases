#!/bin/bash
# vim:tw=78:ft=sh

# Enable color support of commands 
if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
    eval "$(dircolors -b)"
    alias ls='ls -F --color=auto'
    alias dir='ls --color=auto --format=vertical'
    alias vdir='ls --color=auto --format=long'

    alias grep='grep --color=auto --exclude-dir=\.svn'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

    alias less='less -r'
fi

# Custom aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias c='clear'
alias o='gnome-open'
alias monitor-off='xset dpms force off'
alias path='echo "$PATH" | tr -s ":" "\n"' # Pretty print the PATH

alias ack='ACK_PAGER_COLOR="less -x4SRFX" /usr/bin/ack-grep -a -C 1 --follow'
alias agh='ag --depth 0' #ag here, search only current folder
alias apt-whatprovides='apt-cache policy'
alias calc='gnome-calculator &'
alias l='ls -FC'
alias la='ls -FAh'
alias ll='ls -Flh'
alias find='find -L'
alias findfile='find -L . -iname'
alias fix='tset'
alias fuck='$(thefuck $(fc -ln -1))'
alias duck='$(THEFUCK_REQUIRE_CONFIRMATION=true thefuck $(fc -ln -1))'
alias h1='history 10'
alias h2='history 20'
alias h3='history 30'
alias history-search='history | grep '
alias history-time='HISTTIMEFORMAT="%F %T " history'
alias nautilus-fallback='dbus-launch nautilus --no-desktop'
alias nautilus-mounts='cd "$XDG_RUNTIME_DIR/gvfs"'
alias rcd='cd -P .' # Real cd
alias scp-compressed='scp -C -o CompressionLevel=9'
alias tmux-prefix='tmux set -g prefix C-a'
#alias wget='wget --no-check-certificate'
alias vimgit='vim . +Gstatus +"resize +5"'

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
        avconv -i "$file" -b 320k "$converted_name"
    done
}

# Use with pipes as input or output
alias toclip='xclip -selection clipboard'
alias fromclip='xclip -o'
catclip () {
   toclip < "$1"
}

# System administration
ssh-copy-public-key () {
    if [ -z "$1" ] || [[ "$1" == '--help' ]] || [[ "$1" == '-h' ]]; then
        echo 'Usage: ssh-copy-public-key key.pub hostname.example.org'
    fi
    ssh "$2" "cat >> .ssh/authorized_keys" < "$1"
}
alias serve='python -m SimpleHTTPServer 8000'
alias ports='netstat -tulpn'
alias port='netstat -tulpn | grep'
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
alias eggdoc='python setup.py --long-description | rst2html > foo.html; x-www-browser foo.html'
eggcd() {
    cd "$(echo -n "$1" | sed -e 's/\./\//g')"
}
svn-authors() {
    svn log "$1" | grep -E '^r[0-9]+' | cut -d '|' -f2 | sort | uniq | xargs -I {} echo '{}= <>'
}

# vim:tw=78:ft=sh
# Enable color support of commands 
if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls -F --color=auto'
    alias dir='ls --color=auto --format=vertical'
    alias vdir='ls --color=auto --format=long'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Custom aliases
alias o='gnome-open'
alias monitor-off='xset dpms force off'
alias ack='ACK_PAGER_COLOR="less -x4SRFX" /usr/bin/ack-grep -a -C 1 --follow'
alias apt-whatprovides='apt-cache policy'
alias calc='gnome-calculator &'
alias l='ls -FC'
alias la='ls -FAh'
alias ll='ls -Flh'
alias find='find -L'
alias findfile='find -L . -iname'
alias fix='tset'
alias history-search='history | grep '
alias nautilus-fallback='dbus-launch nautilus --no-desktop'
alias rcd='cd -P .' # Real cd
alias scp-compressed='scp -C -o CompressionLevel=9'
#alias wget='wget --no-check-certificate'
alias vimgit='vim . +Gstatus +"resize +5"'
function flac-conversion() {
    for file in *.flac
    do
        converted_name=$(echo $file | sed 's/flac/mp3/')
        avconv -i $file -b 320k $converted_name
    done
}

# Use with pipes as input or output
alias toclip='xclip -selection clipboard'
alias fromclip='xclip -o'

# System administration
function ssh-copy-public-key () {
    if [ -z $1 ] || [[ $1 == '--help' ]] || [[ $1 == '-h' ]]; then
        echo 'Usage: ssh-copy-public-key key.pub hostname.example.org'
    fi
    cat $1 | ssh $2 "cat >> .ssh/authorized_keys"
}
alias serve='python -m SimpleHTTPServer 8000'
alias port='sudo netstat -tulpn | grep'
alias ssl-text='openssl x509 -text -noout -in'
alias hash-wpa2-passwd='python -c "import getpass; print(getpass.getpass())" | iconv -t utf16le | openssl md4'
function csr-generate() {
    if [ -z $1 ] || [[ $1 == '--help' ]] || [[ $1 == '-h' ]]; then
        echo 'Usage: csr-generate hostname.example.org [openssl-options]'
        echo 'Any arbitrary options passed to csr-generate will be passed'
        echo 'to the `openssl req` command.'
        return
    fi
    openssl req -out $1.csr -new -newkey rsa:3072 -nodes -keyout $1.key "${@:2}"
}

# Development
alias eggdoc='python setup.py --long-description | rst2html > foo.html; x-www-browser foo.html'
function eggcd() {
    cd `echo -n $1 | sed -e 's/\./\//g'`
}
function svn-authors() { 
    svn log "$1" | grep -E '^r[0-9]+' | cut -d '|' -f2 | sort | uniq | xargs -I {} echo '{}= <>'
}

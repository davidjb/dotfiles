# Enable color support of commands 
if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias dir='ls --color=auto --format=vertical'
    alias vdir='ls --color=auto --format=long'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Custom aliases
alias ack='ACK_PAGER_COLOR="less -x4SRFX" /usr/bin/ack-grep -a -C 1 --follow'
alias calc='gcalctool &'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -l'
alias find='find -L'
alias findfile='find -L . -iname'
alias fix='tset'
alias history-search='history | grep '
alias scp-compressed='scp -C -o CompressionLevel=9'
#alias wget='wget --no-check-certificate'

# Use with pipes as input or output
alias toclip='xclip -selection clipboard'
alias fromclip='xclip -o'

# System administration
alias port='netstat -tulpn | grep'
alias ssl-text='openssl x509 -text -noout -in'
alias hash-wpa2-passwd='python -c "import getpass; print(getpass.getpass())" | iconv -t utf16le | openssl md4'
function gen-passwd() {
    python -c "import random, string; print('Generated this: ' + ''.join(random.choice(string.letters + string.digits) for i in range(random.randint(24,32))))"
}
function gen-passwd-punc() {
    python -c "import random, string; print('Generated this: ' + ''.join(random.choice(string.printable[:-10]) for i in range(random.randint(24,32))))"
}
function csr-generate() { 
    openssl req -out $1.csr -new -newkey rsa:3072 -nodes -keyout $1.key
}

# Development
alias eggdoc='python setup.py --long-description | rst2html > foo.html; x-www-browser foo.html'
function eggcd() {
    cd `echo -n $1 | sed -e 's/\./\//g'`
}
function svn-authors() { 
    svn log "$1" | grep -E '^r[0-9]+' | cut -d '|' -f2 | sort | uniq | xargs -I {} echo '{}= <>'
}

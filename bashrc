# vim:tw=78:ft=sh
# If not running interactively, don't do anything
[ -z "$PS1" ] && return
[[ $OSTYPE == "darwin"*  ]] && _IS_MAC=yes

# Don't put duplicate lines in the history, ignore commands with leading space.
# See bash(1) for more options
export HISTCONTROL=ignorespace:ignoredups

# Configure terminal for 256 colours
export TERM=xterm-256color

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# autocd - Automatic cd to directories
# cdspell - Simple spell check for cd
# checkjobs - Output job information on attempting to exit
# checkwinsize - Check window size after commands and update LINES/COLUMNS
# cmdhist - Save multi-line commands as same history entry
# For remainder of options, see "list of shopt options" in the bash man page.
shopt -s autocd cdspell checkjobs checkwinsize cmdhist expand_aliases extglob extquote force_fignore interactive_comments progcomp promptvars sourcepath

#color_prompt=yes
#if [ "$color_prompt" = yes ]; then
    #PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#else
    #PS1='\u@\h:\w\$ '
#fi
#unset color_prompt 

# Use vi editing mode for commands
set -o vi

# Disable terminal flow via ^S and ^Q
stty -ixon

# Powerline
powerline-daemon -q
export POWERLINE_BASH_CONTINUATION=1
export POWERLINE_BASH_SELECT=1
. ~/.vim/bundle/powerline/powerline/bindings/bash/powerline.sh

# Enable programmable completion features for bash
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Pass integration
if [ -f /usr/local/etc/bash_completion.d/password-store ]; then
    . /usr/local/etc/bash_completion.d/password-store
fi

# pip bash completion start
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip
# pip bash completion end

# Alias definitions
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Environment variable definitions
if [ -f ~/.environment ]; then
    . ~/.environment
fi

# Enable autoenv
. ~/.autoenv/activate.sh

# Enable private Bash includes
shopt -s nullglob
for file in ~/.bash_private/*
do
    . "$file"
done
shopt -u nullglob

# Tab completion for Grunt
eval "$(grunt --completion=bash)"

#. /usr/local/bin/virtualenvwrapper.sh
#export WORKON_HOME=~/buildout

# GPG agent invocation
# https://blog.chendry.org/2015/03/13/starting-gpg-agent-in-osx.html
if [ $_IS_MAC ]; then
    [ -f ~/.gpg-agent-info ] && source ~/.gpg-agent-info
    if [ -S "${GPG_AGENT_INFO%%:*}"  ]; then
        export GPG_AGENT_INFO
    else
        eval $( gpg-agent --daemon --write-env-file ~/.gpg-agent-info )
    fi

    [ -f ~/.ssh-agent ] && source ~/.ssh-agent
    if [ -S "${SSH_AGENT_PID%%:*}"  ]; then
        export SSH_AGENT_PID
    else
        eval $( ssh-agent > ~/.ssh-agent )
    fi
fi


### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"


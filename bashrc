# vim:tw=78:ft=sh
# If not running interactively, don't do anything
[ -z "$PS1" ] && return
[[ $OSTYPE == "darwin"*  ]] && _IS_MAC=yes


##########################
# Core configuration
##########################

# Don't put duplicate lines in the history, ignore commands with leading space.
# See bash(1) for more options
export HISTCONTROL=ignorespace:ignoredups

# Configure terminal for 256 colours
export TERM=xterm-256color

# autocd - Automatic cd to directories
# cdspell - Simple spell check for cd
# checkjobs - Output job information on attempting to exit
# checkwinsize - Check window size after commands and update LINES/COLUMNS
# cmdhist - Save multi-line commands as same history entry
# For remainder of options, see "list of shopt options" in the bash man page.
shopt -s autocd cdspell checkjobs checkwinsize cmdhist expand_aliases extglob extquote force_fignore interactive_comments progcomp promptvars sourcepath

# Use vi editing mode for commands
set -o vi

# Disable terminal flow via ^S and ^Q
stty -ixon


##############################
# Personal external inclusions
##############################

# Alias definitions
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Environment variable definitions
if [ -f ~/.environment ]; then
    . ~/.environment
fi

# Enable private Bash includes
shopt -s nullglob
for file in ~/.bash_private/*
do
    . "$file"
done
shopt -u nullglob


##########################
# Autocompletion features
##########################

# Enable system-wide completion features
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
elif [ -f /usr/local/etc/bash_completion  ]; then
    . /usr/local/etc/bash_completion
fi

# pass
if [ -f /usr/local/etc/bash_completion.d/password-store ]; then
    . /usr/local/etc/bash_completion.d/password-store
fi

# pip for Python
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip

# Grunt
eval "$(grunt --completion=bash)"


##########################
# Prompt setup ~ powerline
##########################

powerline-daemon -q
export POWERLINE_BASH_CONTINUATION=1
export POWERLINE_BASH_SELECT=1
. ~/.vim/bundle/powerline/powerline/bindings/bash/powerline.sh


##########################
# Platform-specific setup
##########################

#noop

##########################
# External inclusions
##########################

# Enable autoenv on `cd`
. ~/.autoenv/activate.sh

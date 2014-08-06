# vim:tw=78:ft=sh
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

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
. ~/.vim/bundle/powerline/powerline/bindings/bash/powerline.sh

# Enable programmable completion features for bash
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

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
    . $file
done
shopt -u nullglob

#. /usr/local/bin/virtualenvwrapper.sh
#export WORKON_HOME=~/buildout

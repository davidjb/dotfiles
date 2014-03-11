# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Don't put duplicate lines in the history, ignore commands with leading space.
# See bash(1) for more options
export HISTCONTROL=ignorespace:ignoredups

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

#color_prompt=yes
#if [ "$color_prompt" = yes ]; then
    #PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#else
    #PS1='\u@\h:\w\$ '
#fi
#unset color_prompt 

# Powerline
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

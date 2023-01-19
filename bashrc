# vim:tw=78:ft=sh
# If not running interactively, don't do anything
[ -z "$PS1" ] && return
[[ $OSTYPE == "darwin"*  ]] && _IS_MAC=yes
CPU=$(uname -p)

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
for file in ~/.bash_private/*.sh
do
    . "$file"
done
shopt -u nullglob


##########################
# Platform-specific setup
##########################

# Homebrew
if [ $_IS_MAC ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    #if [[ "$CPU" == "arm" ]]; then
    #fi
fi


##########################
# Autocompletion features
##########################

# Enable system-wide completion features
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
if type brew &>/dev/null
then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
  then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
    do
      [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
  fi
fi

# Fzf fuzzy finder
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

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

# vi mode indicators
bind 'set show-mode-in-prompt on'
bind 'set vi-ins-mode-string \1\e[38;5;25;48;5;252;1m\2 I \1\e[38;5;252;48;5;31;1m\2\1\e[0m\2'
bind 'set vi-cmd-mode-string \1\e[38;5;22;48;5;10;1m\2 N \1\e[38;5;10;48;5;31;1m\2\1\e[0m\2'

##########################
# External inclusions
##########################

# Enable direnv on `cd`
eval "$(direnv hook bash)"

export SHELL=$(which bash)
ulimit -n 8192

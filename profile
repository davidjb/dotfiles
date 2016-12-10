# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile
#umask 022

[[ $OSTYPE == "darwin"*  ]] && _IS_MAC=yes

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
    fi
fi

# GPG agent invocation
# https://blog.chendry.org/2015/03/13/starting-gpg-agent-in-osx.html
if [ $_IS_MAC ]; then
    [ -f ~/.gpg-agent-info  ] && source ~/.gpg-agent-info
    if [ -S "${GPG_AGENT_INFO%%:*}"  ]; then
      export GPG_AGENT_INFO
    else
      eval $( gpg-agent --daemon --write-env-file ~/.gpg-agent-info )
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
export LANGUAGE="en_US:en"
export LC_MESSAGES="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"

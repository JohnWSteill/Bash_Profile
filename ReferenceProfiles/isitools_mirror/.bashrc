# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

umask 002

# HISTORY - last 100K commands
export HISTSIZE=100000
## erase previous duplicates
# export HISTCONTROL=erasedups
# append, no override
shopt -s histappend

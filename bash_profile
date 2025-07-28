BASH_PROFILE_HOME=$HOME/bin/Bash_Profile
source $BASH_PROFILE_HOME/git_profile

# ~/.bashrc

# ---------------------
# Aliases and Shortcuts
# ---------------------

alias ..='cd ..'
alias ...='cd ../..'
alias ls='ls -G'
alias clearNb="python3 -m nbconvert --ClearOutputPreprocessor.enabled=True --inplace"

export PS1='\[\e[1;91m\]\A  \W\[\e[0m\] > '

# ---------------------
# Enable programmable completion
# ---------------------
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi
export PATH="/usr/local/opt/python@3.13/bin:$PATH"

# Save and reload the history after each command finishes
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend
export HISTSIZE=50000
export HISTFILESIZE=50000
export HISTCONTROL="ignoreboth:erasedups" # no duplicate entries, cmds wth space
export PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
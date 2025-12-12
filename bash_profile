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

# ---------------------
# Safe rm (interactive only)
# ---------------------
case $- in
  *i*)
    trash() {
      local trash_dir="$HOME/.trash"
      mkdir -p "$trash_dir" || return

      local src
      for src in "$@"; do
        [[ "$src" == -* ]] && { printf 'trash: refusing option-like arg: %s\n' "$src" >&2; continue; }
        [[ ! -e "$src" ]] && { printf 'trash: %s: No such file or directory\n' "$src" >&2; continue; }

        local base target
        base="${src##*/}"
        target="$trash_dir/${base}_$(date +%Y%m%d-%H%M%S)_$$"
        mv -- "$src" "$target"
      done
    }

    alias rm='trash'
    alias realrm='/bin/rm'
    ;;
esac

export PS1='\[\e[1;91m\]\A  \W\[\e[0m\] > '
# export PS1='\[\e[1;91m\]${VIRTUAL_ENV:+" "}\A  \W\[\e[0m\] > '

# ---------------------
# Enable programmable completion
# ---------------------
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi
export PATH="/opt/homebrew/opt/python@3.13/libexec/bin:$PATH"

# Save and reload the history after each command finishes
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend
export HISTSIZE=50000
export HISTFILESIZE=50000
export HISTCONTROL="ignoreboth:erasedups" # no duplicate entries, cmds wth space
export PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Setting PATH for Python 3.12
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:${PATH}"
export PATH
eval "$(/opt/homebrew/bin/brew shellenv)"
export JAVA_HOME=$(/usr/libexec/java_home)
source ~/.env
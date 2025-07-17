# ~/.bashrc

# ---------------------
# Aliases and Shortcuts
# ---------------------

alias gs='git status'
alias gl='git log --oneline --graph --decorate'
alias ..='cd ..'
alias ...='cd ../..'

# Confirm before overwriting
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# ---------------------
# Pyenv (if installed)
# ---------------------
if command -v pyenv &>/dev/null; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# ---------------------
# Git branch in prompt (optional)
# ---------------------

export PS1='\[\e[1;91m\]\A  \h  \W\[\e[0m\] > '
# ---------------------
# Less annoying less
# ---------------------
export LESS='-R'

# ---------------------
# Enable programmable completion
# ---------------------
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

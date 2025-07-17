# Bash Profile Reboot: 10 Recommended Enhancements

This document lists 10 curated, portable enhancements from your old Bash configuration. These are designed to help you reboot your environment with a clean, efficient, and modern setup.

Each suggestion is minimal, safe for macOS and Linux, and avoids brittle legacy logic.

---

## 1. Enhanced PS1 Prompt

```bash
export PS1='\[\e[1;91m\]\A  \h  \W\[\e[0m\] > '
```

> A colorful, readable prompt showing time, hostname, and working directory.

---

## 2. Arrow-Key History Search

```bash
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
```

> Press ↑ and ↓ to autocomplete from history entries that match what you’ve typed.

---

## 3. Better History Behavior

```bash
export HISTSIZE=50000
export HISTFILESIZE=50000
export HISTCONTROL="ignoreboth:erasedups"
shopt -s histappend
export PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"
```

> Giant, deduplicated shell history that syncs across sessions.

---

## 4. Useful Aliases

```bash
alias ll='ls -alF'
alias ..='cd ..'
alias ...='cd ../..'
alias gs='git status'
alias gl='git log --oneline --graph --decorate'
alias vi='vi'
```

> Common navigation and Git shortcuts; `vi` alias protects against unwanted overrides.

---

## 5. Quality-of-Life Git Log Aliases

```bash
alias glp="git log --pretty=format:\"%cr: %s\""
alias glg="git log --oneline --decorate --graph --all"
alias glgc="git log --graph --full-history --all --color --pretty=format:\"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s\""
```

> Beautiful and compact Git history views.

---

## 6. `clearNb` — Jupyter Notebook Cleaner

```bash
alias clearNb="python3 -m nbconvert --ClearOutputPreprocessor.enabled=True --inplace"
```

> Clears all Jupyter output cells — great before commits.

---

## 7. `pta` — Run All Python Tests

```bash
alias pta="python -m unittest discover"
```

> Quick way to run all unittests without external tooling.

---

## 8. `envp` / `envp_off` — Quick venv Toggle

```bash
alias envp="source ~/.pyVirt/env/bin/activate"
alias envp_off="deactivate"
```

> Fast activation/deactivation for your default virtual environment.

---

## 9. `gzip()` + `gunzip()` using `pigz`

```bash
gzip() { pigz "$@"; }
gunzip() { unpigz "$@"; }
```

> Drop-in replacements for faster, multi-threaded compression.

---

## 10. `see_ls_colors` — LS_COLORS Debug Tool

```bash
function see_ls_colors {
    IFS=:
    for i in $LS_COLORS
    do
        echo -e "\e[${i#*=}m$( x=${i%=*}; [ \"${!x}\" ] && echo \"${!x}\" || echo \"$x\" )\e[m"
    done
}
```

> Handy visualizer for debugging LS_COLORS themes.

---

### 📝 Notes

These suggestions were selected from your old Bash config to create a clean, efficient, and modern development environment. All of them are platform-safe, useful, and minimal.

You can copy them directly into your `.bashrc` or `.bash_profile` as needed.  
**Comment out anything you're unsure of and test incrementally.**

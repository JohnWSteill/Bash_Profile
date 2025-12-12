# give_bash_profile_some_tlc.prompt.md

You are helping me clean up and modernize my bash environment on macOS (Apple Silicon), reduce historical cruft, and add safety guardrails after a recent `rm -rf` disaster.

Constraints:
- Single machine profile now (no more multi-host switching logic unless it’s truly needed).
- Prefer boring, standard, well-known patterns.
- Avoid changes that break non-interactive shells, scripts, CI, or SSH remote commands.
- Make changes incrementally, with easy rollback.

## 0) Immediate guardrails (same spirit as `Recovery_Stuff/RECOVERY_TODO.md`)

### 0.1 Safe `rm` — only for interactive shells

Goal: stop accidental destructive deletes, without breaking scripts.

Preferred pattern:
- Define a `trash` function.
- Alias `rm` to `trash` only when the shell is interactive.
- Keep a bypass `rm!` mapped to `/bin/rm`.

Example (adapt as needed):

```bash
# Only for interactive shells
case $- in
  *i*) ;; 
  *) return ;;
esac

trash() {
  local trash_dir="$HOME/.trash"
  mkdir -p "$trash_dir"
  for file in "$@"; do
    [[ "$file" == -* ]] && continue
    [[ ! -e "$file" ]] && echo "trash: $file: No such file or directory" && continue
    mv "$file" "$trash_dir/$(basename "$file")_$(date +%s)"
  done
}

alias rm='trash'
alias rm!='\command rm'
```

Notes:
- If you already have a known-good safe-rm snippet, keep it; just ensure the interactive-shell guard exists.
- If you use macOS Finder Trash, consider `trash` (Homebrew) or moving to `~/.Trash` — but keep it simple.

Verification:

```bash
type rm
rm! --version 2>/dev/null || true
```

### 0.2 Git “private backup” remote

Goal: always have an offsite mirror of branches/tags.

```bash
git remote add private git@github.com:YOUR_USERNAME/cd4-private.git
git push private --all
git push private --tags
```

## 1) Inventory before touching anything

Run these commands and save the output in a scratch file (so you can compare before/after).

```bash
# Shell identity
bash --version
uname -a

# Where bash reads config from
printf 'BASH_ENV=%q\n' "$BASH_ENV"
printf 'INPUTRC=%q\n' "$INPUTRC"

# Current PATH (one entry per line)
python3 - <<'PY'
import os
for p in os.environ.get('PATH','').split(':'):
    print(p)
PY

# Homebrew detection
command -v brew || true
brew --prefix 2>/dev/null || true
brew --version 2>/dev/null || true

# What completion is loaded
shopt -p progcomp || true
complete -p | sed -n '1,200p'

# Readline settings that can affect completion behavior
bind -V
bind -v | sed -n '1,200p'

# Any weird aliases/functions
alias | sed -n '1,200p'
declare -F | sed -n '1,200p'
```

Also inspect these files if present:
- `~/.bash_profile`
- `~/.bashrc`
- `~/.profile`
- `~/.inputrc`
- any sourced files under `~/bin/Bash_Profile/`

## 2) Simplify profile topology (recommended layout)

Target behavior:
- `~/.bash_profile`: minimal, only for login shells; sources `~/.bashrc`.
- `~/.bashrc`: interactive shell configuration (aliases, prompt, completion, functions).
- Optional: `~/.bashrc.d/*.bash` fragments sourced from `.bashrc` (keeps things tidy).

Suggested `.bash_profile` (minimal):

```bash
# ~/.bash_profile

# Source interactive config if it exists
if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi
```

Then keep the rest in `.bashrc` (or your repo-managed profile files) behind an interactive-shell guard:

```bash
# ~/.bashrc
case $- in
  *i*) ;;
  *) return ;;
esac

# source your repo-managed stuff
# . "$HOME/bin/Bash_Profile/bash_profile"  # example
```

## 3) Homebrew modernization (Apple Silicon)

On Apple Silicon, Homebrew typically lives at:
- `/opt/homebrew/bin/brew`
- prefix: `/opt/homebrew`

Golden rule: use `brew shellenv` and stop hard-coding 2018-era paths.

In `.bashrc` (or the sourced profile file), do:

```bash
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
```

What this fixes:
- `PATH`, `MANPATH`, `INFOPATH` consistent.
- Avoids brittle `export PATH=...` piles.

Verification:

```bash
command -v brew
brew --prefix
which python3
python3 -c 'import sys; print(sys.executable)'
```

## 4) The “tab completion adds ./” problem (root-cause playbook)

Symptom: typing `my_file<TAB>` becomes `./my_file`.

This is usually caused by *completion/readline configuration*, not bash itself. Typical suspects:
- `bash-completion` scripts (Homebrew) being sourced multiple times or conflicting versions.
- custom completion functions using `compgen -f` / `-o filenames` with path normalization.
- readline settings in `~/.inputrc`.

### 4.1 Quick bisect (fast)

Start a clean interactive bash without reading any rc files:

```bash
bash --noprofile --norc
```

If the problem disappears here, it’s in your profile files (good news).

### 4.2 Identify if bash-completion is loaded

In your normal shell:

```bash
# show where bash_completion is coming from
ls -la /opt/homebrew/etc/profile.d 2>/dev/null || true
ls -la /usr/local/etc/profile.d 2>/dev/null || true

# show if completion is enabled
shopt -p progcomp
```

Standard Homebrew bash-completion load (only once):

```bash
# ~/.bashrc
if [ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]; then
  . "$(brew --prefix)/etc/profile.d/bash_completion.sh"
fi
```

Avoid loading:
- both `/opt/homebrew/.../bash_completion.sh` and `/usr/local/.../bash_completion.sh`.
- multiple custom completion frameworks simultaneously.

### 4.3 Search for completions that rewrite paths

Search your profile repo for:
- `compopt`
- `complete -F`
- `compgen`
- `bash_completion`
- `.inputrc` tweaks

```bash
grep -R "compopt\|complete -\|compgen\|bash_completion\|INPUTRC\|\.inputrc" -n ~/bin/Bash_Profile 2>/dev/null
```

### 4.4 Readline config check

Look at `~/.inputrc` (and any `INPUTRC` override). Things that can affect completion display/behavior:
- `set show-all-if-ambiguous`
- `set visible-stats`
- `set mark-directories`

Even if none mention `./`, it’s worth temporarily disabling `.inputrc`:

```bash
INPUTRC=/dev/null bash --noprofile --norc
```

If that fixes it, the issue is in readline config.

### 4.5 If you want a “cheap fix” (even before root-cause)

Two options that reduce confusion while you debug:
- Increase safety friction for `rm` (you already did).
- Add a big, visible prompt marker when you are in a repo root vs elsewhere.

Example (minimal):

```bash
PS1='\u@\h \W$ '
```

## 5) Cleanup strategy (low risk)

1. Make a backup branch/commit in your bash-profile repo.
2. Collapse to the minimal `.bash_profile` that sources `.bashrc`.
3. Put everything interactive behind the interactive-shell guard.
4. Replace old brew PATH logic with `brew shellenv`.
5. Ensure bash-completion is loaded at most once.
6. Bisect the `./` completion behavior with `--noprofile --norc`, then reintroduce chunks.

## 6) Definition of done

- `brew` works and points to the expected prefix.
- `python3`, `pip`, and other tooling resolve consistently (no surprise old `/usr/local` fallbacks).
- Tab completion no longer rewrites tokens into `./...` (or you understand exactly why and accept it).
- `rm` is guarded in interactive shells, and scripts still get the real `/bin/rm`.
- The profile is readable: one top-level file plus a few well-named fragments.

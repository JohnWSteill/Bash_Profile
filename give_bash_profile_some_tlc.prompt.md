# give_bash_profile_some_tlc.prompt.md

You are helping me clean up and modernize my bash environment on macOS (Apple Silicon), reduce historical cruft, and add safety guardrails after a recent `rm -rf` disaster.

Constraints:
- Single machine profile now (no more multi-host switching logic unless it’s truly needed).
- Prefer boring, standard, well-known patterns.
- Avoid changes that break non-interactive shells, scripts, CI, or SSH remote commands.
- Avoid breaking VS Code integrated terminal shell integration.
- Make changes incrementally, with easy rollback.

## 0) Immediate guardrails (same spirit as `Recovery_Stuff/RECOVERY_TODO.md`)

### 0.0 After an accidental `rm -rf`: quick recovery triage

Goal: maximize the chance of recovery and reduce repeat accidents.

- If the deleted thing was inside a Git repo, prefer Git recovery first (fast + reliable):

```bash
git status
git log --name-status --all -- <path>
git checkout <good_commit_or_branch> -- <path>
```

- Check macOS backups/snapshots (if you have them):
  - Time Machine: restore the folder/file.
  - iCloud/Dropbox/Drive: check their “Deleted files” UI.
  - APFS snapshots (if enabled): list/restore via your backup tooling.

If you’re unsure, pause big writes (mass installs/copies) until you’ve tried the most likely recovery route.

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
alias rm!='/bin/rm'
```

Notes:
- If you already have a known-good safe-rm snippet, keep it; just ensure the interactive-shell guard exists.
- If you use macOS Finder Trash, consider `trash` (Homebrew) or moving to `~/.Trash` — but keep it simple.

Verification:

```bash
type rm
type rm!
```

### 0.2 Secrets hygiene (important)

Goal: keep tokens out of versioned dotfiles.

- Even in a private repo, prefer not to commit secrets (e.g. `GITLAB_TOKEN`) into tracked files.
  - “Private + expiring soon” lowers risk, but it’s still easy to accidentally paste/log/share a repo later.
- Source an untracked secrets file instead:

```bash
[ -f "$HOME/.bash_profile_secrets" ] && . "$HOME/.bash_profile_secrets"
```

- If a token ever made it into git history, rotate/revoke it.

### 0.3 Git “private backup” remote

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

# Prompt plumbing (VS Code shell integration often uses PROMPT_COMMAND)
printf 'PROMPT_COMMAND=%q\n' "${PROMPT_COMMAND-}"
printf 'PS1=%q\n' "${PS1-}"

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
- `~/.bash_profile`: minimal, just sources your repo-managed `bash_profile`.
- (Optional) `~/.bashrc`: either unused, or used only as a thin compatibility shim.
- Optional: `~/.bashrc.d/*.bash` fragments sourced from `.bashrc` (keeps things tidy).

Suggested `~/.bash_profile` (minimal, your stated goal):

```bash
# ~/.bash_profile

# Source repo-managed profile
if [ -f "$HOME/bin/Bash_Profile/bash_profile" ]; then
  . "$HOME/bin/Bash_Profile/bash_profile"
fi
```

If you want `.bashrc` for compatibility (some tools expect it), keep it as a thin shim:

```bash
# ~/.bashrc
if [ -f "$HOME/bin/Bash_Profile/bash_profile" ]; then
  . "$HOME/bin/Bash_Profile/bash_profile"
fi
```

Then keep interactive-only behavior behind an interactive-shell guard (in the sourced file):

```bash
# ~/.bashrc
case $- in
  *i*) ;;
  *) return ;;
esac

# source your repo-managed stuff
# . "$HOME/bin/Bash_Profile/bash_profile"  # example

# Note: this repo contains legacy fragments (e.g. `alias_and_env_profile`) that assume old multi-host logic
# (like `$onMac`) and include Linux-only/tooling-specific paths. Don’t source them unless you intentionally
# migrate selected pieces.
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

## 3.5 Prompt + history without breaking VS Code shell integration

Symptom you may see if this is wrong:
- `bash: __vsc_prompt_cmd_original: command not found`

Root cause: clobbering `PROMPT_COMMAND` (or ordering issues) can break VS Code’s injected prompt hooks.

Guidelines:
- Don’t overwrite `PROMPT_COMMAND` with a new string.
- Instead, *prepend* your hook if it isn’t already present.
- Prefer lightweight history sync (`history -a`/`history -n`) over a full `-w; -c; -r` cycle.

Safe pattern:

```bash
__bp_history_sync() {
  builtin history -a
  builtin history -n
}

__bp_pre_prompt() {
  __bp_history_sync
}

case ";${PROMPT_COMMAND-};" in
  *";__bp_pre_prompt;"*) : ;;
  "") PROMPT_COMMAND="__bp_pre_prompt" ;;
  *)  PROMPT_COMMAND="__bp_pre_prompt; ${PROMPT_COMMAND}" ;;
esac
```

If you want your prompt to include the venv name with clean spacing (space only when active), either:
- let the venv activation modify PS1 (fine), and use a PS1 that conditionally inserts a space before your time, or
- set `VIRTUAL_ENV_DISABLE_PROMPT=1` and generate the entire PS1 yourself.

## 4) The “tab completion adds ./” problem (root-cause playbook)

Symptom: typing `my_file<TAB>` becomes `./my_file`.

Important nuance: if this only happens in the VS Code integrated terminal (but not in Terminal.app/iTerm), treat it as an environment/config difference first (shell integration, different rc files sourced, different `INPUTRC`, different completion scripts).

Important: this can be *normal* bash behavior.

- If you are completing the **command position** (first word) and `my_file` is an executable in the current directory but **not** found on `$PATH`, bash may complete it as `./my_file`.
- In **argument position** (e.g. after `cat `), you typically won’t see that `./` prefix.

Quick sanity test:

```bash
my_f<TAB>         # command position
cat my_f<TAB>     # argument position
```

If only the first case yields `./...`, that’s expected and not necessarily a misconfiguration.

If it happens in argument position too, then it’s likely caused by *completion/readline configuration*. Typical suspects:
- `bash-completion` scripts (Homebrew) being sourced multiple times or conflicting versions.
- custom completion functions using `compgen -f` / `-o filenames` with path normalization.
- readline settings in `~/.inputrc`.

### 4.1 Quick bisect (fast)

Start a clean interactive bash without reading any rc files:

```bash
bash --noprofile --norc
```

If the problem disappears here, it’s in your profile files (good news).

### 4.1b VS Code vs Terminal.app diff (quick, targeted)

Run these in BOTH places (VS Code integrated terminal and your normal terminal) and compare:

```bash
echo "SHELL=$SHELL"
echo "0=$0"
ps -p $$ -o command=
printf 'TERM=%q\n' "${TERM-}"
printf 'TERM_PROGRAM=%q\n' "${TERM_PROGRAM-}"
printf 'BASH_ENV=%q\n' "${BASH_ENV-}"
printf 'INPUTRC=%q\n' "${INPUTRC-}"
printf 'PROMPT_COMMAND=%q\n' "${PROMPT_COMMAND-}"

shopt -p progcomp
complete -p | sed -n '1,120p'
bind -V
bind -v | sed -n '1,80p'
```

If VS Code differs, that’s the lead.

### 4.1c VS Code shell integration toggle

VS Code can inject prompt hooks and shell integration. As a temporary diagnostic step:
- disable VS Code “shell integration” and restart the terminal.

If that makes the `./` completion behavior match Terminal.app, focus your fixes on prompt/completion hooks rather than bash itself.

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
PS1='\A  \W > '
```

## 5) Cleanup strategy (low risk)

1. Make a backup branch/commit in your bash-profile repo.
2. Collapse to the minimal `.bash_profile` that sources `.bashrc`.
3. Put everything interactive behind the interactive-shell guard.
4. Replace old brew PATH logic with `brew shellenv`.
5. Ensure bash-completion is loaded at most once.
6. Bisect the `./` completion behavior with `--noprofile --norc`, then reintroduce chunks.
7. Remove secrets from tracked files; source them from an untracked secrets file.

Suggested pacing (so you can stop anytime):
- Session A: interactive guard + PROMPT_COMMAND safety (no VS Code errors).
- Session B: Homebrew + PATH cleanup.
- Session C: completion investigation.

## 6) Definition of done

- `brew` works and points to the expected prefix.
- `python3`, `pip`, and other tooling resolve consistently (no surprise old `/usr/local` fallbacks).
- Tab completion no longer rewrites tokens into `./...` (or you understand exactly why and accept it).
- `rm` is guarded in interactive shells, and scripts still get the real `/bin/rm`.
- The profile is readable: one top-level file plus a few well-named fragments.
- No secrets live in versioned files.

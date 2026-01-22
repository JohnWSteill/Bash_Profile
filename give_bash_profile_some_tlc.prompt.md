# give_bash_profile_some_tlc.prompt.md

You are helping me clean up and modernize my bash environment on macOS (Apple Silicon), reduce historical cruft, and maintain a clean setup.

Constraints:
- Single machine profile now (no more multi-host switching logic unless it's truly needed).
- Prefer boring, standard, well-known patterns.
- Avoid changes that break non-interactive shells, scripts, CI, or SSH remote commands.
- Avoid breaking VS Code integrated terminal shell integration.
- Make changes incrementally, with easy rollback.

## Definition of done

- `brew` works and points to the expected prefix (`/opt/homebrew`).
- `python3`, `pip`, and other tooling resolve consistently (no surprise old `/usr/local` fallbacks).
- Tab completion no longer rewrites tokens into `./...` (or you understand exactly why and accept it).
- The profile is readable: one top-level file plus a few well-named fragments.
- No secrets live in versioned files.

## 1) Homebrew status

On Apple Silicon, Homebrew lives at `/opt/homebrew`. The old Intel location `/usr/local` still has legacy packages.

### Current state (as of Jan 2026)

**ARM Homebrew (`/opt/homebrew`)** - Primary, use this:
```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

**Intel Homebrew (`/usr/local`)** - Legacy, being cleaned up:
- Still has: `r`, `postgresql@14`, `postgresql@16`, `pandoc`, `redis`, `wget`, `openconnect`, `evernote-backup`, `gdrive`, `guile`, `libgit2`, `fribidi`, plus shared dependencies
- `r` depends on `python@3.12` at this location - can't remove python@3.12 without migrating R first
- Consider migrating R to ARM Homebrew when ready: `/opt/homebrew/bin/brew install r`

### Cleanup done
- ✓ Removed `python@3.9`, `python@3.11` from Intel (Jan 2026)
- ✓ Removed `node` from Intel (Jan 2026) - duplicated in ARM
- ✓ Removed `export -f git_ls_l` from git_profile (was causing shell errors)
- ✓ Removed rm/trash guardrails (no longer wanted)

## 2) Prompt + history without breaking VS Code shell integration

Symptom you may see if this is wrong:
- `bash: __vsc_prompt_cmd_original: command not found`

Root cause: clobbering `PROMPT_COMMAND` (or ordering issues) can break VS Code's injected prompt hooks.

Guidelines:
- Don't overwrite `PROMPT_COMMAND` with a new string.
- Instead, *prepend* your hook if it isn't already present.
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

## 3) The "tab completion adds ./" problem (root-cause playbook)

Symptom: typing `my_file<TAB>` becomes `./my_file`.

Important nuance: if this only happens in the VS Code integrated terminal (but not in Terminal.app/iTerm), treat it as an environment/config difference first.

Important: this can be *normal* bash behavior.

- If you are completing the **command position** (first word) and `my_file` is an executable in the current directory but **not** found on `$PATH`, bash may complete it as `./my_file`.
- In **argument position** (e.g. after `cat `), you typically won't see that `./` prefix.

Quick sanity test:

```bash
my_f<TAB>         # command position
cat my_f<TAB>     # argument position
```

If only the first case yields `./...`, that's expected and not necessarily a misconfiguration.

### 3.1 Quick bisect

Start a clean interactive bash without reading any rc files:

```bash
bash --noprofile --norc
```

If the problem disappears here, it's in your profile files.

### 3.2 VS Code vs Terminal.app diff

Run in BOTH places and compare:

```bash
echo "SHELL=$SHELL"
printf 'INPUTRC=%q\n' "${INPUTRC-}"
printf 'PROMPT_COMMAND=%q\n' "${PROMPT_COMMAND-}"
shopt -p progcomp
```

## 4) Future cleanup tasks

- [ ] Migrate R to ARM Homebrew (then can remove Intel python@3.12)
- [ ] Evaluate postgresql@14/16 - still needed?
- [ ] Evaluate redis - still needed?
- [ ] Consider removing entire Intel Homebrew once dependencies are resolved

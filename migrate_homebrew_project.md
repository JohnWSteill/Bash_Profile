# 🧼 Project: Migrate Homebrew + Clean Bash Environment

## 🎯 Purpose

Modernize your macOS development environment by:
- Migrating from Intel-based Homebrew to native Apple Silicon (`/opt/homebrew`)
- Cleaning and simplifying `$PATH`
- Updating your `.bash_profile` with carefully selected "bells and whistles" from your legacy configuration

---

## ✅ Project Outcome

A clean, performant, and portable shell environment where:
- Python, Git, and other tools run natively on Apple Silicon
- Your `$PATH` is de-duplicated and consistently ordered
- Your `.bash_profile` and `.bashrc` contain only tested, intentional enhancements

---

## 🧩 Project Components & Tasks

### 🧠 1. Prep & Audit

- [ ] Confirm no critical tools depend on `/usr/local`-based Homebrew
- [ ] Run `brew list` and note essentials for reinstallation
- [ ] Backup old `.bash_profile`, `.bashrc`, and related fragments
- [ ] Note current Python, Git, and terminal behaviors for regression testing

### 💣 2. Uninstall Old Homebrew (Intel-based)

- [ ] Uninstall old Homebrew:
  ```bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
  ```
- [ ] Optionally archive `/usr/local/Homebrew/` and `/usr/local/bin/brew`

### 🍎 3. Install Native Apple Silicon Homebrew

- [ ] Install new Homebrew to `/opt/homebrew`:
  ```bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```
- [ ] Update `.bash_profile` or `.zprofile` with:
  ```bash
  eval "$(/opt/homebrew/bin/brew shellenv)"
  ```

### 🧪 4. Reinstall Core Packages

- [ ] Reinstall `python@3.13`
- [ ] Reinstall any dev tools (e.g., `git`, `jq`, `htop`, `tree`, `ripgrep`, etc.)
- [ ] Confirm installs and update VSCode interpreter if needed

### 🧼 5. Doctor & Clean `$PATH`

- [ ] Remove or rewrite legacy `$PATH` additions in `.bash_profile`
- [ ] Use a helper function or search/replace to deduplicate and remove:
  - `/Library/Frameworks/...`
  - `/usr/local/opt/python@3.12/...`
- [ ] Export clean order, like:
  ```bash
  export PATH="/opt/homebrew/bin:$HOME/bin:/usr/bin:/bin:/usr/sbin:/sbin"
  ```

### 🎩 6. Bring Over “Bells & Whistles” from Old Bash Profile

- [ ] Cherry-pick from `bash_profile_enhancements.md`:
  - [ ] Enhanced PS1
  - [ ] Long history with deduplication
  - [ ] Arrow-key reverse search
  - [ ] Core aliases and Git log helpers
  - [ ] Optional: `gzip()` pigz alias, Jupyter cleaner, test runner
- [ ] Test each addition incrementally

---

## 🚀 Completion Criteria

- [ ] `which brew` returns `/opt/homebrew/bin/brew`
- [ ] `which python3` returns `/opt/homebrew/bin/python3`
- [ ] No `/Library/Frameworks/Python...` entries in `$PATH`
- [ ] `echo $PATH` shows a clean, minimal, de-duplicated order
- [ ] Your `.bash_profile` is short, documented, and versioned in Git

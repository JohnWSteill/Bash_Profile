# Bash Profile Reboot: 10 Recommended Enhancements

This document lists 10 curated, portable enhancements from your old Bash configuration. These are designed to help you reboot your environment with a clean, efficient, and modern setup.

Each suggestion is minimal, safe for macOS and Linux, and avoids brittle legacy logic.




---

## 6. `clearNb` — Jupyter Notebook Cleaner

```bash
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

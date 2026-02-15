# Seamless Bootstrap Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Make `./install` run end-to-end on a fresh Ubuntu or macOS machine with no manual intervention except the `chsh` password prompt.

**Architecture:** Add bootstrap shell commands to the top of `install.conf.yaml`'s shell section (system deps, chsh, conda). Fix hardcoded paths in `env.zsh` and `zshrc`. No new files or build systems.

**Tech Stack:** dotbot, bash, apt-get, brew, conda

---

### Task 1: Add system dependencies bootstrap to install.conf.yaml

**Files:**
- Modify: `install.conf.yaml:39-48` (replace `Installing brew` with `Installing system dependencies`)

**Step 1: Replace the `Installing brew` block with the new system dependencies block**

In `install.conf.yaml`, replace lines 41-48 (the `Installing brew` entry) with:

```yaml
    - description: Installing system dependencies (zsh, curl)
      command: |
        if [ "$(uname)" = "Darwin" ]; then
          if ! command -v brew >/dev/null 2>&1; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
          fi
          brew install zsh curl 2>/dev/null || true
        elif [ "$(uname)" = "Linux" ]; then
          if ! command -v zsh >/dev/null 2>&1 || ! command -v curl >/dev/null 2>&1; then
            sudo apt-get update && sudo apt-get install -y zsh curl
          fi
        fi
```

**Step 2: Verify the yaml is valid**

Run: `python3 -c "import yaml; yaml.safe_load(open('install.conf.yaml'))"`
Expected: No output (no errors)

**Step 3: Commit**

```bash
git add install.conf.yaml
git commit -m "feat: replace brew step with cross-platform system deps bootstrap"
```

---

### Task 2: Add chsh step to install.conf.yaml

**Files:**
- Modify: `install.conf.yaml` (insert after the system dependencies block from Task 1)

**Step 1: Insert the chsh block after the system dependencies block**

Add this entry right after the `Installing system dependencies` block:

```yaml
    - description: Changing default shell to zsh
      command: |
        if [ "$SHELL" != "$(which zsh)" ]; then
          echo "Current shell is $SHELL, switching to zsh..."
          echo "You may be prompted for your password."
          chsh -s "$(which zsh)"
        else
          echo "Default shell is already zsh"
        fi
```

**Step 2: Verify yaml**

Run: `python3 -c "import yaml; yaml.safe_load(open('install.conf.yaml'))"`

**Step 3: Commit**

```bash
git add install.conf.yaml
git commit -m "feat: add automatic chsh to zsh in bootstrap"
```

---

### Task 3: Add conda installation to install.conf.yaml

**Files:**
- Modify: `install.conf.yaml` (insert after the chsh block from Task 2)

**Step 1: Insert the conda block after the chsh block**

```yaml
    - description: Installing miniconda
      command: |
        if command -v conda >/dev/null 2>&1; then
          echo "conda is already installed"
          exit 0
        fi
        if [ "$(uname)" = "Darwin" ]; then
          CONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-$(uname -m).sh"
        else
          CONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-$(uname -m).sh"
        fi
        curl -fsSL "$CONDA_URL" -o /tmp/miniconda.sh
        bash /tmp/miniconda.sh -b -p "$HOME/miniconda3"
        rm /tmp/miniconda.sh
        "$HOME/miniconda3/bin/conda" init zsh
```

**Step 2: Verify yaml**

Run: `python3 -c "import yaml; yaml.safe_load(open('install.conf.yaml'))"`

**Step 3: Commit**

```bash
git add install.conf.yaml
git commit -m "feat: add automatic miniconda installation in bootstrap"
```

---

### Task 4: Fix hardcoded paths in config/zsh/env.zsh

**Files:**
- Modify: `config/zsh/env.zsh:49-64`

**Step 1: Replace hardcoded conda paths with $HOME**

Replace lines 51, 55, 58 — change `/home/simple/miniconda3` to `$HOME/miniconda3`:

```bash
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$("$HOME/miniconda3/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
```

**Step 2: Add existence check for cargo env**

Replace line 64:

```bash
# Before:
source $HOME/.cargo/env

# After:
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
```

**Step 3: Commit**

```bash
git add config/zsh/env.zsh
git commit -m "fix: replace hardcoded paths with \$HOME in env.zsh"
```

---

### Task 5: Fix hardcoded path in zshrc

**Files:**
- Modify: `zshrc:71`

**Step 1: Replace hardcoded bun completions path**

Replace line 71:

```bash
# Before:
[ -s "/home/simple/.bun/_bun" ] && source "/home/simple/.bun/_bun"

# After:
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
```

**Step 2: Commit**

```bash
git add zshrc
git commit -m "fix: replace hardcoded bun path with \$HOME in zshrc"
```

---

### Task 6: Final verification

**Step 1: Review the full install.conf.yaml shell section order**

Run: `grep -n 'description:' install.conf.yaml`

Expected output (order matters):
```
Installing system dependencies (zsh, curl)
Changing default shell to zsh
Installing miniconda
Installing submodules
Installing zoxide
Installing fzf
Installing vim-plug
Installing zinit
```

**Step 2: Check no hardcoded `/home/simple` remains**

Run: `grep -r '/home/simple' config/zsh/env.zsh zshrc`

Expected: No output (no matches)

**Step 3: Squash into single commit (optional)**

If desired, squash the task commits into one:

```bash
git rebase -i HEAD~5
# squash all into: "feat: seamless bootstrap for fresh Ubuntu/macOS setup"
```

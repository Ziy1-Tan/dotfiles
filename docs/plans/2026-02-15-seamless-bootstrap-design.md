# Seamless Dotfiles Bootstrap Design

## Problem

Running `./install` on a fresh Ubuntu or macOS machine hits friction points:
- zsh not installed
- Default shell not changed to zsh
- Conda not installed
- Hardcoded paths in env.zsh/zshrc break on different usernames

## Goal

One-command setup (`./install`) that runs end-to-end with minimal human intervention. Only `chsh` prompts for password confirmation.

## Constraints

- Ubuntu + macOS support
- sudo available on Ubuntu
- Keep everything in dotbot (no new build systems)
- No separate bootstrap script; all logic in `install.conf.yaml`

## Changes

### 1. install.conf.yaml — New bootstrap shell commands (top of shell section)

**Installing system dependencies** (replaces existing `Installing brew`):
- macOS: install brew if missing, then `brew install zsh curl`
- Linux: `sudo apt-get install -y zsh curl` if missing

**Changing default shell to zsh:**
- Check if `$SHELL` is already zsh
- If not, run `chsh -s $(which zsh)` (user prompted for password)

**Installing miniconda:**
- Skip if `conda` already available
- Download correct installer for OS + arch
- Install to `$HOME/miniconda3` in batch mode
- Run `conda init zsh`

### 2. config/zsh/env.zsh — Fix hardcoded paths

- Replace `/home/simple/miniconda3` with `$HOME/miniconda3` in conda init block
- Add existence check for `source $HOME/.cargo/env`

### 3. zshrc — Fix hardcoded paths

- Replace `/home/simple/.bun/_bun` with `$HOME/.bun/_bun`

### Files unchanged

- `install` script — no changes needed (git already available if repo was cloned)

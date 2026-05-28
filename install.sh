#!/usr/bin/env bash
# Executed by Coder's dotfiles module after cloning cody-ma/dotfiles into the workspace.
# Bootstraps chezmoi (if missing) and applies the dotfiles to $HOME.
set -euo pipefail

if ! command -v chezmoi >/dev/null 2>&1; then
  BINDIR="$HOME/.local/bin"
  mkdir -p "$BINDIR"
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$BINDIR"
  export PATH="$BINDIR:$PATH"
fi

# Install pure prompt (zsh theme) if missing. On macOS it comes from brew;
# on Linux workspaces we clone it manually so the same .zshrc works in both.
PURE_DIR="$HOME/.zsh/pure"
if [ ! -d "$PURE_DIR" ]; then
  mkdir -p "$(dirname "$PURE_DIR")"
  git clone --depth 1 https://github.com/sindresorhus/pure.git "$PURE_DIR" 2>/dev/null || true
fi

# Install tmux plugin manager (tpm) if missing. tpm manages the plugins listed
# in ~/.config/tmux/tmux.conf. After cloning, `tmux` + prefix-I installs them.
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  mkdir -p "$(dirname "$TPM_DIR")"
  git clone --depth 1 https://github.com/tmux-plugins/tpm.git "$TPM_DIR" 2>/dev/null || true
fi

# init --apply does both: clone (or noop if already cloned) and apply.
chezmoi init --apply cody-ma

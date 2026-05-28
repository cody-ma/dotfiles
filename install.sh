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

# init --apply does both: clone (or noop if already cloned) and apply.
chezmoi init --apply cody-ma

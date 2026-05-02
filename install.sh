#!/bin/bash
DOTFILES="$HOME/dotfiles"

ln -sf "$DOTFILES/nvim" "$HOME/.config/nvim"
echo "Symlinks created."

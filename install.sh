#!/bin/bash
DOTFILES="$HOME/dotfiles"

mkdir -p "$HOME/.config"

ln -sf "$DOTFILES/git" "$HOME/.config/git"
ln -sf "$DOTFILES/nvim" "$HOME/.config/nvim"
ln -sf "$DOTFILES/texmf" "$HOME/texmf"

echo "Symlinks created."

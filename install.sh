#!/bin/bash
DOTFILES="$HOME/dotfiles"

ln -sf "$DOTFILES/git" "$HOME/.config/git"
ln -sf "$DOTFILES/nvim" "$HOME/.config/nvim"
ln -sf "$DOTFILES/texmf" "$HOME/texmf"

echo "Symlinks created."

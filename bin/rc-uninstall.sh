#!/bin/bash
set -e # exit script on failure

FILES=("$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.bash_profile" "$HOME/.zprofile")

echo "Removing dotfiles rc sourcing from shell startup files..."

for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        cp "$file" "$file.bak"
        awk '!/dotfiles.*rc-source\.sh/ && !/Added by dotfiles rc-install/' "$file.bak" > "$file"
        echo "Cleaned $file (backup: $file.bak)"
    fi
done

echo "dotfiles rc-uninstall complete."

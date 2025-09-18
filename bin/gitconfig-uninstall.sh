#!/bin/bash
set -e # exit script on failure

USER_GITCONFIG="$HOME/.gitconfig"

echo "Removing dotfiles gitconfig include from $USER_GITCONFIG..."

if [ -f "$USER_GITCONFIG" ]; then
    cp "$USER_GITCONFIG" "$USER_GITCONFIG.bak"
    awk '!/Added by dotfiles gitconfig-install/ && !/include.*build\/gitconfig/' "$USER_GITCONFIG.bak" > "$USER_GITCONFIG"
    echo "Cleaned $USER_GITCONFIG (backup: $USER_GITCONFIG.bak)"
else
    echo "$USER_GITCONFIG does not exist, nothing to clean."
fi

echo "dotfiles gitconfig-uninstall complete."

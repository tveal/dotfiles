#!/bin/bash
set -e # exit script on failure

VSCODE_USER_DIR="$HOME/.config/Code/User"

echo "Uninstalling VSCode user configs..."

# Restore or remove all JSON files in the VSCode user directory
find "$VSCODE_USER_DIR" -maxdepth 1 -type f -name '*.json' | while read -r target; do
    backup=$(ls "$target.bak."* 2>/dev/null | tail -n 1)
    if [ -f "$backup" ]; then
        mv "$backup" "$target"
        echo "Restored backup to $target"
    else
        echo "No backup found for $target. Removing."
        rm -f "$target"
    fi
done

# Optionally handle snippets (restore or remove)
if [ -d "$VSCODE_USER_DIR/snippets" ]; then
    for snippet in "$VSCODE_USER_DIR/snippets/"*.json; do
        [ -e "$snippet" ] || continue
        backup=$(ls "$snippet.bak."* 2>/dev/null | tail -n 1)
        if [ -f "$backup" ]; then
            mv "$backup" "$snippet"
            echo "Restored backup to $snippet"
        else
            echo "No backup found for $snippet. Removing."
            rm -f "$snippet"
        fi
    done
fi

echo "VSCode config uninstall complete."
echo "Note: This script does not uninstall VSCode extensions. Please remove them manually if needed."

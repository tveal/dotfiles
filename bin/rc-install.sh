#!/bin/bash
set -e # exit script on failure

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$DOTFILES_DIR/build"
BIN_DIR="$DOTFILES_DIR/bin"
RC_FILE="$BUILD_DIR/run-commands.sh"
SRC_FILE="$BIN_DIR/rc-source.sh"
USER_SHELL=$(basename "${SHELL:-/bin/bash}")

function main() {
    # 0. backup old build/run-commands.sh
    # 1. collect *.rc.sh files into build/run-commands.sh
    # 2. install sourcing of bin/rc-source.sh into either ~/.zshrc or ~/.bashrc
    # 3. install sourcing of bin/rc-source.sh into either ~/.zprofile or ~/.bash_profile
    backupRunCommands
    buildRunCommands
    installRunCommands
}

function backupRunCommands() {
    if [ -f "$RC_FILE" ]; then
        local backupFile="$BUILD_DIR/backups/$(basename "$RC_FILE").bak.$(date +"%Y%m%d_%H%M%S")"
        mkdir -p "$BUILD_DIR/backups"
        cp "$RC_FILE" "$backupFile"
        echo "Backed up $RC_FILE to $backupFile"
    fi
}

function buildRunCommands() {
    mkdir -p "$BUILD_DIR"
    echo "# dotfiles run-commands created: $(date +"%Y%m%d_%H%M%S")" > "$RC_FILE"
    find ~/.dotfiles -type f -name '*.rc.sh' | while read -r filename; do
        if [ -f "$filename" ]; then
            echo "# >>> $filename" >> "$RC_FILE"
            cat "$filename" >> "$RC_FILE"
            echo "# <<< $filename" >> "$RC_FILE"
        fi
    done
}

function installRunCommands() {
    if [ ! -f "$SRC_FILE" ]; then
        echo "Warning - SRC_FILE not found or not a regular file: $SRC_FILE"
        exit 0
    fi
    case "$USER_SHELL" in
        zsh)
            local targetRC="$HOME/.zshrc"
            local targetProfile="$HOME/.zprofile"
            ;;
        bash)
            local targetRC="$HOME/.bashrc"
            local targetProfile="$HOME/.bash_profile"
            ;;
        *)
            echo "Unsupported shell: $USER_SHELL"
            return 1
            ;;
    esac

    for file in "$targetRC" "$targetProfile"; do
        if [ -f "$file" ] && ! grep -Fq "source \"$SRC_FILE\"" "$file"; then
            cp "$file" "$file.bak.$(date +"%Y%m%d_%H%M%S")"
            echo -e "\n# Added by dotfiles rc-install\nsource \"$SRC_FILE\"" >> "$file"
            echo "Added sourcing of $SRC_FILE to $file"
        fi
    done
}

main "$@"

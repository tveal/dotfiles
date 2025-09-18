#!/bin/bash
set -e # exit script on failure

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$DOTFILES_DIR/build"
BUILD_GITCONFIG="$BUILD_DIR/gitconfig"
USER_GITCONFIG="$HOME/.gitconfig"

function main() {
    backupUserGitconfig
    buildGitconfig
    installGitconfigIncludes
}

function backupUserGitconfig() {
    if [ -f "$USER_GITCONFIG" ]; then
        local backupFile="$BUILD_DIR/backups/gitconfig.bak.$(date +"%Y%m%d_%H%M%S")"
        mkdir -p "$BUILD_DIR/backups"
        cp "$USER_GITCONFIG" "$backupFile"
        echo "Backed up $USER_GITCONFIG to $backupFile"
    fi
}

function buildGitconfig() {
    mkdir -p "$BUILD_DIR"
    # > "$BUILD_GITCONFIG"
    echo "# dotfiles gitconfig created: $(date +"%Y%m%d_%H%M%S")" > "$BUILD_GITCONFIG"
    find "$DOTFILES_DIR" -type f -name '*.gitconfig' | while read -r filename; do
        echo "# >>> $filename" >> "$BUILD_GITCONFIG"
        cat "$filename" >> "$BUILD_GITCONFIG"
        echo "# <<< $filename" >> "$BUILD_GITCONFIG"
    done
}

function installGitconfigIncludes() {
    # Only add include if not present
    if ! grep -Fq "path = $BUILD_GITCONFIG" "$USER_GITCONFIG"; then
        echo -e "\n# Added by dotfiles gitconfig-install\n[include]\n    path = $BUILD_GITCONFIG" >> "$USER_GITCONFIG"
        echo "Added include for $BUILD_GITCONFIG to $USER_GITCONFIG"
    else
        echo "Include for $BUILD_GITCONFIG already exists in $USER_GITCONFIG"
    fi
}

main "$@"

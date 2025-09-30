#!/bin/bash
set -e # exit script on failure

VSCODE_USER_DIR="$HOME/.config/Code/User"
DOTFILES_DIR="$HOME/.dotfiles"

function main() {
    installDeps
    installVSCodeConfigs
}

function installVSCodeConfigs() {
    mkdir -p "$VSCODE_USER_DIR"
    echo "Installing combined VSCode user configs..."

    # Find all unique JSON filenames in any vscode/ subdir
    json_files=()
    while IFS= read -r fname; do
        json_files+=("$fname")
    done < <(find "$DOTFILES_DIR" -type f -path '*/vscode/*.json' -exec basename {} \; | sort -u)

    for fname in "${json_files[@]}"; do
        # Find all files with this name
        files=()
        while IFS= read -r f; do
            files+=("$f")
        done < <(find "$DOTFILES_DIR" -type f -path "*/vscode/$fname")
        target="$VSCODE_USER_DIR/$fname"

        if [ -f "$target" ]; then
            cp "$target" "$target.bak.$(date +"%Y%m%d_%H%M%S")"
            echo "Backed up $target"
        fi

        # Decide merge strategy: array or object
        if is_array_json "${files[0]}"; then
            jq -s 'add' "${files[@]}" > "$target"
            echo "Merged array $fname files into $target"
        else
            jq -s 'reduce .[] as $item ({}; . * $item)' "${files[@]}" > "$target"
            echo "Merged object $fname files into $target"
        fi
    done

    echo "VSCode config install complete."
}

function is_array_json() {
    # Returns 0 if file is a JSON array, 1 otherwise
    jq 'if type=="array" then true else false end' "$1" &>/dev/null
}

function installDeps() {
    if ! command -v jq &>/dev/null; then
        echo "jq not found. Installing..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            if command -v brew &>/dev/null; then
                brew install jq
            else
                echo "Homebrew not found. Please install Homebrew first: https://brew.sh/"
                exit 1
            fi
        elif [[ -f /etc/debian_version ]]; then
            sudo apt-get update
            sudo apt-get install -y jq
        elif [[ -f /etc/redhat-release ]]; then
            sudo yum install -y jq
        else
            echo "Unsupported OS. Please install jq manually."
            exit 1
        fi
    else
        echo "jq is already installed."
    fi
}

main "$@"

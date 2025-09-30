# Conditionally source dotfiles run-commands.sh if not already sourced
if ! alias dotver &>/dev/null; then

    alias dotver='git -C ~/.dotfiles log -1 --pretty=format:"%cd %h" --date="format:%Y-%m-%d %H:%M:%S"'
    alias dotdir='cd $HOME/.dotfiles'
    dotup() {
        "$HOME/.dotfiles/bin/all-install.sh" && source "$HOME/.dotfiles/build/run-commands.sh"
        echo "dotfiles updated to: $(dotver)"
    }

    source "$HOME/.dotfiles/build/run-commands.sh"
fi

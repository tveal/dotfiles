# dotfiles

Repeatable dev env setup. Inspired by <https://github.com/rio/dotfiles>.

## Prerequisites

- **curl**
- **zsh** - primary shell; if not default (`echo $SHELL`), set with `chsh -s $(which zsh)`
- **C compiler** - nvim tree-sitter, herdr nav plugin

## Usage

### 1. bootstrap

Clone the repo and run the setup script:

```sh
./setup
```

This will:

- Install chezmoi (if not present)
- Apply all dotfiles to your home directory

### 2. chezmoi

[chezmoi](https://www.chezmoi.io/) manages dotfiles, templates, and external resources.

- **chezmoi apply**: Apply dotfiles to your home directory
- **chezmoi update**: Pull and apply latest changes

### 3. test in docker

Start the container with copied dotfiles

```sh
docker run --rm -it \
  -v "$HOME/.local/share/chezmoi:/root/ref/dotfiles:ro" \
  debian:bookworm-slim \
  bash -c "apt-get update && apt-get install -y curl git ca-certificates zsh build-essential && cp -rv /root/ref/dotfiles/ /tmp/ && cd /tmp/dotfiles && /bin/zsh"
```

Run the setup to test in clean environment

```sh
./setup
```

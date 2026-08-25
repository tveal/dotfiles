# dotfiles

Repeatable dev env setup. Inspired by <https://github.com/rio/dotfiles>.

## prerequisites

- **curl**
- **zsh** - primary shell; if not default (`echo $SHELL`), set with `chsh -s $(which zsh)`
- **C compiler** - nvim tree-sitter, herdr nav plugin

## usage

### one-time setup from source

Clone the repo and run the setup script:

```sh
./setup
```

This will apply all dotfiles to your home directory and install mise with all it's configured runtimes.

### chezmoi setup

[chezmoi](https://www.chezmoi.io/) manages dotfiles, templates, and external resources.

- **chezmoi apply**: Apply dotfiles to your home directory
- **chezmoi update**: Pull and apply latest changes

To setup, [install chezmoi](https://www.chezmoi.io/install/), then run

```sh
chezmoi init https://github.com/$GITHUB_USERNAME/dotfiles.git
```

### test in docker

Start the container with copied dotfiles

```sh
docker run --rm -it \
  -v "$PWD:/root/ref/dotfiles:ro" \
  debian:bookworm-slim \
  bash -c "apt-get update && apt-get install -y curl git ca-certificates zsh build-essential && cp -rv /root/ref/dotfiles/ /tmp/ && cd /tmp/dotfiles && /bin/zsh"
```

Run the setup to test in clean environment

```sh
./setup
```

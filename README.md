# Dotfiles Manager

A modular, scriptable system for managing your shell and development environment configuration files.

## Features

- **Shell config management:** Collects all `*.rc.sh` fragments (aliases, functions, etc.) into a single build file: [`build/run-commands.sh`](build/run-commands.sh)
- **Git config management:** Aggregates all `*.gitconfig` fragments into [`build/gitconfig`](build/gitconfig) and includes them in your global git config
- **Automatic installation:** Installs sourcing logic into your shell startup files (`.bashrc`, `.zshrc`, `.bash_profile`, `.zprofile`)
- **Safe updates:** Backs up previous configuration files before modifying them ([`build/backups/`](build/backups/))
- **Convenient aliases:** Adds `dotup`, `dotver`, and `dotdir` for easy updating, version checking, and navigation
- **Extensible:** Designed to support additional dotfiles (e.g., VSCode settings) in the future

## Getting Started

### Installation

Clone this repository to your home directory as `~/.dotfiles`:

```sh
git clone https://github.com/tveal/dotfiles.git ~/.dotfiles
```

Then run the install scripts:

```sh
~/.dotfiles/bin/rc-install.sh
~/.dotfiles/bin/gitconfig-install.sh
```

This will set up your shell and git configuration using the fragments in [`local/`](local/).

### Usage

- **Update dotfiles:**  
  Run `dotup` in your shell to rebuild and reload your configuration.
- **Check dotfiles version:**  
  Run `dotver` to show the current git commit date and hash.
- **Jump to dotfiles directory:**  
  Run `dotdir` to `cd` into your dotfiles directory.

### Customization

- Add shell customizations to any `*.rc.sh` file, e.g. [`local/aliases.rc.sh`](local/aliases.rc.sh)
- Add git aliases/config to any `*.gitconfig` file, e.g. [`local/aliases.gitconfig`](local/aliases.gitconfig)
- Future: Add VSCode or other editor configs to dedicated fragments

### Backup & Restore

- Previous versions of build files are backed up in [`build/backups/`](build/backups/)
- Your original shell and git config files are backed up before modification

### Uninstall

To remove shell config changes:
```sh
~/.dotfiles/bin/rc-uninstall.sh
```
To remove git config changes:
```sh
~/.dotfiles/bin/gitconfig-uninstall.sh
```
Or manually remove the sourcing/include lines from your config files.

## Extending

To add support for new dotfiles (e.g., VSCode):

1. Create a new fragment file (e.g., `local/vscode.settings.json`)
2. Write an install/uninstall script in [`bin/`](bin/) to aggregate and link settings
3. Update this README with usage instructions

---

For details, see scripts in [`bin/`](bin/) and build outputs in [`build/`](build/).
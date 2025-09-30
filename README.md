# Dotfiles Manager

A modular, scriptable system for managing your shell and development env configuration files.

## Features

- **Shell config management:** Collects all `*.rc.sh` fragments (aliases, functions, etc.) into a single build file: [`build/run-commands.sh`](build/run-commands.sh)
- **Git config management:** Aggregates all `*.gitconfig` fragments into [`build/gitconfig`](build/gitconfig) and includes them in your global git config
- **Automatic installation:** Installs sourcing logic into your shell startup files (`.bashrc`, `.zshrc`, `.bash_profile`, `.zprofile`)
- **Safe updates:** Backs up previous configuration files before modifying them ([`build/backups/`](build/backups/))
- **Convenient aliases:** Adds `dotup`, `dotver`, and `dotdir` for easy updating, version checking, and navigation
- **Extendable:** Designed to support additional dotfiles (e.g., VSCode settings, editor configs) in the future

## Getting Started

### Installation

Clone this repository to your home directory as `~/.dotfiles`:

```sh
git clone https://github.com/tveal/dotfiles.git ~/.dotfiles
```

Then run the install script:

```sh
~/.dotfiles/bin/all-install.sh
```

This will set up your shell, git, and vscode configuration using the fragments in [`local/`](local/).

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
- Add shell scripts to any `*/scripts/` subfolder, e.g. [`local/scripts/findUp.sh`](local/scripts/findUp.sh)
    - You can use env variable `$DOT_SCRIPTS_DIR` for path to your scripts, such as `$DOT_SCRIPTS_DIR/findUp.sh` in `*.rc.sh` files
- VSCode: Add config fragments to any `vscode/` subdirectory in your dotfiles tree. Supported files include:
  - `settings.json` (user settings)
  - `keybindings.json` (user keybindings)
  - `snippets/*.json` (user snippets)
  - `locale.json` (UI language)
  - Any other user-level VSCode config file in `vscode/` folders
  These will be merged and installed to your VSCode user directory by the install script.

### Backup & Restore

- Previous versions of build files are backed up in [`build/backups/`](build/backups/)
- Your original shell and git config files are backed up before modification

### Uninstall

To remove all dotfiles config from your user:
```sh
~/.dotfiles/bin/all-uninstall.sh
```

#### Individual Uninstall Scripts

To remove shell config changes:
```sh
~/.dotfiles/bin/rc-uninstall.sh
```
To remove git config changes:
```sh
~/.dotfiles/bin/gitconfig-uninstall.sh
```
Or manually remove the sourcing/include lines from your config files.

To remove vscode config changes:
```sh
~/.dotfiles/bin/vscode-uninstall.sh
```

## Extending

To add support for new dotfiles (e.g., VSCode):

1. Create config fragments in any subdirectory (e.g., `local/vscode/settings.json`, `repo-a/vscode/keybindings.json`)
2. Write or update install/uninstall scripts in [`bin/`](bin/) to aggregate, merge, and link settings
3. Update this README with usage instructions and supported config files

---

For details, see scripts in [`bin/`](bin/) and build outputs in [`build/`](build/).
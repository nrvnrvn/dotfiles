# Dotfiles

Managed in a proper way.

## Quickstart

```sh
curl -fsS https://raw.githubusercontent.com/nrvnrvn/dotfiles/refs/heads/main/.config/macos/bootstrap.sh | bash -s all
```

## Features

- dotfiles are laid out where they belong. Your home dir is your github repo. With two caveats:
  - use `dotfiles` instead of `git` to manage "dotfiles".
  - all contents are ignored by default. `dotfiles a -f` all new stuff. Also serves as a protection from accidentally committing your whole life to the repo. Inspired by [this](https://www.atlassian.com/git/tutorials/dotfiles).
- zsh with useful enough defaults.
- powerlevel10k on top of it.
- vim for quick adhoc stuff.
- neovim for something more than that.
- git config with solid defaults.
- ssh config also worth looking at.
- macOS tailored. Used to support Linux as well back in the day.

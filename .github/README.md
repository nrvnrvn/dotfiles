# Dotfiles

<!--toc:start-->
- [Dotfiles](#dotfiles)
  - [1. Quickstart](#1-quickstart)
  - [2. Features](#2-features)
<!--toc:end-->

Managed in a proper way.

## 1. Quickstart

```sh
curl -fsS https://raw.githubusercontent.com/nrvnrvn/dotfiles/refs/heads/main/.bootstrap.sh | bash -s all
```

## 2. Features

- dotfiles are laid out where they belong. Your home dir is your github repo. With two caveats:
  - use `dotfiles` instead of `git` to manage "dotfiles".
  - all contents are ignored by default. `dotfiles a -f` all new stuff. Also serves as a protection from accidentally committing your whole life to the repo. Inspired by [this](https://www.atlassian.com/git/tutorials/dotfiles).
- zsh with useful enough defaults.
- powerlevel10k on top of it.
- vim for quick adhoc stuff.
- neovim for something more than that.
- git config with solid defaults.
- ssh config also worth looking at.
- macOS tailored. Supports Linux to some extent.

#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

ensure_xcode() {
  while [[ "$(xcode-select --install 2>&1)" == "xcode-select: note: install requested for command line developer tools" ]]; do
    sleep 10
    echo waiting for xcode to get installed
  done
}

ensure_theme() {
  if [[ $(defaults read com.apple.terminal 'Default Window Settings') == "Solarized Dark" ]]; then return; fi
  open "${HOME}/.config/macos/Solarized Dark.terminal"
  defaults write com.apple.terminal 'Default Window Settings' -string 'Solarized Dark'
  defaults write com.apple.terminal 'Startup Window Settings' -string 'Solarized Dark'
}

ensure_brew() {
  if [[ ! -x "/opt/homebrew/bin/brew" ]]; then
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

install_brew_dependencies() {
  eval "$(/opt/homebrew/bin/brew shellenv)"
  if [[ ! $(brew list --quiet --cask font-iosevka) ]]; then
    brew tap homebrew/cask-fonts
    brew install --cask font-iosevka
  fi
  brew install fzf
}

ensure_dotfiles() {
  if [[ ! -d "${HOME}/.config/dotfiles" ]]; then
    /usr/bin/git clone --bare git@github.com:nrvnrvn/dotfiles.git "${HOME}/.config/dotfiles"
  fi
  /usr/bin/git --git-dir="${HOME}/.config/dotfiles" --work-tree="${HOME}" checkout
  /usr/bin/git --git-dir="${HOME}/.config/dotfiles" --work-tree="${HOME}" submodule update --init --depth 1
}

setup_macos_defaults() {
  # Only use UTF-8 in Terminal.app
  defaults write com.apple.terminal StringEncodings -array 4
  # Enable Terminal.app secure keyboard entry
  defaults write com.apple.terminal SecureKeyboardEntry -bool true
  # Set location for screenshots to /tmp
  defaults write com.apple.screencapture location /tmp
  # Disable automatic period substitution as it’s annoying when typing code
  defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
  # Disable smart quotes as they’re annoying when typing code
  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
  # Disable auto-correct
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
  # Set a blazingly fast keyboard repeat rate
  defaults write NSGlobalDomain KeyRepeat -int 2
  defaults write NSGlobalDomain InitialKeyRepeat -int 15
}

setup_hosts_file() {
  sudo curl -fsSLo /etc/hosts https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling/hosts
  sudo sh -c 'dscacheutil -flushcache; killall -HUP mDNSResponder; killall -9 mDNSResponder; killall mDNSResponderHelper'
}

ensure_xcode
ensure_brew
install_brew_dependencies
ensure_dotfiles
ensure_theme

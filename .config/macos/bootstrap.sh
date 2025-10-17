#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

ensure_xcode() {
  echo "Checking for Xcode command line tools..."

  while [[ "$(xcode-select --install 2>&1)" == "xcode-select: note: install requested for command line developer tools" ]]; do
    sleep 10
    echo "Waiting for Xcode to finish installation..."
  done

  echo "Xcode command line tools are installed."
}

ensure_brew() {
  echo "Checking for Homebrew..."

  if [[ ! -x "/opt/homebrew/bin/brew" ]]; then
    echo "Homebrew not found. Installing..."

    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    echo "Homebrew installed successfully."
  else
    echo "Homebrew is already installed."
  fi

  eval "$(/opt/homebrew/bin/brew shellenv)"
}

ensure_dotfiles() {
  echo "Checking for dotfiles repository..."

  if [[ ! -d "${HOME}/.config/dotfiles" ]]; then
    echo "Dotfiles not found. Cloning repository..."
    /usr/bin/git clone --bare https://github.com/nrvnrvn/dotfiles.git "${HOME}/.config/dotfiles"

    echo "Dotfiles repository cloned."
  else
    echo "Dotfiles repository already exists."
  fi

  /usr/bin/git --git-dir="${HOME}/.config/dotfiles" --work-tree="${HOME}" checkout

  echo "Updating dotfiles submodules..."
  /usr/bin/git --git-dir="${HOME}/.config/dotfiles" --work-tree="${HOME}" submodule update --init --depth 1

  echo "Dotfiles setup complete."
}

ensure_terminal() {
  echo "Installing terminal dependencies..."

  brew install --quiet --require-sha ghostty font-iosevka fzf

  echo "Terminal dependencies installed successfully."
}

ensure_neovim() {
  local -r python_path="${HOME}/.local/share/nvim-python"
  local -r python_version='3.13.9'
  local -r node_path="${HOME}/.local/share/nvim-node"
  local -r node_version='24.10.0'

  echo "Installing Neovim and dependencies..."
  brew install --quiet --require-sha neovim fzf fd ripgrep lazygit wget fnm uv

  echo "Setting up Python environment for Neovim..."
  uv venv --python "${python_version}" --clear --seed "${python_path}"
  uv pip install pynvim --python "${python_path}"

  echo "Setting up Node.js environment for Neovim..."
  rm -rf "${node_path}"
  fnm install --fnm-dir "${node_path}" "${node_version}"
  fnm exec --fnm-dir "${node_path}" --using "${node_version}" npm update -g
  fnm exec --fnm-dir "${node_path}" --using "${node_version}" npm i -g neovim

  echo "Neovim setup complete."
}

ensure_defaults() {
  echo "Configuring macOS defaults..."

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

  # Set up firewall
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on

  # Enable automatic updates
  sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool true
  sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates -bool true
  sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool true
  sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall -bool true
  sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool true

  # Set up finder
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true

  # Set up screensaver
  defaults write com.apple.screensaver askForPassword -bool true
  defaults write com.apple.screensaver askForPasswordDelay -int 0

  echo "macOS defaults configured."
}

ensure_hosts() {
  echo "Updating /etc/hosts file..."

  # Allow one domain for the sake of google search results working correctly for advertised products.
  curl -fsS https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling/hosts | rg -v www.googleadservices.com >/tmp/etc_hosts
  sudo bash -o errexit -o nounset -o pipefail -o xtrace -c 'cp /tmp/etc_hosts /etc/hosts; dscacheutil -flushcache; killall -HUP mDNSResponder; killall -9 mDNSResponder; killall mDNSResponderHelper'

  echo "/etc/hosts file updated."
}

usage() {
  cat <<EOF
Bootstrap macOS in an idempotent fashion

Usage:
  $0 {xcode | dotfiles | brew | terminal | neovim | defaults | hosts | all}

Available commands:
  xcode      Install and verify Xcode command line tools
  dotfiles   Clone and set up dotfiles
  brew       Install Homebrew if not already installed
  terminal   Install terminal emulator and its dependencies
  neovim     Set up Neovim with some goodies
  defaults   Apply preferred macOS system defaults
  hosts      Update the /etc/hosts file with entries from StevenBlack's list
  all        Run all of the above in sequence

Example:
  $0 all
EOF

  exit 1
}

main() {
  # Check if arguments are provided
  if [ "$#" -eq 0 ]; then
    usage
  fi

  # Execute functions based on arguments
  for arg in "$@"; do
    case "$arg" in
    xcode | dotfiles | brew | terminal | neovim | defaults | hosts)
      "ensure_${arg}"
      ;;
    all)
      ensure_xcode
      ensure_dotfiles
      ensure_brew
      ensure_terminal
      ensure_neovim
      ensure_defaults
      ensure_hosts
      ;;
    *)
      echo "Invalid option: $arg"
      usage
      ;;
    esac
  done
}

main "$@"

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Theme
ZSH_THEME="nicorevin"

# Aliases
alias pmr='python manage.py runserver'
alias dfr='diff <(pip freeze) requirements.txt'
alias plo='pip list -o'
alias ghp='git push heroku master'
alias ghr='git pull --rebase heroku master'
alias pup='yaourt -Syua'
alias puc='yes|sudo pacman -Scc && sudo localepurge'

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git heroku npm pip python virtualenv django)
if [[ $(uname) == "Linux" ]]; then
    plugins+=(archlinux systemd)
else
    plugins+=(osx brew terminalapp)
fi

source $ZSH/oh-my-zsh.sh

source $HOME/.dotfiles/skinnyvirtualenvwrapper.sh

# User configuration

export PATH=$HOME/bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

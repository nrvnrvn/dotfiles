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

# Virtualenv "wrapper"
function venv {
    local venvhome=$HOME/.virtualenvs/$(basename $PWD)
    if [[ $1 == "on" ]]; then
        if [[ ! -d $venvhome ]]; then
            # $(which virtualenv) $HOME/.virtualenvs/${${PWD#/}//\//-}
            $(which virtualenv) $venvhome
        fi
        source $venvhome/bin/activate
    elif [[ $1 == "off" ]]; then
        deactivate
    else
        echo "Skinny virtualenv wrapper"
        echo "Usage: venv [on|off]\n"
        echo "Options:"
        echo "  on      Creates virtualenv under $HOME/.virtualenvs/"
        echo "          if it doesn't exist and activates it"
        echo "  off     Deactivates virtualenv"
    fi
}

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to disable command auto-correction.
# DISABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

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

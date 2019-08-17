###############################################################################
# AUTOLOADS
autoload -Uz compaudit
autoload -Uz compinit
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
autoload -Uz vcs_info
###############################################################################
# BINDINGS AND IMPORTS
bindkey -e
# enable fzf key bindings
[ -f ${HOME}/.fzf.zsh ] && source ${HOME}/.fzf.zsh
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/nicorevin/.google/google-cloud-sdk/path.zsh.inc' ]; then
    source '/Users/nicorevin/.google/google-cloud-sdk/path.zsh.inc'
fi
###############################################################################
# VARIABLES
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR=vim
export LESS=-R
#export GOPATH="${HOME}/go"
export PATH=/usr/local/sbin:${HOME}/go/bin:$PATH
export LSCOLORS="Gxfxcxdxbxegedabagacad"
###############################################################################
# ALIASES
alias k='kubectl'
alias ls='ls -G'
alias ll='ls -Glh'
alias lla='ls -lha'

alias grep='grep --color=auto --exclude-dir=.git'

alias ga='git add'
alias gc='git commit -S -s'
alias gcm='git commit -S -s -m'
alias gd='git diff'
alias gfa='git fetch --all --prune'
alias gl='git pull'
alias gp='git push'
alias gss='git status -s'
###############################################################################
# HISTORY
export HISTFILE="${HOME}/.zsh_history"
export HISTSIZE=999999
export SAVEHIST=$HISTSIZE

setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_reduce_blanks     # remove superfluous blanks from history items
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down
###############################################################################
# COMPLETION
if [ $(date +'%j') != $(/usr/bin/stat -f '%Sm' -t '%j' ${HOME}/.zcompdump) ]; then
    compinit
else
    compinit -C
fi

# Execute code in the background to not affect the current session
{
    # Compile zcompdump, if modified, to increase startup speed.
    local ZCOMPDUMP="${HOME}/.zcompdump"
    if [[ -s "${ZCOMPDUMP}" && (! -s "${zcompdump}.zwc" || "${ZCOMPDUMP}" -nt "${ZCOMPDUMP}.zwc") ]]; then
        zcompile "${ZCOMPDUMP}"
    fi
} &!

setopt auto_menu
setopt auto_cd
setopt interactivecomments

zstyle ':completion:*' menu select
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ${HOME}/.zsh_cache
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' group-name ''

# The next line enables shell command completion for gcloud.
if [ -f '/Users/nicorevin/.google/google-cloud-sdk/completion.zsh.inc' ]; then
    source '/Users/nicorevin/.google/google-cloud-sdk/completion.zsh.inc'
fi
###############################################################################
# GPG AGENT
AGENT_SOCK=$(gpgconf --list-dirs | grep agent-socket | cut -d : -f 2)

if [[ ! -S ${AGENT_SOCK} ]]; then
    gpg-agent --daemon --use-standard-socket &>/dev/null
fi
export GPG_TTY=$TTY

# Set SSH to use gpg-agent if it's enabled
GNUPGCONFIG="${GNUPGHOME:-"${HOME}/.gnupg"}/gpg-agent.conf"
if [[ -r ${GNUPGCONFIG} ]] && command grep -q enable-ssh-support "${GNUPGCONFIG}"; then
    export SSH_AUTH_SOCK="${AGENT_SOCK}.ssh"
    unset SSH_AGENT_PID
fi
###############################################################################
# TAB AND WINDOWS TITLE
function update_tab_precmd {
    local TAB_TITLE="%~"
    print -Pn "\e]1;$TAB_TITLE:q\a"
    print -Pn "\e]2;$TAB_TITLE:q\a"
}

function update_tab_preexec {
    setopt extended_glob
    local TAB_TITLE=${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}
    print -Pn "\e]1;$TAB_TITLE:q\a"
}

precmd_functions+=(update_tab_precmd)
preexec_functions+=(update_tab_preexec)
###############################################################################
# PROMPT

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' use-simple true
zstyle ':vcs_info:*' max-exports 1
zstyle ':vcs_info:git*' formats '%F{green}%b%f'
zstyle ':vcs_info:git*' actionformats '%F{yellow}%b%f:%F{red}%a%f'

function git_prompt {
    vcs_info
    echo "%F{yellow}$vcs_info_msg_0_%f "
}

function gcloud_prompt {
    echo "%F{magenta}$(awk '/project/ {print $3}' ${HOME}/.config/gcloud/configurations/config_default < /dev/null)%f "
}

function kube_prompt {
    echo "%F{blue}$(awk '/current-context/ {print $2}' ${HOME}/.kube/config < /dev/null)%f:%F{blue}$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)%f "
}

ZSH_PROMPT_CACHE_FILE=${TMPDIR}${TERM_SESSION_ID}_ZSH_PROMPT_CACHE

function update_lazy_prompt {
    local res="$(git_prompt)$(gcloud_prompt)$(kube_prompt)"
    echo -n ${res} > ${ZSH_PROMPT_CACHE_FILE}
}

function lazy_prompt {
    if [ ! -f ${ZSH_PROMPT_CACHE_FILE} ]; then
        update_lazy_prompt
    fi
    cat ${ZSH_PROMPT_CACHE_FILE}
}

#
# Update prompt
TMOUT=5
function TRAPALRM {
    if [[ ${WIDGET} != *"complet"* && ${WIDGET} != *"beginning-search" ]]; then
        update_lazy_prompt &!
        zle reset-prompt
    fi
}

# prompt
setopt PROMPT_SUBST
PROMPT='%F{yellow}%T%f %B%F{cyan}%~%f%b $(lazy_prompt)
%(!.%F{red}#.%(0?.%F{green}.%F{red})$)%f '

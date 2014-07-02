# Load required modules.
autoload -Uz vcs_info
autoload -U add-zsh-hook

add-zsh-hook precmd vcs_info

# pretty dir colors
eval $(dircolors -b)
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# enable git support
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*:*' check-for-changes true
zstyle ':vcs_info:*:*' unstagedstr   "%F{red}!%f"
zstyle ':vcs_info:*:*' stagedstr     "%F{green}+%f"
zstyle ':vcs_info:*:*' actionformats "(%F{cyan}%b%f%c%u%f) (%F{yellow}%a%f)"
zstyle ':vcs_info:*:*' formats       "(%F{cyan}%b%f%c%u%f)"
zstyle ':vcs_info:*:*' nvcsformats   ""
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

# show marker if there are untracked files
function +vi-git-untracked {
    # if [[ $(git symbolic-ref --short HEAD &>/dev/null) == 'true' ]] && \
    if git status --porcelain &>/dev/null | fgrep '??' &>/dev/null ; then
        hook_com[unstaged]='%F{yellow}?%f'$hook_com[unstaged]
    fi
}

# virtualenv prompt
function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('%F{magenta}`basename $VIRTUAL_ENV`%f') '
}

PROMPT='%{$fg[blue]%}%T%f $(virtualenv_info)%{$fg[green]%}%~%f $vcs_info_msg_0_%f
%(0?.%{$fg[green]%}.%{$fg[red]%})$%f '

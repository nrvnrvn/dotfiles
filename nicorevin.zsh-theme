# Load required modules.
autoload -Uz vcs_info
autoload -U add-zsh-hook

add-zsh-hook precmd vcs_info

# pretty dir colors
if [[ $(uname) == 'Linux' ]] ; then
    eval $(dircolors -b)
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

# enable git support
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*:*' actionformats '(%F{cyan}%b%f)-(%F{yellow}%a%f) '
zstyle ':vcs_info:*:*' formats       '(%F{cyan}%b%f) '

# virtualenv prompt
function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('%F{magenta}${VIRTUAL_ENV##*/}%f') '
}

PROMPT='%F{blue}%T%f %F{green}%~%f $(virtualenv_info)$vcs_info_msg_0_%f
%(!.%F{red}#.%(0?.%F{yellow}.%F{red})$)%f '

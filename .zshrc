# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

alias \
  brewdauc='brew doctor && brew autoremove && brew upgrade --require-sha --greedy && brew cleanup --prune=all -s' \
  dotfiles='/usr/bin/git --git-dir=${HOME}/.config/dotfiles --work-tree=${HOME}' \
  g=git \
  grep='grep --color=auto --exclude-dir=.git' \
  rg='rg --colors="match:fg:yellow"' \
  k=kubectl \
  ll='ls -Glh' \
  lla='ls -Glha' \
  ls='ls -G' \
  vim=nvim

export \
  CLICOLOR=1 \
  EDITOR=nvim \
  GOMODCACHE="${HOME}/.cache/gomod" \
  GOPATH="${HOME}/.go" \
  GPG_TTY="${TTY}" \
  GREP_COLOR='1;33' \
  HISTSIZE=999999 \
  LANG=en_US.UTF-8 \
  LC_ALL=en_US.UTF-8 \
  LESS=-RFi \
  LSCOLORS="ExfxcxdxbxGxDxabagacad" \
  PAGER=less \
  SAVEHIST=999999 \
  WORDCHARS=''

# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Widgets
autoload -U \
  add-zsh-hook \
  bracketed-paste-url-magic \
  compaudit \
  compinit \
  down-line-or-beginning-search \
  up-line-or-beginning-search \
  url-quote-magic \
  zrecompile

# http://zsh.sourceforge.net/Doc/Release/Options.html#Description-of-Options
setopt \
  always_to_end \
  auto_cd \
  auto_list \
  auto_menu \
  auto_param_slash \
  complete_in_word \
  extended_glob \
  extended_history \
  hist_expire_dups_first \
  hist_ignore_dups \
  hist_ignore_space \
  hist_reduce_blanks \
  hist_verify \
  inc_append_history \
  interactive_comments \
  share_history

function refresh_completions {
  compinit
  touch "${HOME}/.zcompdump"
  # http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Recompiling-Functions
  zrecompile -pq "${HOME}/.zcompdump" -- "${HOME}/.zshrc"
}

# Load and initialize the completion system ignoring insecure directories with a
# cache time of 23 hours, so it should almost always regenerate the first time a
# shell is opened each day.
function _setup_completion {
  fpath=(/opt/homebrew/share/zsh/site-functions "${fpath[@]}")
  if [[ "${HOME}/.zcompdump"(#qNmh-23) ]]; then
    compinit -C
  else
    refresh_completions
  fi

  zstyle -e ':completion:*:approximate:*'         max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'
  zstyle ':completion:*:-tilde-:*'                group-order 'named-directories' 'path-directories' 'users' 'expand'
  zstyle ':completion:*:*:-subscript-:*'          tag-order indexes parameters
  zstyle ':completion:*:*:*:*:*'                  menu select
  zstyle ':completion:*:*:cd:*:directory-stack'   menu yes select
  zstyle ':completion:*:*:cd:*'                   tag-order local-directories directory-stack path-directories
  zstyle ':completion:*:approximate:*'            max-errors 1 numeric
  zstyle ':completion:*:corrections'              format '%f -- %F{green}%d (errors: %e)%f --'
  zstyle ':completion:*:default'                  list-colors ${(s.:.):-di=1;34:ln=35:so=32:pi=33:ex=31:bd=1;36:cd=1;33:su=30;41:sg=30;46:tw=30;42:ow=30;43}
  zstyle ':completion:*:default'                  list-prompt '%S%M matches%s'
  zstyle ':completion:*:descriptions'             format '%f -- %F{yellow}%d%f --'
  zstyle ':completion:*:functions'                ignored-patterns '(_*|pre(cmd|exec))'
  zstyle ':completion:*:history-words'            list false
  zstyle ':completion:*:history-words'            menu yes
  zstyle ':completion:*:history-words'            remove-all-dups yes
  zstyle ':completion:*:history-words'            stop yes
  zstyle ':completion:*:match:*'                  original only
  zstyle ':completion:*:matches'                  group yes
  zstyle ':completion:*:messages'                 format '%f  -- %F{purple}%d%f --'
  zstyle ':completion:*:options'                  auto-description '%d'
  zstyle ':completion:*:options'                  description yes
  zstyle ':completion:*:warnings'                 format '%f -- %F{red}no matches found%f --'
  zstyle ':completion:*'                          accept-exact '*(N)'
  zstyle ':completion:*'                          completer _complete _match _approximate
  zstyle ':completion:*'                          format '%f -- %F{yellow}%d%f --'
  zstyle ':completion:*'                          group-name ''
  zstyle ':completion:*'                          matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
  zstyle ':completion:*'                          squeeze-slashes true
  zstyle ':completion:*'                          use-cache yes
  zstyle ':completion:*'                          verbose yes
}

# Shorten path to fit into a tab size
# no rocket science for speed purposes.
function _set_term_title {
  local -r dir="${PWD/#$HOME/~}"
  local -r dir_tree=(${(s:/:)dir})
  local -r max_segment_length=$(((33 - ${#dir_tree[-1]}) / ${#dir_tree[@]}))

  # don't shorten path if it is shorter than 25 chars
  if [[ 30 -gt ${#dir} ]]; then
    printf '\e]0;%s\a' "${dir}" # set terminal title
    return 0
  fi

  if [[ 2 -lt ${max_segment_length} ]]; then
    local -r segment_length=$((max_segment_length - 1))
  else
    local -r segment_length=1
  fi

  if [[ "~" != "${dir_tree[1]}" ]]; then
    local dir_shortened="/${dir_tree[1]:0:${segment_length}}"
  else
    local dir_shortened="~"
  fi

  for el in "${dir_tree[@]:1:${#dir_tree[@]}-2}"; do
    dir_shortened+="/${el:0:${segment_length}}"
  done

  printf '\e]0;%s\a' "${dir_shortened}/${dir_tree[-1]}" # set terminal title
}

function _setup_input {
  # http://zsh.sourceforge.net/Guide/zshguide04.html
  zle -N bracketed-paste bracketed-paste-url-magic
  zle -N down-line-or-beginning-search
  zle -N self-insert url-quote-magic
  zle -N up-line-or-beginning-search

  # Make sure that the terminal is in application mode when zle is active, since
  # only then values from $terminfo are valid
  if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function _zl_init { echoti smkx; }
    function _zl_finish { echoti rmkx; }
    zle -N zle-line-init _zl_init
    zle -N zle-line-finish _zl_finish
  fi

  # http://zsh.sourceforge.net/Intro/intro_11.html
  # [Space] - do history expansion
  # [Shift-Tab] - move through the completion menu backwards
  # start typing + [Down-Arrow] - fuzzy find history backward
  # start typing + [Up-Arrow] - fuzzy find history forward
  # [Delete] - delete forward
  bindkey -e \
    ' ' magic-space \
    "${terminfo[kcbt]}" reverse-menu-complete \
    "${terminfo[kcud1]}" down-line-or-beginning-search \
    "${terminfo[kcuu1]}" up-line-or-beginning-search \
    "${terminfo[kdch1]}" delete-char
}

function _setup_p10k {
  source "${HOME}/.p10k/powerlevel10k.zsh-theme"

  # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
  [[ -f "${HOME}/.p10k.zsh" ]] && source "${HOME}/.p10k.zsh"
}

function _setup_brew_integration {
  source <(/opt/homebrew/bin/brew shellenv)

  if brew list --formula | grep -q '^fzf$'; then
    eval "$(fzf --zsh)"
  fi

  if brew list --formula | grep -q '^rustup$'; then
    local -r RUSTUP_BIN_DIR="$(brew --prefix rustup)/bin"

    if [[ ":${PATH}:" != *:"${RUSTUP_BIN_DIR}":* ]]; then
      export PATH="${RUSTUP_BIN_DIR}:${PATH}"
    fi
  fi

  if brew list --formula | grep -q '^fnm$'; then
    eval "$(fnm env --use-on-cd --version-file-strategy=recursive)" || true
  fi
}

add-zsh-hook precmd _set_term_title
_setup_completion
_setup_input
_setup_p10k
_setup_brew_integration

# handy function definitions below

function pdfcompress {
  local input="" output="" password="" level="screen"
  local -a GS_OPTIONS=("-sDEVICE=pdfwrite")

  usage() {
    cat <<EOF
Usage: pdfcompress -i|--input <input.pdf> [-o|--output <output.pdf>] [-p|--password <password>] [-l|--level <screen|ebook|printer|prepress>]

  -i, --input     Path to the source PDF (required)
  -o, --output    Path for the compressed PDF (default: same dir, prefixed "compressed-")
  -p, --password  PDF password, if any
  -l, --level     Compression preset: screen, ebook, printer, or prepress (default: screen)
  -h, --help      Show this help message and exit
EOF
  }

  # Check for Ghostscript
  if ! command -v gs >/dev/null 2>&1; then
    echo "Error: Ghostscript (gs) not found. Please install it first." >&2
    return 1
  fi

  # Parse command-line arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -i | --input)
      input="$2"
      shift 2
      ;;
    -o | --output)
      output="$2"
      shift 2
      ;;
    -p | --password)
      password="$2"
      shift 2
      ;;
    -l | --level)
      level="$2"
      shift 2
      ;;
    -h | --help)
      usage
      return 0
      ;;
    *)
      echo "Error: Invalid option '$1'" >&2
      usage
      return 1
      ;;
    esac
  done

  # Validate input
  if [[ -z "${input}" ]]; then
    echo "Error: --input is required" >&2
    usage
    return 1
  fi
  if [[ ! -f "${input}" ]]; then
    echo "Error: Input file '${input}' not found" >&2
    return 1
  fi

  if [[ -z "${output}" ]]; then
    output="$(dirname "${input}")/compressed-$(basename "${input}")"
  fi

  case "${level}" in
  screen | ebook | printer | prepress)
    GS_OPTIONS+=("-dPDFSETTINGS=/${level}")
    ;;
  *)
    echo "Error: Invalid level '${level}'" >&2
    usage
    return 1
    ;;
  esac

  local -r target=$(mktemp)
  local -r orig_size=$(stat -f%z "${input}")

  echo -n "Compressing ${input}... "
  gs "${GS_OPTIONS[@]}" \
    ${password:+-sPDFPassword="$password"} \
    -q -o "${target}" "${input}"

  # Ensure output directory
  mkdir -p "$(dirname "${output}")"

  # Write temporary target to desired location
  mv "${target}" "${output}"

  # Report compression metrics
  local -r comp_size=$(stat -f%z "${output}")
  echo "Done:
  Result: ${output}
  Stats: ${orig_size}B -> ${comp_size}B ($((comp_size * 100 / orig_size))% of original)"
}

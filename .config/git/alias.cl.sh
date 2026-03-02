#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

f() {
  local -r url="$1"
  shift

  local target="${url%.git}"
  target="${target#*://}"
  target="${target#*@}"
  target="${HOME}/Projects/${target//://}"

  if [[ ! -d "${target}" ]]; then
    git clone "${url}" "${target}" "$@"
  fi

  printf "Cloned %s into:\n" "${url}" >&2
  printf "%s" "${target}"
}

f "$@"

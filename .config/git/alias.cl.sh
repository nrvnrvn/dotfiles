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

  git clone "${url}" "${target}" "$@"
}

f "$@"

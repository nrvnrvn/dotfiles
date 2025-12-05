#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

f() {
  local -r cfg="${HOME}/.config/git/config"
  awk -F '\t' '$1 { section = $1; print section } $2 { print section "\t" $2}' "${cfg}" | sort -u | awk -F '\t' '!$2 { print $1 } $1 && $2 { print "\t" $2 }' >"${cfg}.new" && mv "${cfg}"{.new,}
}

f

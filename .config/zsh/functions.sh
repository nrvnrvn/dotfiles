#!/usr/bin/env bash

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

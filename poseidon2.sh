#!/usr/bin/env bash

# Treat unset variables and parameters other than the special parameters ‘@’ or
# ‘*’ as an error when performing parameter expansion. An 'unbound variable'
# error message will be written to the standard error, and a non-interactive
# shell will exit.
set -o nounset
# Exit immediately if a pipeline returns non-zero.
set -o errexit
# Print a helpful message if a pipeline with non-zero exit code causes the
# script to exit as described above.
trap 'echo "Aborting due to errexit on line $LINENO. Exit code: $?" >&2' ERR
# Allow the above trap be inherited by all functions in the script.
set -o errtrace
# Return value of a pipeline is the value of the last (rightmost) command to
# exit with a non-zero status, or zero if all commands in the pipeline exit
# successfully.
set -o pipefail
# Set $IFS to only newline and tab.
IFS=$'\n\t'

#### Environment ####

# Set to the program's basename.
_ME=$(basename "${0}")

#### Main Function ####

_main() {
  # call special module help in case of no input at all
  if [[ $# -eq 0 ]] ; then
    _print_help
    exit 0
  fi
  # catch input variables
  _module="${1}"
  # run modules depending on user input
  case "${_module}" in
    help) _print_help ;;
    merge) _merge ${2} ${3} ;;
    convert) printf "Not yet implemented\\n" ;;
    extract) printf "Not yet implemented\\n" ;;
  esac
  # exit gracefully
  exit 0
}

#### Load other code files ####

source poseidon2_help.sh
source poseidon2_merge.sh
source poseidon2_convert.sh
source poseidon2_extract.sh

#### Run ####

_main "$@"


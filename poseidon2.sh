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
_path_to_me=$(dirname "${0}")

#### Helper functions ####

_check_number_of_input_parameters() {
  if (( ${1} != ${2} )); then
    printf "Error 2: Illegal number of parameters\\n"
    exit 2
  fi
}

#### Main Function ####

_main() {
  # call special module help in case of no input at all
  if [[ $# -eq 0 ]] ; then
    _print_help
    exit 0
  fi
  # catch module variable
  _module="${1}"
  # check number of input parameters
  case "${_module}" in
    help) _print_help ;;
    merge) _check_number_of_input_parameters $# 3 ;;
    convert) _check_number_of_input_parameters $# 4 ;;
    extract) printf "Not yet implemented.\\n" ;;
    *) printf "I don't know this module name.\\n"
  esac
  # get name date
  _current_date="$(date +'%Y-%m-%d_%H:%M')"
  # get random alphanumeric string
  _random_string="$(openssl rand -hex 7)"
  # create tmp_and_log_directory
  _log_file_directory="poseidon2_tmp_and_log/${_current_date}_${_random_string}"
  mkdir -p ${_log_file_directory}
  # run modules depending on user input
  case "${_module}" in
    help) _print_help ;;
    merge) _merge ${2} ${3} ${_current_date} ${_log_file_directory} ;;
    convert) _convert ${2} ${3} ${4} ${_log_file_directory} ;;
    extract) printf "Not yet implemented.\\n" ;;
    *) printf "I don't know this module name.\\n"
  esac
  # exit gracefully
  exit 0
}

#### Load other code files ####

source ${_path_to_me}/helpers_check_if_valid_package.sh
source ${_path_to_me}/poseidon2_help.sh
source ${_path_to_me}/poseidon2_merge.sh
source ${_path_to_me}/poseidon2_convert.sh
source ${_path_to_me}/poseidon2_extract.sh

#### Run ####

_main "$@"


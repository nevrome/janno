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

#### Help function ####

_print_help() {
cat <<HEREDOC
Usage:
  ${_ME} [<arguments>]
  ${_ME} -h | --help
Options:
  -h --help  Show this screen.
HEREDOC
}

#### Program Functions ####

_create_binary_file_list_file() {
  # start message
  printf "Creating input list for plink\\n"
  # temporary output file
  result_file="/tmp/mastermerge_binary_file_list_file"
  rm -f ${result_file}
  touch ${result_file}
  # loop through all modules directories
  while read p; do
    # ignore empty names (empty lines in the input dir list)
    if [ -z "${p}" ]
    then
      continue
    fi
    # loop through relevant file types (bed, bim, fam)
    file_list=""
    for extension in bed bim fam
    do
      new_file=$(find "${p}/" -name "*.${extension}")
      file_list="${file_list} ${new_file}"
    done 
    # write result to output file
    echo "${file_list}" >> ${result_file}
  done <${1}
  # end message
  printf "Done\\n"
}

#### Main function ####

_main() {
  # Avoid complex option parsing when only one program option is expected.
  if [[ "${1:-}" =~ ^-h|--help$  ]]
  then
    _print_help
  else
    _create_binary_file_list_file "${1:-}"
  fi
}

_main "$@"


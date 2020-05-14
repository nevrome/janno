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
  printf "Creating input file for plink merge\\n"
  # input file
  _input_file=${1}
  # temporary output file
  _result_file=${2}
  rm -f ${_result_file}
  touch ${_result_file}
  # loop through all modules directories
  while read p; do
    # ignore empty names (empty lines in the input dir list)
    if [ -z "${p}" ]
    then
      continue
    fi
    # loop through relevant file types (bed, bim, fam)
    _file_list=""
    for extension in bed bim fam
    do
      _new_file=$(find "${p}/" -name "*.${extension}")
      _file_list="${_file_list} ${_new_file}"
    done 
    # write result to output file
    echo "${_file_list}" >> ${_result_file}
  done <${_input_file}
  # end message
  printf "Done\\n"
}

_plink_merge() {
  # start message
  printf "Merge genome data with plink\\n"

  ## TODO

  # end message
  printf "Done\\n"
} 

_janno_merge() {
  # start message
  printf "Merge janno files\\n"
#  # https://stackoverflow.com/questions/27516935/merging-two-data-tables-with-missing-values-using-bash
#  _input_file=${1}
#  # loop through all modules directories 
#  _last_origin=""
#  _last_new=""
#  while read p; do
#    # ignore empty names (empty lines in the input dir list)
#    if [ -z "${p}" ]
#    then
#      continue
#    fi
#    _new_file=$(find "${p}/" -name "*.tsv" -not -path '*/\.*')
#    if [ -z "${_new_file}" ]
#    then
#      continue
#    fi
#    _last_origin="${_new_file}"
#    sed -n '2,$p' "${_new_file}" | sort >"/tmp/mastermerge_$(basename ${_new_file}).sorted"
#    if [ -z "${_last_new}" ]
#    then
#      _last_new="/tmp/mastermerge_$(basename ${_new_file}).sorted"
#    else
#      join -a 1 -a 2 -e '0' -1 1 -2 1 -t $'\t' ${_last_new} "/tmp/mastermerge_$(basename ${_new_file}).sorted" > "/tmp/mastermerge_joinedanno"
#      head -1 ${_last_origin} | join -1 1 -2 1 -t $'\t' - <(head -1 "/tmp/mastermerge_joinedanno") >"/tmp/mastermerge_header"
#      cat "/tmp/mastermerge_header" "/tmp/mastermerge_joinedanno" >> "/tmp/mastermerge_janno"
#    fi
#  done <${_input_file}
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
    _tmp_binary_file_list_file="/tmp/mastermerge_binary_file_list_file"
    _create_binary_file_list_file ${1:-} ${_tmp_binary_file_list_file}
    _plink_merge ${2:-}
    _janno_merge ${1:-}
  fi
}

_main "$@"


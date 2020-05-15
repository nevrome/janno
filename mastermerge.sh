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

_merge_multiple_files() {
  Rscript -e "
    input_files_paths <- commandArgs(trailingOnly = TRUE)
    input_files_dfs <- lapply(input_files_paths, read.delim, stringsAsFactors = F)
    res_df <- do.call(rbind, input_files_dfs)
    res_df[is.na(res_df)] <- 'n/a'
    out_file <- '/tmp/mastermerge_mergedfile'
    write.table(res_df, file = out_file, sep = '\t')
    cat(out_file)
  " ${@}
}

_janno_merge() {
  # start message
  printf "Merge janno files\\n"
  _input_file=${1}
  _output_file=${2}
  # loop through all modules directories 
  _janno_files=()
  while read p; do
    # ignore empty names (empty lines in the input dir list)
    if [ -z "${p}" ]
    then
      continue
    fi
    _new_file=$(find "${p}/" -name "*.tsv" -not -path '*/\.*')
    if [ -z "${_new_file}" ]
    then
      continue
    fi
    _janno_files+=("${_new_file}")
  done <${_input_file}
  # merge resulting janno files
  _merged_janno_tmp_file=$(_merge_multiple_files ${_janno_files[@]})
  # move output file
  mv ${_merged_janno_tmp_file} ${_output_file}
  # end message
  printf "Done\\n"
} 

#### Main function ####

_workflow() {
  _tmp_binary_file_list_file="/tmp/mastermerge_binary_file_list_file"
  _create_binary_file_list_file ${1:-} ${_tmp_binary_file_list_file}
  _plink_merge ${2:-}
  _janno_merge ${1:-} "test_merged_janno.janno"
}

_main() {
  if [[ $# -eq 0 ]] ; then
    _print_help
  fi
 
  case "${1}" in
    -h) _print_help ;;
    --help) _print_help ;;
    *) _workflow ${1} ;;
  esac
}

_main "$@"


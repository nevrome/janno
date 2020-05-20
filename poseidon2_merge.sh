# Author: Clemens & Ayshin

#### Main function ####

_merge() {
  # catch input variables
  _input_file_with_list_of_poseidon_modules=${1}
  _output_directory=${2}
  # prepare other variables
  _plink_input_file="/tmp/mastermerge_binary_file_list_file"
  # make output directory
  mkdir -p ${_output_directory}
  # run steps
  #_create_binary_file_list_file ${_input_file_with_list_of_poseidon_modules} ${_plink_input_file}
  # TODO: create concatenated order file from first two columns of fam files
  # _order_file = ...
  #_plink_merge ${_plink_input_file} ${_order_file} ${_output_directory}
  _janno_merge ${_input_file_with_list_of_poseidon_modules} ${_output_directory}
}

_create_binary_file_list_file() {
  # start message
  printf "Creating input file for plink merge...\\n"
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
  printf "Merge genome data with plink...\\n"

  sbatch -p "short" -c 4 --mem=10000 -J "plink-merge" --wrap="plink --merge-list ${1} --make-bed --indiv-sort f ${2} --out ${3}_TF"
  # write slurm logs somewhere

  sbatch -p "short" -c 1 --mem=10000 -J "extract_SNPs" --wrap="plink --bfile ${3}_TF --extract ${4} --make-bed --out ${5}_HO"
  # To extract Human Origins SNPs for PCA & other analysis with modern samples

  # end message
  printf "Done\\n"
}

_merge_multiple_files() {
  _output_file=${1}
  shift
  _janno_files=("$@")
  head -1 ${_janno_files[0]} > ${_output_file}
  tail -n +3 -q ${_janno_files[@]} >> ${_output_file}
  # replace R script with concat solution: The janno fiels do have the same columns and column order all the time - no complex merge logic necessary
  # sort by order file
}

_janno_merge() {
  # start message
  printf "Merge janno files...\\n"
  _input_file=${1}
  _output_file="${2}/test_merged_janno.janno"
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
  _merge_multiple_files "${_output_file}" "${_janno_files[@]}"
  # end message
  printf "Done\\n"
}

_order_file() {
  # TODO: Create order file from fam files
  printf "Done\\n"
}


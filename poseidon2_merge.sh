# Author: Clemens & Ayshin

_merge() {
  # catch input variables
  _input_file_with_list_of_poseidon_packages=${1}
  _output_directory=${2}
  # prepare other variables
  _current_date=${3}
  _output_files_name="poseidon2_merge_${_current_date}"
  _log_file_directory=${4}
  _plink_input_file="${_log_file_directory}/poseidon2_merge_plink_input_file.txt"
  _plink_order_file="${_log_file_directory}/poseidon2_merge_plink_order_file.txt"
  # start message
  _merge_start_message ${_input_file_with_list_of_poseidon_packages} ${_output_directory} ${_output_files_name} ${_log_file_directory}
  _print_packages ${_input_file_with_list_of_poseidon_packages}
  # check if the input packages are valid
  _check_packages ${_input_file_with_list_of_poseidon_packages}
  # make output directory
  mkdir -p ${_output_directory}
  # run steps
  _create_binary_file_list_file ${_input_file_with_list_of_poseidon_packages} ${_plink_input_file}
  _janno_merge ${_input_file_with_list_of_poseidon_packages} ${_output_directory} ${_output_files_name}
  _create_order_file_from_fam_files ${_input_file_with_list_of_poseidon_packages} ${_plink_order_file}
  _plink_merge ${_plink_input_file} ${_plink_order_file} ${_output_directory} ${_output_files_name} ${_log_file_directory}
  
  printf "\\n"
}

_merge_start_message() {
cat << EOF
                       _     _             ____  
  ____   ___  ___  ___(_) __| | ___  ____ |___ \ 
 |  _ \ / _ \/ __|/ _ \ |/ _  |/ _ \|  _ \  __) |
 | |_) | (_) \__ \  __/ | (_| | (_) | | | |/ __/ 
 |  __/ \___/|___/\___|_|\____|\___/|_| |_|_____|
 |_| 

merge => Merges multiple poseidon directories
  
Input file with package list:	${1}
Output directory: 		${2}
Output file name: 		${3}.*
Log file directory:		${4}  
  
EOF
}

_print_packages() {
  printf "Packages to be merged:\\n"
  _input_file=${1}
  # loop through all packages directories
  while read p; do
    # ignore empty names and lines starting with in the input dir list
    case ${p} in
      ''|\#*) continue ;;
    esac
    printf "=> ${p}\\n"
  done <${_input_file}
  printf "\\n"
}

_check_packages() {
  _input_file=${1}
  # loop through all packages directories
  while read p; do
    # ignore empty names and lines starting with in the input dir list
    case ${p} in
      ''|\#*) continue ;;
    esac
    _check_if_valid_package ${p}
  done <${_input_file}
  printf "\\n"
}

_create_binary_file_list_file() {
  printf "Creating input file for plink merge...\\n"
  _input_file=${1}
  _output_file=${2}
  rm -f ${_output_file}
  touch ${_output_file}
  # loop through all packages directories
  while read p; do
    # ignore empty names and lines starting with in the input dir list
    case ${p} in
      ''|\#*) continue ;;
    esac
    # loop through relevant file types (bed, bim, fam)
    _file_list=""
    for extension in bed bim fam
    do
      _new_file=$(find "${p}/" -name "*.${extension}")
      _file_list="${_file_list} ${_new_file}"
    done
    # write result to output file
    echo "${_file_list}" >> ${_output_file}
  done <${_input_file}
  # print output file path
  printf "=> ${_output_file}\\n"
}

_merge_multiple_files_with_header() {
  _output_file=${1}
  shift
  _input_files=("$@")
  head -1 ${_input_files[0]} > ${_output_file}
  tail -n +2 -q ${_input_files[@]} >> ${_output_file}
}

_janno_merge() {
  printf "Merge janno files...\\n"
  _input_file=${1}
  _output_file="${2}/${3}.janno"
  # loop through all packages directories
  _janno_files=()
  while read p; do
    # ignore empty names and lines starting with in the input dir list
    case ${p} in
      ''|\#*) continue ;;
    esac
    _new_file=$(find "${p}/" -name "*.janno" -not -path '*/\.*')
    if [ -z "${_new_file}" ]
    then
      continue
    fi
    _check_if_newline_at_eof ${_new_file}
    _janno_files+=("${_new_file}")
  done <${_input_file}
  # merge resulting janno files
  _merge_multiple_files_with_header "${_output_file}" "${_janno_files[@]}"
  # print output file path
  printf "=> ${_output_file}\\n"
}

_check_if_newline_at_eof() {
    if ! _file_ends_with_newline $1
    then
        printf "Missing newline at the end of:\\n=> $1\\n\\n"
	exit 1
    fi
}

_file_ends_with_newline() {
    [[ $(tail -c1 "$1" | wc -l) -gt 0 ]]
}

_merge_multiple_files_and_cut_first_two_columns() {
  _output_file=${1}
  shift
  _input_files=("$@")
  cat ${_input_files[@]} | cut -f 1,2 -d " " > ${_output_file}
}

_create_order_file_from_fam_files() {
  printf "Merge fam files to get order file...\\n"
  _input_file=${1}
  _output_file=${2}
  # loop through all packages directories
  _fam_files=()
  while read p; do
    # ignore empty names and lines starting with in the input dir list
    case ${p} in
      ''|\#*) continue ;;
    esac
    _new_file=$(find "${p}/" -name "*.fam" -not -path '*/\.*')
    if [ -z "${_new_file}" ]
    then
      continue
    fi
    _fam_files+=("${_new_file}")
  done <${_input_file}
  _merge_multiple_files_and_cut_first_two_columns "${_output_file}" "${_fam_files[@]}"
  # print output file path
  printf "=> ${_output_file}\\n"
}

_plink_merge() {
  printf "Merge genome data with plink...\\n=> "
  sbatch -p "short" -c 4 --mem=10000 -J "poseidon2_merge" -o "${5}/poseidon2_%j.out" -e "${5}/poseidon2_%j.err" --wrap="plink --merge-list ${1} --make-bed --indiv-sort f ${2} --out ${3}/${4} && mv ${3}/${4}.log ${5}/plink.log"
}


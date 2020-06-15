# Author: Clemens

_check_if_valid_package() {
  
  _input_package=${1}

  # check file numbers
  _num_janno=$(find ${_input_package} -type f -name "*.janno" | wc -l)
  _check_number_of_files ${_num_janno} 1 "*.janno" ${_input_package}
  _num_bim=$(find ${_input_package} -type f -name "*.bim" | wc -l)
  _check_number_of_files ${_num_bim} 1 "*.bim" ${_input_package}
  _num_bed=$(find ${_input_package} -type f -name "*.bed" | wc -l)
  _check_number_of_files ${_num_bed} 1 "*.bed" ${_input_package}
  _num_fam=$(find ${_input_package} -type f -name "*.fam" | wc -l)
  _check_number_of_files ${_num_fam} 1 "*.fam" ${_input_package}

  # further checks...

}

_check_number_of_files() {
  if (( ${1} != ${2} )); then
    printf "Error 3: Multiple ${3} files in input package ${4}\\n"
    exit 3
  fi
}

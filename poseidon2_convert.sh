# Author: Ayshin & Clemens

_convert() {
  # catch input variables
  _input_module=${1}
  _output_format=${2}
  # prepare other variables
  _current_date=${3}
  _output_files_name="poseidon2_convert_${_current_date}"
  _log_file_directory=${4}
  # start message
  _convert_start_message ${_input_module} ${_output_format} ${_log_file_directory}
  # run conversion depending on user input
  case "${_output_format}" in
    eigenstrat) printf "Not yet implemented.\\n" ;; #_ped2eig ${_input_module} ${_output_files_name} ;;
    *) printf "I don't know this output format name.\\n"
  esac
}

_convert_start_message() {
cat << EOF
                       _     _             ____  
  ____   ___  ___  ___(_) __| | ___  ____ |___ \ 
 |  _ \ / _ \/ __|/ _ \ |/ _  |/ _ \|  _ \  __) |
 | |_) | (_) \__ \  __/ | (_| | (_) | | | |/ __/ 
 |  __/ \___/|___/\___|_|\____|\___/|_| |_|_____|
 |_| 

convert => Converts data in poseidon directories
  
Input module:			${1}
Output format: 			${2}
Log file directory:		${3}  
  
EOF
}

_ped2eig() {
  # start message
  printf "Converting plink files to eigenstrat format...\\n"

  sbatch -p "short" -c 1 --mem=10000 -J "bed2map" --wrap="plink --bfile ${3}_TF --recode --out ${6}_TF"
  # For 1240K dataset

  #sbatch -p "short" -c 1 --mem=10000 -J "bed2map" --wrap="plink --bfile ${5}_HO --recode --out ${7}_HO"
  # For Human Origins dataset, we can have this as only a temporary file

  cat convertf_TF.par <<EOF
  genotypename: $PWD/${6}_TF.ped
  snpname: $PWD/${6}_TF.map
  indivname: $PWD/${6}_TF.pedind
  outputformat: EIGENSTRAT
  genotypeoutname: $PWD/${6}_TF.geno
  snpoutname: $PWD/${6}_TF.snp
  indivoutname: $PWD/${6}_TF.ind
  familynames: NO
EOF
 # TODO: check .pedind format, we might have create it or just modify one of plink files
  sbatch -c 1 --mem=2000  -J "convertf" --wrap="convertf -p convertf_TF.par > convert.log"
}

# Author: Ayshin & Clemens

_convert() {
  # catch input variables
  _output_format=${1}
  _input_package=${2}
  _output_directory=${3}
  # prepare other variables
  _log_file_directory=${4}
  # start message
  _convert_start_message ${_input_package} ${_output_format} ${_output_directory} ${_log_file_directory}
  # check if the input package is valid
  _check_if_valid_package ${_input_package}
  # make output directory
  mkdir -p ${_output_directory}
  # run conversion depending on user input
  case "${_output_format}" in
    eigenstrat) _ped2eig ${_input_package} ${_output_directory} ${_log_file_directory} ;;
    *) printf "I don't know this output format name.\\n"
  esac

  printf "\\n"
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
  
Input package:			${1}
Output format: 			${2}
Output directory: 		${3}
Log file directory:		${4}  
  
EOF
}

_ped2eig() {
  printf "Converting plink files to eigenstrat format...\\n"
  _input_package=${1}  
  _output_directory=${2}
  _log_file_directory=${3}
  # loop to get links to bed, bim and fam file
  _file_list=()
  for extension in bed bim fam
  do
    _file_list+=($(find "${_input_package}/" -name "*.${extension}"))
  done
  # get 
  _file_name=$(basename "${_file_list[0]}" .bed)  #${_file_list[1]%.*}
  # prepare pedind file
  awk '{print $1, $2, $3, $4, $5, $1}' ${_file_list[2]} > "${_log_file_directory}/for_conversion.pedind"
  # create eigensoft convertion config file  
  touch "${_log_file_directory}/convertf.par"
cat > ${_log_file_directory}/convertf.par <<EOF
  genotypename: ${_file_list[0]}
  snpname: ${_file_list[1]}
  indivname: ${_log_file_directory}/for_conversion.pedind
  outputformat: EIGENSTRAT
  genotypeoutname: ${_output_directory}/${_file_name}.geno
  snpoutname: ${_output_directory}/${_file_name}.snp
  indivoutname: ${_output_directory}/${_file_name}.ind
  familynames: NO
EOF
  # print path to conversion file
  printf "=> ${_log_file_directory}/convertf.par\\n=> "
  # run actual conversion with sbatch
  #sbatch -c 1 --mem=2000  -J "poseidon_convert" --wrap="plink --bed ${_file_list[0]} --bim ${_file_list[1]} --fam ${_file_list[2]} --recode --out ${6} && convertf -p convertf.par > convert.log"
  sbatch -c 1 --mem=2000  -J "poseidon_convert" -o "${_log_file_directory}/poseidon2_%j.out" -e "${_log_file_directory}/poseidon2_%j.err" --wrap="convertf -p ${_log_file_directory}/convertf.par > ${_log_file_directory}/convert.log"
}


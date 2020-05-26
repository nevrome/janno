# Author: Ayshin & Clemens

_convert() {
  # catch input variables
  _input_module=${1}
  _output_format=${2}
  # prepare other variables
  _log_file_directory=${3}
  # start message
  _convert_start_message ${_input_module} ${_output_format} ${_log_file_directory}
  # run conversion depending on user input
  case "${_output_format}" in
    eigenstrat) _ped2eig ${_input_module} ${_log_file_directory} ;; #_ped2eig ${_input_module} ${_output_files_name} ;;
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
  printf "Converting plink files to eigenstrat format...\\n"

  _input_package=${1}  
  _log_file_directory=${2}

  _file_list=()
  for extension in bed bim fam
  do
    _file_list+=($(find "${_input_package}/" -name "*.${extension}"))
  done

  _file_name=${_file_list[1]%.*}
  
  touch "${_log_file_directory}/convertf.par"
 
cat > ${_log_file_directory}/convertf.par <<EOF
  genotypename: ${_file_name}.ped
  snpname: ${_file_name}.map
  indivname: ${_file_name}.pedind
  outputformat: EIGENSTRAT
  genotypeoutname: ${_file_name}.geno
  snpoutname: ${_file_name}.snp
  indivoutname: ${_file_name}.ind
  familynames: NO
EOF

  printf "=> ${_log_file_directory}/convertf.par\\n" 

 # TODO: check .pedind format, we might have create it or just modify one of plink files
  #sbatch -c 1 --mem=2000  -J "poseidon_convert" --wrap="plink --bed ${_file_list[0]} --bim ${_file_list[1]} --fam ${_file_list[2]} --recode --out ${6} && convertf -p convertf.par > convert.log"

}


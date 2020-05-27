_print_help() {
cat << EOF
                       _     _             ____  
  ____   ___  ___  ___(_) __| | ___  ____ |___ \ 
 |  _ \ / _ \/ __|/ _ \ |/ _  |/ _ \|  _ \  __) |
 | |_) | (_) \__ \  __/ | (_| | (_) | | | |/ __/ 
 |  __/ \___/|___/\___|_|\____|\___/|_| |_|_____|
 |_| 

Utility functions for the poseidon2 data format. All input directories have to adhere to the poseidon2 file structure as documented here: /projects1/poseidon/janno/README.md

convert => Converts data in poseidon directories
  
  ${_ME} convert [output_format] [input_module]

  output_format		Output file format. One of eigenstrat, ...
  input_module		Path to poseidon2 module that is supposed to be converted
  
extract => Extracts certain SNP panels from a poseidon module

  ${_ME} extract ...

  ...

help => Shows this screen

  ${_ME} help

merge => Merges multiple poseidon directories
 
  ${_ME} merge [input_file] [output_directory]

  input_file		File with a list of paths to poseidon module directories
  output_directory	Path to an output directory

EOF
}

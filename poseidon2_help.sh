_print_help() {
cat << EOF
                       _     _             ____  
  _ __   ___  ___  ___(_) __| | ___  _ __ |___ \ 
 | '_ \ / _ \/ __|/ _ \ |/ _  |/ _ \| '_ \  __) |
 | |_) | (_) \__ \  __/ | (_| | (_) | | | |/ __/ 
 | .__/ \___/|___/\___|_|\__,_|\___/|_| |_|_____|
 |_| 

Utility functions for the poseidon2 data format

help => Shows this screen

  ${_ME} help

merge => Merges multiple poseidon directories
 
  ${_ME} merge [input_file] [output_directory]

  input_file		File with a list of paths to poseidon module directories
  output_directory	Path to an output directory

convert => Converts data in poseidon directories
  
  ${_ME} convert ...

  ...

EOF
}

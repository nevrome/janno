# Author: Ayshin & Clemens

_convert() {
  
}

_ped2eig() {
  # start message
  printf "Converting plink files to eigenstrat format...\\n"

  sbatch -p "short" -c 1 --mem=10000 -J "bed2map" --wrap="plink --bfile ${3}_TF --recode --out ${6}_TF"
  # For 1240K dataset

  sbatch -p "short" -c 1 --mem=10000 -J "bed2map" --wrap="plink --bfile ${5}_HO --recode --out ${7}_HO"
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

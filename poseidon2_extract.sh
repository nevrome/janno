# Author: Ayshin

  # To extract Human Origins SNPs for PCA & other analysis with modern samples
  #sbatch -p "short" -c 1 --mem=10000 -J "extract_SNPs" --wrap="plink --bfile ${3}_TF --extract ${4} --make-bed --out ${5}_HO"

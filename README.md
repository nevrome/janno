# Poseidon v.2: DAG Genotype Data Organisation

Poseidon v.2 is an intermediate solution for the genotype data organisation within the department of archaeogenetics at the Max Planck Institute for the Science of Human History (MPI-SHH). Please check the internal documentation for more details.

Content of this file:

1. The Poseidon v.2 `package`
2. The `.janno` file
3. The `poseidon2` command line software

## 1. The Poseidon v.2 `package`

All ancient and modern data are distributed into so-called packages, which are folders containing a dedicated set of files. Packages correspond to published sets of genomes, or in case of unpublished projects, ongoing (and growing) sets of samples currently analysed.

Individual contributors would create packages in dedicated poseidon folders in their user project directories, e.g. `/project1/user/xyz/poseidon/2018_Lamnidis_Fennoscandia`. That way, subfolders belong to individual maintainers and be writable only by them. 

The poseidon admins would then link these packages into the official `/projects1/poseidon` repo, located on the HPC storage unit of the MPI-SHH, where we distinguish ancient and modern genotype data:

```
/projects1/poseidon/ancient/…  
/projects1/poseidon/modern/…
```

### Naming

The naming of packages should follow a simple scheme:

Ancient published: YEAR_NAME_IDENTIFIER

```
2018_Lamnidis_Fennoscandia  
2019_Wang_Caucasus  
2019_Flegontov_PaleoEskimo  
```

Ancient unpublished: IDENTIFIER_NAME

```
Switzerland_LNBA_Roswita  
Italy_Mesolithic_Paul  
SouthEastAsia_Simon  
```

Modern published: YEAR_(NAME)_IDENTIFIER

```
2015_1000_Genomes-1240K_haploid_pulldown
2016_Mallick_SGDP1240K_diploid_pulldown
2014_Lazaridis_HOmodern
2016_Lazaridis_HOmodern
2019_Flegontov_HO_NewSiberian
2018_Lipson_SEA
```

Modern unpublished: IDENTIFIER_NAME

```
Eurasia_newHO_Paul
Afrika_newHO_Andrea
```

Identifiers can be somewhat informal as long as the project is ongoing, they just need to be unique. As soon as a project gets published, we create a final version of the respective package with the YEAR_NAME_IDENTIFIER label.

External projects can be integrated similarly by using their publication name, or by temporary internal identifiers such as `Iron_Age_Boston_Share`.

### Substructure

Every package should have the following files: 

- README.txt
- CHANGELOG.txt#
- data-subfolders with date name: YYYY_MM_DD

Each of the data-subfolders must hold all the following files:

- X.janno (see below)
- X.bed
- X.bim
- X.fam

Example:

```
Switzerland_LNBA_Roswita/README.txt
Switzerland_LNBA_Roswita/CHANGELOG.txt
Switzerland_LNBA_Roswita/2019_03_20/
Switzerland_LNBA_Roswita/2019_05_15/  
...  
Switzerland_LNBA_Roswita/2019_05_15/Bohemia_LNBA.eigenstrat.geno
Switzerland_LNBA_Roswita/2019_05_15/Bohemia_LNBA.eigenstrat.snp
Switzerland_LNBA_Roswita/2019_05_15/Bohemia_LNBA.eigenstrat.ind
Switzerland_LNBA_Roswita/2019_05_15/Bohemia_LNBA.plink.bed
Switzerland_LNBA_Roswita/2019_05_15/Bohemia_LNBA.plink.bim
Switzerland_LNBA_Roswita/2019_05_15/Bohemia_LNBA.plink.fam
Switzerland_LNBA_Roswita/Bohemia_LNBA_Luka/2019_05_15/Bohemia_LNBA.janno
```

## 2. The `.janno` file

The .janno file is a tab-separated text file with a header line that holds a clearly defined set of metainformation (columns) for each sample (rows) in a package. 

The variables (columns), variable types and possible content of the janno file are documented in a google doc (ask the admins).

A .janno file must have all of these columns in exactly this order with exactly these column names. If information is unknown or a variable does not apply for a certain sample, then the respective cell(s) can be filled with the NULL value n/a. Ideally, a .janno file should have the least number of n/a-values possible.

The order of the samples (rows) in the .janno file must be equal to the order in the files that hold the core genetic data.

## 3. The `poseidon2` command line software

To automate the most important operations with Poseidon v.2 packages, the department collaboratively develops a bash command line tool called poseidon2. See the help module to learn about the current set of features: `./poseidon2.sh help`.

If you want to add features please contact @nevrome to get write access to the source code.

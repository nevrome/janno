# Poseidon v.2: DAG Genotype Data Organisation
Last Update: May 25, 2020

Poseidon v.2 is an intermediate solution for the genotype data organisation within our department. It's a more simple approach than Stephan's Poseidon v.1 and also not as sophisticated as Stephan's yet unfinished Poseidon v.3, but still may simplify data storage and acquisition in the near to mid-term future.

Content of this file:

1. The Poseidon v.2 `package`
2. The `.janno` file
3. The `poseidon2` command line software

## 1. The Poseidon v.2 `package`

All ancient and modern data are distributed into so-called packages, which are folders containing a dedicated set of files. Packages correspond to published sets of genomes, or in case of unpublished projects, ongoing (and growing) sets of samples currently analysed.

Individual contributors would create packages in dedicated poseidon folders in their user project directories, e.g. `/project1/user/xyz/poseidon/2018_Lamnidis_Fennoscandia`. That way, subfolders belong to individual maintainers and be writable only by them. 

The poseidon admins (currently Stephan, Wolfgang, Ayshin and Clemens) would then link these packages into the official `/projects1/poseidon` repo, where we distinguish ancient and modern genotype data:

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
Bohemia_LNBA_Luka  
Africa_with_DA_Ke  
SouthEastAsia_Selina  
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
Eurasia_newHO_Choongwon  
Mali_Dogon_Hiba
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
- X.geno
- X.snp
- X.ind
- X.bed
- X.bim
- X.fam

Example:

```
Bohemia_LNBA_Luka/README.txt
Bohemia_LNBA_Luka/CHANGELOG.txt
Bohemia_LNBA_Luka/2019_03_20/
Bohemia_LNBA_Luka/2019_05_15/  
...  
Bohemia_LNBA_Luka/2019_05_15/Bohemia_LNBA.eigenstrat.geno
Bohemia_LNBA_Luka/2019_05_15/Bohemia_LNBA.eigenstrat.snp
Bohemia_LNBA_Luka/2019_05_15/Bohemia_LNBA.eigenstrat.ind
Bohemia_LNBA_Luka/2019_05_15/Bohemia_LNBA.plink.bed
Bohemia_LNBA_Luka/2019_05_15/Bohemia_LNBA.plink.bim
Bohemia_LNBA_Luka/2019_05_15/Bohemia_LNBA.plink.fam
Bohemia_LNBA_Luka/2019_05_15/Bohemia_LNBA.janno
```

## 2. The `.janno` file

The `.janno` file is a tab-separated text file with a header line that holds a clearly defined set of metainformation (columns) for each sample (rows) in a package. 

The variables (columns), variable types and possible content of the `janno` file are documented here: https://docs.google.com/spreadsheets/d/1YfdApKAqSKdxsw_AdFqLqo6zfru-IFmwty1uUPMfYv0

A `.janno` file must have all of these columns in exactly this order with exactly these column names. If information is unknown or a variable does not apply for a certain sample, then the respective cell(s) can be filled with the NULL value n/a. Ideally, a `.janno` file should have the least number of n/a-values possible.

The order of the samples (rows) in the `.janno` file must be equal to the order in the files that hold the core genetic data.

## 3. The `poseidon2` command line software

...

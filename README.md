# Poseidon: DAG Genotype Data Organisation
Last Update: May 25, 2020

Basic idea: All ancient and modern data are distributed into so-called packages. These correspond to published sets of genomes, or in case of unpublished projects, ongoing (and growing) sets of samples currently analysed.

Basic root folder division:  
/projects1/poseidon/ancient/…  
/projects1/poseidon/modern/…

These folders would be world-readable and writable only by Poseidon Admins (Currently Users schiffels,haak, Clemens and Ayshin). Individual contributors would create modules in dedicated poseidon folders in their user project directories, e.g. /project1/user/xyz/poseidon/2018_Lamnidis_Fennoscandia. That way, subfolders belong to individual maintainers and be writable only by them. The poseidon admins would then link these folders into the official /projects1/poseidon repo.


## Internal projects
### Published
Identifiers with year:  
/ancient/2018_Lamnidis_Fennoscandia  
/ancient/2019_Wang_Caucasus  
/ancient/2019_Flegontov_PaleoEskimo  


### Unpublished
Identifiers without Year:  
/ancient/Bohemia_LNBA_Luka  
/ancient/Africa_with_DA_Ke  
/ancient/SouthEastAsia_Selina  

These identifiers can be somewhat more informal as long as the project is ongoing, they just need to be unique. As soon as a project gets published, we need to rename into YEAR_LASTNAME_IDENTIFER as above.

### Sub-Structure
Every project should have the following items: README, CHANGELOG, data-subfolders organised via dates (YYYY_MM_DD). Examples:

/ancient/Bohemia_LNBA_Luka/README.txt
/ancient/Bohemia_LNBA_Luka/CHANGELOG.txt
/ancient/Bohemia_LNBA_Luka/2019_03_20/
/ancient/Bohemia_LNBA_Luka/2019_05_15/  
...  
/ancient/Bohemia_LNBA_Luka/2019_05_15/Bohemia_LNBA.eigenstrat.geno
/ancient/Bohemia_LNBA_Luka/2019_05_15/Bohemia_LNBA.eigenstrat.snp
/ancient/Bohemia_LNBA_Luka/2019_05_15/Bohemia_LNBA.eigenstrat.ind
/ancient/Bohemia_LNBA_Luka/2019_05_15/Bohemia_LNBA.plink.bed
/ancient/Bohemia_LNBA_Luka/2019_05_15/Bohemia_LNBA.plink.bim
/ancient/Bohemia_LNBA_Luka/2019_05_15/Bohemia_LNBA.plink.fam
/ancient/Bohemia_LNBA_Luka/2019_05_15/Bohemia_LNBA.janno

External projects can be integrated similarly by using their publication name, or by temporary internal identifiers such as “Iron_Age_Boston_Share”.


## Modern Data
### Published
/modern/2015_1000_Genomes-1240K_haploid_pulldown
/modern/2016_Mallick_SGDP1240K_diploid_pulldown
/modern/2014_Lazaridis_HOmodern
/modern/2016_Lazaridis_HOmodern
/modern/2019_Flegontov_HO_NewSiberian
/modern/2018_Lipson_SEA

### Unpublished, no year:
/modern/Eurasia_newHO_Choongwon  
/modern/Mali_Dogon_Hiba

Janno-files and other files should follow the same structure as above, with year_month_day subfolders for genotype data.

**Important: Individuals are unique in each dataset (no duplicates across datasets).**


## Janno-Format:
we should make a script, which will take an IND file as input and output an annot file from Pandora. This would be partial, as several analyses results need to be added (Sex, haplogroups etc).???

In general, we allow N/A in janno-files in fields for which the analyses hasn’t yet been made. Ideally, all published projects should have the least number of N/As possible. For modern data several fields will be filled as N/A as well.

**format: Tab-separated, with a header line.**

Columns:  
- Individual_ID (from Pandora, in most cases Individual, but can also be Sample or Library depending on the granularity of the project)
- Collection_ID  
- Archaeological_ID  
- Skeletal_Element  
- Country  
- Location  
- Site  
- Latitude  
- Longitude  
- Average_Date (0 for modern, **calBP always!**)  
- Date_Earlier (calBP)  
- Date_Later (calBP)  
- Date_Type (C14 vs. contextual)  
- No_of_Libraries  
- Data_Type (SG or 1240K)
- Genotype_Ploidy   
- Group_name (Eisenmann rule + underscore flags, e.g. to annotate relatives or outliers)  
- Genetic_Sex (F, M, U)  
- Nr_autosomal_SNPs  
- Coverage_1240K (N/A for modern)  
- MT_haplogroup (can be N/A)  
- Y_haplogroup (can be N/A)  
- %endogenous (best library)  
- UDG (minus, half, plus, or combinations thereof in case multiple libraries were merged)  
- Library_Built  (ds, ss)
- Damage (for the majority shotgun library)  
- Xcontam if male for captured library  
- Xcontam stderr  
- mtContam  
- mtContam_stderr  
- Primary_Contact (e.g. project leader or first author)  
- Publication_status (published or unpublished)  
- Note  

# PHGv2
Practical Haplotype Graph from Katie Jordon with 472 accessions aligned to Wheat CS RefSeq v2.1

The PHG database was created using PHG v0.35 software then updated to PHG v0.40 using Liquibase plugin.
The PHG database was used to impute genotypes from 9K and 90K Illumina to high density (2.9M markers).

* [Align Illumina Infinium data to Reference](https://github.com/TriticeaeToolbox/PHGv2/blob/main/align2Genome)
* [Imputation protocol](https://github.com/TriticeaeToolbox/PHGv2/tree/main/imputation)
* [Testing Imputation accuracy](https://github.com/TriticeaeToolbox/PHGv2/blob/main/accuracy/PHG_accuracy_v2.pdf) 
* [Imputation accuracy by market class](https://github.com/TriticeaeToolbox/PHGv2/tree/main/cluster-snprelate)
* [Breedbase Integration using wizard](https://wheat.triticeaetoolbox.org/breeders/search)
  - requires logon account (available to public)
  - Select genotyping protocol then genotyping project. If the project has been imputed then expand section "Imputed Genotype Data available", then select "Download File"
* [Breedbase Integration using FTP site](https://files.triticeaetoolbox.org/)
  - look for section labeled "Imputed Protocols"
* [Imputation on demand from PHG](https://github.com/TriticeaeToolbox/PHGv2/tree/main/imputation-precomputed/README.md)
* [BrAPI access to PHG](https://bitbucket.org/bucklerlab/phg_webktor_service/src/master/)
  - docker container for accessing genotype information through Breeding API

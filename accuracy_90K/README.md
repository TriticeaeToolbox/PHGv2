<h2>Accuracy checks for imputation</h2>

# Accuracy for different protocols
Compare imputed genotypes with the genotypes from 2019_hapmap protocol. The "imputation accuracy" is the comparison between the PHG imputed genotypes and the 2019_hapmap data genotypes.

**accessions in the PHG** - compare the imputed genotypes to the genotypes in the 2019_hapmap protocol for accessions that are in the PHG database. These accuracies are high because the haplotypes are in the PHG.
  
| Low density Protocol | accessions | imputation accuracy |
|----------|-------------------|----------------|
| 90K      |      80           | 95%          |
| 9K       |      64           | 94%          |  

**accessions not in the PHG** - compare the imputed genotypes to the genotypes in the 2019_hapmap protocol for accessions that that are not in the PHG database. I expect this accuracy to be lower because these accessions contain haplotypes that are not in the PHG.
 
| Low density Protocol | accessions | imputation accuracy | 
|----------|-------------------|----------------|
| 90K      |     54     | 88%        |
| 9K       |     48     | 88%        |
 
**accessions in the PHG PCA** - merge inPHG accessions with PHG accessions then PCA. The clusters are well defined but seperate

![PCA in PHG](https://github.com/TriticeaeToolbox/PHGv2/blob/main/accuracy_90K/images/snprelate-pca-90K-inPHG.png)

**accessions in the PHG IBS Cmdscale** - MDS analysis shows the same clusters

![PCA in PHG](https://github.com/TriticeaeToolbox/PHGv2/blob/main/accuracy_90K/images/snprelate-90K-inPHG.png)

**nearest genetic distance for each accession** - Look at each accession from 90K inPHG and finding the nearest accession in PHG.

**accession not in the PHG PCA** - merge notinPHG accessions with PHG accessions then PCA. The clusters for notinPHG are a little more spread out

![PCA in PHG](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-snprelate/images/snprelate-pca-90K-notinPHG.png)

**accessions not in the PHG Cmdscale** - MDS analysis show the same clusters

![PCA in PHG](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-snprelate/images/snprelate-90K-notinPHG.png)

**nearest genetic distance for each accession** - For each accession from 90K notinPHG and finding the nearest accession in PHG. No correlation with genetic distance and accuracy

**percentage match to PHG for each accession** - For each accession from 90K find percentage match to any accession in PHG. If there is a close match to something in PHG I expect the imputation accuracy to be high.

![Imputed Accuracy vs PHG match](https://github.com/TriticeaeToolbox/PHGv2/blob/main/accuracy/images/accuracyVsmatch.png)




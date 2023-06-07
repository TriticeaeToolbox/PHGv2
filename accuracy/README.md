<h2>Accuracy checks for imputation</h2>

# Accuracy for different protocols
Compare imputed genotypes with the genotypes from 2019_hapmap protocol. The "accuracy common markers" is the comparison done using only the markers common between the low density protocol and the 2019_hapmap protocol. The "accuracy all markers" compares the full 2.9M markers.

**accessions in the PHG** - compare the imputed genotypes to the genotypes in the 2019_hapmap protocol
  
| Low density Protocol | common accessions | accuracy common markers | accuracy all markers |
|----------|-------------------|----------------|-------------|
| 90K      |      80           | 94%          |   93%     |
| 9K       |      64           | 93%          |   92%     |

**accessions not in the PHG** - compare the imputed genotypes to the genotypes in the 2019_hapmap protocol
 
| Low density Protocol | common accessions | accuracy common markers | accuracy all markers |
|----------|-------------------|----------------|-------------|
| 90K      |     54     | 72%        |        |
| 9K       |     48     | 70%        |        |
 
**accessions in the PHG PCA** - merge inPHG accessions with PHG accessions then PCA. The clusters are well defined but seperate

![PCA in PHG](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-snprelate/images/snprelate-pca-90K-inPHG.png)

**accessions in the PHG IBS Cmdscale** - MDS analysis shows the same clusters

![PCA in PHG](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-snprelate/images/snprelate-90K-inPHG.png)

**nearest genetic distance for each accession** - Look at each accession from 90K inPHG and finding the nearest accession in PHG. Almost all accessions are closest to "Wendy", so this does not explain differences in accuracy

**accession not in the PHG PCA** - merge notinPHG accessions with PHG accessions then PCA. The clusters for notinPHG are a little more spread out

![PCA in PHG](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-snprelate/images/snprelate-pca-90K-notinPHG.png)

**accessions not in the PHG Cmdscale** - MDS analysis show the same clusters

![PCA in PHG](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-snprelate/images/snprelate-90K-notinPHG.png)

**nearest genetic distance for each accession** - Look at each accession from 90K notinPHG and finding the nearest accession in PHG. No correlation with genetic distance and accuracy




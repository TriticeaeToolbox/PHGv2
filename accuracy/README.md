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
 
![kmeans](https://github.com/TriticeaeToolbox/PHGv2/blob/main/accuracy/images/snprelate-histogram-bymarker.png)

![kmeans](https://github.com/TriticeaeToolbox/PHGv2/blob/main/accuracy/images/snprelate-ibs-mds-population.png)

![kmeans](https://github.com/TriticeaeToolbox/PHGv2/blob/main/accuracy/images/snprelate-ibs-mds-population-onlydup.png)

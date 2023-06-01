<h2>Accuracy checks for imputation</h2>

# Accuracy for different protocols
Compare imputed genotypes with the genotypes from 2019_hapmap protocol. The "accuracy common markers" is the comparison done using only the markers common between the low density protocol and the 2019_hapmap protocol. The "accuracy all markers" compares the full 2.9M markers.

| Low density Protocol | common accessions | accuracy common markers | accuracy all markers |
|----------|-------------------|----------------|-------------|
| 90K      |      80           | 93.6%          |             |
| 9K       |                   | 93.6%          |             |

<li> for imputed accessions that were used in creating the PHG, compare the imputed genotypes to the genotypes from those used to create the PHG
<li> for imputed accessions not contained in the PHG, compare the imputed genotypes to the genotypes in the 2019_hapmap protocol

![kmeans](https://github.com/TriticeaeToolbox/PHGv2/blob/main/accuracy/images/snprelate-histogram-bymarker.png)

![kmeans](https://github.com/TriticeaeToolbox/PHGv2/blob/main/accuracy/images/snprelate-ibs-mds-population.png)

![kmeans](https://github.com/TriticeaeToolbox/PHGv2/blob/main/accuracy/images/snprelate-ibs-mds-population-onlydup.png)

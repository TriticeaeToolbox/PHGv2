<h2>SNPRelate IBS then MDS</h2>
<li>SNPRelate R package using
<li>snpgdsIBS: Identity-By-State (IBS) - calculate the fraction of identity by state for each pair of samples
<li>cmdscale: Classical Multidementional Scaling, also known as principal coordinates analysis
<br><br>
combined PHG472 and 2019_hapmap, both data sets are filtered before merging with maf < 0.5 and missing > 50% removed

cluster data without market class
![kmeans](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-snprelate/images/snprelate-exomeseq-ibs-mds.png)

cluster data using market class
![MDS](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-snprelate/images/snprelate-ibs-mds-marketclass-with-legend.png)

cluster data using PC1 and PC2
![PCA](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-snprelate/images/snprelate-2019_hapmap-pca.jpg)

for better resolution look at the genotype data sets indipendintly<br>
PHG470<br>

![IBS MDS](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-snprelate/images/snprelate-phg470-ibs-mds-all.png)

![PHG470 market class](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-snprelate/images/snprelate-phg470-ibs-mds-marketclass.png)

2019_hapmap<br>

![IBS MDS]((https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-snprelate/images/snprelate-2019_hapmap-ibs-mds-all.png)

![PHG470 market class](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-snprelate/images/snprelate-2019_hapmap-ibs-mds-marketclass.png")

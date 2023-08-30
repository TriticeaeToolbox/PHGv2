# cluster population

merge populations (90K, HQ_EC, 2019_hapmap) with PHGv2 then cluster results to show differences in populations

First look at the 13 accessions from Katie (HQ_EC). These are closely related to PHGv2. The first image is PCA. The second image is IBS cmsscale

![PCA1](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-snprelate3/images/snprelate-pca-HQEC.png)

![CMD1](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-snprelate3/images/snprelate-cmdscale-HQEC.png)

Next look at 2019_hapmap accessions. There are 200 accession accessions that are the same between 2019_hapmap and PHGv2. The PCA clustering show differences in PCA3 and PCA4. The cmdscale(ibs) also shows accessions different then in PHGv2. It appears that some of the accessions in 2019_hapmap are more genetically different then the PHGv2 population

![PCA2](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-snprelate3/images/snprelate-pca-2019hapmap.png)

![PCA3](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-snprelate3/images/snprelate-pcapairs-2019hapmap.png)

![CMD2](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-snprelate3/images/snprelate-cmdscale-2019hapmap.png)

Finally look at the 90K accessions. There are 125 90K accessions in the 2019_HapMap. These are divided into two groups in PHGv2 and notin PHGv2. Another way of looking at the 90K data is to cluster it with 2019_hapmap as shown in 3rd figure. The clustering analysis shows that the 90K data is different than the Exome Capture (PHGv2 and 2019_HapMap) data. I believe the difference can be attributed to both errors in mapping the 90K to RefSeq_v2 and converting it from the Illumina A_allele/B_allele format.

![PCA4](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-snprelate3/images/snprelate-pca-90KinPHG.png)
![PCA5](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-snprelate3/images/snprelate-pca-90KnotinPHG.png)
![PCA6](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-snprelate3/images/snprelate-pca-90Kin2019hapmapb.png)

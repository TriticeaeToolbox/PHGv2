# cluster population

merge populations (90K, HQEC, 2019_hapmap) with PHG470 then cluster results to show differences in poplulations

first look at the 13 accessions from Katie (HQ_EC). These are closely related to PHG470. The first imagage is PCA. The second image is IBS cmsscale

![PCA1](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-snprelate/images/snprelate-pca-HQEC.png)

![CMD1](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-snprelate/images/snprelate-cmdscale-HQEC.png)

next look at hapmap_2019 accessions. These are clearly related but not identical to PHG470. You can see a pattern that is produced from over 100 accessions that are identical but don't cluster together. It could be differences in
- protocol
- liftover to RefSeqV2
- the accessions themselves

![PCA2](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-snprelate/images/snprelate-pca-2019hapmap.png)

![CMD2](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-snprelate/images/snprelate-cmdscale-2019hapmap.png)


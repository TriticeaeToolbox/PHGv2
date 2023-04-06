# PCA to reduce dimension then K-means clustering

## combined 2019_hapmap and PHG470 datasets

1. Use Liftover to convert 2019_hapmap to RefSeq V2
2. combines PHG470 (5M markers) and 2019_hapmap (7M markers). The overlap by location with same ref allele is 1.5M markers.
3. ./plink2 --vcf /data/wheat/liftover/phg_merged_new.vcf --double-id --allow-extra-chr --set-missing-var-ids @:# --pca 20 -out PHG_merged

Cluster analysis show 3 clusters. A table showing clusters for each population (2019_hapmap and PHG) show populations are similar.

| Cluster | 2019_hapmap | PHG470 |  | Cluster | 2019 hapmap | PHG470 |
|---------|-------------|--------|  |---------|-------------|--------|
| 1       | 127         | 212    |  | 1       | 16          | 16     |
| 2       | 156         | 116    |  | 2       | 9           | 11     |
| 3       | 54          | 131    |  | 3       | 152         | 197    |
				    | 4       | 104        | 95     |
				    | 5       | 56          | 140    |

Analysis by market class. A table showing clusters for each market class shows
1. PHG represents each market class
2. Hard vs Soft have small differences in cluster
3. Spring vs Winter have small differences in cluster


| Cluster |  Hard | Soft | unknown |
|---------|-------|------|---------|
| 1       |  0    | 1    | 45      |
| 2       |  212  | 86   | 414     |
| 3       |  0    | 28   | 10      |

| Cluster | Spring | Winter | unknown |
| --------|--------|--------|---------|
| 1       |  34    | 2      | 10      |
| 2       |  132   | 244    | 335     |
| 3       |  0     | 34     | 14      |

| Cluster |  Red   | White | unknown |
|---------|--------|-------|---------|
| 1       |  1     | 0     | 45      |
| 2       |  224   | 34    | 454     |
| 3       |  17    | 0     | 21      |


![4 Clusters](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-merged/images/PHG_merged.png)
![4 Clusters](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-merged/images/PHG_merged_text.png)

pairs plot of PCA

![pairs](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-merged/images/cluster_merged_ggpairs.png)

3D plotpoly

![3 Clusters](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-merged/images/phg_merged_3dclus.png)
![3 Clusters](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-merged/images/phg_merged_3dpop.png)

3D plotpoly by market class

![3 Clusters](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-merged/images/phg_merged_hardness.png)
![3 Clusters](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-merged/images/phg_merged_oolor.png)
![3 Clusters](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-merged/images/phg_merged_season.png)

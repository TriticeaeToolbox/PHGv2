# PCA to reduce dimension then K-means clustering

## combined 2019_hapmap and PHG470 datasets

1. Use Liftover to convert 2019_hapmap to RefSeq V2
2. combines PHG470 (5M markers) and 2019_hapmap (7M markers). The overlap by location with same ref allele is 1.5M markers.
3. ./plink2 --vcf /data/wheat/liftover/phg_merged_new.vcf --double-id --allow-extra-chr --set-missing-var-ids @:# --pca 20 -out PHG_merged

Cluster analysis show 3 clusters. A table showing clusters for each population (2019_hapmap and PHG) show populations are similar.

| Cluster | 2019_hapmap | PHG470 |
|---------|-------------|--------|
| 1       | 127         | 212    | 
| 2       | 156         | 116    |
| 3       | 54          | 131    | 

| Cluster | 2019 hapmap | PHG470 |
|---------|-------------|--------|
| 1       | 16          | 16     |
| 2       | 9           | 11     |
| 3       | 152         | 197    |
| 4       | 104         | 95     |
| 5       | 56          | 140    |

Analysis by market class. A table showing clusters for each market class shows
1. PHG represents each market class
2. Hard vs Soft have small differences in cluster
3. Spring vs Winter have small differences in cluster


| Cluster |  Hard | Soft | unknown |
|---------|-------|------|---------|
| 1       |  130  | 86   | 123     |
| 2       |  84   | 30   | 158     |
| 3       |  7    | 9    | 169     |

| Cluster |  Hard | Soft | unknown |
|---------|-------|------|---------|
| 1       |  0    | 23   | 9       |
| 2       |  0    | 16   | 4       |
| 3       |  127  | 69   | 153     |
| 4       |  78   | 3    | 118     |
| 5       |  16   | 14   | 116     |

| Cluster | Hard  | Soft | unknown |
|---------|-------|------|---------|
| 1       |  0    | 28   |  10     |
| 2       |  7    | 7    |  117    |
| 3       |  0    | 1    |  45     |
| 4       |  12   | 78   |  122    |
| 5       |  20   | 0    |  43     |
| 6       |  11   | 7    |  8      |
| 7       |  171  | 4    |  105    |


| Cluster | Spring | Winter | unknown |
| --------|--------|--------|---------|
| 1       |  8     | 224    | 106     |
| 2       |  121   | 34     | 117     |
| 3       |  38    | 22     | 125     |

| Cluster | Spring | Winter | unknown |
| --------|--------|--------|---------|
| 1       |  0     | 284    | 4       |
| 2       |  0     | 18     | 2       |
| 3       |  23    | 198    | 127     |
| 4       |  107   | 3      | 89      |
| 5       |  37    | 33     | 126     |

| Cluster | Spring | Winter | unknown |
| --------|--------|--------|---------|
| 1       |  0     | 34     | 4       |
| 2       |  3     | 16     | 112     |
| 3       |  34    | 2      | 10      |
| 4       |  18    | 89     | 105     |
| 5       |  14    | 6      | 43      |
| 6       |  3     | 17     | 6       |
| 7       |  95    | 116    | 68      |


| Cluster |  Red   | White | unknown |
|---------|--------|-------|---------|
| 1       |  156   | 26    | 156     |
| 2       |  99    | 4     | 169     |
| 3       |  9     | 5     | 171     |

| Cluster |  Red   | White | unknown |
|---------|--------|-------|---------|
| 1       |  156   | 26    | 156     |
| 2       |  99    | 4     | 169     |
| 3       |  9     | 5     | 171     |
| 4       |  99    | 4     | 169     |
| 5       |  9     | 5     | 171     |

![3 Clusters](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-merged/images/PHG_merged_3c.png)
![5 Clusters](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-merged/images/PHG_merged_5c.png)
![7 Clusters](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-merged/images/PHG_merged_7c.png)

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

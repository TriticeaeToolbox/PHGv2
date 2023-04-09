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
| 1       | 46          | 0      |
| 2       | 220         | 380    |
| 3       | 51          | 66     |
| 4       | 9           | 11     |
| 5       | 11          | 2      |

| Cluster | 2019 hapmap | PHG470 |
|---------|-------------|--------|
| 1       | 42          | 223    |
| 2       | 78          | 81     |
| 3       | 112         | 88     |
| 4       | 46          | 0      |
| 5       | 14          | 8      |
| 6       | 45          | 59     |

| Cluster | 2019 hapmap | PHG470 |
|---------|-------------|--------|
| 1       | 18          | 20     |
| 2       | 2           | 124    |
| 3       | 137         | 97     |
| 4       | 46          | 0      |
| 5       | 4           | 1      |
| 6       | 48          | 135    |
| 7       | 82          | 82     |

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

| Cluster |  Hard | Soft | unknown |
|---------|-------|------|---------|
| 1       |  84   | 37   | 144     |
| 2       |  51   | 19   | 89      |
| 3       |  507  | 42   | 108     |
| 4       |  7    | 7    | 32      |
| 5       |  3    | 2    | 17      |
| 6       |  26   | 18   | 60      |

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
| 1       |  113   | 14    | 212     |
| 2       |  96    | 9     | 167     |
| 3       |  55    | 12    | 118     |

| Cluster |  Red   | White | unknown |
|---------|--------|-------|---------|
| 1       |  10    | 3     | 33      |
| 2       |  207   | 29    | 364     |
| 3       |  41    | 3     | 73      |
| 4       |  4     | 0     | 169     |
| 5       |  2     | 0     | 11      |

| Cluster |  Red   | White | unknown |
|---------|--------|-------|---------|
| 1       |  90    | 16    | 159     |
| 2       |  52    | 10    | 97      |
| 3       |  73    | 5     | 122     |
| 4       |  10    | 3     | 33      |
| 5       |  4     | 0     | 18      |
| 6       |  35    | 1     | 68      |

| Cluster |  Red   | White | unknown |
|---------|--------|-------|---------|
| 1       |  113   | 11    | 194     |
| 2       |  10    | 3     | 33      |
| 3       |  42    | 9     | 76      |
| 4       |  40    | 3     | 74      |
| 5       |  4     | 0     | 16      |
| 6       |  2     | 0     | 11      |
| 7       |  53    | 9     | 93      |

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

# PCA to reduce dimension then K-means clustering

## combined 2019_hapmap and PHG470 datasets

1. Use Liftover to convert 2019_hapmap to RefSeq V2
2. combines PHG470 (5M markers) and 2019_hapmap (7M markers). The overlap by location with same ref allele is 1.5M markers.
3. ./plink2 --vcf /data/wheat/liftover/phg_merged_new.vcf --double-id --allow-extra-chr --set-missing-var-ids @:# --pca 20 -out PHG_merged

Cluster analysis show 3 clusters. A table showing clusters for each population (2019_hapmap and PHG) show population is similar.

| Cluster | 2019_hapmap | PHG470 |
| 1       | 151         | 97     |
| 2       | 18          | 20     |
| 3       | 168         | 342    |

Analysis by market class. A table showing clusters for each market class show PHG represents each market class

| Market class | Hard | Soft | unknown |
| 1            | 36   | 46   | 166     |
| 2            | 5    | 9    | 24      |
| 3            | 99   | 58   | 353     |


![4 Clusters](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-merged/images/PHG_merged.png)
![4 Clusters](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-merged/images/PHG_merged_text.png)

3D plotpoly

![3 Clusters](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-merged/images/phg_merged_3dclus.png)
![3 Clusters](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-merged/images/phg_merged_3dpop.png)

3D plotpoly by market class

![3 Clusters](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-merged/images/phg_merged_hardness.png)
![3 Clusters](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-merged/images/phg_merged_oolor.png)
![3 Clusters](https://github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-merged/images/phg_merged_season.png)

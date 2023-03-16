# PCA to reduce dimension then kmeans clustering

## combind 2019_hapmap and PHG470 datasets

This dataset combines PHG470 (5M markers) and 2019_hapmap (7M markers). The overlap by location with same ref allele is 768K markers.

./plink2 --vcf /data/wheat/liftover/phg_merged_new.vcf --double-id --allow-extra-chr --set-missing-var-ids @:# --pca 20 -out PHG_merged

[4 Clusters](github.com/TriticeaeToolbox/PHGv2/blob/main/cluster-merged/images/PHG_merged.pdf)

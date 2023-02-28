PCA to reduce dimension then kmeans clustering

use vcftools to remove outliers (diploid species)
vcftools --remove-indv TA10171 --remove-indv TA10171-DSEE --remove-indv TA10187 --remove-indv TA1615 --remove-indv TA1642 --remove-indv TA1662 --remove-indv TA1693 --remove-indv TA1718 --remove-indv DV92 --remove-indv G3116 --remove-indv G20_0172_CF9819 --vcf /data/phg/PHG470v2-31_db.maf_seg.vcf --out /data/phg/PHG470v2-31_db.maf_seg_filtered --recode

usig plink2 for PCA analysis

./plink2 --vcf /data/phg/PHG470v2-31_db.maf_seg_filtered.vcf --double-id --allow-extra-chr --set-missing-var-ids @:# --pca 20 -out PHG470v2f

PHGv2-plink2-pca.R
PHGv2-cluster.R

use SNPRelate for PCA analysis
PHGv2-snprelate-pca.R

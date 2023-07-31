# 2019_hapmap genotype protocol

These genotypes were aligned to RefSeqV2 using liftover
Filter the genotypes aligned to RefSeqV2 by comparing it to the VCF file from PHGv2.

1. Compare markers and accessions in 2019_hapmap with the genotypes in PHG470.
 - compare-2019_hapmap-phg470.pl
 - remove markers with NCC < 30, this is the number oaf accessions scored out of 300
 - remove markers that do not have the same location and ref allele as  PHG470 genotypes. This was larger than expected. Even though liftover found corresponding SNPs in RefSeqV2 they do not always match the PHG470 exome SNPs
 - remove markers where genotypes do not match PHG470 < 80% (this removed about 20,000 markers)

2. filter 2019_hapmap file
 - filter-bymarker.pl

3. merge 2019_hapmap_filtered.vcf with PHG470v2-31_db.maf_seg_filtered.vcf
 - merge-simp.pl
 

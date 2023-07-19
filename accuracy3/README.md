# Imputation accuracy from 2019_hapmap by exon capture protocal.

Impute using 2019_hapmap genotype to see if this gets better accuracy 

Imputing the 90K protocol introduces possible errors from 
1. mapping the marker locations to RefSeq_V2
2. converting from Illumina AB to ATCG
3. errors from markers that map to multiple locations

Imputing from 2019_hapmap protocol should give better accuracy because the protocol is the same as was used to create the PHG. To use the 2019_hapmap protocol I down sampled the data in 2 ways.
1. pick subset of markers that are at same location of 90K markers "2019_hapmap_90K"
2. pick subset of markers by keeping every 100th marker "2019_hapmap_d100"
These two dataset where imputed using the PHG

To test the accuracy of imputation I compared the imputed data to original dataset in 2 ways
1. compare subset of markers that are at same location of 90K markers "common"
2. compare subset of markers using every 100th marker "d100"

Results
| Trial | accuracy test | accuracy | accessions | markers |
|-------|----------|------------|---------|----------|
| 2019_hapmap_90K  | common | 86% (72%/93%) | 108/191 | 11,107 |
| 2019_hapmap_90K  | d100   | 89% (83%/92%) | 108/191 | 14,668 |
| 2019_hapmap_d100 | common | 85% (72%/93%) | 108/191 | 11,107 |
| 2019_hapmap_d100 | d100   | 89% (83%/93%) | 108/191 | 14,728 |

Conclusion:
Imputation accuracy is better using the 100th marker sampling method



# Imputation accuracy from 2019_hapmap by exon capture protocal.

Imputing from 2019_hapmap protocol should give better accuracy because the protocol is the same as was used to create the PHG. The filtered data has markers removed that do not match PHG470 by 
1. markers where NCC > 30 (Number of no-called accessions)
2. markers that do not match PHG470 by location and ref allele
3. markers where genotypes matches with  PHG470 < 80%

Results
| Trial | accuracy test | accuracy | accessions | markers |
|-------|----------|------------|---------|----------|
| Infinium 9K  |  |  | |
| Infinium 90K |  |  | |
| 2019_hapmap_filtered  | 92% (86%/95%) | 108/191 | 4,345 |

Conclusion:



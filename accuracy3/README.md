# Imputation accuracy of 2019_hapmap (exon capture protocal)

## Compared imputed genotypes to PHG470, VCF file of genotypes used to create PHG

Imputing from 2019_hapmap protocol should give high accuracy because the protocol is the same as was used to create the PHG. The input for imputation is the 2019_hapmap that has been filtered to remove markers as follows
1. markers where NCC > 30 (Number of no-called accessions)
2. markers that do not match PHG470 by location and Ref allele
3. markers where genotypes matches with  PHG470 < 80%

The imputation accuracy was calculated on every 100th (d100) and every 10th (d100) marker to reduce computatio time

Results
| Trial | test | accuracy | accessions | markers |
|-------|------|----------|------------|---------|
| 2019_hapmap_filtered  | d100 | 92% (86%/95%) | 108/191 | 4,345 |
| 2019_hapmap_filtered  | d10  | 92% (87%/95%) | 108/191 | 43,452 |

Lowest imputation accuracy
| Accn | in PHG | accuracy | notes |
|------|--------|----------|-------|
| G3116 | no    | 64%      | Wild diploid |
| DV92  | no    | 66%      | Cultivated diploid |
| TA1718 | yes  | 75%      | Aegilops tauschii  |
| TA1615 | yes  | 77%      | Aegilops tauschii  |
| TA1662 | yes  | 78%      | Aegilops tauschii  |
| IL07-20728 | yes | 79%   |                    |
| DAYN | yes    | 80%      |                    |
| W7984 | no    | 81%      | Synthetic          |
| M6    | no    | 81%      |                    |
| 26R61 | no    | 81%      |                    |

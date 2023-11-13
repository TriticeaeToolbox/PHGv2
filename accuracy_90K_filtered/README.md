# Remove markers and accessions where the raw 90K (unimputed) data does not match 2019_hapmap

Some accessions in 90K may be missidentified and some markers may be mapped to the wrong location. Look at improved accuracy by remove the accessions and markers with less than 90% imputation accuracy. Use a set of 130 accessions that are in both 90K and 2019_hapmap
compare imputation accuracy for markers in 90K

1. not filtered or corrected, (strand, d30)
2. complement genotypes for markers when that improves the accuracy matching 2019_hapma (strand2, d30)
3. remove "bad accessions" - accessions with < 90% accuracy when compared with raw data (d30)
4. remove "bad markers" - markers with < 90% accuracy when compared with raw data

  
| test | imputation accuracy | not in PHG /in PHG | markers | accessions|
|------| --------------------| -------------|---------| ----------|
| uncorrected                | 92%   | 86/94 | 14484 | 125 |
| aligned to 2019_hapmap     | 92%   | 87/95 | 14484 | 125 |
| remove bad accn            | 92%   | 87/96 | 14484 | 104 |
| remove bad marker          | 99%   | 95/98 |  9839 | 125 |



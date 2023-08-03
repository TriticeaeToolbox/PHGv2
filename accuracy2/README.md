# Remove markers and accessions where the raw 90K (unimputed) data does not match 2019_hapmap

Some accessions in 90K may be missidentified and some markers may be mapped to the wrong location. Look at improved accuracy by remove the accessions and markers with less than 90% imputation accuracy. Use a set of 130 accessions that are in both 90K and 2019_hapmap
compare imputation accuracy for markers in 90K

1. strand
2. complement genotypes for markers when that improves the accuracy matching 2019_hapma (strand2)
3. remove "bad accessions" - accessions with < 90% accuracy when comparing raw data
4. filtered (d30)

  
| test | imputation accuracy | not in PHG /in PHG | markers | accessions|
|------| --------------------| -------------|---------| ----------|
| uncorrected                | 92%   | 86/94 | 14484 | 125 |
| aligned to 2019_hapmap     | 93%   | 87/95 | 14484 | 125 |
| remove bad accn            | 93%   | 88/96 | 14484 | 104 |
| filtered (d30)             | 93%   | 87/95 | 14484 | 125 |



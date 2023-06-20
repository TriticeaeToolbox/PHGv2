# Look at the improvement of removing markers and accessions where the raw 90K (unimputed) data does not match 2019_hapmap

Use a set of 130 accessions that are in both 90K and 2019_hapmap

1. complement genotypes for markers when that improves the accuracy matching 2019_hapmap
2. remove "bad accessions" - accessions with < 90% accuracy when comparing raw data
3. remove "bad markers" - markers with < 90% accuracy when comparing raw data
4. remove "bad markers and bad accessions"
  
| test | imputation accuracy | notin/in PHG | markers | accessions|
|------| --------------------| -------------|---------| ----------|
| uncorrected | 84.2% | 82.9/89.0 | 11107 | 130 |
| aligned to 2019_hapmap | 86.4% | 85.1/91.5  | 11107 | 130                                 |
| remove bad accn | 87.3% |    | 11107 | 104 |
| remove bad markers | 87.9% | | 9673 | 130                       |
| remove bad accn & markers | 88.8% | 87.3/98.2 | 9673 | 104      |

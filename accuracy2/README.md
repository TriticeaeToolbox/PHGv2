# Look at the improvement of removing markers and accessions where the raw 90K (unimputed) data does not match 2019_hapmap

- using a set of 130 accessions that are in both 90K and 2019_hapmap
- remove "bad accessions" - accessions with < 90% accuracy when comparing raw data
- remove "bad markers" - markers with < 90% accuracy when comparing raw data

| test | imputation accuracy | notin/in PHG | markers | accessions|
|------| --------------------| -------------|---------| ----------|
| regular | 86.4% | | 11107 | 130                                 |
| remove bad accn | 87.3% | | 11107 | 104 |
| remove bad markers | 87.9% | | 9673 | 130                       |
| remove bad accn & markers | 88.8% | 87.3/98.2 | 9673 | 104      |

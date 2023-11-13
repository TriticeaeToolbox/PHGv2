# List of scripts used in PHG imputation

1. fix PHG database before upgrade
   - imputation/fix-phg-database.sh

2. Upgrade PHG database from 0.35 to 0.40
   - imputation/upgrade-phg-database.sh
     
3. Align Illumina Infinium data to reference
   - align2Genome/align_90K.php
   - align2Genome/correct_genotypes_90K.pl

4. Run imputation for VCF file
   - imputation/run-imputation.sh

5. convert 2019_hapmap protocol to RefSeqV2
   - liftover/README

6. accuracy by accession
   - accuracy/check-overlap-accn.pl

7. accuracy by marker
   - accuracy/check-overlap-markers.pl

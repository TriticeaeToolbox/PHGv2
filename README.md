# PHGv2
Practical Haplotype Graph from Katie Jordon with 473 accessions aligned to CSv2.1

The PHG database was created using PHG v0.17 software. 
The PHG database was updated to PHG v0.40 using Liquibase plugin
For 90K protocol the input VCF was mapped by chromosome and position to RefSeq v2.1 using BLAST
For 90K protocol the input VCF was aligned by changing the Ref, Alt, and GT fields to match RefSeq v2.1
A VCF file was generated from the PHG for the 473 accesions used to create the PHG and this file was used to
test imputation accuracy for those accessions.

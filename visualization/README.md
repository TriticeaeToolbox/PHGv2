Visualization of PHG

1. JBrowse

https://files.triticeaetoolbox.org/jbrowse/?data=phg

JBrowse shows reference sequence and gene annotation tracks. It can also display the SNPs from the accessions used to create the PHG "SNPs from PHG472". The PHG can generate a VCF file of the haplotypes for a specified method and path. An example of this is shown in the "Haplotypes from 90K" track. This tracks show the haplotypes for 120 accessions that are in both 90K and PHG472. The size and format of this file will cause JBrowse memory crash, so I have shown a truncated version of this file.

2. DivBrowse

DivBrowse is a new tool designed to visualize large VCF and GFF files. It uses Zarr compression so it can quickly retrieve both a subset of accessions and specific locations from a large VCF

3. rPHG, Shiny Server

The combination of rPHG package and Shiny Server makes it easy to extract small sections from the PHG database. The limitation of this environment is that the entire PHG database has to be loaded into memory. For the wheat PHG the memory requirements prohibit it from working.

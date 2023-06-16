Align Illumina 9K and 90K data to genome assembly

Converting Illumina AB into VCF
Illumina data loaded into T3 database as Ref = A_allele, Alt = B_allele.
The Illumina 90K data can be combined with similar array data and analyzed with website tools but can not be used in PHG, Beagle, or merged with GBS data because the format is not aligned (strand and orientation) with reference genome.

1. use samtools faidx with the iwgsc2.1 assembly to get Ref allele
2. compare Ref allele to A_allele and B_allele
3. correct genotype data (compliment if necessary) to match exome capture protocol


| match	                | Ref and Alt changes             | genotypes changes |
|-----------------------|---------------------------------|-------------------|
| Ref = A_allele        | unchanged                       | unchanged  |
| Ref = B_allele        | Ref = B_allele, Alt = A_allele  | compliment |
| Ref = comp(A_allele)	| Ref = comp(A_allele) Alt = comp(B_allele) | unchanged  |
| Ref = comp(B_allele)	| Ref = comp(B_allele) Alt = comp(A_allele) | compliment |

Compliment genotypes
| original	| converted |
|-----------|-----------|
| 0/0       |	1/1       |
| 0/1       |	0/1       |
| 1/1	      | 0/0       |
| ./.	      | ./.       |

https://www.illumina.com/documents/products/technotes/technote_topbot.pdf

**compare 90K to 2019_hapmap**

130 accessions and 13,828 of 21,473 markers in common

![by marker](https://github.com/TriticeaeToolbox/PHGv2/blob/main/accuracy/images/90Kvs2019hapmap-marker.png)

![by accession](https://github.com/TriticeaeToolbox/PHGv2/blob/main/accuracy/images/90Kvs2019hapmap-accn.png)


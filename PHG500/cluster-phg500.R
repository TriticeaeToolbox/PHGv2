#cluster accessions in PHG500

library("SNPRelate")
library("ggplot2")

vcf.fn <- "PHG500v2_db_seg.vcf"
snpgdsVCF2GDS(vcf.fn, "ccm_PHG500v2.gds",  method="biallelic.only")
genofile <- snpgdsOpen("ccm_PHG500v2.gds")

#first look at IBS
ibs <- snpgdsIBS(genofile, num.thread=4)
loc <- cmdscale(1 - ibs$ibs, eig=TRUE, k = 2)
x <- loc$points[, 1]; y <- loc$points[, 2]
pop <- append(rep("PHG470", 143), rep("CIMMYT", 25))
pop <- append(pop, rep("PHG470",330))
pop <- as.factor(pop)
popSym <- as.numeric(pop)
plot(x, y, xlab="", ylab="", col=pop, pch=popSym, main="cmdscale(ibs) PHG500")
legend("topleft", legend=levels(pop), text.col=1:nlevels(pop), pch=1:nlevels(pop))
dev.copy(png,"images/snprelate-phg500-ibs-mds-all.png"); dev.off()

#now look at PCA analysis
ccm_pca<-snpgdsPCA(genofile)
pca <- ccm_pca$eigenval[1:20]
res <- ccm_pca$eigenvec[, 1:20]
pca <- data.frame(sample.id = ccm_pca$sample.id, 
                  EV1 = ccm_pca$eigenvect[,1],
                  EV2 = ccm_pca$eigenvect[,2])
plot(pca$EV1, pca$EV2, main="PCA of PHG500")
pca2 <- pca
pca2 <- pca2[-113,] #remove TG20_0172_CF9819
pca2 <- pca2[-394,] #remove TA10171
pop <- append(rep("PHG470", 142), rep("CIMMYT", 25))
pop <- append(pop, rep("PHG470",330))

pop <- as.factor(pop)
popSym <- as.numeric(pop)
plot(pca2$EV1, pca2$EV2, main="PCA of PHG500")
plot(pca2$EV1, pca2$EV2, col=pop, pch=popSym, main="PCA of PHG500", xlim=c(-0.01,0.01), ylim=c(-0.01,0.01))
legend("topleft", legend=levels(pop), text.col=1:nlevels(pop), pch=1:nlevels(pop))
dev.copy(png,"images/snprelate-phg500-ibs-pca.png"); dev.off()

#compare populations HQ from Katie and PHG470

library("SNPRelate")

#this is done once because it can be large file
vcf.fn <- "HQ_EClines_PHGtesting_notin472-d10.vcf.merged" #includes duplicates
snpgdsVCF2GDS(vcf.fn, "ccm_HQ_EClines_merged-d10.gds",  method="biallelic.only")
genofile <- snpgdsOpen("ccm_HQ_EClines_merged-d10.gds")
pop <- append(rep("HQ_EC", 13), rep("PHGv2", 472))
pop <- as.factor(pop)
popSym <- as.numeric(pop)

#first look at PCA analysis
ccm_pca<-snpgdsPCA(genofile)
pca <- ccm_pca$eigenval[1:20]
res <- ccm_pca$eigenvec[, 1:20]
pca <- data.frame(sample.id = ccm_pca$sample.id,
                  EV1 = ccm_pca$eigenvect[,1],
                  EV2 = ccm_pca$eigenvect[,2])
plot(pca$EV1, pca$EV2, col=pop, pch=popSym, main="PCA HQ_EC vs PHG")
legend("bottomleft", legend=levels(pop), text.col=1:nlevels(pop), pch=1:nlevels(pop))

#sample.id N87 is an outlier have to remove it which.min(pca$EV1)
pca2 <- pca[-262,]
plot(pca2$EV1, pca2$EV2, col=pop, pch=popSym, main="PCA HQ_EC vs PHG")
legend("bottomleft", legend=levels(pop), text.col=1:nlevels(pop), pch=1:nlevels(pop))
dev.copy(png,"images/snprelate-pca-HQEC.png"); dev.off()

pc.percent <- ccm_pca$varprop*100
lbls <- paste("PC", 1:4, "\n", format(pc.percent[1:4], digits=2), "%", sep="")
pairs(ccm_pca$eigenvect[,1:4], col=pop, labels=lbls, main="PCA HQ_EC vs PHG")
dev.copy(png,"images/snprelate-pcapair-HQEC.png"); dev.off()

ibs <- snpgdsIBS(genofile, num.thread=4)
loc <- cmdscale(1 - ibs$ibs, eig=TRUE, k = 2)
x <- loc$points[, 1]; y <- loc$points[, 2]

plot(x, y, xlab="", ylab="", col=pop, pch=popSym, main="cmdscale(ibs) HQ_EC vs PHG")
legend("bottomleft", legend=levels(pop), text.col=1:nlevels(pop), pch=1:nlevels(pop))
dev.copy(png,"images/snprelate-cmdscale-HQEC.png"); dev.off()

#now do the same for 2019_hapmap
#this is done once because it can be large file
vcf.fn <- "2019_hapmap_d100.vcf.merged" #includes duplicates
#snpgdsVCF2GDS(vcf.fn, "ccm_2019_hapmap_merged-d100.gds",  method="biallelic.only")
#genofile <- snpgdsOpen("ccm_2019_hapmap_merged-d100.gds")
genofile <- snpgdsOpen("ccm_2019_hapmap_filtered_merged.gds")
pop <- append(rep("2019_hapmap", 337), rep("PHGv2", 472))
pop <- as.factor(pop)
popSym <- as.numeric(pop)

#first look at PCA analysis
ccm_pca<-snpgdsPCA(genofile)
pca <- ccm_pca$eigenval[1:20]
res <- ccm_pca$eigenvec[, 1:20]
pca <- data.frame(sample.id = ccm_pca$sample.id,
                  EV1 = ccm_pca$eigenvect[,1],
                  EV2 = ccm_pca$eigenvect[,2])
plot(pca$EV1, pca$EV2, col=pop, pch=popSym, main="PCA 2019_HapMap vs PHG")
legend("topleft", legend=levels(pop), text.col=1:nlevels(pop), pch=1:nlevels(pop))
dev.copy(png,"images/snprelate-pca-2019hapmap.png"); dev.off()

pc.percent <- ccm_pca$varprop*100
lbls <- paste("PC", 1:4, "\n", format(pc.percent[1:4], digits=2), "%", sep="")
pairs(ccm_pca$eigenvect[,1:4], col=pop, labels=lbls, main="PCA 2019_HapMap vs PHG")
dev.copy(png,"images/snprelate-pcapairs-2019hapmap.png"); dev.off()

ibs <- snpgdsIBS(genofile, num.thread=4)
loc <- cmdscale(1 - ibs$ibs, eig=TRUE, k = 2)
x <- loc$points[, 1]; y <- loc$points[, 2]

plot(x, y, xlab="", ylab="", col=pop, pch=popSym, main="cmdscale(ibs) 2019_HapMap vs PHG")
legend("bottomright", legend=levels(pop), text.col=1:nlevels(pop), pch=1:nlevels(pop))
dev.copy(png,"images/snprelate-cmdscale-2019hapmap.png"); dev.off()

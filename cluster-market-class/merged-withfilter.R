#IBS MDS analysis using SNPRelate

library("SNPRelate")
library("ggpubr")

vcf.fn <- "/data/wheat/liftover/2019_hapmap_all.vcf.merged2" #includes duplicates
snpgdsVCF2GDS(vcf.fn, "ccm_2019_hapmap_merged2.gds",  method="biallelic.only")
#this file has markers with missing data removed, contains about 1M markers
genofile <- openfn.gds("ccm_2019_hapmap_merged2.gds")

ibs <- snpgdsIBS(genofile, num.thread=4)
loc <- cmdscale(1 - ibs$ibs, eig=TRUE, k = 2)
x <- loc$points[, 1]; y <- loc$points[, 2]
plot(x, y)
dev.copy(png,"images/snprelate-exomeseq-ibs-mds.png"); dev.off()
text(x, y, labels=ibs$sample.id)
dev.copy(png,"images/snprelate-exomeseq-ibs-mds-withlegend.png"); dev.off()

ibsf <- snpgdsIBS(genofile, maf = 0.05, num.thread=4) # removes about 500K markers
locf <- cmdscale(1 - ibsf$ibs, eig=TRUE, k = 2)
x <- locf$points[, 1]; y <- locf$points[, 2]
plot(x, y)
dev.copy(png,"images/snprelate-exomeseq-ibs-mds-maf05.png"); dev.off()
text(x, y+.01, labels=ibsf$sample.id)
dev.copy(png,"images/snprelate-exomeseq-ibs-mds-maf05-withlegend.png"); dev.off()

mds.df <- as.data.frame(locf$points)
mds.df$sample.id <- ibsf$sample.id
colnames(mds.df) <- c("Dim1", "Dim2")
ggscatter(mds.df, x = "Dim1", y = "Dim2")

class1 <- read.table("accession-class-hapmap.txt", header = TRUE, sep = "\t")
class2 <- read.table("accession-class-phgv2.txt", header = TRUE, sep = "\t")
class <- rbind(class1, class2)
MC <- cbind(class$hardness, class$color, class$season)

MC <- paste0(class[,2],class[,3],class[,4])
MC <- as.factor(MC)
MCsym <- as.numeric(MC)

plot(x, y, pch=MCsym, col=MC)
legend("bottomleft", legend=levels(MC), text.col=1:nlevels(MC), pch=1:nlevels(MC))
#above plot is too crowded so remove unknown classes

locf <- loc$points[!grepl("unknown",MC),]
MCF <- MC[!grepl("unknown",MC)]
MCF <- droplevels(MCF)
MCF <- as.factor(MCF)
MCFsym <- as.numeric(MCF)
x <- locf[, 1]; y <- locf[, 2]

plot(x, y, pch=MCFsym, col=MCF)
dev.copy(png,"images/snprelate-ibs-mds-marketclass.png"); dev.off()
legend("bottomleft", legend=levels(MCF), text.col=1:nlevels(MCF), pch=1:nlevels(MCF))
dev.copy(png,"images/snprelate-ibs-mds-marketclass-with-legend.png"); dev.off()

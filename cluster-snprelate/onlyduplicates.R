#look at only duplicate accessions

library("SNPRelate")
library("ggpubr")

genofile <- openfn.gds("ccm_2019_hapmap_merged2.gds")
genofile <- openfn.gds("ccm_2019_hapmap_merged_maf05_mis50.gds")
ibs <- snpgdsIBS(genofile, num.thread=4)
loc <- cmdscale(1 - ibs$ibs, eig=TRUE, k = 2)
x <- loc$points[, 1]; y <- loc$points[, 2]
plot(x, y, xlab="", ylab="", main="cmdscale(IBS)")

mds.df <- as.data.frame(loc$points)
mds.df$sample.id <- ibs$sample.id
colnames(mds.df) <- c("Dim1", "Dim2", "Sample")
ggscatter(mds.df, x = "Dim1", y = "Dim2")

pop <- read.table("accessions-all.txt", header = TRUE, sep = "\t", stringsAsFactors = TRUE)
popGrp <- as.numeric(pop$group)
popSym <- as.numeric(popGrp)

locf <- loc$points[pop$duplicate,]       #filtered location list
popf <- pop$name[pop$duplicate]          #filtered group list 
popfGrp <- pop$group[pop$duplicate]
popfSym <- as.numeric(popfGrp)

plot(loc$points[,1], loc$points[,2], pch=popSym, col=popSym, xlab="", ylab="")
plot(locf[,1], locf[,2], pch=popfSym, col=popfSym, xlab="", ylab="", main="cmdscale(IBS) population")
legend("topleft", legend=levels(popfGrp), text.col=1:nlevels(popfGrp), pch=1:nlevels(popfGrp))
dev.copy(png,"images/snprelate-ibs-mds-population-onlydup.png"); dev.off()

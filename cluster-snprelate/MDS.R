# using /data/wheat/liftover/2019_hapmap_all.vcf.merged

library(tidyverse)
pca <- read.table("2019_hapmap_merged.eigenvec2", header = TRUE)
pca_transform <- as.data.frame(pca[,2:21])

library("SNPRelate")
vcf.fn <-"/data/wheat/liftover/2019_hapmap_all.vcf.merged"
snpgdsVCF2GDS(vcf.fn, "ccm_2019_hapmap_merged.gds",  method="biallelic.only")
genofile <- openfn.gds("ccm_2019_hapmap_merged.gds")
ccm_pca<-snpgdsPCA(genofile)

pca <- ccm_pca$eigenval[1:20]
pca_perc <- pca/sum(pca)*100
pve <- data.frame(PC = 1:20, pve = pca/sum(pca)*100)
a <- ggplot(pve, aes(PC, pve)) + geom_bar(stat = "identity")
a + ylab("Percentage variance explained") + theme_light()
ggsave("snprelate-2019_hapmap-var.jpg")

ibs <- snpgdsIBS(genofile)
loc <- cmdscale(1 - ibs$ibs, k = 2)
x <- loc[, 1]; y <- loc[, 2]

class1 <- read.table("accession-class-hapmap.txt", header = TRUE, sep = "\t")
class2 <- read.table("accession-class-phgv2.txt", header = TRUE, sep = "\t")
class <- rbind(class1, class2)


class$hardness <- as.factor(class$hardness)
class$color <- as.factor(class$color)
class$season <- as.factor(class$season)


jpeg("snprelate-2019_hapmap-cluster-hardness.jpg")
plot(x, y, col=class$hardness, xlab = "", ylab = "", main = "cmdscale(IBS Distance) hardness")
legend("topleft", legend=levels(class$hardness), text.col=1:nlevels(class$hardness))
dev.off()

jpeg("snprelate-2019_hapmap-cluster-color.jpg")
plot(x, y, col=class$color, xlab = "", ylab = "", main = "cmdscale(IBS Distance) color")
legend("topleft", legend=levels(class$color), text.col=1:nlevels(class$color))
dev.off()

jpeg("snprelate-2019_hapmap-cluster-season.jpg")
plot(x, y, col=class$season, xlab = "", ylab = "", main = "cmdscale(IBS Distance) season")
legend("topleft", legend=levels(class$season), text.col=1:nlevels(class$season))
dev.off()

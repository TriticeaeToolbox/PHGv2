# using /data/wheat/liftover/2019_hapmap_all.vcf.merged

library(tidyverse)
pca <- read.table("2019_hapmap_merged.eigenvec2", header = TRUE)
pca_transform <- as.data.frame(pca[,2:21])

library("SNPRelate")
library("ggplot2")

vcf.fn <- "/data/phg/TCAP90K_NAMparents_panel-strand.vcf.merged"
snpgdsVCF2GDS(vcf.fn, "ccm_TCAP90K_NAMparents_panel-strand.vcf.merged", method="biallelic.only")
genofile <- openfn.gds("ccm_TCAP90K_NAMparents_panel-strand.vcf.merged")
ccm_pca<-snpgdsPCA(genofile)

vcf.fn <- "/data/phg/TCAP90K_HWWAMP-strand.vcf.merged";
snpgdsVCF2GDS(vcf.fn, "ccm_TCAP90K_HWWAMP-strand.vcf.merged", method="biallelic.only")
genofile <- openfn.gds("ccm_TCAP90K_HWWAMP-strand.vcf.merged")
ccm_pca<-snpgdsPCA(genofile)

vcf.fn <- "/data/phg/TCAP90K_YQV14-strand.vcf.merged";
snpgdsVCF2GDS(vcf.fn, "ccm_TCAP90K_YQV14-strand.vcf.merged", method="biallelic.only")
genofile <- openfn.gds("ccm_TCAP90K_YQV14-strand.vcf.merged")
ccm_pca<-snpgdsPCA(genofile)

vcf.fn <- "/data/phg/TCAP90K_SWWpanel-strand.vcf.merged"
snpgdsVCF2GDS(vcf.fn, "ccm_TCAP90K_SWWpanel-strand.vcf.merged", method="biallelic.only")
genofile <- openfn.gds("ccm_TCAP90K_SWWpanel-strand.vcf.merged")
ccm_pca<-snpgdsPCA(genofile)

pca <- ccm_pca$eigenval[1:20]
pca_perc <- pca/sum(pca)*100
pve <- data.frame(PC = 1:20, pve = pca/sum(pca)*100)
a <- ggplot(pve, aes(PC, pve)) + geom_bar(stat = "identity")
a + ylab("Percentage variance explained") + theme_light()
ggsave("snprelate-TCAP90K_NAM-var.jpg")
ggsave("snprelate-TCAP90K-HWWAMP-var.jpg")

ibs <- snpgdsIBS(genofile)
loc <- cmdscale(1 - ibs$ibs, k = 2)
x <- loc[, 1]; y <- loc[, 2]

pop <- append(rep("TCAP90K_NAM", 60), rep("PHG470", 459))
pop <- append(rep("TCAP90K_HWWAMP", 299), rep("PHG470", 459))
pop <- append(rep("TCAP90K_YQV14", 212), rep("PHG470", 459))
pop <- append(rep("TCAP90K_SWWPanel", 299), rep("PHG470", 459))
pop <- as.factor(pop)

jpeg("snprelate-TCAP90K-NAM.jpg", width = 960, height = 960, point = 20)
plot(x, y, col=pop, xlab = "", ylab = "", main = "cmdscale(IBS Distance) TCAP90K_NAM")
legend("topleft", legend=levels(pop), text.col=1:nlevels(pop))
dev.off()

jpeg("snprelate-TCAP90K-HWWAMP.jpg", width = 960, height = 960, point = 20)
plot(x, y, col=pop, xlab = "", ylab = "", main = "cmdscale(IBS Distance) TCAP90K_HWWAMP")
legend("topleft", legend=levels(pop), text.col=1:nlevels(pop))
dev.off()

jpeg("snprelate-TCAP90K-YQV14.jpg", width = 960, height = 960, point = 20)
plot(x, y, col=pop, xlab = "", ylab = "", main = "cmdscale(IBS Distance) TCAP90K_YQV14")
legend("topleft", legend=levels(pop), text.col=1:nlevels(pop))
dev.off()

jpeg("snprelate-TCAP90K-SWWPanel.jpg", width = 960, height = 960, point = 20)
plot(x, y, col=pop, xlab = "", ylab = "", main = "cmdscale(IBS Distance) TCAP90K_SWWPanel")
legend("topleft", legend=levels(pop), text.col=1:nlevels(pop))
dev.off()

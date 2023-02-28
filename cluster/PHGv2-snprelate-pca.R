library("SNPRelate")
library("ggplot2")

vcf.fn <-"/data/phg/PHG470v2-31_db.maf_seg_filtered.vcf"
snpgdsVCF2GDS(vcf.fn, "ccm.gds",  method="biallelic.only")
genofile <- openfn.gds("ccm.gds")
ccm_pca<-snpgdsPCA(genofile)
jpeg("snprelate-var.jpg")
pca <- ccm_pca$eigenval[1:20]
pca_perc <- pca/sum(pca)*100
pve <- data.frame(PC = 1:20, pve = pca/sum(pca)*100)
a <- ggplot(pve, aes(PC, pve)) + geom_bar(stat = "identity")
a + ylab("Percentage variance explained") + theme_light()
ggsave("PHG470v2-snprelate-var.jpg")

jpeg("snprelate-pca.jpg")
plot(ccm_pca$eigenvect[,1],ccm_pca$eigenvect[,2] ,col=as.numeric(substr(ccm_pca$sample, 1,3) == 'CCM')+3, pch=2)


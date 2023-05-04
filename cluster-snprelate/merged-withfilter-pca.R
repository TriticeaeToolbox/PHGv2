# PCA analysis using SNPRelate

library("SNPRelate")
library("factoextra")

vcf.fn <- "/data/wheat/liftover/2019_hapmap_all.vcf.merged2" #includes duplicates
snpgdsVCF2GDS(vcf.fn, "ccm_2019_hapmap_merged2.gds",  method="biallelic.only")
#this file has markers with missing data removed, contains about 1M markers
genofile <- openfn.gds("ccm_2019_hapmap_merged2.gds")

#first look at PCA analysis
ccm_pca<-snpgdsPCA(genofile)
pca <- ccm_pca$eigenval[1:20]
res <- ccm_pca$eigenvec[, 1:20]
pca_perc <- pca/sum(pca)*100
pve <- data.frame(PC = 1:20, pve = pca/sum(pca)*100)
a <- ggplot(pve, aes(PC, pve)) + geom_bar(stat = "identity")
a + ylab("Percentage variance explained") + theme_light()
ggsave("images/snprelate-exome-var.jpg")
fviz_nbclust(res, kmeans, method = 'wss', k.max = 20)
ggsave("images/snprelate-exome-nbclus.jpg")

pca12 <- data.frame(sample.id = ccm_pca$sample.id, 
                  EV1 = ccm_pca$eigenvect[,1],
                  EV2 = ccm_pca$eigenvect[,2])
plot(pca12$EV1, pca12$EV2)
dev.copy(png, "images/snprelate-exome-pca.png"); dev.off()

class1 <- read.table("accession-class-hapmap.txt", header = TRUE, sep = "\t")
class2 <- read.table("accession-class-phgv2.txt", header = TRUE, sep = "\t")
class <- rbind(class1, class2)
MC <- cbind(class$hardness, class$color, class$season)

MC <- paste0(class[,2],class[,3],class[,4])
MC <- as.factor(MC)
MCsym <- as.numeric(MC)

MCF <- MC[!grepl("unknown",MC)]
MCF <- droplevels(MCF)
MCF <- as.factor(MCF)
MCFsym <- as.numeric(MCF)

resf <- res[!grepl("unknown", MC),]
plot(resf[,1], resf[,2], pch=MCFsym, col=MCF, main = "PCA eig1 vs eig2")
legend("topleft", legend=levels(MCF), text.col=1:nlevels(MCF), pch=1:nlevels(MCF))
dev.copy(png, "images/snprelate-exome-pca12.png"); dev.off()

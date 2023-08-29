# using tcaps:/data/wheat/liftover/2019_hapmap_all.vcf.merged
# genotype files available at https://files.triticeaetoolbox.org/PHGv2
# filtered to remove markers MAF  < 0.05 2019_hapmap_all_maf05.vcf

library("SNPRelate")
library("ggplot2")
library("ggpubr")
library(factoextra)
vcf.fn <- "2019_hapmap_all.vcf"
snpgdsVCF2GDS(vcf.fn, "ccm_2019_hapmap_merged.gds",  method="biallelic.only")
genofile <- openfn.gds("ccm_2019_hapmap_merged.gds")
ccm_pca<-snpgdsPCA(genofile)

vcf.fn <- "2019_hapmap_all_maf05.vcf.gz"
snpgdsVCF2GDS(vcf.fn, "ccm_2019_hapmap_merged05.gds",  method="biallelic.only")
genofile <- openfn.gds("cluster-snprelate/ccm_2019_hapmap_merged05.gds")
ccm_pca<-snpgdsPCA(genofile)

pca <- ccm_pca$eigenval[1:20]
res <- ccm_pca$eigenvec[, 1:20]
pca_perc <- pca/sum(pca)*100
pve <- data.frame(PC = 1:20, pve = pca/sum(pca)*100)
a <- ggplot(pve, aes(PC, pve)) + geom_bar(stat = "identity")
a + ylab("Percentage variance explained") + theme_light()
ggsave("cluster-snprelate/images/snprelate-2019_hapmap-var.jpg")

fviz_nbclust(res, kmeans, method = 'wss', k.max = 20)

ibs <- snpgdsIBS(genofile)
loc <- cmdscale(1 - ibs$ibs, eig=TRUE, k = 2)
x <- loc$points[, 1]; y <- loc$points[, 2]

mds.df <- as.data.frame(loc$points)
colnames(mds.df) <- c("Dim1", "Dim2")
kmclusters <- kmeans(mds.df, 5)
kmclusters <- as.factor(kmclusters$cluster)
mds.df$groups <- kmclusters

#cluster data using kmeans (not market class)
ggscatter(mds.df, x = "Dim1", y = "Dim2", label = rownames(ibs),
	  color = "groups",
	  palette = "jco",
	  size = 1,
	  ellipse = TRUE,
	  ellipse.type = "convex",
	  repel = TRUE,
	  title = "cluster K-means")
ggsave("cluster-snprelate/images/snprelate-exome-cluster-kmeans.jpg")

class1 <- read.table("accession-class-hapmap.txt", header = TRUE, sep = "\t")
class2 <- read.table("accession-class-phgv2.txt", header = TRUE, sep = "\t")
class <- rbind(class1, class2)
MC <- cbind(class$hardness, class$color, class$season)

class$hardness <- as.factor(class$hardness)
class$color <- as.factor(class$color)
class$season <- as.factor(class$season)

MC <- paste0(class[,2],class[,3],class[,4])
MC <- as.factor(MC)
MCsym <- as.numeric(MC)

locf <- loc$points[!grepl("unknown",MC),]
mcf <- MC[!grepl("unknown",MC)]
mcf <- as.factor(mcf)
mcfsym <- as.numeric(mcf)
mcf <- droplevels(mcf)

resf <- res[!grepl("unknown", MC),]

x <- locf[, 1]; y <- locf[, 2]
mds.df <- as.data.frame(locf)
colnames(mds.df) <- c("Dim1", "Dim2")
mds.df$class <- mcf

# cluster data using market class
ggscatter(mds.df, x = "Dim1", y = "Dim2", label = rownames(ibs),
          color = "class",
          palette = "jco",
          size = 1,
          repel = TRUE,
          title = "cluster market class")
ggsave("cluster-snprelate/images/snprelate-exome-cluster-market.jpg")

#with ggscatter it is difficult to change symbols and points so switch to plot
jpeg("cluster-snprelate/images/snprelate-2019_hapmap-pca.jpg")
plot(resf[,1], resf[,2], pch=mcfsym, col=mcf, main = "PCA eig1 vs eig2")
legend("topleft", legend=levels(mcf), text.col=1:nlevels(mcf), pch=1:nlevels(mcf))
dev.off()

jpeg("cluster-snprelate/images/snprelate-2019_hapmap-MDS.jpg")
plot(x, y, pch=mcfsym, col=mcf, xlab = "", ylab = "", main = "cmdscale(IBS Distance) market class")
legend("topright", legend=levels(mcf), text.col=1:nlevels(mcf), pch=1:nlevels(mcf))
dev.off()

jpeg("cluster-snprelate/images/snprelate-2019_hapmap-cluster-hardness05.jpg")
plot(x, y, col=class$hardness, xlab = "", ylab = "", main = "cmdscale(IBS Distance) hardness")
legend("topleft", legend=levels(class$hardness), text.col=1:nlevels(class$hardness))
dev.off()

jpeg("cluster-snprelate/images/snprelate-2019_hapmap-cluster-color05.jpg")
plot(x, y, col=class$color, xlab = "", ylab = "", main = "cmdscale(IBS Distance) color")
legend("topleft", legend=levels(class$color), text.col=1:nlevels(class$color))
dev.off()

jpeg("cluster-snprelate/images/snprelate-2019_hapmap-cluster-season05.jpg")
plot(x, y, col=class$season, xlab = "", ylab = "", main = "cmdscale(IBS Distance) season")
legend("topleft", legend=levels(class$season), text.col=1:nlevels(class$season))
dev.off()



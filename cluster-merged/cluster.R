library(cluster)
library(tidyverse)
library(factoextra)

pca <- read.table("2019_hapmap_merged.eigenvec2", header = TRUE)
pca_transform <- as.data.frame(pca[,2:21])
set.seed(1234)
km.res <- kmeans(pca_transform, 3, nstart = 25)

fviz_cluster(km.res, data = pca_transform, geom = c("point"), ellipse.type = "euclid", main = "PHG_merged, 20 PCs")
fviz_cluster(km.res, data = pca_transform, geom = c("text"), ellipse.type = "euclid", main = "PHG_merged, 20 PCs")

pop <- append(rep("2019_hapmap", 337), rep("PHG470", 459))
table(km.res$cluster, pop)

class1 <- read.table("accession-class-hapmap.txt", header = TRUE, sep = "\t")
class2 <- read.table("accession-class-phgv2.txt", header = TRUE, sep = "\t")
class <- rbind(class1, class2)

table(km.res$cluster, class$hardness)
table(km.res$cluster, class$season)
table(km.res$cluster, class$color)

ibrary(GGally)
library(data.table)

pca <- data.table(pca_transform)
pca[, cluster := as.factor(km.res$cluster)]
ggpairs(pca, aes(colour = cluster, alpha = 0.4),
        columns = c("PC1", "PC2", "PC3", "PC4"))




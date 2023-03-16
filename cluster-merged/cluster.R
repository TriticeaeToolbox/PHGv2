library(cluster)
library(tidyverse)
library('factoextra')

pca <- read.table("PHG_merged.eigenvec2", header = TRUE)
pca_transform <- as.data.frame(pca[,2:20])
km.res <- kmeans(pca_transform, 4, nstart = 25)

fviz_cluster(km.res, data = pca_transform, geom = c("point"), ellipse.type = "euclid", main = "PHG_merged, 20 PCs")



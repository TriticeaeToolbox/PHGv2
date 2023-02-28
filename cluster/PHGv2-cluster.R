library('cluster')
library('factoextra')

pca <- read_table("PHG470v2f.eigenvec")
pca_transform <- as.data.frame(pca[,3:4])
jpeg("kmeans-phg470v2f.jpg")
fviz_nbclust(pca_transform, kmeans, method = 'wss')
dev.off()

remove first entry of header so column names will be read in correctly
pca <- read.table("PHG470v2f.eigenvec2", header = TRUE)
pca_transform <- as.data.frame(pca[,2:3])
jpeg("cluster-phg470v2f.jpg")
km.res <- kmeans(pca_transform, 3, nstart = 25)
fviz_cluster(km.res, data = pca_transform)


library(plotly)
library(dplyr)

pca <- read.table("phg_merged.eigenvec2", header = TRUE)
pca_transform <- as.data.frame(pca[,2:20])
res.km <- kmeans(pca_transform, 3, nstart = 25)
pca_transform$cluster <- factor(res.km$cluster)

p <- plot_ly(pca_transform, x=~PC1, y=~PC2, z=~PC3,
             color=~cluster) %>%
  add_markers(size=5)
print(p)

pop <- append(rep("2019_hapmap", 337), rep("PHG470",459))
pca_transform$pop <- factor(pop)

p <- plot_ly(pca_transform, x=~PC1, y=~PC2, z=~PC3,
             color=~pop, colors = c("red", "blue")) %>%
  add_markers(size=5)
print(p)

class1 <- read.table("accession-class-phgv2.txt", sep = "\t", header = TRUE)
class2 <- read.table("accession-class-hapmap.txt", sep = "\t", header = TRUE)
class <- rbind(class1, class2)
pca_transform$hardness <- class$hardness
pca_transform$color <- class$color
pca_transform$season <- class$season

p <- plot_ly(pca_transform, x=~PC1, y=~PC2, z=~PC3,
             color=~hardness) %>%
  add_markers(size=5)
print(p)
p <- plot_ly(pca_transform, x=~PC1, y=~PC2, z=~PC3,
             color=~color) %>%
  add_markers(size=5)
print(p)
p <- plot_ly(pca_transform, x=~PC1, y=~PC2, z=~PC3,
             color=~season) %>%
  add_markers(size=5)
print(p)


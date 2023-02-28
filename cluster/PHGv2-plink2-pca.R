library(tidyverse)
library(ggplot2)

pca <- read_table("PHG470v2f.eigenvec")
eigenval <- scan("PHG470v2f.eigenval")
class <- read_table("accession-class-phgv2f.txt")
hardness <- class$hardness
color <- class$color
season <- class$season
pca <- pca[,-1]
names(pca)[1] <- "ind"
pca <- as_tibble(data.frame(pca, hardness, color, season))
pve <- data.frame(PC = 1:20, pve = eigenval/sum(eigenval)*100)

a <- ggplot(pve, aes(PC, pve)) + geom_bar(stat = "identity")
a + ylab("Percentage variance explained") + theme_light()
ggsave("plink2-PHG470v2f-var.jpg")
b <- ggplot(pca, aes(PC1, PC2, col = hardness, shape = color)) + geom_point(size = 3)
b <- b + scale_colour_manual(values = c("red", "blue", "green"))
b <- b + coord_equal() + theme_light()
b <- xlab(paste0("PC1 (", signif(pve$pve[1], 3), "%)"))
b <- ylab(paste0("PC2 (", signif(pve$pve[2], 3), "%)"))
ggsave("plink2-PHG470v2f-pca.jpg")

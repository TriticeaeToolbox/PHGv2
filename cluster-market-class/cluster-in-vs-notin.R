## compare populations "inPHG" vs "notinPHG"

library("SNPRelate")

#this is done once because it can be large file
vcf.fn <- "90KinPHGv2-strand.vcf.merged" #includes duplicates
snpgdsVCF2GDS(vcf.fn, "ccm_90KinPHGv2-strand.gds",  method="biallelic.only")
#genofile <- openfn.gds("ccm_90KinPHGv2-strand.gds")
genofile <- snpgdsOpen("ccm_90KinPHGv2-strand.gds")

pop <- append(rep("in PHG", 104), rep("PHG470", 463))
pop <- as.factor(pop)
popSym <- as.numeric(pop)

#first look at PCA analysis
ccm_pca<-snpgdsPCA(genofile)
pca <- ccm_pca$eigenval[1:20]
res <- ccm_pca$eigenvec[, 1:20]
pca <- data.frame(sample.id = ccm_pca$sample.id, 
                    EV1 = ccm_pca$eigenvect[,1],
                    EV2 = ccm_pca$eigenvect[,2])
plot(pca$EV1, pca$EV2, col=pop, pch=popSym, main="PCA in PHG")
legend("topright", legend=levels(pop), text.col=1:nlevels(pop), pch=1:nlevels(pop))
dev.copy(png,"images/snprelate-pca-90K-inPHG.png"); dev.off()

ibs <- snpgdsIBS(genofile, num.thread=4)
loc <- cmdscale(1 - ibs$ibs, eig=TRUE, k = 2)
x <- loc$points[, 1]; y <- loc$points[, 2]

plot(x, y, xlab="", ylab="", col=pop, pch=popSym, main="cmdscale(ibs) in PHG")
legend("bottomleft", legend=levels(pop), text.col=1:nlevels(pop), pch=1:nlevels(pop))
dev.copy(png,"images/snprelate-90K-inPHG.png"); dev.off()
# the "inPHG" accessions are in a single cluster (closely related) but seperate from the PHG470
# could this be caused by different protocol?

#plot accuracy (compare each genotype) to (distance of imputed from 2019_hapmap)
#accuracy <- read.table("results-90K-imp-com-inPHG-byaccn.csv", "\t")
name1 <- c()
name2 <- c()
dist <- c()
euc.dist <- function(x1, x2) sqrt(sum((x1 - x2) ^ 2))
for (i in 1:50) {
  min <- 100
  for (j in 105:567) {
    df1 = data.frame(x=loc$points[i,1],y=loc$points[i,2])
    df2 = data.frame(x=loc$points[j,1],y=loc$points[j,2])
    d1 <- euc.dist(df1,df2)
    if (d1 < min) {
      min <- d1
      best <- j
      #cat(i," good ",d1," ",min," ",ibs$sample.id[j],"\n")
    } else {
      #cat(i," bad  ",d1," ",ibs$sample.id[j],"\n")
    }
  }
  cat(i," ",best," ",ibs$sample.id[i]," ",ibs$sample.id[best]," ",min,"\n")
  #cat(loc$points[i,1]," ",loc$points[i,2],"\n")
  #cat(loc$points[best,1]," ",loc$points[best,2],"\n")
  name1 <- rbind(name1, ibs$sample.id[i])
  name2 = rbind(name2, ibs$sample.id[best])
  dist = rbind(dist, min)
}
df <- data.frame(
  name1=name1,
  name2=name2,
  dist=dist)
write.csv(df, file="90K-inphg-genetic-distance.csv")
# majority of "inPHG" accessions are cloesest in distance to WENDY

vcf.fn <- "90KnotinPHGv2-strand.vcf.merged" #includes duplicates
snpgdsVCF2GDS(vcf.fn, "ccm_90KnotinPHGv2-strand.gds",  method="biallelic.only")
#genofile <- openfn.gds("ccm_90KnotinPHGv2-strand.gds")
genofile <- snpgdsOpen("ccm_90KnotinPHGv2-strand.gds")

#first look at PCA analysis
ccm_pca<-snpgdsPCA(genofile)
pca <- ccm_pca$eigenval[1:20]
res <- ccm_pca$eigenvec[, 1:20]
pca <- data.frame(sample.id = ccm_pca$sample.id, 
                  EV1 = ccm_pca$eigenvect[,1],
                  EV2 = ccm_pca$eigenvect[,2])
plot(pca$EV1, pca$EV2, col=pop, pch=popSym, main="PCA not in PHG")
legend("bottomleft", legend=levels(pop), text.col=1:nlevels(pop), pch=1:nlevels(pop))
dev.copy(png,"images/snprelate-pca-90K-notinPHG.png"); dev.off()

ibs <- snpgdsIBS(genofile, num.thread=4)
loc <- cmdscale(1 - ibs$ibs, eig=TRUE, k = 2)
x <- loc$points[, 1]; y <- loc$points[, 2]

pop <- append(rep("not in PHG", 53), rep("PHG470", 463))
pop <- as.factor(pop) 
popSym <- as.numeric(pop)
plot (x, y, xlab="", ylab="", col=pop, pch=popSym, main="cmdscale(ibs) not in PHG")
legend("bottomleft", legend=levels(pop), text.col=1:nlevels(pop), pch=1:nlevels(pop))
dev.copy(png,"images/snprelate-90K-notinPHG.png"); dev.off()
# the "notinPHG" accessions are more scattered

#plot accuracy (compare each genotype) to (distance of imputed from 2019_hapmap)
#accuracy <- read.table("results-90K-imp-com-inPHG-byaccn.csv", "\t")
euc.dist <- function(x1, x2) sqrt(sum((x1 - x2) ^ 2))
for (i in 1:53) {
  min <- 100
  for (j in 54:516) {
    df1 = data.frame(x=loc$points[i,1],y=loc$points[i,2])
    df2 = data.frame(x=loc$points[j,1],y=loc$points[j,2])
    d1 <- euc.dist(df1,df2)
    if (d1 < min) {
      min <- d1
      best <- j
      #cat(i," good ",d1," ",min," ",ibs$sample.id[j],"\n")
    } else {
      #cat(i," bad  ",d1," ",ibs$sample.id[j],"\n")
    }
  }
  cat(i," ",best," ",ibs$sample.id[i]," ",ibs$sample.id[best]," ",min,"\n")
  #cat(loc$points[i,1]," ",loc$points[i,2],"\n")
  #cat(loc$points[best,1]," ",loc$points[best,2],"\n")
}


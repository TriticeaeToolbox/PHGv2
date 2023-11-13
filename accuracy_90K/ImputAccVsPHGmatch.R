# find correlation between marker best matches and imputation accuracy

matches1 <- read.table("results-90K-inPHG-dist.csv", sep="\t")
matches2 <- read.table("results-90K-notinPHG-dist.csv", sep="\t")
matches <- rbind(matches1, matches2)
colnames(matches) <- c("name90K", "namePHG","perc")

accuracy1 <- read.table("results-90K-imp-com-in-byaccn.csv", sep=",")
accuracy2 <- read.table("results-90K-imp-com-notin-byaccn.csv", sep=",")
accuracy <- rbind(accuracy1, accuracy2)
colnames(accuracy) <- c("name","inPHG","total","match","notmatch","accuracy")

x <- c()
y <- c()
for (matchIndex in 1:155) {
  matchName <- matches$name90K[matchIndex]
  accIndex <- which(accuracy$name == matchName)
  cat(matchIndex, " matchName=",matchName, " ", accIndex, " ", matches$perc[matchIndex], " ",  accuracy$accuracy[accIndex],"\n")
  if (length(accIndex) > 0) {
    x[matchIndex] <- matches$perc[matchIndex]
    y[matchIndex] <- accuracy$accuracy[accIndex]
  }
}
plot(x,y, xlab="perc match to PHG", ylab="imput accuracy")
dev.copy(png,"images/accuracyVsmatch.png"); dev.off()

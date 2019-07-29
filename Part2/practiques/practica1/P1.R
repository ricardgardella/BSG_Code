FrenchSTRs <- read.table("FrenchSTRs.dat", quote="\"", comment.char="")
View(FrenchSTRs)
library(genetics)
library(adegenet)
library(dplyr)
#1#####
length(unique(FrenchSTRs$Individual))
ncol(FrenchSTRs)-1 #-1 cause the 1 is the individuals
#2#####
FrenchSTRs[FrenchSTRs == -9] = NA
#% of missing values
(sum(length(which(is.na(FrenchSTRs))))/(ncol(FrenchSTRs)*nrow(FrenchSTRs)))*100
#3#####
countAlleles <- function(x){
  y <- length(unique(x[!is.na(x)]))
  return(y)
}
resultAlleles = apply(FrenchSTRs, 2, countAlleles)
#sumary of the result
summary(resultAlleles)
#standard deviation
sd(resultAlleles)
#4#####
barplot(table(resultAlleles))
# the most common is the STR 6 with more than 150 Alleles.
#5#####
expectedHeterozygote <- function(x){
  1-sum((unique(table(x[!is.na(x)]))/length(x))^2) #formula from slides.
}
resultExpected = apply(FrenchSTRs, 2, expectedHeterozygote)
summary(resultExpected)

#7#####

#As the data sets are different, it is difficult to extract conclusions.
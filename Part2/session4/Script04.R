#
# Script for phase estimation.
#

install.packages("haplo.stats")
library(haplo.stats)
rm(list=ls())

load(file=url("http://www-eio.upc.es/~jan/data/bsg/CHBChr2-2000.rda"))
ls()

X[1:10,1:10] #A lot of missing values, typicall with genetic data
Z <- t(X)
dim(Z)
nmis <- function(x) {
  y <- sum(is.na(x))
  return(y)
}

nmissings <- apply(Z,2,nmis)
nmissings

Z <- Z[,nmissings==0]
dim(Z)

ntypes <- function(x) {
  y <- length(table(x))
  return(y)
}

length(table(Z[,1]))

Z[1:10,1:10]

FirstFive <- Z[,1:5]
FirstFive
nrow(FirstFive)

Geno <- cbind(substr(FirstFive[,1],1,1),substr(FirstFive[,1],2,2),
              substr(FirstFive[,2],1,1),substr(FirstFive[,2],2,2),
              substr(FirstFive[,3],1,1),substr(FirstFive[,3],2,2),
              substr(FirstFive[,4],1,1),substr(FirstFive[,4],2,2),
              substr(FirstFive[,5],1,1),substr(FirstFive[,5],2,2))

Geno

Snpnames <- paste("SNP",1:5,sep="")
Snpnames
Haplo.Res <- haplo.em(Geno,locus.label=Snpnames,control=haplo.em.control(min.posterior=1e-4))
Haplo.Res

nHaploPossible <- 2^5
nHaploPossible

Haplo.Res$nreps
Haplo.Res$indx.subj[1:10]
Haplo.Res$hap1code[1:10]
Haplo.Res$hap2code[1:10]
hprob <- Haplo.Res$hap.prob
hprob

Haplo.Res$post


First25 <- Z[,1:25]
First25
nrow(First25)

Geno <- cbind(substr(First25[,1],1,1),substr(First25[,1],2,2))

for(i in 2:25) {
  Geno <- cbind(Geno,substr(First25[,i],1,1),substr(First25[,i],2,2))
}
             
Geno

Snpnames <- paste("SNP",1:25,sep="")
Snpnames
Haplo.Res <- haplo.em(Geno,locus.label=Snpnames,control=haplo.em.control(min.posterior=1e-4))
Haplo.Res

nHaploPossible <- 2^25
nHaploPossible

Haplo.Res$nreps
Haplo.Res$indx.subj[1:10]
Haplo.Res$hap1code[1:10]
Haplo.Res$hap2code[1:10]
hprob <- Haplo.Res$hap.prob
hprob

Haplo.Res$post


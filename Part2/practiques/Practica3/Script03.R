#
# Exercise on LD
#

install.packages("genetics")
install.packages("HardyWeinberg")
install.packages("LDheatmap")

library(genetics)
library(HardyWeinberg)
library(LDheatmap)

setwd('C:/Master/3rd Semestre/BSG - Bioinformatics and Statistical Genetics/Statistical Genetics/Theory/Lesson3_LD')
load("CHBChr2-2000.rda")
ls()
Alleles

class(X)
X[1:10,1:10] 
  # Identifiers of individuals in the columns. Genetic variants in the rows. Lots of NA. Each genotype two successive letters. 
  # We will transpose the data in order to have the individuals in the rows and the variants in the columns --> nxp matrix!!

X <- t(X)
dim(X)
  # We have 45 individuals and 2000 genetic variants.


######
## Calculate the statistics D; D0; R2 and Chisq2 for SNPs 12 and 13. Interpret the results.
## Calculate the statistics D; D0; R2 and Chisq2 for SNPs 12 and 1000. Interpret the results.

SNP12 <- X[,12]
SNP13 <- X[,13]
SNP1000 <- X[,1000]

# Table of genotype frequencies:
table(SNP12) # Polymorphic but only one CG individual
table(SNP13) # Only 37 individuals. 8 Missing values.
table(SNP13,useNA='always')

# We will transform them as genotype objects 
SNP12g <- genotype(SNP12,sep="")
SNP13g <- genotype(SNP13,sep="")
SNP1000g <- genotype(SNP1000,sep="")

summary(SNP12g) # Fully-typed variant. One heterozygal. 
summary(SNP13g) # 8 missing values --> x2=16 missing alleles.
summary(SNP1000g) # GA polymorphism. 

# To compute LD Statistic
res <- LD(SNP12g,SNP13g)
  # it is complaining about the type of variants. The 13th has no variation. Both variants need to be polymorphic.
  # With LD we need to remove all the variants that are MONOMORPHIC.

# We will compare the 12th and 1000th, cause the 13th is monomorphic. 
table(SNP12,SNP1000) #There are no AA neither CC --> So we will work with a 2X2 table.
(res <- LD(SNP12g,SNP1000g))
  # It calculates all the statistics. 
  # It seems that these two variants aren't associated, cause the test is not statistically significant (pvalue > threshold of 0.05)

attributes(res)
(chisq <- res$`X^2`)
pchisq(chisq,df=1,lower.tail=F)
  #Pvalue

# What the problem had been doing it has estimated the haplotypes probabilities, it estimates the 2x2 table and finally the D,D',LD by ML.
# There is an additional amount of "incertanty" due to the estimation of the haplotypes frequencies (and probabilities).
# They have been ESTIMATED, they are not real.



######
## Select the first 100 SNP that have no missing values

(n <- nrow(X))
  # Number of individuals

nmis <- function(x) {
  y <- sum(is.na(x))
  return(y)
}

nmis(X[,1])
  #We will see how many missing values do we have in the first variant.

(nmissingpersnp <- apply(X,2,nmis))
  #Table of missing values for each variant in the database.

X <- X[,nmissingpersnp==0] #We take all the variants that has no missing values.
dim(X)

sum(is.na(X))

X100 <- X[,1:100]


######
## Compute 4 matrices of association statistics, for D; D0; R2 and Chisq2 respectively.
## Extract the subdiagonal part of each matrix into a vector.
## Make a scatterplot matrix of the 4 association statistics. Are they related?

# The LD function need a genotype object to be calculated. That's why we will use the matrix as a genotype object.
RES <- data.frame(genotype(X100[,1],sep=""))
  # We take from the dataset the first genetic variant and we had converted it into a genotype object.

# We will do the same with all the variants we have in the dataset.
for(i in 2:ncol(X100)) {
   snp <- genotype(X100[,i],sep="")
   RES <- cbind(RES,snp)
}

dim(RES) #100 variants, 45 individuals
output <- LD(RES) # We will compute all the LD statistics of all the variants
attributes(output)

Dm <- output$D
Dp <- output$"D'"
R2 <- output$"R^2"
X2 <- output$"X^2"

Dm[1:10,1:10]

Dm <- Dm[upper.tri(Dm)] # 1 if the element of the metric is above the diagonal and 0 if not. True=entries above the diagonal/False=in and below.
Dp <- Dp[upper.tri(Dp)]
R2 <- R2[upper.tri(R2)]
X2 <- X2[upper.tri(X2)]

Dm
pairs(cbind(Dm,Dp,R2,X2))
  #Scatterplot of all the statistics. X2 and R2 are explaining almost the same.
  #Dp makes the absolut value of Dm. Dp can jump fastly to 1. It tends to accelerate the correlation.


######
## Make an LDheatmap for each of the four association statistics. Are the results similar?

?LDheatmap
rgb.palette <- colorRampPalette(rev(c("blue", "orange", "red")), space = "rgb")
LDheatmap(RES, color=rgb.palette(18))

par(mfrow=c(1,2))
LDheatmap(RES,LDmeasure="D'",color=rgb.palette(18))
LDheatmap(RES,LDmeasure="r",color=rgb.palette(18))
  # The first block is highly correlated with the fourth.








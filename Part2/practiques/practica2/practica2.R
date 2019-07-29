library(HardyWeinberg)
###Exercise1###
load("/Users/ricardgardellagarcia/Documents/Master Data science/BSG/Part2/practiques/practica2/YRIChr1.rda")

###Exercise2###
X[1:3] #We can conclude that we have 107 individuals, same as observations
#Delete monomorphic
data = 0
for (i in 1:ncol(X))
  {
    if(sum(unique(X[i])) != 0) 
      {
      data = cbind(data, X[i]) 
      }
}
data = data[-1] #Delete 1st columns due all 0 values of inicialization of the dataframe

(ncol(X) - ncol(data)) /100  #69.65% of monomorphic values
ncol(data) #3035 variants remaining

#variantscount
matrixvariants = matrix(data = 0,nrow = 3,ncol = ncol(data))
for (i in 1:ncol(data))
{
  matrixvariants[1,i] = sum(data[i] == 0)
  matrixvariants[2,i] = sum(data[i] == 1)
  matrixvariants[3,i] = sum(data[i] == 2)
}

#test
pvaluescc0 <<- 0
HWchisqcc0 <- function(x)
{
   test = HWChisq(x,cc=0)
   if(test$pval >= 0.05)
   {
     pvaluescc0 <<- pvaluescc0 + 1
   }
}
apply(matrixvariants, 2, HWchisqcc0)
pvaluescc0 #2875 pvalues pass the test
### Exercise 3 ###

#Ni idea albert sabr??

### Exercise 4 ###
pvaluesexact = 0
HWexactapply <- function(x)
{
  test = HWExact(x)
  if(test$pval >= 0.05)
  {
    pvaluesexact <<- pvaluesexact + 1
  }
}
apply(matrixvariants, 2, HWexactapply)
pvaluesexact  #2909 pass the test the values are similar

### Exercise 5 ###
pvaluesratio = 0
HWratio <- function(x)
{
  test = HWLratio(x)
  if(test$pval >= 0.05)
  {
    pvaluesratio <<- pvaluesratio + 1
  }
}
apply(matrixvariants, 2, HWratio)
pvaluesratio  #2890 pass the test the values are similar

### Exercise 6 ###
matrixex6 = matrix(data = 0,nrow = 2,ncol = 10)
for(i in 1:10){
  testchisq = HWChisq(matrixvariants[,i],cc = 0)
  testexact = HWExact(matrixvariants[,i])
  matrixex6[1,i] = testchisq$pval
  matrixex6[2,i] = testexact$pval
}
matrixex6 # The values are similar but we can observe how the valyes of the last 8 are rounded up to 1

### Exercise 7 ###
UniqueGenotypeCounts(matrixvariants)
### Exercise 8 ###

#Redacting exercise, no code 

####SOFIA PART STARTS HERE #####

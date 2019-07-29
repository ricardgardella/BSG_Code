#Script asssociation analysis

Cases = c(112,278,150)
Controls = c(206,348,150)

X = rbind(Cases,Controls)
rownames(X) = c("Cases","Controls")
colnames(X) = c("MM","Mm","mm")

X

Y = cbind(2*X[,1]+X[,2],2*X[,3]+X[,2])
colnames(Y) = c("M","m")
Y

sum(Y)
rowSums(Y)


#
#Alleles test
#

res = chisq.test(Y,correct = FALSE)
res$expected

fisher.test(Y)

Y

or <- (Y[1,1]*Y[2,2])/(Y[1,2]*Y[2,1])
or

se.lor = sqrt(sum(1/Y))#standard error logistic regression
se.lor

#Calculating confaince interval from odds
#low limit
ll.logodds = log(or) - qnorm(0.975)*se.lor#natural log, not log 10
#upper limit
ul.logodds = log(or) + qnorm(0.975)*se.lor

ll.logodds = exp(ll.logodds)
ul.logodds = exp(ul.logodds)


#
#Armitage trend test
#

X

cas = rep(c(0,1,2),Cases)
con = rep(c(0,1,2),Controls)

x = c(rep(1,sum(Cases)),rep(0,sum(Controls)))
y = c(cas,con)

length(x)
length(y)

r = cor(x,y)
r
n = length(x)
A = n*(r^2)
A

pvalue = pchisq(A,df=1,lower.tail=FALSE)

#
# Plot fo risk as funciton fo genotype
#

X

total.genotype.counts = colSums(X)
total.genotype.counts

risk = Cases/total.genotype.counts
risk

plot(c(0,1,2),risk,ylim=c(0,1),type="b",xlab="Genotype",ylab="Risk") #plot of the risk

lm1 = lm(x~y)
summary(lm1)
abline(coefficients(lm1),lty ="dotted")

#Co-dominant model

chisq.test(X)
fisher.test(X)

#
#Dominant model

X
Z = cbind(X[,1],X[,2]+X[,3])
colnames(Z) = c("MM","not MM")
chisq.test(Z,correct = FALSE)

#Recessive model

W = cbind(X[,1]+X[,2],X[,3])
W
chisq.test(W)

#Logistic regresion
y
x
newy = x
newx = y
#Genotype trated as quantitative
out.lm <- glm(newy~newx, family = binomial(link = "logit"))
summary(out.lm)
v coefficients(out.lm)
or <- exp(coefficients(out.lm))

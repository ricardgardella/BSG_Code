param n > 0 integer;
param s {1..n} symbolic;
#Param M to force higher value I set it by default at n+2
param M > 0 integer default n+2;
for {i in 1..n}
  for {j in 1..n: i != j and length(s[i]) <= length(s[j])}
    for {k in 1..length(s[j])-length(s[i])+1}
      check s[i] != substr(s[j],k,length(s[i]));

param o {i in 1..n,j in 1..n: i != j} :=
  max {k in 0..min(length(s[i]),length(s[j])):
    substr(s[i],length(s[i])-k+1,k) = substr(s[j],1,k)} k;

/* for {i in 1..n,j in 1..n: i != j} display o[i,j]; */

param p {i in 1..n,j in 1..n: i != j} :=
  length(s[i]) - o[i,j];

var x {i in 1..n,j in 1..n: i != j} binary;
var y {i in 1..n,j in 1..n: i != j} binary;
#z will be always >= tha  1 but smaller than n. an integer
var z {i in 1..n} >= 1, <= n, integer;

minimize target:
  sum {i in 1..n,j in 1..n:i != j} p[i,j]*x[i,j] +
  sum {i in 1..n,j in 1..n:i != j} length(s[j])*y[i,j];

subject to first {i in 1..n}:
  sum {j in {1..n} diff {i}} x[i,j] +
  sum {j in {1..n} diff {i}} y[j,i] = 1;

subject to second {j in 1..n}:
  sum {i in {1..n} diff {j}} x[i,j] +
  sum {i in {1..n} diff {j}} y[j,i] = 1;

subject to third:
  sum {i in 1..n,j in 1..n:i != j} y[i,j] = 1;

#Here we set in order using the parameter M
subject to Order {i in 1..n, j in 1..n: i != j}:
	z[j] >= z[i]+1-M*(1-x[i,j]);

solve;

#Output
printf "The SCS has a length ----> %s:\n", target;
for {i in 1..n} printf "Position of string %s  ----> %s\n", i, z[i];

data;

param n := 3;
param s :=
1 "ACGTACGT"
2 "AACGT"
3 "ACACGTGT";

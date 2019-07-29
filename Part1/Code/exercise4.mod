param n > 0 integer;
param s {1..n} symbolic;

# Large parameter for deactivate BIG NUMBER
param M > 0 integer default n+90000000;

# No string is contained in another one
for {i in 1..n}
	for {j in 1..n: i != j and length(s[i]) <= length(s[j])}
		for {k in 1..length(s[j])-length(s[i])+1}
			check s[i] != substr(s[j], k ,length(s[i]));

# Overlap
param overlap {i in 1..n, j in 1..n: i != j} := 
	max {k in 0..min(length(s[i]), length(s[j])):
		substr(s[i], length(s[i])-k+1, k) = substr(s[j], 1, k)} k;

# write parameter
param w {i in 1..n, j in 1..n: i != j} :=
	length(s[i])-overlap[i,j];

# i followed by j (1 or 0)
var x {i in 1..n, j in 1..n: i != j} binary;

# i and j are first and last strings? (1 or 0)
var y {i in 1..n, j in 1..n: i != j} binary;

# Order
var z {i in 1..n} >= 1, <= n, integer;

#obj function
minimize target:
	sum {i in 1..n, j in 1..n: i != j}
		(x[i,j]*w[i,j] + length(s[j])*y[i,j]);


subject to follow {i in 1..n}:
	sum {j in 1..n: i != j} (x[i,j] + y[j,i]) = 1;

subject to before {j in 1..n}:
	sum {i in 1..n: i != j} (x[i,j]+y[j,i]) = 1;

subject to firstandlast:
	sum {i in 1..n, j in 1..n: i != j} y[i,j] = 1;

#Position and avoid cycles
subject to order {i in 1..n, j in 1..n: i != j}:
	z[j] >= z[i]+1-M*(1-x[i,j]);

solve;

# indicate the string of a given position
param str {i in 1..n} symbolic := min {j in 1..n: z[j] == i} j;

param r {j in 1..n} symbolic := min {k in 1..n: k != j and x[j,k]+y[k,j] == 1} k;

# this variable indicates the superstring up to position i. So super[n] is the SCS that we want
param scs {i in 1..n} symbolic :=
	#special treatment for the 1st
	if i == 1 then 
		substr(s[str[i]], 1, w[str[i], r[str[i]]])
	else 
		if i != n then
			scs[i-1] & substr(s[str[i]], 1, w[str[i], r[str[i]]])
		else #special treatment for the last 
			scs[i-1] & substr(s[str[i]], 1,length(s[str[i]]));	
printf "The SCS is %s \n", scs[n];
printf "The lenght of the SCS is %s \n", target;
for {i in 1..n} printf "The string %s have position %s in the solution\n", i, z[i];

data;
param n := 5;
param s :=
1 "ACGTACGT"
2 "AACGT"
3 "ACACGTGT"
4 "AGATGHYUSA"
5 "HYSAGSTAHSHYAJSIISISAAA";
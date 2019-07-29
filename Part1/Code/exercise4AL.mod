param n > 0 integer;
param s {1..n} symbolic;

# this is a large parameter used to desactive some constraints related to the ordering
# for this problem, n+2 is big enough
param M > 0 integer default n+2;

# we check that no string is contained in another one
for {i in 1..n}
	for {j in 1..n: i != j and length(s[i]) <= length(s[j])}
		for {k in 1..length(s[j])-length(s[i])+1}
			check s[i] != substr(s[j], k ,length(s[i]));

# compute overlap between strings
param o {i in 1..n, j in 1..n: i != j} := 
	max {k in 0..min(length(s[i]), length(s[j])):
		substr(s[i], length(s[i])-k+1, k) = substr(s[j], 1, k)} k;

# this is to show the parameters obtained
# for {i in 1..n, j in 1..n: i != j} display o[i,j];

# this is not necessary but makes the model easier to write
param p {i in 1..n, j in 1..n: i != j} :=
	length(s[i])-o[i,j];

# indicates if i is followed by j in the solution (1 it is, 0 otherwise)
var x {i in 1..n, j in 1..n: i != j} binary;

# indicates if (i,j) are the first and last strings (first s[i] and last s[j])
var y {i in 1..n, j in 1..n: i != j} binary;

# indicates the order
var z {i in 1..n} >= 1, <= n, integer;

# we add the prefixes and all the last string
minimize target:
	sum {i in 1..n, j in 1..n: i != j}
		(x[i,j]*p[i,j] + length(s[j])*y[i,j]);

# a string has another one behind except the last one
subject to OneFollowing {i in 1..n}:
	sum {j in 1..n: i != j} (x[i,j] + y[j,i]) = 1;

# similarly, a string has another before except the first one
subject to OneBefore {j in 1..n}:
	sum {i in 1..n: i != j} (x[i,j]+y[j,i]) = 1;

subject to JustOneFirstandLast:
	sum {i in 1..n, j in 1..n: i != j} y[i,j] = 1;

# the following constraint define the position of the strings. They 
# are needed not only to obtain the position, but also to avoid cycles
subject to SetOrder {i in 1..n, j in 1..n: i != j}:
	z[j] >= z[i]+1-M*(1-x[i,j]);

solve;

# this indicates the string (element) in the given position (inverse of z)
param el {i in 1..n} symbolic := min {j in 1..n: z[j] == i} j;

# this indicates the next string in the final ordering of the string j 
#if j is the last, the next is the first one 
param next {j in 1..n} symbolic := min {k in 1..n: k != j and x[j,k]+y[k,j] == 1} k;

# this variable indicates the superstring up to position i. So super[n] is the SCS that we want
param super {i in 1..n} symbolic :=
	if i == 1 then 
		substr(s[el[i]], 1, p[el[i], next[el[i]]])
	else 
		if i != n then
			super[i-1] & substr(s[el[i]], 1, p[el[i], next[el[i]]])
		else
			super[i-1] & substr(s[el[i]], 1,length(s[el[i]]));	

# display some variables of the solution if wanted
#for {i in 1..n, j in 1..n: i != j and x[i,j] != 0} display x[i,j];
#for {i in 1..n, j in 1..n: i != j and y[i,j] != 0} display y[i,j];
#for {i in 1..n} display z[i];

printf "The shortest common superstring is (length %s):\n", target;
printf super[n] & "\n";

for {i in 1..n} printf "The position of string %s in the solution is %s\n", i, z[i];

data;

param n := 6;
param s :=
1 "ACGTACGT"
2 "AACGT"
3 "ACACGTGT"
4 "ATTGTCC"
5 "TTCCCGGG"
6 "GGTTCCCAAAA";
/*
param n := 5;
param s :=
	1 "EFG"
	2 "ABC"
	3 "CDE"
	4 "BCD"
	5 "DEF";
	*/
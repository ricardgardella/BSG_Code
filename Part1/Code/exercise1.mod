param n > 0 integer default 2;
param s {i in 1..n} symbolic;

param lcp {i in 1..n-1, j in i+1..i+1,p in 1..length(s[i]), q in 1..length(s[j])} := max {k in 0..min(length(s[i])-p+1,length(s[j])-q+1):substr(s[i],p,k) == substr(s[j],q,k)} k;
var x {i in 1..n-1, j in i+1..i+1, p in 1..length(s[i]), q in 1..length(s[j])} binary;
maximize length:
    sum{i in 1..n-1, j in i+1..i+1, p in 1..length(s[i]), q in 1..length(s[j])} lcp[i,j,p,q]*x[i,j,p,q];

subject to one {i in 1..n-1, j in i+1..i+1}:
    sum{p in 1..length(s[i]), q in 1..length(s[j])} x[i,j,p,q] = 1;

solve;

printf "Lenght of the LCS: %s\n", length;
for {i in 1..n-1, j in i+1..i+1, p in 1..length(s[i]), q in 1..length(s[j]): x[i,j,p,q] != 0}:
    {
        printf "string 1 is %s\n", p;
        printf "string 2 is %s\n", q;
    }

data;

param s :=
1 "TTACGTA"
2 "ACGTGTGT";
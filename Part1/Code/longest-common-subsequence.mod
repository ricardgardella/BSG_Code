param n > 0 integer default 2;
param s {i in 1..n} symbolic;

var x {i in 1..n-1,j in i+1..i+1,
  p in 1..length(s[i]),q in 1..length(s[j])} binary;

maximize target: sum {i in 1..n-1,j in i+1..i+1,
    p in 1..length(s[i]),q in 1..length(s[j])}
  x[i,j,p,q];

/* map identical symbols only */

subject to first {i in 1..n-1,j in i+1..i+1,
    p in 1..length(s[i]),q in 1..length(s[j]):
    substr(s[i],p,1) != substr(s[j],q,1)}:
  x[i,j,p,q] == 0;

/* each symbol of s[i] is mapped to at most one symbol of s[j] */

subject to second {i in 1..n-1,j in i+1..i+1,
    p in 1..length(s[i])}:
  sum {q in 1..length(s[j])} x[i,j,p,q] <= 1;

/* each symbol of s[j] is mapped to at most one symbol of s[i] */

subject to third {i in 1..n-1,j in i+1..i+1,
    q in 1..length(s[j])}:
  sum {p in 1..length(s[i])} x[i,j,p,q] <= 1;

/* non-crossing */

subject to fourth {i in 1..n-1,j in i+1..i+1,
    p in 1..length(s[i]),qq in 1..length(s[j]),
    pp in p+1..length(s[i]),q in qq+1..length(s[j])}:
  x[i,j,p,q] + x[i,j,pp,qq] <= 1;

/* compatible mappings */

subject to fifth {j in 2..n-1,q in 1..length(s[j])}:
  sum {i in j-1..j-1,p in 1..length(s[i])} x[i,j,p,q] ==
  sum {k in j+1..j+1,r in 1..length(s[k])} x[j,k,q,r];

solve;

for {i in 1..n-1,j in i+1..i+1,
    p in 1..length(s[i]),q in 1..length(s[j]):
    x[i,j,p,q] != 0}
  display x[i,j,p,q];

data;

param n := 3;
param s :=
1 "TTAAGTAA"
2 "ACACGTGT"
3 "ACACGTGT";

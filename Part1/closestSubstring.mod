# Closest substring of n strings of length at least m
param n > 0 integer;
param s {i in 1..n} symbolic;
param m > 0 integer;

set V := setof {i in 1..n, k in 1..length(s[i])} substr(s[i],k,1);

/* 1 iff character j is used at k-th position in a solution */
var x {j in V, k in 1..max{i in 1..n} length(s[i])} binary;

/* 1 iff Hamming distance between x and substr(s[i],k,m) <= d_h */
var y {i in 1..n, k in 1..length(s[i])-m+1} binary;

var d_h >= 0 integer;

minimize Hamming_distance: d_h;

/* exactly one symbol in V is selected at each posiiton k */
subject to first {k in 1..m}: sum{j in V} x[j,k] = 1;

/* force x to satisfy Hamming_distance(x,ss) <= d_h for at least one
length-m substring ss = substring(s[i], k,m) of s[i] */


data;
param n:= 3;
param s :=
1 "ACGTCA"
2 "TTAC"
3 "CCGC";
param m := 2;

end;
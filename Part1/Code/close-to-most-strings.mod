/* close to most of n strings of length m */

param n > 0 integer;
param s {i in 1..n} symbolic;
param m > 0 integer default min {i in 1..n} length(s[i]);
param k_c > 0 integer;

set V := setof {i in 1..n,k in 1..m} substr(s[i],k,1);

# 1 iff nucleotide j is used at k-th position in the solution
var x {j in V,k in 1..m} binary;

# 1 iff Hamming distance between x and s[i] <= k_c
var y {i in 1..n} binary;

maximize target: sum {i in 1..n} y[i];

# exactly one nucleotide in V is selected at each position

subject to first {k in 1..m}: sum {j in V} x[j,k] = 1;

# the Hamming distance between the selected nucleotides x and each string s[i] lies within k_c

subject to second {i in 1..n}: k_c + sum {j in 1..m} x[substr(s[i],j,1),j] >= m*y[i];

end;

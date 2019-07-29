param n > 0 integer;
param s {i in 1..n} symbolic;
param m > 0 integer;

set V {k in 1..m} := setof {i in 1..n} substr(s[i],k,1);

var v {k in 1..m,j in V[k]} binary;
var h >= 0 integer;

minimize hamming_distance: h;

subject to first {k in 1..m}: sum {j in V[k]} v[k,j] = 1;

subject to second {i in 1..n}:
  m - sum {k in 1..m} v[k,substr(s[i],k,1)] <= h;

solve;

for {i in 1..n} { printf s[i]; printf "\n"; }
for {k in 1..m} printf "-"; printf "\n";
for {k in 1..m,j in V[k]: v[k,j] != 0} printf j; printf "\n";

end;

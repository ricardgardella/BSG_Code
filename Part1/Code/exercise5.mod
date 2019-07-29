param n > 0 integer;
param m > 0 integer;

# create a random set of strings
param CHARS symbolic := "ACTG";
param s {i in 1..n, j in 1..m} symbolic := substr(CHARS, ceil(Uniform(0,4)), 1);

# set of possible values for each position of the solution string
set V {j in 1..m} := setof {i in 1..n} s[i,j];

# this indicates the char in each position
var v {k in 1..m, j in V[k]} binary;

# Hamming distance
var h >= 0 integer;

minimize hamming_distance: h;

subject to OneCharPerPosition {k in 1..m}:
    sum {j in V[k]} v[k,j] = 1;

subject to Hamming {i in 1..n}:
    h >= m - sum{k in 1..m} v[k, s[i,k]];



# display the random strings generated
#for {i in 1..n} {
#    printf "\n";
#    for {j in 1..m} printf s[i,j];
#}

#for {k in 1..m} printf "-"; printf "\n";
#for {k in 1..m, j in V[k]: v[k,j] != 0} printf j;
#printf "\n";

data;
param n := 100;
param m := 300;
solve;
end;

/* SOLVERS TO USE:

We can see that there is a big difference between commercial and free solvers. The commercial solvers do the work faster than the free solvers. That makes sense that why a lot of companies spend a lot of money in buying licenses for commercial solvers instead of using the free ones, specially if you are working with very complex models. In this case AMPL is the fastest solver.

All the computations have been done in a 2013 MacBook Pro Retina Display with the following characteristics:
	-2,4 GHz Intel Core i7
	-8 GB 1600 MHz DDR3
	-Intel HD Graphics 4000 1536 MB
		

- GLPK simplex optimizer 
		-(2s) n = 20 m=44
		-(95.9) n=50 m=50
		-(42.5) n=2 m=100000
		-(13.2) n=15 m=1000
		-(1000s+) n=20 m=1000
		-(1000s+) n=20 m=500
		-(70.2) n=20 m=255
		-(11.7) n=20 m=100
		-(971.8) n=20 m=300
		-(1000s+) n=100 m=300
- AMPL 
		-(0s) n=20 m= 255
		-(0s) n=20 m=300
		-(5s) n=200 m=500
		-(10s) n=500 m=500
		-(120s) n=1000 m=500
		-(171s) n=1000 m=500
		-(243s) n=1000 m=700
- CPLEX
		-(0s) n=20 m= 255
		-(0s) n=20 m=300
		-(1000s+) n=200 m=500
		-(3s) n=2 m=100000
		-(1s) n=15 m=1000
		-(1000s+) n=20 m=1000
		-(1000s+) n=20 m=500
		-(1s) n=20 m=255
		-(1s) n=20 m=100
		-(1s) n=20 m=300
		-(1000s+) n=100 m=300
- GUROBI
		-(0s) n=20 m= 255
		-(0s) n=20 m=300
		-(1000s+) n=200 m=500
		-(10s) n=500 m=500
		-(120s) n=1000 m=500
		-(171s) n=1000 m=500
		-(243s) n=1000 m=700
COMENTARI AL FINAL D'AQUEST FITXER MATEIX
POSAR UNA TAULA DE VALORS AMB EL TAMANY DEL PROBLEMA I EL TEMPS DE RESOLUCIO
AL FINAL COMENTAR DIFERENCIES ENTRE COMERCIAL I FREE, 
PROVAR QUE PASSA SI EXTREUS EL MODEL
*/
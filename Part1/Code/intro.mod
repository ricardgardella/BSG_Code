set ING;
set PROD;

# parameters
param profit { PROD };
param supply { ING };
param amt { ING, PROD };

# variables
var x { PROD } >= 0;

# objective function
maximize TotalProfit:
	sum {p in PROD} profit[p]*x[p];
	
 # constraints
 subject to SupplyLimit {i in ING}:
 	sum {p in PROD} amt[i,p]*x[p] <= supply[i];
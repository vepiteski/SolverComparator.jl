param n := 128;
param eps := 0.0000000001;
param a{j in 0..n} := if j==0 then 0 else 0.5;
param b{j in 0..n} := if j==1 then 1 else 0.5;
param C=4./3.;
param x{j in 0..n}:= (5.)*(j/n);
var y {j in 0..n} ;

param dx {j in 1..n} := (x[j] - x[j-1]);
var dy {j in 1..n} = (y[j] - y[j-1]);
var s{j in 1..n} =  sqrt(dx[j]^2 + dy[j]^2);

#var f {j in 1..n} = sqrt( (dx[j]^2 + dy[j]^2)/((a[j-1]*y[j-1]+b[j]*y[j])) );
#var f {j in 1..n} = s[j] /(sqrt(max(y[j-1],eps))+sqrt(max(y[j],eps)));
var f {j in 1..n} = s[j] /(sqrt(y[j-1])+sqrt(y[j]));

minimize time: sum {j in 1..n} f[j] ;

subject to y0: y[0] = 0;
subject to yn: y[n] = 1;

let {j in 0..n} y[j] := x[j]/5.0;

write gbray; # produit bray.nl

#option solver snopt;

#solve;

#printf {j in 0..n}: "%10.5f %10.5f  \n", x[j], -y[j] > bcy.out;














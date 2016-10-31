param n := 128;
param eps := 0.001;

param xn := 5;  #  x final à atteindre
                #  y final == (-)1

var x {j in 0..n}:= xn*(j/n);
var y {j in 0..n}:= j/n ;

var dx {j in 1..n} = (x[j] - x[j-1]);
var dy {j in 1..n} = (y[j] - y[j-1]);

var s{j in 1..n} =  sqrt(dx[j]^2 + dy[j]^2);

var f {j in 1..n} = s[j] /(sqrt(y[j-1])+sqrt(y[j]));

#var f {j in 1..n} = s[j] /(sqrt(max(y[j-1],eps))+sqrt(max(y[j],eps)));
#var f {j in 1..n} = sqrt( (dx[j]^2 + dy[j]^2)/((0.5*y[j-1]+0.5*y[j])) );

#minimize time: sum {j in 1..n} (f[j] + eps*dx[j]^2) ;
minimize time: sum {j in 1..n} f[j] ;

subject to x0: x[0] = 0;
subject to x1: x[n] = xn;

subject to y0: y[0] = 0;
subject to y1: y[n] = 1;

write gbraxy; # produit braxy.nl

#option solver snopt;
#solve;

#printf {j in 0..n}: "%10.5f %10.5f  \n", x[j], -y[j] > bcxy.out;













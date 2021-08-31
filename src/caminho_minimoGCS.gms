* Author: Marcos Proenca
set i origem /A,B,C,D,E,F,G,H,I,J/
    conexoes(i,i) /A.B,
                  A.C,
                  A.D,
                  B.E,
                  B.C,
                  C.F,
                  C.D,
                  D.G,
                  E.F,
                  E.I,
                  F.H,
                  F.G,
                  I.J,
                  I.H,
                  H.G,
                  H.J,
                  G.J/
;

alias(i,j,k);

parameter d(i,j)
/
A.B 90,
A.C 138,
A.D 348,
B.E 84,
B.C 66,
C.F 90,
C.D 156,
D.G 48,
E.F 120,
E.I 84,
F.H 60,
F.G 132,
I.J 126,
I.H 132,
H.G 48,
H.J 126
G.J 150
/
variables x(i,j),z;
binary variables x;
equations
FO funçao objetivo
R1
R2
R3
;

FO..     z =e= sum((i,j),d(i,j)*x(i,j));
R1..     sum(conexoes('A',j), x('A',j)) =e= 1;
R2..     sum(conexoes(i,'J'), x(i,'J')) =e= 1;
R3(j)${ord(j) gt 1 and ord(j) <> card(j)}..
         sum(conexoes(i,j), x(i,j)) - sum(conexoes(j,k), x(j,k)) =e= 0;



Model caminhominimo /all/;
solve caminhominimo using mip minimizing z;

display z.l, x.l;

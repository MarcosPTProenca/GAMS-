variables x1,x2,z;

positive variables x1,x2;

equations
         FO funçao objetivo
         restricao1
         restricao2;
FO..             z=e=3*x1+4*x2;
restricao1..     2*x1+3*x2=g=8;
restricao2..     5*x1+2*x2=g=12;

model exercicio1 /all/;
solve exercicio1 using lp minimizing z;
display x1.l,x2.l,z.l;


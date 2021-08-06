variables x1,x2,x3,z;

positive variables x1,x2,x3;

equations
         FO funçao objetivo
         restricao1
         restricao2
         restricao3;
FO..             z=e=0.56*x1+0.81*x2+0.46*x3;
restricao1..     4*x1+2*x2+5*x3=g=0.3;
restricao2..     0.6*x1+0.2*x2+0.4*x3=g=0.5;
model exercicio1 /all/;
solve exercicio1 using lp minimizing z;
display x1.l,x2.l,x3.l,z.l;


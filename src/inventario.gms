Sets items / p1*p4 /
     periods / t1*t5 /;

Parameter cap(periods);
cap(periods) = 70;

Parameter pt(items) tempo de producao;
pt(items) = 1;

Parameter hc(items) custo de inventario
/ p1 3
  p2 2
  p3 4
  p4 3
/;

Parameter st(items) set up time
/ p1 10
  p2 20
  p3 30
  p4 20
/;

Parameter sc(items) set up cost
/ p1 300
  p2 400
  p3 600
  p4 500
/;

table d(items,periods)
         t1      t2      t3      t4      t5
p1       10      0       20      30      10
p2       20      0       15      30      10
p3       0       10      0       5       30
p4       10      0       30      0       10
;

Free variable z;
positive variables  I(items,periods),q(items,periods);
Binary variable x(items,periods);
Equations
         FO
         R1
         R2
         R3;

FO..                    z =e= sum((items,periods), sc(items) * x(items,periods)+ I(items,periods) * hc(items));
R1(items,periods)..     I(items,periods)=e=I(items,periods-1) + q(items,periods) - d(items,periods);
R2(items,periods)..     q(items,periods)*pt(items) =l= cap(periods) * x(items,periods);
R3(periods)..           sum(items, q(items,periods)* pt(items)) =l= cap(periods);

Option limrow = 100, optcr = 0, decimals = 0;

model t /all/;
solve t using mip minimizing z;
display x.l,I.l,q.l,z.l;




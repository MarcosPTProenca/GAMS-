$title An optimization approach for the lot sizing and scheduling problem in the brewery industry from Baldo et al. (2014)

$onText
This is a MIP (Mixed Integer Problem) and GLSP (General Lot Sizing and Scheduling Problem)
that aims to minimize the costs of inventory, backlog and changeovers on the brewery industry.
It is based on the paper Baldo et al. (2014) and it is implemented here for educational purposes
for the subject Operational Research II of the college Unicamp-BR.
@Author: Marcos Proenca
$offText

SETS i items N /i1*i3/
     l liquids L /l1,l2/
     m bottling kegging canning lines M /m1,m2/
     o tanks O /o1*o8/
     t periods T (T = T1 U T2)/t0*t12/
     tt(t) subset of periods used in R2/t1*t12/
     t1(t) periods of the first stage T1 /t1*t3/
     t2(t) periods of the second stage T2 /t4*t12/
     p subperiods p of period t /p0*p18/
     p1(p) subperiods p1 of periods of T1 (first stage) /p1*p9/
     p2(p) subperiods p2 of period of T2 (second stage) /p10*p18/
     pt(p,t) corresponding subperiods for each period lambda t
             /(p1*p3).t1,
              (p4*p6).t2,
              (p7*p9).t3,
               p10.t4,
               p11.t5,
               p12.t6,
               p13.t7,
               p14.t8,
               p15.t9,
               p16.t10,
               p17.t11,
               p18.t12/
     yl(l,i) items made of liquid l
             /l1.i1,
              l1.i3,
              l2.i2/
     um(m,i) items that can be produced on filling line m
             /m1.i2,
              m1.i3,
              m2.i1/
;
ALIAS (j,i);
ALIAS (l,lx);
ALIAS (t,tx);

PARAMETER delta(l) number of periods required for processing liquid l
/
l1       2
l2       3
/
;
TABLE d(i,t) demand for item i in period t
         t1      t2      t3      t4      t5      t6      t7      t8      t9      t10     t11     t12
i1       100     200     500     0       0       500     0       0       0       500     0       500
i2       0       50      100     0       0       700     0       0       0       500     0       800
i3       0       250     700     200     0       0       0       800     0       800     0       1000
;
PARAMETER h1(i) inventory cost for one unit of item i over one time period
/
i1       0.02939
i2       0.01600
i3       0.03100
/
;
PARAMETER h2(i) backlogging cost for one unit of item i over one time period (100 x h1)
/
i1       2.939
i2       1.600
i3       3.100
/
;
TABLE a(m,i) production time of one unit of item i on filling line m
         i1      i2      i3
m1       0       0.56    0.6
m2       0.543   0       0
;
PARAMETER C(m,t) total bottling kegging canning line m time capacity in period t
/
m1.(t1*t12)        500
m2.(t1*t12)        500
/
;
TABLE r(l,i) quantity of liquid l necessary for the production of one unit of item i
    i1   i2   i3
l1  5    0    7
l2  0    4    0
;
PARAMETER b(m,j,i) setup time of filling line m due to the changeover from item j to i
/
m1.i1.i1 = 0
m1.i1.i2 = 0
m1.i1.i3 = 0
m1.i2.i1 = 0
m1.i2.i2 = 0
m1.i2.i3 = 91
m1.i3.i1 = 0
m1.i3.i2 = 92
m1.i3.i3 = 0

m2.i1.i1 = 0
m2.i1.i2 = 0
m2.i1.i3 = 0
m2.i2.i1 = 0
m2.i2.i2 = 0
m2.i2.i3 = 0
m2.i3.i1 = 0
m2.i3.i2 = 0
m2.i3.i3 = 0
/
;
PARAMETER capmax(o) maximum capacity of tank o
/
o1       1000
o2       3000
o3       3000
o4       3000
o5       1000
o6       1000
o7       1000
o8       1000
/
;
PARAMETER capmin(o) lower bound on the amount of liquid in tank o (0.1 x capmax)
/
o1       100
o2       300
o3       300
o4       300
o5       100
o6       100
o7       100
o8       100
/
;

*Display of the parameters
DISPLAY delta, d, h1, h2, c, r, b, capmax, capmin;

SCALAR omega maximum number of preparations in each filling line in period t /3/;
SCALAR alfa sufficiently small number /0.0001/;
SCALAR beta sufficiently large number /999999/;

FREE variable W;
* Stage 1
POSITIVE variable K(o,l,t) amount of ready liquid l available in tank o in period t ;
POSITIVE variable Q(o,l,t) total amount of liquid l that gets ready in tank o in period t;
BINARY variable Y1(o,l,t) 1 if liquid l gets ready in period t in tank o and 0 otherwise;
* Stage 2
POSITIVE variable I1(i,t) inventory of item i at the end of period t;
POSITIVE variable I2(i,t) backlog of item i at the end of period t;
POSITIVE variable Z(m,j,i,p) 1 if there is a changeover on filling line m from item j to i in subperiod p and 0 otherwise;
BINARY variable Y2(o,m,i,p) 1 if tank o supplies ready liquid to filling line m in subperiod p and the line is set up for item i and 0 otherwise;
* Common to both stages
POSITIVE variable X(o,m,i,p) amount of item i produced on filling line m in period p made of liquid fed by o;

EQUATIONS
FO objective function: minimize the sum of inventory backlog and changeover costs - equivalent to (1) in the paper
R1 control the quantity of liquid in each tank - equivalent to (2) in the paper
R2 preparation of the liquids - equivalent to (3) in the paper
R3 ensure that the tanks have no available liquid during any period of the fermentation process - equivalent to (4) in the paper
R4 impose boundaries on the minimum amount of ready liquid - equivalent to (5) in the paper
R5 impose boundaries on the maximum amount of ready liquid - equivalent to (5) in the paper
R6 balance the inventory and backlog according to production and demand - equivalent to (6) in the paper
R7 ensure that the limited capacity of filling lines is respected - equivalent to (7) in the paper
R8 garantee that the production of items occurs only when the filling line is ready - equivalent to (8) in the paper
R9 ensure that the filler must be prepared for a single item for each subperiod - equivalent to (9) in the paper
R10 limit the number of preparations of the filler in every subperiod in T2 - equivalent to (10) in the paper
R11 balance the flow in and the flow out setups in each filling lines by capturing the changeovers - equivalent to (11) in the paper
R12 balance the flow in and the flow out setups in each filling lines by capturing the changeovers - equivalent to (12) in the paper
;

* There is no ready liquid at the start of the planning horizon
K.FX(o,l,'t0') = 0;
* There is no inventory of items at the start of the planning horizon
I1.FX(i,'t0') = 0;
* There is no backlog of items at the start of the planning horizon
I2.FX(i,'t0') = 0;
* To ensure that all demand is satisfied in the planning horizon
I2.FX(i,'t12') = 0;
* Initially adjusted variables (different for each instance)
Y1.FX(o,'l1','t1') = 0;
Y1.FX(o,'l2','t1') = 0;
Y1.FX(o,'l2','t2') = 0;

FO..             W =e= sum((i,t), h1(i)*I1(i,t)) + sum((i,t), h2(i)*I2(i,t))
                 + sum((m,j,i,pt(p,t1))$[um(m,i) and um(m,j)], alfa*Z(m,j,i,p));
* Stage 1 and 2
R1(o,l,t)..      K(o,l,t) =e= K(o,l,t-1) + Q(o,l,t)
                 - sum((m,i,pt(p,t))$[yl(l,i)*um(m,i)], r(l,i)*X(o,m,i,p));
* Stage 1
R2(o,l,t)..      sum((lx,tt)$[ord(tt) le (delta(l)+1)],K(o,lx,t-ord(tt))) =l= beta*(1-Y1(o,l,t));
R3(o,t)..        sum((l,tx)$[ord(tx) le (delta(l)+1)],Y1(o,l,t+(1-ord(tx)))) =l= 1;
R4(o,l,t)..      capmin(o)*Y1(o,l,t) =l= Q(o,l,t);
R5(o,l,t)..      capmax(o)*Y1(o,l,t) =g= Q(o,l,t);
* Stage 2
R6(t,i)..        sum((o,m,pt(p,t))$[um(m,i)], X(o,m,i,p)) + I1(i,t-1) + I2(i,t)
                 =e= d(i,t) + I2(i,t-1) + I1(i,t);
R7(t,m)..        sum((j,i,pt(p,t))$[um(m,i) and um(m,j) and p1(p)], b(m,j,i)*Z(m,j,i,p))
                 + sum((o,i,pt(p,t))$[um(m,i)], a(m,i)*X(o,m,i,p)) =l= C(m,t);
R8(o,m,i,pt(p,t))$[um(m,i)]..
                 X(o,m,i,p) =l= (C(m,t)/a(m,i))*Y2(o,m,i,p);
R9(m,pt(p,t1)).. sum((o,i)$[um(m,i)], Y2(o,m,i,p)) =e= 1;
R10(m,pt(p,t2))..sum((o,i)$[um(m,i)], Y2(o,m,i,p)) =l= omega;
R11(m,j,pt(p,t1))$[um(m,j)]..
                 sum(o, Y2(o,m,j,p-1)) =e= sum(i$[um(m,i)],Z(m,j,i,p));
R12(m,i,pt(p,t1))$[um(m,i)]..
                 sum(o, Y2(o,m,i,p)) =e= sum(j$[um(m,j)],Z(m,j,i,p));

OPTION limrow = 100000;
OPTION optcr = 0, decimals = 0;
MODEL trabalhofinal /all/;
SOLVE trabalhofinal using mip minimizing w;
DISPLAY W.l, K.l, Q.l, Y1.l, I1.l, I2.l, Z.l, Y2.l, X.l;

* Other ways to visualize the results
PARAMETER plan(*,*,*) a way to visualize and compare the production inventory backlog and demand of each item in each period;
loop((t),
  plan("Production",i,t) = sum((p,o,m)$[pt(p,t)],X.l(o,m,i,p));
  plan("Inventory",i,t) = I1.l(i,t);
  plan("Backlog",i,t) = I2.l(i,t);
  plan("Demand",i,t) = d(i,t);
);
PARAMETER tank(*,*,*) all liquid produced and consumed in each period in all tanks;
loop((t),
  tank("Q",l,t) = sum(o,Q.l(o,l,t));
  tank("K",l,t) = sum(o,K.l(o,l,t));
);
PARAMETER items_produced(*,*,*,*) quantity of items that can be produced using the liquids in each tank;
loop((t,l)$[ord(t) gt 1],
  items_produced("Q",o,i,t)$[yl(l,i)] = Q.l(o,l,t)/r(l,i);
  items_produced("K",o,i,t)$[yl(l,i)] = K.l(o,l,t)/r(l,i);
);
DISPLAY plan,tank, items_produced;




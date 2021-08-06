set k veiculos /car1,car2,car3/;
set i localidade /0*10/;
alias(j,i,h);
parameter cordx(i)
/
0       50
1       16
2       23
3       40
4       9
5       97
6       78
7       20
8       71
9       64
10      50
/
;

parameter cordy(i)
/
0       50
1       32
2       1
3       65
4       77
5       71
6       24
7       26
8       98
9       55
10      50
/
;

parameter demand(i)
/
1       11
2       35
3       2
4       9
5       3
6       18
7       8
8       10
9       11
/
;

parameter tA(i)
/
0       0
1       45
2       11
3       25
4       20
5       15
6       50
7       10
8       40
9       10
10      0
/
;

parameter tB(i)
/
0       0
1       70
2       145
3       40
4       100
5       80
6       190
7       110
8       190
9       45
10      400
/
;

parameter Q(k)
/
car1       60
car2       60
car3       60
/
;

parameter dist(i,j);
dist(i,j)= sqrt((abs(cordx(j) - cordx(i)))**2 + (abs(cordy(j) - cordy(i)))**2);
parameter custo_transp(i,j);
custo_transp(i,j)=dist(i,j);

parameter t(i,j,k);
loop (k,
 t(i,j,k) = dist(i,j);
);
scalar tmax /400/;
free variable z;
BINARY VARIABLE x(i,j,k);
positive variable W(i,k);
positive variable u(i,k);

U.fx('0',k)=0;

EQUATIONS
   fo
   R1
   R2
   R3
   R4
   R5
   R6
   R7
   R8
;

fo..          z =e= sum((i,j,k)$[ord(i)<>ord(j) and ord(i) <> card(i) and ord(j) gt 1], dist(i,j) * x(i,j,k));
R1(i)${ord(i) gt 1 and ord(i) ne card(i)}..
                 sum((k,j)${ord(j) gt 1 and ord(i)<>ord(j)}, x(i,j,k))=e=1;
R2(k)..          sum(i${ord(i) gt 1 and ord(i) < card(i)},demand(i)
                 *sum(j${ord(j) gt 1 and ord(i) <> ord(j)},x(i,j,k)))=l=Q(k);
R3(k)..          sum(j$[ord(j) gt 1 and ord(j) <> card(j)],x('0',j,k))=e=1;
R4(h,k)$[ord(h) > 1 and ord(h) < card(h)]..
                 sum((i)${ord(i) < card(i) and ord(h) <> ord(i)},x(i,h,k))
                 =e=sum((j)${ord(j) gt 1 and ord(h) <> ord(j)},x(h,j,k));
R5(k)..        sum(i$[ord(i)<> card(i) and ord(i) gt 1],x(i,'10',k))=e=1;
R6(i,j,k)$(ord(j)>1 and ord(i)<>ord(j) and ord(i) <> card(i))..
                 u(j,k) =g= u(i,k) + demand(j)*x(i,j,k) + Q(k)*(x(i,j,k)-1);
R7(k,i)$(ord(i) eq 1).. sum(j$(ord(j) ne 1), x(i,j,k)) =e= 1;
R8(k,j)$(ord(j) eq card(j))..    sum(i$(ord(i) ne card(i)), x(i,j,k)) =e= 1;

MODEL vrp /all/;
OPTIONS OPTCR=0;
SOLVE vrp USING mip minimizing z;
Display z.l, x.l;



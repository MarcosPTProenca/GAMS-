* Author: Marcos Proenca

SETS
   i cidades /0*20/

ALIAS (i,j);

PARAMETER cordx(i)
/
0 4
1 0
2 0
3 1
4 1
5 2
6 2
7 3
8 3
9 3
10 4
11 5
12 5
13 5
14 6
15 6
16 6
17 7
18 7
19 7
20 8
/

cordy(i)
/
0 3
1 0
2 4
3 2
4 7
5 3
6 5
7 1
8 4
9 7
10 6
11 1
12 3
13 7
14 1
15 5
16 7
17 3
18 4
19 6
20 5
/
;
PARAMETER d(i,j);
d(i,j)= sqrt((abs(cordx(j) - cordx(i)))**2 + (abs(cordy(j) - cordy(i)))**2);
display d;

VARIABLES
   x(i,j)   1 se a rota vai de i para j imediatamente e 0 caso contrario
   z        distancia total percorrida
   u(i);

BINARY VARIABLE x;

EQUATIONS
   custo           funcao objetivo
   restr_suc(i)    garante que cada cidade i tem uma unica cidade sucessora
   restr_antec(j)  garante que cada cidade j tem uma unica cidade antecessora
   rest_subtour(i,j) garante a nao existencia de subrotas
;

custo..              z =e= sum((i,j) $ {ord(i)<>ord(j)}, d(i,j) * x(i,j) );
restr_suc(i)..       sum(j${ORD(j) <> ORD(i)}, x(i,j) ) =e= 1;
restr_antec(j)..     sum(i${ORD(i) <> ORD(j)}, x(i,j) ) =e= 1;
rest_subtour(i,j)$[ord(j) > 1 and ord(i) <> ord(j)]..    u(j) =g= u(i) + x(i,j) + card(i)*(x(i,j)-1);

MODEL caixeiro /all/;
SOLVE caixeiro USING mip minimizing z;

DISPLAY z.l, x.l;


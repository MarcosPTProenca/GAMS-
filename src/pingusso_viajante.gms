Sets i /  FCA, "Bar Praia", "Fuxico Bar"
          Esquenta,    "Abridor Bar"
          "Bar do Pimenta",    "Nosso Boteko"
          "Bar da Montanha",   "Rota 66"
/;

Alias(i,j);


Table dist(i,j)

                    FCA       "Bar Praia"   "Fuxico Bar"     Esquenta    "Abridor Bar"    "Bar do Pimenta"   "Nosso Boteko"    "Bar da Montanha"    "Rota 66"
FCA                           162           379             765         1590              2430               3070              5020                377
"Bar Praia"         162                     215             600         1540              2260               2900              5120                537
"Fuxico Bar"        378.5      215                          392         1520              2060               2690              5060                752
Esquenta            765        600          392                         1450              1650               2300              4820                1130
"Abridor Bar"       1590       1540        1520             1450                          2280               2770              3620                1680
"Bar do Pimenta"    2430       2260        2060             1650        2280                                 642               4420                2780
"Nosso Boteko"      3070       2900        2690             2300        2770              642                                  4360                3420
"Bar da Montanha"   5020       5120        5060             4820        3620              4420               4360                                  5310
"Rota 66"           377        537         752              1130        1680              2780               3420              5310
;
display dist;

VARIABLES
   x(i,j)   1 se a rota vai de i para j imediatamente e 0 caso contrario
   z        distancia total percorrida
   u(i);
positive variable S;

* Definir as variaveis como binarias
BINARY VARIABLE x;

* Definir a funcao objetivo e as restricoes do problema
EQUATIONS
   custo           funcao objetivo
   restr_suc    garante que cada cidade i tem uma unica cidade sucessora
   restr_antec  garante que cada cidade j tem uma unica cidade antecessora
   rest_subtour
;

custo..              z =e= sum( (i,j), dist(i,j) * x(i,j) );
restr_suc(i)..       sum( j${ORD(j) <> ORD(i)}, x(i,j) ) =e= 1;
restr_antec(j)..     sum( i${ORD(i) <> ORD(j)}, x(i,j) ) =e= 1;
rest_subtour(i,j)$(ord(j)>2 and ord(i)<>ord(j) and ord(i) < card(i))..  u(i)-u(j)+card(i)*x(i,j)=l=card(i)-1;


MODEL caixeiro /all/;
SOLVE caixeiro USING mip minimizing z;

Display z.l, x.l;

sets
         i origem / o1,o2,o3 /
         j destino / d1,d2,d3,d4,d5 / ;

parameters
         a(i) capacidade do produto
         / o1    3000
           o2    5000
           o3    4000 /
         b(j) demanda do produto
         / d1    500
           d2    2000
           d3    3000
           d4    2000
           d5    900 / ;
table c(i,j) custo de transporte de cada unidade de produto
                 d1      d2      d3      d4      d5
         o1      20      30      10      50      15
         o2      30      15      20      35      10
         o3      10      25      40      20      55

table d(i,j) distancia de transporte para cada cidade
                 d1      d2      d3      d4      d5
         o1      15      30      80      100     70
         o2      60      50      30      45      55
         o3      55      20      25      70      35


variables
x(i,j) quantidade de produtos enviados
y(i)
z custo total de transporte dos produtos ;

positive variable x;
binary variable y;

equations
         FO funçao objetivo
         oferta(i)
         local(j)
         demanda(j);

FO..             z =e= sum((i,j),y(i)*d(i,j))+sum((i,j),y(i)*c(i,j)*x(i,j));
local(j)..       sum(i,y(i))=e=2;
oferta(i)..      sum(j, x(i,j)) =e= a(i)*y(i);
demanda(j)..     sum(i, x(i,j)) =l= b(j);

Model transporte /all/;
solve transporte using minlp minimizing z;

display y.l,x.l,z.l;

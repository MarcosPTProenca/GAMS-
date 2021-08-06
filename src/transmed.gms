sets
         i origem /bh,sp,rj/
         j destino /c1,c2,c3,c4,c5,c6,c7,c8/ ;

parameters
         cap(i)  capacidade de produçao
         /       bh      1300
                 sp      1200
                 rj      2000 /
         d(j)    demanda anual de produtos
         /       c1      200
                 c2      200
                 c3      200
                 c4      200
                 c5      300
                 c6      300
                 c7      300
                 c8      500 /
         c(i) custo de instalçao da fabrica
         /       bh      55000
                 sp      40000
                 rj      60000 /      ;

table cust(i,j) custo de transporte entre localidades

                 c1      c2      c3      c4      c5      c6      c7      c8
         bh      4       5       5       3.5     3       4.2     3.3     5.5
         sp      2.5     3.5     4.5     3       2.2     4       3.2     5
         rj      2       4       4.8     2.5     2.6     3.8     3.5     5
                                                                             ;
variables
         x(i,j) quantidade de cada produto
         y(i) variavel que decide a localidade da fabrica
         z custo total;
binary variable y;
positive variable x;

equations
         FO funçao objetivo
         medianas(j) quantidade medianas
         oferta(i) capacidade de oferta
         demanda(j) quantidade demandada;

FO..             z=e=sum(i, y(i)*c(i))+sum((i,j),cust(i,j)*x(i,j));
medianas(j)..        sum(i, y(i))=l=2;
oferta(i)..          sum(j, x(i,j))=l=cap(i)*y(i);
demanda(j)..         sum(i, x(i,j))=g=d(j);

model transmed /all/

solve transmed using minlp minimizing z;
display y.l,z.l,x.l;



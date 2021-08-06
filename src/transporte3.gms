*definicao de conjuntos
set i origem /ara, sjc/
    j destino /sp, bh, rj/
;

*definicao de parametros (dados)

parameter a(i) oferta de i
/ ara    800
  sjc    1000
/
;

parameter d(j) demanda de j
/ sp     500
  bh     400
  rj     900
/
;
table c(i,j) custo de transporte de i para j
        sp      bh      rj
ara     4       2       5
sjc     11      7       4

;

*declaracao das variaveis de decisao
free variable z;
positive variables x(i,j);

*declaracao das equacoes
equations
fo
r1_oferta
r2_demanda
;

fo.. z=e= sum((i,j), c(i,j)* x(i,j));
r1_oferta(i).. sum(j, x(i,j)) =l= a(i);
r2_demanda(j).. sum(i, x(i,j)) =e= d(j);

model transporte /all/ ;
solve transporte using lp minimizing z;
display x.l,z.l;

variables z,x1,x2,x3;
positive variables x1,x2,x3;

equations
         FO
         R1
         R2;

FO..     z=e=5*x1+3*x2+x3;
R1..     2*x1+2*x2+x3=g=8;
R2..     3*x1+x2+2*x3=g=6;


model q1 /all/ ;
solve q1 using lp minimizing z;
display z.l,x1.l,x2.l,x3.l;

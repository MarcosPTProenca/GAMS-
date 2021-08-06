set i origem /1,2,3,4,5,6,7/;

alias(i,j);

parameter a(i,j)
          /1.2   15, 1.3     20
           2.4   10, 2.5     25
           3.4   15, 3.6     20
           4.5   20, 4.6     15, 4.7     30
           5.7   10
           6.7   20/;

variables x(i,j),z;
binary variables x;
equations
         FO funçao objetivo
         R1
         R2
         R3
         R4
         R5
         R6
         R7 ;

FO ..                z =e= sum((i,j),a(i,j)*x(i,j));
R1..             x('1','2')+x('1','3')=e=1;
R2..             -x('1','2')+x('2','4')+x('2','5')=e=0;
R3..             -x('1','3')+x('3','4')+x('3','6')=e=0;
R4..             -x('2','4')-x('3','4')+x('4','5')+x('4','6')+x('4','7')=e=0;
R5..             -x('2','5')-x('4','5')+x('5','7')=e=0;
R6..             -x('3','6')-x('4','6')+x('6','7')=e=0;
R7..             -x('4','7')-x('5','7')-x('6','7')=e=-1;


Model caminhominimo /all/;
solve caminhominimo using mip minimizing z;

display x.l,z.l;



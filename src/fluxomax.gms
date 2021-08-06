set i origem /1,2,3,4,5,6,7/;

alias(i,j);

parameter a(i,j)
          /1.2   40, 1.3     40
           2.4   10, 2.5     10
           3.4   15, 3.6     20
           4.5   20, 4.6     10, 4.7     10
           5.7   30
           6.7   20/;

variables x(i,j),z,F;

equations
         FO funçao objetivo
         R1(j)
         R2(j)
         R3(j)
         R4(j)
         R5(j)
         R6(j)
         R7(j)
         R8(i,j);

FO..                z =e=F;
R1(j)..             x('1','2')+x('1','3')=e=F;
R2(j)..             -x('1','2')+x('2','4')+x('2','5')=e=0;
R3(j)..             -x('1','3')+x('3','4')+x('3','6')=e=0;
R4(j)..             -x('2','4')-x('3','4')+x('4','5')+x('4','6')+x('4','7')=e=0;
R5(j)..             -x('2','5')-x('4','5')+x('5','7')=e=0;
R6(j)..             -x('3','6')-x('4','6')+x('6','7')=e=0;
R7(j)..             -x('4','7')-x('5','7')-x('6','7')=e=-F;
R8(i,j)..            x(i,j)=l=a(i,j);


Model fluxomax /all/;
solve fluxomax using mip maximizing z;

display x.l,z.l;



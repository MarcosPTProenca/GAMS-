
set i /A,B,C,D,E/
;
alias(i,j,k);

table peso(i,j)
        A       B       C       D       E
A               1       2
B       1               3       4
C       2       3               5       6
D               4       5               7
E                       6       7

;

variable z;
variable x(i,j);
binary variable y(i,j);

equations

         FO
         R1
         R2

;

FO..     z=e=sum((i,j),y(i,j)*peso(i,j));
R1(j)..   sum(i$(ord(i)<>ord(j)),x('A',j))=e=card(i)-1;
R2(i)..       sum(j, x(i,j))-sum((j,k),x(j,k)) =e= 1;

Model mst /all/;
solve mst using mip minimizing z;
display z.l,x.l;

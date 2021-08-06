sets
         i /i1,i2,i3,i4/
         j /j1,j2,j3,j4/;
table   c(i,j)
                 j1      j2      j3      j4
         i1      5       8       6       3
         i2      9       7       10      10
         i3      3       8       12      8
         i4      6       2       7       6
variables x(i,j),z;

binary variable x;

equations
         jobs(i)
         maquinas(j)
         FO  ;

FO..             z=e=sum((i,j),c(i,j)*x(i,j));
maquinas(j)..    sum(i,x(i,j))=e=1;
jobs(i)..        sum(j,x(i,j))=e=1;

model designacao /all/
solve designacao using minlp minimizing z;
display z.l,x.l;




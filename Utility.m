n=48;
U1=zeros(n,1);
CC1=zeros(n,1);
a=0.5;
for i=1:n

 U1(i)=w(i)*X(i)-(a/2)*X(i)^2-lambda(i)*X(i);
 CC1(i)=lambda(i)*X(i);
end

U2=zeros(n,1);
CC2=zeros(n,1);
for i=1:n

 U2(i)=w(i)*B(i)-(a/2)*B(i)^2-lambda(i)*B(i);
 CC2(i)=lambda(i)*B(i);
end
sum (CC1)
sum (CC2)
sum (U1)
sum (U2)
plot (CC1)
hold on 
plot (CC2)
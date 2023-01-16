x=0:9;
n=10;
U1=zeros(n,1);
U2=zeros(n,1);
U3=zeros(n,1);
U4=zeros(n,1);
w=[1,2,3,4];
a=[0.5,0.5,0.5,0.5];
for i=1:10
    if 0<=x(i) && x(i)<=w(1)/a(1)
    U1(i)=w(1)*x(i)-(a(1)/2)*x(i)^2;
    end
    if x(i)>=w(1)/a(1)
    U1(i)=w(1)^2/(2*a(1));
    end
end
for i=1:10
    if 0<=x(i) && x(i)<=w(2)/a(2)
    U2(i)=w(2)*x(i)-(a(2)/2)*x(i)^2;
    end
    if x(i)>=w(2)/a(2)
    U2(i)=w(2)^2/(2*a(2));
    end
end
for i=1:10
    if 0<=x(i) && x(i)<=w(3)/a(3)
    U3(i)=w(3)*x(i)-(a(3)/2)*x(i)^2;
    end
    if x(i)>=w(3)/a(3)
    U3(i)=w(3)^2/(2*a(3));
    end
end
for i=1:10
    if 0<=x(i) && x(i)<=w(4)/a(4)
    U4(i)=w(4)*x(i)-(a(4)/2)*x(i)^2;
    end
    if x(i)>=w(4)/a(4)
    U4(i)=w(4)^2/(2*a(4));
    end
end
plot (U4)
hold on 
plot (U3,'r')
hold on
plot (U2,'g')
hold on 
plot (U1,'y')



 



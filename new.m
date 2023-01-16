close all
n=48; %Time slots 
Ta=30; %Time when user arrives home 
Td=16; %Time when user departures home 
M=100; %Total miles needed for daily consumption 
Nt=50; %Number of Tesla involved in this optimisation 
Cr=0.0035*Nt; %Maximum charge rate of Tesla/MW (single charger) per EV
Dr=0.002*Nt; %Maximum discharge rate/MW per EV
Er=M/2.85/1000*Nt; %Energy required for the usage/ MWh  per EV
Charge=zeros(n,1); %EV battery energy charging for daily travel
Discharge=zeros(n,1);  %EV battery energy discharging for daily travel
Tl=zeros(n,1); %Total load without V2H 
lb=xm; %vector of minimum demand for 48 time slots
ub=xM; %vector of maximum demand for 48 time slots
x0=0; %estimated initial value 
N=2606; %Number of electricity consumers  
options = optimset('Algorithm', 'interior-point'); %Selecting interior-point optimisation method
X=zeros(n,1); %Initialisation 
Lk=zeros(n,1); %Generation capacity under opitised consumptiuon 
lambda=zeros(n,1); %Price or Lagrangian multiplier 
MA=zeros(n,1); %Moving average 
MA1=zeros(n,1);
P=zeros(n,1); %Charging and discharging power of the battery 
B=zeros(n,1); %Load after power-load shaving 
E=zeros(n,1); %Energy storage level of the battery 
a=0.5;  %Parameter of utility function 
w=2/5*xM; % Parameter of consumer stisfaction towards to the specific electricty consumption
gama=0.025; %Step size 
lambda(1)=0.058; %Predicted initial value
e=0.95; %Battery efficiency (self discharging ratio within one hour and losses when charging or discharging and transpotation)
c=0.2; %Battery C-rate/ Mw/hour 
l=0.9; %Limitation of peak-load (Percentage)
C=85/1000*Nt; %Battery capacity/ MWh
E(1)=0.8*C; %The maximum depth of discharge
A=zeros(n,1); %Parameters of linear inequalities
b=zeros(n,1); %Parameters of linear inequalities
T1=zeros(n,1); %Upper bound based on price 
T2=zeros(n,1); %Lower bound based on price 
for i=1:n
    if xM(i)<w(i)/a %Find the Different intervals  to determine the corresponding maximum value;
[X(i)]=fmincon(@(x)myfun(x,w(i),lambda(i)),x0,[],[],[],[],lb(i),ub(i),[],options);%Find a constrained minimum of a function of several variables
    end
    if xm(i)>w(i)/a %Find the Different intervals  to determine the corresponding maximum value;
[X(i)]=xm(i);
    end
    if xm(i)<=w(i)/a&&xM(i)>=w(i)/a %Find the Different intervals  to determine the corresponding maximum value;
[X(i)]=w(i)/a;
    end
    for t=1:5%This loop is performed whilst the optimum price for the time period k is being found;
    [Lk(t)]=fmincon(@(Lk)myfun1(Lk,lambda(t)),0,[],[],[],[],lb(i),ub(i),[],options);
    lambda(t+1)=lambda(t)+gama*(X(i)-Lk(t));
    end

    Lk(i)=Lk(t);
    lambda(i+1)=lambda(t+1);
end
Ma= sum (lambda)/48; %Average value of price
Ma1= sum (X)/48; %Average value of demand
for i=1:48
    MA(i)=Ma; %Define the Moving Average;
    MA1(i)=Ma1; %Define the Moving Average;
end
XX=max(lambda)-MA(i); %Maximum point minus Moving average (price)
xx=min(lambda)-MA(i); %Minimum point minus Moving average (price)
XX1=max(X)-MA1(i); %Maximum point minus Moving average (demand)
xx1=min(X)-MA1(i); %Minimum point minus Moving average (demand)

for i=1:n
     if i==Td
        Discharge(i)=-1/4*Er; %Energy consumption for dialy travel 
        Discharge(i+1)=-1/4*Er;%Energy consumption for dialy travel 
    end
    if i==Ta-2
        Discharge(i)=-1/4*Er; %Energy consumption for dialy travel 
        Discharge(i+1)=-1/4*Er; %Energy consumption for dialy travel 
    end
    if i>Ta && E(i)<0.3*C %Battery starts charging when the energy level is lower than minimum state 
        Charge(i)=1/2*Cr;
    end
    Tl(i)=X(i)+Charge(i); %Load without V2H applied
    
    
    A(i)=1; %Parameters of linear inequalities
    b(i)=C-E(i);  %b(i) Battery Capacity constraint 
    E(i+1)=E(i)+P(i)+Discharge(i); %State of battery
    if (lambda(i)-MA(i))<xx*l && i<Td %Load control applied when total power consumption is lower the minimum limit 
   [P(i)]=fmincon(@(P)myfun2(P,MA1(i),X(i)),0,A(i),b(i),[],[],[],Cr,[],options); %Find the maximum value for P(i)
   E(i+1)=E(i)+P(i)+Discharge(i); %Redifine the value of energy state of battery 
    end
   if (lambda(i)-MA(i))>XX*l && i>Ta && E(i)>0.3*C %Load control applied when total power consumption is exceed the maximum limit
   [P(i)]=fmincon(@(P)myfun2(P,MA1(i),X(i)),0,[],[],[],[],-Dr,[],[],options);%Find the maximum value for P(i)
   E(i+1)=E(i)+P(i)+Discharge(i); %Redifine the value of energy state of battery 
   if E(i+1)<=0.3*C %Change the discharge from Model 1 to Model 2 
       P(i)=-(E(i)-0.3*C); 
       E(i+1)=E(i)+P(i)+Discharge(i);%Redifine the value of energy state of battery 
   end
   end
   B(i)=X(i)+P(i); %Power consumption after V2H technique applied 
   T1(i)=MA1(i)+l*XX1; %Upper bound (demand)
   T2(i)=MA1(i)+l*xx1; %Lower bound (demand)
end
plot (X,'--')
hold on
plot (lb,'g')
hold on
plot (ub,'g')
hold on
plot (B,'r')
hold on 
plot (T1,'y')
hold on 
plot (T2,'y')

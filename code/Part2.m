%ELEC 4700 MNA Building
%Narrthanan Seevananthan

%Equations in use:
%V = IR
%I = C(dV/dt)
%V = L(dI/dt)

clc;
clear;

%Component Values
R1 = 1;
Cap = 0.25;
R2 = 2;
L = 0.2;
R3 = 10;
alpha = 100;
R4 = 0.1;
RO = 1000;


G = zeros(8,8);
C = zeros(8,8);
F = zeros(8,1);

%populate the G matric individually by column
G(1,1) =  (1/R1);
G(2,1) =  -(1/R1);
G(6,1) = 1; 

G(1,2) =  -(1/R1);
G(2,2) = (1/R1) + (1/R2); 
G(7,2) = 1; 

G(3,3) = 1/R3; 
G(7,3) = -1; 
G(8,3) = -alpha/R3; 

G(4,4) = 1/R4; 
G(5,4) = 1/R4; 
G(8,4) =  (1); 

G(4,5) = -1/R4; 
G(5,5) = 1/R4 + 1/RO; 

G(1,6) = 1; 


G(2,7) = 1; 
G(3,7) = -1; 

G(4,8) = 1; 


%populate the C matric individually by row
C(1,1) =  Cap;
C(1,2) =  -(Cap);

C(2,1) = -Cap;
C(2,2) = Cap;
C(7,7) = (-L);

total_time = 1;
num_step = 1000;

dt = total_time/num_step;
V = zeros(8,1);

Vin = zeros(1,num_step);
Vin((0.03*num_step):num_step)=1;

non_lin = Cap./dt + G;


for t = 1:num_step
   F(6,1)=Vin(t);
   B = Cap*V(:,t)./dt + F;
   V(:,t+1) = non_lin\B;
end

figure(4)
subplot(2,1,1)
plot(V(1,:))
title('Vin (V) ')
xlabel('Time step ')
ylabel('Voltage (V)')

subplot(2,1,2)
plot(-V(5,:))
title('Vout (V) ')
xlabel('Time step ')
ylabel('Voltage (V)')


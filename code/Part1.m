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


Vin = -10:10;


%Differential Equations from left to right:
%N1:
% Ix1 - (VN1-VN2)/R1 - C*(d(VN1-VN2)/dt) = 0;
% VN1 = Vin;
% %Ix1 = current passing through Voltage source Vin
% 
% %N2:
% (VN1-VN2)/R1 + C*(d(VN1-VN2)/dt) - VN2/R2 - IL = 0;
% (VN2-VN3) = L*(dIL/dt);       shouldn't be an equation
% 
% %N3:
% IL - VN3/R3 = 0;
% I3 = VN3/R3;
% 
% %N4:
% Ix2 - (VN4-VN5)/R4 = 0;
% VN4 = alpha*I3;
% %Ix2 = current passing through current dependent voltage source @ N4
% 
% %N5:
% (VN4-VN5)/R4 - VN5/RO = 0;
% 
% 
% 
% %Differential Equations from left to right (Frequency Domain):
% %N1:
% Ix1 - (VN1-VN2)/R1 - C*(j*w*VN1(w) - j*w*VN2(w)) = 0;
% VN1 = Vin;
% %Ix1 = current passing through Voltage source Vin
% 
% %N2:
% (VN1-VN2)/R1 + C*(j*w*VN1(w)-j*w*VN2(w)) - VN2/R2 - IL = 0;
% (VN2-VN3) = L*(j*w*IL(w));    shouldn't be an equation
% 
% %N3:
% IL - VN3/R3 = 0;
% I3 = VN3/R3;
% 
% %N4:
% Ix2 - (VN4-VN5)/R4 = 0;
% VN4 = alpha*I3;
% %Ix2 = current passing through current dependent voltage source @ N4
% 
% %N5:
% (VN4-VN5)/R4 - VN5/RO = 0;  %VN5 = VO


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

G
C

%DC analysis
w=0;

vout=zeros(1,10);
v3 = zeros(1,10);
i=1

for Vin = -10:10
F(6,1) = Vin;

V = (G\F);
vout(1,i) = -V(5);
v3 (1,i) = V(3);
i=i+1;

end

figure (1)
hold on;
title('DC Sweep');
xlabel('Vin sweep from -10 to 10 (V)');
ylabel('Voltage at respective nodes(V)');
plot(v3);
plot(vout);
legend('node V3','node VO');

% %AC analysis

VO = zeros(1, 1000);
gain = zeros(1, 1000);

for w = 1:1:1000

V = (G + 1i*2*pi*w*C)\F;
VO(1,w) = abs(V(5));
gain(1,w) = 20*log10(abs(V(5)/V(1)));

end
figure (2)

subplot(1,2,1);
semilogx(1:1:1000, gain)
title('AC Sweep - Gain vs Frequency');
xlabel('Frequency (Hz)');
ylabel('Gain (dB)'); 

subplot(1,2,2);
semilogx(1:1:1000, VO)
title('AC Sweep - Output Voltage vs Frequency');
xlabel('Frequency (Hz)');
ylabel('Output Voltage (V)'); 

% AC sweep with perturbations on C

VO_r = zeros(1, 1000);
gain_r = zeros(1, 1000);
w = pi;
for i_r = 1:1:1000
    r = randn()*0.05;
    C(1,1) =  Cap*r;
    C(1,2) =  -(Cap)*r;

    C(2,1) = -Cap*r;
    C(2,2) = Cap*r;

    V = (G + 1i*2*pi*w*C)\F;
    VO_r(1,i_r) = abs(V(5));
    gain_r(1,i_r) = 20*log10(abs(V(5)/V(1)));

end
figure (3)

subplot(2,1,1);
histogram(gain_r)
title('AC Sweep - Gain vs Perturbations on Capacitor');
xlabel('Gain (dB)');
ylabel('Perturbations on Capacitor'); 

subplot(2,1,2);
semilogx(1:1:1000, gain_r)
title('AC Sweep with Perturbations - Gain vs Frequency');
xlabel('Frequency (Hz)');
ylabel('Gain (dB)'); 
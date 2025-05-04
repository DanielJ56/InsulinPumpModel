t = [0:720];
BW = 100; %Adjust body weight in kg
Q0 = 50000; %glucose in small intestines in mg

kabs = 0.057; %0.023 if T2diabetic
ke1 = 0.0005; %0.0007 if T2diabetic
ke2 = 339; %269 if T2diabetic
k1 = 0.065 %0.042 if T2D
k2 = 0.079 %0.071 if T2D
kp1 = 2.7 %3.09 if T2D
kp3 = 0.009 %0.005 if T2D
kp4 = 0.0618 %0.0066 if T2D

m1 = 0.190; %0.379 if T2D
m2 = 0.484; %0.674 if T2D
m3 = m1*1.5; 
m4 = 0.194; %0.269 if T2D
ki = 0.0079 % 0.006 if T2D 

Ip0 = 5.343;
Il0 = 7.93;
Vi = 0.05;
S = m3*Il0 + m4*Ip0
f = 0.9;
gamma = 0.5

RA = rate_of_appearance(t,f,kabs,BW,Q0);
%ET = renal_extraction(t,Gp,ke1,ke2)
Ipo = portal_vein_insulin(t,gamma)




%%%%%%%%%%%%%%%%%%%

[time,yaxis] = ode45(@(t, y) insulin_mass_rate(t, y, m1, m2, m3, m4, S,Il0,Ip0),[0,720],[Il0,Ip0]);
Il_values = yaxis(:,1)
Ip_values = yaxis(:,2)
I = Ip_values/Vi;

%plot(time,I)
%ylabel("pmol/kg")

%part 2, finding Id
[time2,yaxis2] = ode45(@(t, y) delayed_insulin_rate(t, y, ki,I,time),[0,720],[Il0,Ip0]);
I1_values = yaxis2(:,1)
Id_values = yaxis2(:,2)
%hold on
%plot(time,I)
%plot(time2,I1_values)
%plot(time2,Id_values)



function 

function dydt = insulin_mass_rate(t,y,m1,m2,m3,m4,S,Il0,Ip0)
    Il = y(1);    
    Ip = y(2);
    
    if t>=0 && t<=120
        S = m3*Il0 + m4*Ip0 + 0 %insulin pump secretion amount
    else
        S = m3*Il0 + m4*Ip0
    end

    dIldt = -1 * (m1 + m3) * Il + m2*Ip + S;
    dIpdt = -1 * (m2 + m4) * Ip + m1 *Il;

    dydt = [dIldt; dIpdt];
    
end

function didt = delayed_insulin_rate(t,y,ki,I_values,I_time)
    I1 = y(1);
    Id = y(2);
    I = interp1(I_time,I_values,t)
    
    dI1dt = -1*ki*[I1 - I];
    dIddt = -1*ki*[Id - I1];

    didt = [dI1dt;dIddt]
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%



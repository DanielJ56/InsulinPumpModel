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

f = 0.9;
gamma = 0.5

Gp = 1
Uii = 1;
RA = rate_of_appearance(t,f,kabs,BW,Q0);
%ET = renal_extraction(t,Gp,ke1,ke2)
Ipo = portal_vein_insulin(t,gamma)


function Ra = rate_of_appearance(t,f,kabs,BW,Q0)
    Q = Q0 * (0.98.^t);
    Ra = f*kabs*Q / BW;
end

function Et = renal_extraction(t,Gp,ke1,ke2)
    if Gp >ke2
        Et = ke1*(Gp-ke2);
    else
        Et = 0;
    end
end

function Ipo = portal_vein_insulin(t,gamma)
    a = -0.000236553
    b = 0.0470318
    c = 3.36293
    gamma = gamma
    isr = a*t.^2 + b*t + c
    isr = max(isr,0)
    Ipo = isr/gamma
end

function didt = delayed_insulin_rate(t,y,ki,I_values,I_time)
    I1 = y(1);
    Id = y(2);
    I = interp1(I_time,I_values,t)
    
    dI1dt = -1*ki*[I1 - I];
    dIddt = -1*ki*[Id - I1];

    didt = [dI1dt;dIddt]
end
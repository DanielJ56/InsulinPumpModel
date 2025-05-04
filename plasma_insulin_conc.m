function outputs = plasma_insulin_conc(t,y,diab)
    if diab == 0
        m1 = 0.190; %0.379 if T2D
        m2 = 0.484; %0.674 if T2D
        m3 = m1*1.5; 
        m4 = 0.194; %0.269 if T2D
    else
        m1 = 0.379;
        m2 = 0.674;
        m3 = m1*1.5;
        m4 = 0.269;
    end
    Il0 = 7.93;
    Ip0 = 5.343;
    
    S = m3*Il0 + m4*Ip0;

    Il = y(1);    
    Ip = y(2);

    if t>=0 && t<=120
        S = m3*Il0 + m4*Ip0 + 5; %insulin pump secretion amount
    else
        S = m3*Il0 + m4*Ip0;
    end

    dIldt = -1 * (m1 + m3) * Il + m2*Ip ;
    dIpdt = -1 * (m2 + m4) * (Ip) + m1 *Il + S;

    outputs = [dIldt; dIpdt];
end
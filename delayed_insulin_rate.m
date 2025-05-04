function [output_id,output_i] = delayed_insulin_rate(t,diab)
    diab = diab;
    Ip0 = 5.343;
    Il0 = 7.93;
    Id0 = 90.56;
    I10 = 90.56;
    Vi = 0.05;
    
    [time,values]  = ode45(@(t, y) plasma_insulin_conc(t,y,diab),t,[Il0,Ip0]);
    Il_values = values(:,1);
    Ip_values = values(:,2);
    I = Ip_values/Vi;

    [time2,values2] = ode45(@(t, y) sub_function(t,y,I,time,diab),t,[I10,Id0]);
    I1_values = values2(:,1);
    Id_values = values2(:,2);


    output_id = Id_values;
    output_i = I;
    
end

function outputs = sub_function(t,y,I_values,I_time,diab)
    if diab == 0
        ki = 0.0079;
    else 
        ki = 0.006;
    end

    I1 = y(1);
    Id = y(2);
    I = interp1(I_time,I_values,t);

    dI1dt = -1*ki*[I1 - I];
    dIddt = -1*ki*[Id - I1];

    outputs = [dI1dt;dIddt];
end
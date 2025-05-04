function outputs = x_solver(t,diab)
    Vi = 0.05;
    [time,values]  = ode45(@(t, y) plasma_insulin_conc(t,y,diab),t,[7.93,5.343]);
    Ip_values = values(:,2);
    I = Ip_values/Vi;
    
    [time,values] = ode45(@(t, y) sub_function_x(t,y,I,time,diab),t,[0]);
    outputs = values;

end

function outputs = sub_function_x(t,y,I,time,diab)
    p2u = 0.015;
    Ib = 90.56;
    I_values = interp1(time,I,t);
    
    x = y(1);

    dxdt = -p2u * x + p2u *(I_values - Ib);

    outputs = [dxdt];
end
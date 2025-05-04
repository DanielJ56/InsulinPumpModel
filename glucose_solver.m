function outputs = glucose_solver(t,BW,Q0,length,diab)
    BW = BW; %Adjust body weight in kg
    Q0 = Q0; %glucose in small intestines in mg
    Ra = rate_of_appearance(t,BW,Q0,diab); %Get RA
    Ipo = portal_vein_insulin(t); %Get Ipo
    [Id,I]  = delayed_insulin_rate(t,diab); %Get Id
    Uii = ones(1, length);; % Get Uii
    x = x_solver(t,diab);







    Gp0 = 86.496;
    Gt0 = 70;
    times = t;
    [time,values] = ode45(@(t, y) sub_function_dGpdt(t,y,Ra,Ipo,Id,Uii,x,diab,length,times),t,[Gp0,Gt0]);
    outputs = values(:,1);
end




function outputs = sub_function_dGpdt(t,y,Ra,Ipo,Id,Uii,x,diab,length,times)
    Gp = y(1);
    Gt = y(2);
    if diab == 0
            k1 = 0.065; 
            k2 = 0.079;
            kp1 = 0.9; 
            kp3 = 0.069;
            kp4 = 0.0618; 
            Vm0 = 2.5;
            Vmx = 0.047;
            km0 = 225.59;
    else
            k1 = 0.042; 
            k2 = 0.071; 
            kp1 = 2.5; 
            kp3 = 0.02; 
            kp4 = 0.0066;
            Vm0 = 4.65;
            Vmx = 0.034;
            km0 = 466.21;
    end



    Ra = interp1(times, Ra, t);
    Ipo = interp1(times, Ipo, t);
    Id = interp1(times, Id, t);
    Uii = interp1(times, Uii, t);
    x = interp1(times, x, t);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %PID controller 
    G_setpoint = 120; ...; % Define your desired setpoint
    
    % Define the PID controller parameters based on your system
    Kp = -0.0780; 
    Ki = -9.6753;
    Kd = -15.5195;    
    
    last_error = 0;
    integral = 0;
    dt = mean(diff(t));

    % Control loop
    for k = 1:(length)
        % find error
        error = G_setpoint - Gp;
        
        % PID
        integral = integral + error * dt;
        derivative = (error - last_error) / dt;
        deltaId = Kp * error + Ki * integral + Kd * derivative;
        if isnan(deltaId)
            deltaId = 0;
        end
        Id = Id + deltaId;%Add control value onto Id to imitate insulin injection

        last_error = error;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



    

    Et = renal_extraction(Gp,diab);
    dGpdt = Ra - Uii - Et + k2*Gt - k1*Gp + kp1 - kp3*Id - kp4*Ipo;
    dGtdt = -((Vm0 + Vmx* x) / (km0 + Gt)) + k1*Gp - k2*Gt;
    outputs = [dGpdt;dGtdt];

end
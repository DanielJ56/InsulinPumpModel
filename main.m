length = 1440;
diab = 0;
t = [0:length];
BW = 100; %Adjust body weight in kg
Q0 = 50000; %glucose in small intestines in mg
Vg = 1.88;
Ra = rate_of_appearance(t,BW,Q0,diab); %Get RA
Ipo = portal_vein_insulin(t); %Get Ipo
[Id,I]  = delayed_insulin_rate(t,diab); %Get Id
Uii = 1; % Get Uii

x = x_solver(t,diab);    

gp = glucose_solver(t,BW,Q0,length + 1,diab);
gp = gp /1.88;
gp(gp < 0) = 0;
hold on
plot(t,gp)
plot(t,Id)
ylabel("concentration mg/dl")
xlabel("time (minutes)")







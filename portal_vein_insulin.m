function outputs = portal_vein_insulin(t)
    a = -0.000236553;
    b = 0.0470318;
    c = 3.36293;
    gamma = 0.5;
    isr = a*t.^2 + b*t + c;
    isr = max(isr,0);
    Ipo = isr/gamma;
    outputs = Ipo;
end
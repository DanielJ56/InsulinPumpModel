
function outputs = rate_of_appearance(t,BW,Q0,diab)
    BW = BW;
    Q0 = Q0;
    f = 0.9;
    if diab ==0
        kabs = 0.057;
    else 
        kabs = 0.023;
    end 
    Q = Q0 * (0.98.^t);
    Ra = f*kabs*Q / BW;
    
    outputs = Ra;
end
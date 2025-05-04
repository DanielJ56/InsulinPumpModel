function outputs = renal_extraction(Gp,diab)
    if diab ==0
        ke1 = 0.0005; 
        ke2 = 339; 
    else 
        ke1 = 0.0007;
        ke2 = 269;
    end 

    if Gp >ke2
        outputs = ke1*(Gp-ke2);
    else
        outputs = 0;
    end
end



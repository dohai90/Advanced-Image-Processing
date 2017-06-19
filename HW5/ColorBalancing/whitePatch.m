function RGB_balanced = whitePatch(RGB)
    % Convert image to the linear RGB domain
    R = RGB(:,:,1);
    G = RGB(:,:,2);
    B = RGB(:,:,3);
    R_l = R.^2.2;
    G_l = G.^2.2;
    B_l = B.^2.2;

    % White Patch algorithm
    Rmax = max(R_l(:));
    Gmax = max(G_l(:));
    Bmax = max(B_l(:));
    Pr = Gmax/Rmax;
    Pg = 1;
    Pb = Gmax/Bmax;
    R_l_balanced = Pr * R_l;
    G_l_balanced = Pg * G_l;
    B_l_balanced = Pb * B_l;
    
    % Convert result back to the original RGB domain
    R_balanced = R_l_balanced.^(1/2.2);
    G_balanced = G_l_balanced.^(1/2.2);
    B_balanced = B_l_balanced.^(1/2.2);
    RGB_balanced(:,:,1) = R_balanced;
    RGB_balanced(:,:,2) = G_balanced;
    RGB_balanced(:,:,3) = B_balanced;
end
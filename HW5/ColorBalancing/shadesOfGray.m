function RGB_balanced = shadesOfGray(RGB,p)
    % Convert image to the linear RGB domain
    R = RGB(:,:,1);
    G = RGB(:,:,2);
    B = RGB(:,:,3);
    R_l = (R.^2.2).^p;
    G_l = (G.^2.2).^p;
    B_l = (B.^2.2).^p;

    % Shades of Gray algorithm
    Rsum = (sum(R_l(:)))^(1/p);
    Gsum = (sum(G_l(:)))^(1/p);
    Bsum = (sum(B_l(:)))^(1/p);
    Pr = Rsum/Gsum;
    Pg = 1;
    Pb = Bsum/Gsum;
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
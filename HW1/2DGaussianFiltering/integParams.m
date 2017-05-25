function [wl, wu, m, actualSigma] = integParams(desiredSigma, nFilts)
    wIdeal = sqrt(12*desiredSigma^2/nFilts + 1); % Ideal averaging filter width
    % wl is first odd valued integer less than wIdeal
    wl = floor(wIdeal);
    if ~mod(wl, 2)
        wl = wl - 1;
    end
    % wu is the next odd value greater than wl
    wu = wl + 2;
    
    mIdeal = (12*desiredSigma^2 - nFilts*wl^2 - 4*nFilts*wl - 3*nFilts) / (-4*wl -4);
    m = round(mIdeal);
    
    if m > nFilts || m < 0
        error('Calculation of m has failed');
    end
    
    % Compute actual sigma 
    actualSigma = sqrt((m*wl^2 + (nFilts - m)*wu^2 - nFilts)/12);
end
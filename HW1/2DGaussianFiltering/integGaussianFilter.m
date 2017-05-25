function [fim, actualSigma] = integGaussianFilter(im, desiredSigma, nFilts)
    if nFilts < 5
        nFilts = 5;
    end
    
    %Solve for the combination of averaging filter sizes that will result
    %in the closest approximation of sigma given nFilts
    [wl, wu, m, actualSigma] = integParams(desiredSigma, nFilts);
    radl = (wl - 1) / 2;
    filterl = [-radl -radl radl radl];
    radu = (wu - 1) / 2;
    filteru = [-radu -radu radu radu];
    
    % Apply the averaging filters via integral images
    for i = 1:m
        fim = integralFilter(im, filterl);
    end
    
    for j = 1:(nFilts - m)
        fim = integralFilter(fim, filteru);
    end

end
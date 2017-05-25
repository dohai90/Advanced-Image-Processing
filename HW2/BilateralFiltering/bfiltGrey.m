function BFG = bfiltGrey(im, w, sigma_d, sigma_r)
    % Calculating Gaussian distance weights (space domain)
    [X, Y] = meshgrid(-w:w, -w:w);
    c = exp((-1/2)*(X.^2+Y.^2)/(sigma_d^2));
    dim = size(im);
    BFG = zeros(dim);
    
    for i = 1:dim(1)
        for j = 1:dim(2)
            %Finding local region
            iMin = max(i-w, 1);
            iMax = min (i+w, dim(1));
            jMin = max(j-w, 1);
            jMax = min(j+w, dim(2));
            Window = im(iMin:iMax, jMin:jMax);
            
            %Calculating Gaussian intensity difference (range domain)
            s = exp(-(Window - im(i,j)).^2/(2*sigma_r^2));
            
            %Calculating bilateral filter
            f = s.*c((iMin:iMax)-i+w+1, (jMin:jMax)-j+w+1);
            f_norm = sum(f(:));
            BFG(i,j) = sum(f(:).*Window(:))/f_norm;
        
        end
    end
end
function BFrgb = bfiltRGB(im, w, sigma_d, sigma_r)
    % Calculating Gaussian distance weights
    [X, Y] = meshgrid(-w:w, -w:w);
    c = exp((-1/2)*(X.^2+Y.^2)/(sigma_d^2));
    dim = size(im);
    BFrgb = zeros(dim);
    
    for i = 1:dim(1)
        for j = 1:dim(2)
            %Finding local region
            iMin = max(i-w, 1);
            iMax = min (i+w, dim(1));
            jMin = max(j-w, 1);
            jMax = min(j+w, dim(2));
            Window = im(iMin:iMax, jMin:jMax,:);
            
            %Calculating color distance that considers RGB data simutaneously
            dR = Window(:,:,1) - im(i,j,1);
            dG = Window(:,:,2) - im(i,j,2);
            dB = Window(:,:,3) - im(i,j,3);
            s = exp(-(dR.^2 + dG.^2 + dB.^2)/(2*sigma_r^2));
            
            %Calculate bilateral filter
            f = s.*c((iMin:iMax)-i+w+1, (jMin:jMax)-j+w+1);
            f_norm = sum(f(:));
            BFrgb(i,j,1) = sum(sum(f.*Window(:,:,1)))/f_norm;
            BFrgb(i,j,2) = sum(sum(f.*Window(:,:,2)))/f_norm;
            BFrgb(i,j,3) = sum(sum(f.*Window(:,:,3)))/f_norm;
        
        end
    end
end
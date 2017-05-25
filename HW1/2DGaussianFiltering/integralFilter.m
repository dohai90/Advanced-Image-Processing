function fim = integralFilter(im, f)
    N = (2*f(3)+1) * (2*f(4)+1);

    intim = integralImage(im);
    [rows, cols] = size(intim);
    fim = zeros(rows, cols);
    f(1:2) = f(1:2) - 1;
    
    rmin = 1 - f(1);
    rmax = rows - f(3);
    cmin = 1 - f(2);
    cmax = cols - f(4);
    
    for r = rmin:rmax
        for c = cmin:cmax
            fim(r,c) = (1/N)*(intim(r+f(3),c+f(4)) - intim(r+f(1),c+f(4)) ...
                - intim(r+f(3), c+f(2)) + intim(r+f(1), c+f(2)));        
        end
    end
    
end

function intim = integralImage(im)
    if ndims(im) == 3
        im=rgb2gray(im);
    end
    
    if strcmp(class(im), 'uint8')
        im = double(im);
    end
    
    intim = cumsum(cumsum(im, 1), 2);
    intim = padarray(intim, [1 1], 'pre');
end
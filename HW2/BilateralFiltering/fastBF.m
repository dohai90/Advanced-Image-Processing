function res = fastBF(im, sigma_s, sigma_r)
    %Parameters init
    edge = im;
    [H, W] = size(im);    
    sampling_s = sigma_s;
    edgeMin = min(edge(:)); 
    sampling_r = sigma_r;
    derivedSigma_s = sigma_s / sampling_s;
    derivedSigma_r = sigma_r / sampling_r;
    padXY = floor(2 * derivedSigma_s) + 1;
    padZ = floor(2 * derivedSigma_r) + 1;
    
    %Step 1: Downsampling
    dsW = floor((W - 1)/sampling_s) + 1 + 2*padXY;
    dsH = floor((H - 1)/sampling_s) + 1 + 2*padXY;
    dsD = floor(10 * sigma_r/sampling_r) + 1 + 2*padZ;
    gridI = zeros(dsH, dsW, dsD);
    gridWeights = zeros(dsH, dsW, dsD);
    [x, y] = meshgrid(0:W-1, 0:H-1);
    dx = round(x/sampling_s) + padXY + 1;
    dy = round(y/sampling_s) + padXY + 1;
    dz = round((edge - edgeMin)/sampling_r) + padZ + 1;
    for k = 1:numel(dz)
        dataZ = im(k);
        if ~isnan(dataZ)
            dxk = dx(k);
            dyk = dy(k);
            dzk = dz(k);
            gridI(dyk, dxk, dzk) = gridI(dyk, dxk, dzk) + dataZ;
            gridWeights(dyk, dxk, dzk) = gridWeights(dyk, dxk, dzk) + 1;
        end
    end
    
    %Step 2: Gaussian linear filtering
    kernW = 2 * derivedSigma_s + 1;
    kernH = kernW;
    kernD = 2 * derivedSigma_r + 1;
    halfKernW = floor(kernW/2);
    halfKernH = floor(kernH/2);
    halfKernD = floor(kernD/2);
    [gridX, gridY, gridZ] = meshgrid(0:kernW-1, 0:kernH-1, 0:kernD-1);
    gridX = gridX - halfKernW;
    gridY = gridY - halfKernH;
    gridZ = gridZ - halfKernD;
    gridSquared = (gridX.^2 + gridY.^2)/(derivedSigma_s^2) + (gridZ.^2)/(derivedSigma_r^2);
    gaussKern = exp(-0.5 * gridSquared);
    blurredGridI = convn(gridI, gaussKern, 'same');
    blurredGridWeights = convn(gridWeights, gaussKern, 'same');
    
    %Step 3: Slicing and devision
    blurredGridWeights(blurredGridWeights == 0) = -2;
    normBlurredGrid = blurredGridI./blurredGridWeights;
    normBlurredGrid(blurredGridWeights < -1) = 0;
    blurredGridWeights(blurredGridWeights < -1) = 0;
    
    [x, y] = meshgrid(0:W-1, 0:H-1);
    dx = (x/sampling_s) + padXY + 1;
    dy = (y/sampling_s) + padXY + 1;
    dz = ((edge - edgeMin)/sampling_r) + padZ + 1;
    
    res = interpn(normBlurredGrid, dy, dx, dz);
end
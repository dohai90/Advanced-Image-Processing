function peakSNR_RGB = psnr_RGB(I, ref)

    % Read the dimensions of the image.
    [rows columns ~] = size(I);

    % Calculate mean square error of R, G, B.   
    mseRImage = (double(I(:,:,1)) - double(ref(:,:,1))) .^ 2;
    mseGImage = (double(I(:,:,2)) - double(ref(:,:,2))) .^ 2;
    mseBImage = (double(I(:,:,3)) - double(ref(:,:,3))) .^ 2;

    mseR = sum(sum(mseRImage)) / (rows * columns);
    mseG = sum(sum(mseGImage)) / (rows * columns);
    mseB = sum(sum(mseBImage)) / (rows * columns);

    % Average mean square error of R, G, B.
    mse = (mseR + mseG + mseB)/3;

    % Calculate PSNR (Peak Signal to noise ratio).
    peakSNR_RGB = 10 * log10( 255^2 / mse);
end
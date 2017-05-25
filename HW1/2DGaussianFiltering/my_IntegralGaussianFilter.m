im = imread('cameraman.tif');
desiredSigma = 2.6;
nFilts = 6;
[fim, actualSigma] = integGaussianFilter(im, desiredSigma, nFilts);
imshow(uint8(fim));
title('Gaussian filtering by repeatedly applying 2D integral image');
clear all;
clc

for i=1:2
    close all;
    if i==1
        im= double(imread('cameraman.tif'));
    else
        im= double(imread('Lena.tif'));
    end    
    figure,imshow(im,[]), title('Original Image');

    % add Gaussian noise
    sigma=10;
    g=im+sigma*randn(size(im));
    figure, imshow(g,[]), title('AWGN Image');

    % denoise it
    fprintf('Please wait...\n');
    fima=nonLMFilter(g,5,2,sigma);
    figure, imshow(fima,[]), title('Filtered Image');
    % peak snr calculation
    peakSNR=psnr(uint8(fima),uint8(im));
    if i==1
        fprintf('NLM filter applied for cameraman image case has PSNR: %0.4fdB\n', peakSNR);
        fprintf('Click on image to continue...\n');
        waitforbuttonpress
    else
        fprintf('NLM filter applied for Lena image case has PSNR: %0.4fdB\n', peakSNR);
        fprintf('Done!\n');
    end    
end
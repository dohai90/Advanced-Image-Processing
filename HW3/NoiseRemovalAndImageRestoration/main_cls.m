for c=1:2
    close all;
    if c==1
        im= imread('cameraman.tif');
        gamma=0.9;
    else
        im= imread('Lena.tif');
        gamma=0.9;
    end
    [m,n] = size(im);

    %blur the image with Gaussian blur filter
    h=fspecial('gaussian', [11 11], 4);
    imBlur=imfilter(im,h,'same');   

    %Add white Gaussian noise to blurred image
    sigma = 10;
    imBlurNoise=double(imBlur)+sigma*randn(size(im));   

    %Constrained Least Squares filter
    h_pad=padarray(h,[m-11,n-11],'post');
    H=fft2(h_pad);     
    p=[0 -1 0;-1 4 -1;0 -1 0];
    p_pad=padarray(p,[m-3,n-3],'post');
    P=fft2(p_pad);
    G=fft2(imBlurNoise);
    Filter=conj(H)./(abs(H).^2 + gamma*(abs(P).^2));    
    F_hat=Filter.*G;
    f_hat=abs(ifft2(F_hat));    
    %Show results
    figure,
    subplot(2,2,1), imshow(im), title('Original image');
    subplot(2,2,2), imshow(imBlur), title('Blurred image');
    subplot(2,2,3), imshow(imBlurNoise,[]), title('Noisy Blurred image');
    subplot(2,2,4), imshow(f_hat,[]), title('Filtered image');
    
    peakSNR=psnr(uint8(f_hat), im);
    if c==1
        fprintf('CLS Filter applied for cameraman image: PSNR=%0.4f dB\n', peakSNR);
        fprintf('Click on image to continue...\n');
        waitforbuttonpress;
    else
        fprintf('CLS Filter applied For Lena image: PSNR=%0.4f dB\n', peakSNR);
        fprintf('Done!\n');
    end
end
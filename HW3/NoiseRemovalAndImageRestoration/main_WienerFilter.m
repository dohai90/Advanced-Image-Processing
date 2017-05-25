for c=1:2
    close all;
    if c==1
        im= imread('cameraman.tif');
    else
        im= imread('Lena.tif');
    end
    [m,n] = size(im);

    %blur the image with Gaussian blur filter
    h=fspecial('gaussian', [11 11], 4);
    imBlur=imfilter(im,h,'same');   

    %Add white Gaussian noise to blurred image
    sigma = 10;
    imBlurNoise=double(imBlur)+sigma*randn(size(im));   

    %Wiener filter
    h_pad=padarray(h,[m-11,n-11],'post');
    H=fft2(h_pad);     
    K=linspace(0.001,0.1,100);
    G=fft2(imBlurNoise);
    errVect=zeros(size(K));
    wbar=waitbar(0,'Please wait...');
    len=length(K);
    for i=1:len    
        %Generate Wiener filter
        W=conj(H)./(abs(H).^2 + K(i));
        F_hat=W.*G;
        f_hat=uint8(real(ifft2(F_hat)));
        %Calculate error
        err=im-f_hat;
        errVect(i)=mean(err(:)).^2;    
        waitbar(i/len);
    end
    close(wbar);

    %Retrieve minimum error
    [MSE, idx] = min(errVect);
    W=conj(H)./(abs(H).^2 + K(idx));
    F_hat=W.*G;
    f_hat=uint8(real(ifft2(F_hat)));    
    figure,
    subplot(2,2,1), imshow(im), title('Original image');
    subplot(2,2,2), imshow(imBlur), title('Blurred image');
    subplot(2,2,3), imshow(imBlurNoise,[]), title('Noisy Blurred image');
    subplot(2,2,4), imshow(f_hat), title('Filtered image');
    peakSNR=psnr(f_hat,im);
    if c==1
        fprintf('Wiener Filter applied for cameraman image: PSNR=%0.4f dB\n', peakSNR);
        fprintf('Click on image to continue...\n');
        waitforbuttonpress;
    else
        fprintf('Wiener Filter applied for Lena image: PSNR=%0.4f dB\n', peakSNR);
        fprintf('Done!\n');
    end
end
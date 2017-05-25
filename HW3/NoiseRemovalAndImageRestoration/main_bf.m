fprintf('Bilateral filtering execution\n');
for c=1:2  
    if c==1
        sigma_s = 2;
        sigma_r = 20;
        w = 2;  
        f= double(imread('cameraman.tif'));            
       
    else
        sigma_s = 2;
        sigma_r = 30;
        w = 2;  
        f= double(imread('Lena.tif'));
    end
    
    sigma=10;
    g = f + sigma*randn(size(f));
    BFG_w2 = bfiltGrey(g, w, sigma_s, sigma_r);
    
    subplot(1,2,1), imshow(f,[]), title('Original image');
    subplot(1,2,2), imshow(BFG_w2,[]), title('Bilateral smoothing');    
    peakSNR = psnr(uint8(BFG_w2), uint8(f));
    if c==1
        fprintf('Bilateral Filter applied for cameraman image: PSNR=%0.4f dB\n', peakSNR);
        fprintf('Click on image to continue...\n');
        waitforbuttonpress;
    else
        fprintf('Bilateral Filter applied For Lena image: PSNR=%0.4f dB\n', peakSNR);
        fprintf('Done!\n');
    end
    
end

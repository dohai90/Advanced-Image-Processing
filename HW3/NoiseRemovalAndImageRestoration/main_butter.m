for i=1:4
    fprintf('Please wait...\n');
    if i==1       
        f = imread('cameraman.tif');
        [height, width] = size(f);
        [y, x] = meshgrid(1:height, 1:width);
        n = 20*(sin(x*pi/4) + sin(y*pi/4));
        g = double(f) + n;        
        filtered_im = butterworthBRF(g, 50,80, 4);  
        peakSNR=psnr(filtered_im,f);
        fprintf('Butterworth filter apply for cameraman image has PSNR=%0.4f dB\n', peakSNR);
    elseif i==2
        f = imread('Lena.tif');
        [height, width] = size(f);
        [y, x] = meshgrid(1:height, 1:width);
        n = 20*(sin(pi/4*x) + sin(pi/4*y));
        g = double(f) + n;        
        filtered_im = butterworthBRF(g, 80,130, 4);
        peakSNR=psnr(filtered_im,f);
        fprintf('Butterworth filter apply for Lena image has PSNR=%0.4fdB\n', peakSNR);
    elseif i==3
        g = imread('im1.jpg');        
        filtered_im = butterworthBRF(g, 1,300, 4);          
    else
        g = imread('im2.jpg');        
        filtered_im = butterworthBRF(g, 60,110, 4);       
    end  
    
    if i~=4
        fprintf('Click on image to continue...\n');
        waitforbuttonpress;   
    else
        fprintf('Done!\n');
    end
end
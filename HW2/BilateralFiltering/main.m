sigma_s = 3;
sigma_r = 50;
im_grey = imread('Peppers.bmp');
im_color = imread('PeppersRGB.bmp');  
fprintf('Naive Bilateral filtering execution\n');
for i=1:2
    if(i==1)
        im_grey=double(im_grey);
        for j=1:2
            tic
            fprintf('Please wait...!\n');
            if(j==1)
                w = 2;                
                BFG_w2 = bfiltGrey(im_grey, w, sigma_s, sigma_r);
                BFG_w2 = uint8(BFG_w2);
                fprintf('Execution time for window size = 2: \n');
            else
                w = 20;
                BFG_w20 = bfiltGrey(im_grey, w, sigma_s, sigma_r);
                BFG_w20 = uint8(BFG_w20);
                fprintf('Execution time for window size = 20: \n');
            end
            toc
        end
        subplot(1,3,1), imshow(uint8(im_grey)), title('Original image');
        subplot(1,3,2), imshow(BFG_w2), title('Bilateral smoothing with window size w=2');
        subplot(1,3,3), imshow(BFG_w20), title('Bilateral smoothing with window size w=20');
        fprintf('Click on image to continue ... \n');
        waitforbuttonpress;
    else
        close all;
        tic
        fprintf('Please wait...!\n');
        w = 2;
        im_color=double(im_color);        
        BFrgb = bfiltRGB(im, w, sigma_s, sigma_r);
        BFrgb = uint8(BFrgb);       
        fprintf('Execution time for color image: \n');
        toc
    end
    subplot(1,2,1), imshow(uint8(im_color)), title('Original color image');
    subplot(1,2,2), imshow(BFrgb), title('Bilateral smoothing for color image');
end

fprintf('Click on image to continue ... \n');
waitforbuttonpress;
fprintf('O(1) time Bilateral filtering execution\n');
for i=1:2
    if(i==1)      
        tic
        fprintf('Please wait...!\n');
        im_grey=double(im_grey);
        blurredGrey = fastBF(im_grey, sigma_s, sigma_r);
        blurredGrey = uint8(blurredGrey);
        fprintf('Execution time for greyscale image using O(1) time bilateral filtering:\n');
        toc   
        subplot(1,2,1), imshow(uint8(im_grey)), title('Original color image');
        subplot(1,2,2), imshow(blurredGrey), title('Blur greyscale image by using O(1) time bilateral filtering');
        fprintf('Click on image to continue ... \n');        
        waitforbuttonpress;
    else
        close all;
        tic
        fprintf('Please wait...!\n');
        im_color=double(im_color);
        blurredR = fastBF(im_color(:,:,1), sigma_s, sigma_r);
        blurredG = fastBF(im_color(:,:,2), sigma_s, sigma_r);
        blurredB = fastBF(im_color(:,:,3), sigma_s, sigma_r);
        blurredRGB = zeros(size(im_color));
        blurredRGB(:,:,1) = blurredR(:,:);
        blurredRGB(:,:,2) = blurredG(:,:);
        blurredRGB(:,:,3) = blurredB(:,:);
        blurredRGB = uint8(blurredRGB);
        fprintf('Execution time for color image using O(1) time bilateral filtering: \n');
        toc  
        subplot(1,2,1), imshow(uint8(im_color)), title('Original color image');
        subplot(1,2,2), imshow(blurredRGB), title('O(1) time bilateral smoothing for color image');
    end
end

peakSNR = psnr(blurredGrey, BFG_w20);
fprintf('The Peak-SNR between grayscale images is: %f dB\n', peakSNR);
peakSNR_RGB = psnr(blurredRGB, BFrgb);
fprintf('The Peak-SNR between color images is: %f dB\n', peakSNR_RGB);
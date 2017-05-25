% define some functions
norm_img = @(img) (img - min(img(:))) / (max(img(:)) - min(img(:)));
gNotch = @(v,mu,cov) 1-exp(-0.5*sum((bsxfun(@minus,v,mu).*(cov\bsxfun(@minus,v,mu)))));

for i=1:4    
    fprintf('Please wait...\n');
    warning('off', 'Images:initSize:adjustingMag');
    if i==1
        f = imread('cameraman.tif');
        [m, n] = size(f);
        [y, x] = meshgrid(1:m, 1:n);
        noise = 20*(sin(x*pi/4) + sin(y*pi/4));
        g = double(f) + noise;  
        figure, imshow(g,[]), title('Noisy image');

        ft = fftshift(fft2(g));
        figure, fftshow(ft);
        hold on; axis on, title('Spectrum before filtering');

        % create notch filter
        filt = ones(m,n);
        
        % use gaussian notch with standard deviation of 5
        sigma = 5;        
        X = [y(:) x(:)].';
        Noise_cord=[129, 96;
                    161, 129;
                    129, 160;
                    97, 129];
         
    elseif i==2
        f = imread('Lena.tif');
        [m, n] = size(f);
        [y, x] = meshgrid(1:m, 1:n);
        noise = 50*(sin(x*pi/4) + sin(y*pi/4));
        g = double(f) + noise;  
        figure, imshow(g,[]), title('Noisy image');

        ft = fftshift(fft2(g));
        figure, fftshow(ft);
        hold on; axis on, title('Spectrum before filtering');
        
        % create notch filter
        filt = ones(m,n);
        
        % use gaussian notch with standard deviation of 5
        sigma = 5;        
        X = [y(:) x(:)].';
        Noise_cord=[257, 193;
                    321, 256;
                    257, 322;
                    193, 256];
         
    elseif i==3
        f = imread('im1.jpg');
        figure, imshow(f), title('Noisy image');
        ft = fftshift(fft2(f));
        [m,n] = size(ft);
        
        % show spectrum before
        figure, fftshow(ft);
        hold on; axis on, title('Spectrum before filtering');        

        % create notch filter
        filt = ones(m,n);

        % use gaussian notch with standard deviation of 5
        sigma = 5;
        [y,x] = meshgrid(1:n, 1:m);
        X = [y(:) x(:)].';
        Noise_cord=[261, 124;
                    268, 81;
                    245, 216;
                    238, 259];
    else
        f = imread('im2.jpg');
        figure, imshow(f), title('Noisy image');
        ft = fftshift(fft2(f));
        [m,n] = size(ft);
        
        % show spectrum before
        figure, fftshow(ft);
        hold on; axis on, title('Spectrum before filtering');        

        % create notch filter
        filt = ones(m,n);

        % use gaussian notch with standard deviation of 5
        sigma = 5;
        [y,x] = meshgrid(1:n, 1:m);
        X = [y(:) x(:)].';
        Noise_cord=[210, 450;
                    274, 444];
    end
    
    for j=1:size(Noise_cord,1)
        filt = filt .* reshape(gNotch(X,Noise_cord(j,:)',eye(2)*sigma^2),[m,n]);
    end
    
    % apply filter
    ft = ft .* filt;

    % show spectrum after
    figure, fftshow(ft);
    hold on, title('Spectrum after filtering');

    % compute inverse
    ifft_ = ifft2(ifftshift( ft));
    img_res = histeq(norm_img(real(ifft_)));

    figure, imshow(img_res), title('Filtered image');
    
    if (i==1)
        peakSNR = psnr(img_res,norm_img(double(f)));
        fprintf('Notch filtering applied for cameraman image has PSNR=%0.4f dB\n', peakSNR);
    elseif i==2
        peakSNR = psnr(img_res,norm_img(double(f)));
        fprintf('Notch filtering applied for Lena image has PSNR=%0.4f dB\n', peakSNR);
    end
    if i~=4
        fprintf('Click on image to continue...\n');
        waitforbuttonpress;
        close all;
    else
        fprintf('Done!\n');
    end    
end
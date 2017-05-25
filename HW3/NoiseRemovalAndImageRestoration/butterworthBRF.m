function filtered_im = butterworthBRF(I, D0, D1, n)
    f = double(I);
    [nx, ny] = size(f);
    f = uint8(f);
    fftI = fft2(f, 2*nx-1, 2*ny-1);
    fftI = fftshift(fftI);
    
    subplot(2,2,1)
    imshow(f,[]);
    title('Noisy Image')
    subplot(2,2,2)
    fftshow(fftI)
    title('Image in Fourier Domain')
    
    % Initialize filters
    filt1 = ones(2*nx-1, 2*ny-1);
    filt2 = ones(2*nx-1, 2*ny-1);
    filt3 = ones(2*nx-1, 2*ny-1);
    filt4 = ones(2*nx-1, 2*ny-1);
    
    for u = 1:2*nx-1
        for v = 1:2*ny-1
            D = ((u-(nx+1))^2 + (v-(ny+1))^2)^.5;
            % Butterworth filters
            filt1(u,v) = 1/(1+(D/D1)^(2*n)); %lowpass filter with higher cutoff freq
            filt2(u,v) = 1/(1+(D/D0)^(2*n)); %lowpass filter with lower cutoff freq
            filt2(u,v) = 1 - filt2(u,v); %highpass filter
            filt3(u,v) = filt1(u,v).*filt2(u,v); %bandpass filter
            filt4(u,v) = 1 - filt3(u,v); %bandreject filter
        end
    end
    
    subplot(2,2,3)
    imshow(filt4);
    title('Filter Image');
    
    filtered_im = fftI + filt4.*fftI;
    filtered_im = ifftshift(filtered_im);
    filtered_im = ifft2(filtered_im, 2*nx-1, 2*ny-1);
    filtered_im = real(filtered_im(1:nx, 1:ny));
    filtered_im = uint8(filtered_im);
    
    subplot(2,2,4);
    imshow(filtered_im,[]);
    title('Filtered Image');
end
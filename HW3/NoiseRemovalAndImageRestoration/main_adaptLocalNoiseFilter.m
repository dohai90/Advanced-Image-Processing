for c=1:2

    close all;
    if c==1
        f= double(imread('cameraman.tif'));
    else 
        f= double(imread('Lena.tif'));
    end
    figure,imshow(f,[]), title('Original Image');
    sz = size(f,1)*size(f,2);

    %Add gaussian noise 
    sigma=10;
    g = f + sigma*randn(size(f));
    figure, imshow(g,[]), title('AWGN Image');

    %Define window size
    M=5; N=5;
    %Pad the matrix withd zeros on all sizes
    g_pad=padarray(g,[round(M/2), round(N/2)]);

    lmean=zeros(size(g));
    lvar=zeros(size(g));
    window=zeros(M,N);

    for i=1:size(g_pad,1)-M-1
        for j=1:size(g_pad,2)-N-1
            window=g_pad(i:i+(M-1),j:j+(N-1));
            lmean(i,j)=mean(window(:));
            lvar(i,j)=mean(window(:).^2)-mean(window(:))^2;    
        end
    end

    %Noise variance
    nvar=sum(lvar(:))/sz;

    %If nvar>lvar then lvar=nvar
    lvar=max(lvar,nvar);
    f_hat = g - (nvar./lvar ).*(g-lmean);
    figure, imshow(f_hat,[]), title('Filtered Image');

    %Calculate PSNR
    peakSNR=psnr(uint8(f_hat), uint8(f));
    
    if c==1
        fprintf('Adaptive local noise filter applied for cameraman image has PSNR=%0.4f dB\n', peakSNR);
        fprintf('Click on image to continue...\n');
        waitforbuttonpress;
    else
        fprintf('Adaptive local noise filter applied for Lena image has PSNR=%0.4f dB\n', peakSNR);
        fprintf('Done!\n');
    end
end

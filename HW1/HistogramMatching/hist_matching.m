im1=imread('rose.jpg');
im2=imread('cameraman.tif'); % Reference image
if ndims(im1) == 3
    im1 = rgb2gray(im1);
end

M = zeros(256,1,'uint8');

figure(1);
subplot(1,2,1), imshow(im1);
subplot(1,2,2), imhist(im1);
title('Original image and its histogram');
hist1 = imhist(im1); % Compute histogram

figure(2);
subplot(1,2,1), imshow(im2);
subplot(1,2,2), imhist(im2);
title('Reference image and its histogram');
hist2 = imhist(im2); % Compute histogram

cdf1 = cumsum(hist1) / numel(im1); % Compute CDFs
cdf2 = cumsum(hist2) / numel(im2);
for idx = 1:256
    [~, ind] = min(abs(cdf1(idx) - cdf2));
    M(idx) = ind - 1;
end
out = M(double(im1)+1);

figure(3);
subplot(1,2,1), imshow(out);
subplot(1,2,2), imhist(out);
title('Result Image and its histogram after matching');

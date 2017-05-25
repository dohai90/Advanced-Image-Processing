close all;

% Design struturing element for best performance
se = strel('square', 17);

% Enhance blurry image
Im_blurry = imread('blurry.jpg');
Im = Im_blurry;
row=330;
figure('name','Intensity Profile')
subplot(6,2,1), plot(Im(row, :)), title('Original Image');

for iter=1:10
    Im_d = imdilate(Im, se);
    Im_e = imerode(Im, se);
    Im_h = 0.5*(Im_d + Im_e);

    idxD = find(Im >= Im_h);
    idxE = find(Im < Im_h);
    Im(idxD) = Im_d(idxD);
    Im(idxE) = Im_e(idxE);
    
    % Plot Intensity profile for each iteration
    subplot(6,2, iter+1), plot(Im(row,:)), title(sprintf('After iteration %d', iter+1));
end

figure('name', 'Images'),
subplot(1,2,1), imshow(Im_blurry), title('Original');
subplot(1,2,2), imshow(Im), title('Sharpened');
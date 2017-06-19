clear;

for iter = 1:2
    close all;
    if iter==1
        RGB1 = im2double(imread('leaf.jpg'));
    else
        RGB1 = im2double(imread('macbeth.jpg'));
    end
    [m, n, ~] = size(RGB1);
    RGB1_GW = grayWorld(RGB1, m*n);
    figure('name', 'Gray World Method'), 
    subplot(1,2,1), imshow(RGB1), title('Original Image');
    subplot(1,2,2), imshow(RGB1_GW), title('Color Balanced Image');

    RGB1_WP = whitePatch(RGB1);
    figure('name', 'White Patch Method'), 
    subplot(1,2,1), imshow(RGB1), title('Original Image');
    subplot(1,2,2), imshow(RGB1_WP), title('Color Balanced Image');

    p = [1,5,6,100];
    for i=1:length(p)
        RGB1_SOG = shadesOfGray(RGB1,p(i));
        figure('name', 'Shades Of Gray Method'), 
        subplot(1,2,1), imshow(RGB1), title('Original Image');
        subplot(1,2,2), imshow(RGB1_SOG), title(sprintf('Color Balanced Image with p=%d', p(i)));
        figure('name', 'Histogram'),
        subplot(1,3,1), imhist(RGB1_SOG(:,:,1)), title(sprintf('Red channel with p=%d', p(i)));
        subplot(1,3,2), imhist(RGB1_SOG(:,:,2)), title(sprintf('Green channel with p=%d', p(i)));
        subplot(1,3,3), imhist(RGB1_SOG(:,:,3)), title(sprintf('Blue channel with p=%d', p(i)));
    end
    
    if iter==1
        fprintf('Click on image to continue\n');
        waitforbuttonpress;
    else
        fprintf('Program finished!\n');
    end
end


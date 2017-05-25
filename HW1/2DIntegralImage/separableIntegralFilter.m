for i = 1:2
    if i == 1
        f = [-3 -3 3 3];
    else
        f = [-11 -11 11 11];
    end

tic
im = imread('cameraman.tif');
if ndims(im) == 3
    im=rgb2gray(im);
end

if strcmp(class(im), 'uint8')
    im = double(im);
end

im1 = cumsum(im,2); 
im1 = padarray(im1, [1 1], 'pre'); % integral Image along horizontal direction

[rows, cols] = size(im1);
fim = zeros(rows, cols);
out = zeros(rows, cols);
f(2) = f(2)-1;

cmin = 1 - f(2);
cmax = cols - f(4);

for c = cmin:cmax
    fim(:,c) = im1(:, c+f(4)) - im1(:, c+f(2));            
end

f(1) = f(1) - 1;
rmin = 1 - f(1);
rmax = rows - f(3);

fim = cumsum(fim,1); % integral Image along vertical direction

for r = rmin:rmax 
    out(r,:) = fim(r+f(3),:) - fim(r+f(1),:);   
end

N = (2 * f(3) + 1) * (2 * f(4) + 1); % number of filter elements
out = (1/N) * out; % average Image

if i == 1
    figure(1);
    imshow(uint8(out));
else
    figure(2);
    imshow(uint8(out));
end

toc
end
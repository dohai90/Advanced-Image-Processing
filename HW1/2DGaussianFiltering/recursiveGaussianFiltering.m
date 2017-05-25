sigma = 2.6;

if (sigma >=2.5)
    q = sigma * 0.98711 - 0.96330;
elseif (sigma >= 0.5)
    q = 3.97156 - 4.14554 * sqrt(1 - 0.26891 * sigma);
else
    error('Gaussian sigma must be greater or equal than 0.5');
end

I = imread('cameraman.tif');
I = im2double(I);
figure(1);
imshow(I);
title('Original Image');

b0 = 1.57825 + (2.44413 * q) + (1.4281 * q^2) + (0.422205 * q^3);
b1 = (2.44413 * q) + (2.85619 * q^2) + (1.26661 * q^3);
b2 = -((1.4281 * q^2) + (1.26661 * q^3));
b3 = 0.422205 * q^3;
B = 1- ((b1 + b2 + b3) / b0);

B1 = b1 / b0;
B2 = b2 / b0;
B3 = b3 / b0;

tic
border = 3;
G = padarray(I, [border border], 'replicate', 'both');
[R,C] = size(G);
W = G;

% forward along horizontal axis
for r = 1:R
    W(r,1) = B * G(r,1);
    W(r,2) = B * G(r,2) + B1 * W(r,1);
    W(r,3) = B * G(r,3) + B1 * W(r,2) + B2 * W(r,1);
    for c = 4:C
        W(r,c) = B * G(r,c) + B1 * W(r,c-1) +B2 * W(r,c-2) + B3 * W(r,c-3);
    end
end

% backward along horizontal axis
for r = 1:R
    G(r,C) = B * W(r,C);
    G(r,C-1) = B * W(r,C-1) + B1 * G(r,C);
    G(r,C-2) = B * W(r,C-2) + B1 * G(r,C-1) + B2 * W(r,C);
    for c = C-3:-1:1
        G(r,c) = B * W(r,c) + B1 * G(r,c+1) + B2 * G(r,c+2) + B3 * G(r,c+3);
    end
end
figure(2);
imshow(G);
title('Gaussian Filtered Image along horizontal axis');

% forward along vertical axis
for c = 1:C
    W(1,c) = B * G(1,c);
    W(2,c) = B * G(2,c) + B1 * W(1,c);
    W(3,c) = B * G(3,c) + B1 * W(2,c) + B2 * W(1,c);
    for r = 4:R
        W(r,c) = B * G(r,c) + B1 * W(r-1,c) + B2 * W(r-2,c) + B3 * W(r-3,c);
    end
end

% backward along vertical axis
for c = 1:C
    G(R,c) = B * W(R,c);
    G(R-1,c) = B * W(R-1,c) + B1 * G(R,c);
    G(R-2,c) = B * W(R-2,c) + B1 * G(R-1,c) + B2 * G(R,c);
    for r = R-3:-1:1
        G(r,c) = B * W(r,c) + B1 * G(r+1,c) + B2 * G(r+2,c) + B3 * G(r+3,c);
    end
end

G = G(border + 1:R - border, border + 1:C - border);

figure(3);
imshow(G);
title('Recursive Gaussian Filtered Image');
toc



for i = 1:2
    if i == 1
        f = [-3 -3 3 3];
    else
        f = [-11 -11 11 11];
    end
tic
im = imread('cameraman.tif');
fim = integralFilter(im, f);
    if i == 1
        figure(1);
        imshow(uint8(fim));
    else
        figure(2);
        imshow(uint8(fim));
    end
toc
end
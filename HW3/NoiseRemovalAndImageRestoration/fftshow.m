function fftshow(f)
    fl = log(1+abs(f));
    fm = max(fl(:));
    imshow(im2uint8(fl/fm));
end


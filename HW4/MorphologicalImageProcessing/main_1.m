close all;

% Read license plate image
im_clean = imread('license_clean.png');
im_noise = imread('license_noisy.png');

% Get threshold by Otsu's method
thresh = graythresh(im_clean);

% Binarize license plate 
bw_clean = ~im2bw(im_clean, thresh);
bw_noise = ~im2bw(im_noise, thresh);

figure('name', 'Images'),
subplot(2,2,1), imshow(im_clean), title('license clean');
subplot(2,2,2), imshow(im_noise), title('license noisy');
subplot(2,2,3), imshow(bw_clean), title('clean binary image');
subplot(2,2,4), imshow(bw_noise), title('noisy binary image');

% Character recognition using erosion operation
se33 = strel('square', 3);
template = imread('B.png');
template_bin = ~im2bw(template, thresh);
template_eroded = imerode(template_bin, se33);
figure('name', 'B template'),
subplot(1,2,1), imshow(template), title('Origin');
subplot(1,2,2), imshow(template_eroded), title('Eroded');

% Erosion on clean image
match = imerode(bw_clean, template_eroded);
out = imdilate(match, template_eroded);
Composite=imfuse(bw_clean, out);
figure('name', 'Erosion Operation on clean Image'),
subplot(1,3,1), imshow(match), title('Match');
subplot(1,3,2), imshow(out), title('Character recognition');
subplot(1,3,3), imshow(Composite), title('Recognized character in white');

% Erosion on noisy image
match = imerode(bw_noise, template_eroded);
out = imdilate(match, template_eroded);
Composite=imfuse(bw_noise, out);
figure('name', 'Erosion Operation on noisy Image'),
subplot(1,3,1), imshow(match), title('Match');
subplot(1,3,2), imshow(out), title('Character recognition');
subplot(1,3,3), imshow(Composite), title('Recognized character in white');

% Character recognition using hit-or-miss method
SE1 = template_eroded;
se55 = strel('square', 5);
SE2 = imdilate(template_bin, se55) - imdilate(template_bin, se33);

% Hit-or-miss operation on clean image
hit = imerode(bw_clean, SE1) & imerode(~bw_clean, SE2);
hit_out = imdilate(hit, SE1);
Composite_hit=imfuse(bw_clean, hit_out);
figure('name', 'Hit-miss method on clean Image'),
subplot(1,3,1), imshow(hit), title('Hit');
subplot(1,3,2), imshow(hit_out), title('Character recognition');
subplot(1,3,3), imshow(Composite_hit), title('Recognized character in white');

% Hit-or-miss operation on noisy image
hit = imerode(bw_noise, SE1) & imerode(~bw_noise, SE2);
hit_out = imdilate(hit, SE1);
Composite_hit=imfuse(bw_noise, hit_out);
figure('name', 'Hit-miss method on noisy Image'),
subplot(1,3,1), imshow(hit), title('Hit');
subplot(1,3,2), imshow(hit_out), title('Character recognition');
subplot(1,3,3), imshow(Composite_hit), title('Recognized character in white');

p1=2; 
p2=11;
rank_hit = min(ordfilt2(bw_noise, p1, SE1), ordfilt2(~bw_noise, p2, SE2));
hit_out = imdilate(rank_hit, SE1);
Composite_hit=imfuse(bw_noise, hit_out);
figure('name', 'Rank filter on noisy Image'),
subplot(1,3,1), imshow(rank_hit), title('Hit');
subplot(1,3,2), imshow(hit_out), title('Character recognition');
subplot(1,3,3), imshow(Composite_hit), title('Recognized character in white');

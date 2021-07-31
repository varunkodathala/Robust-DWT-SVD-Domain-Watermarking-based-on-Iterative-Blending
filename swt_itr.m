clc;
close all;
clear all;

flag = true;

alpha = 0.5;

for i = 1:11

%% Cover Image Loading

cover_image = imread('peppers.png');
cover_image = double(rgb2gray(cover_image));
cover_image = imresize(cover_image,[256,256]);
[H_H,H_W] = size(cover_image);

[ca,chd,cvd,cdd] = swt2(cover_image,2,'db6');
A1 = (ca(:,:,1));
H1 = (chd(:,:,1));
V1 = (cvd(:,:,1));
D1 = (cdd(:,:,1));

A2 = (ca(:,:,2));
H2 = (chd(:,:,2));
V2 = (cvd(:,:,2));
D2 = (cdd(:,:,2));

%% Watermark Image Loading

watermark_image = imread('watermark3.jpg');
watermark_image = double(rgb2gray(watermark_image));
watermark_image = imresize(watermark_image,[256,256]);
%watermark_image = im2bw(watermark_image);
[W_H,W_W] = size(watermark_image);

[caw,chdw,cvdw,cddw] = swt2(cover_image,2,'db6');
A1w = wcodemat(caw(:,:,1),255);
H1w = wcodemat(chdw(:,:,1),255);
V1w = wcodemat(cvdw(:,:,1),255);
D1w = wcodemat(cddw(:,:,1),255);

A2w = wcodemat(caw(:,:,2),255);
H2w = wcodemat(chdw(:,:,2),255);
V2w = wcodemat(cvdw(:,:,2),255);
D2w = wcodemat(cddw(:,:,2),255);


[UC,SC,VS] = svd(double(A2w), 'econ');
[UW,SW,VW] = svd(double(A2), 'econ');

n = 1;

if flag
S_EMB = (1-alpha^n)*SC + (alpha^n)*SW;
end

A2_EMB = UC*S_EMB*VS';



TT = EMB_IMG;

 if i == 1
TT = TT;
end
if i == 2
TT = imgaussfilt(TT,[5,5]);
end
if i == 3
TT = imnoise(uint8(TT),'salt & pepper',0.8);
end
if i == 4
TT = imnoise(uint8(TT),'poisson');
end
if i == 5
TT = imnoise(uint8(TT),'speckle');
end
if i == 6
TT = imsharpen(TT);
end
if i == 7
TT = wiener2(TT,[3 3]);
end
if i == 8
TT = imfilter(TT, fspecial('average', [3 3]));
end
if i == 9
TT = medfilt2(TT, [3 3]);
end
if i == 10
TT = imresize(imresize(TT,[128,128]),[256,256]);
end
if i == 11
TT = imrotate(TT,20);
TT = imresize(TT,[256,256]);
end
%% Extraction Technique



[UR,SR,VR] = svd(double((LL2r)));

if flag
S_EMBR = (SR - (1-alpha^n)*SC)/(alpha^n);
end
WMR = UW*S_EMBR*VW';



imwrite(uint8(WMR),strcat('SWT_ITR/wm',int2str(i),'.png'));
imwrite(uint8(TT),strcat('SWT_ITR/em',int2str(i),'.png'));

end
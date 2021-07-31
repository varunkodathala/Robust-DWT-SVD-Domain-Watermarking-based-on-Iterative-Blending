clc;
close all;
clear all;

display('PROGRAM DETAILS:')
display('Cover Image in Frequency Domain')
display('Watermark Image in Spatial Domain')
display('Features: LL')

flag = true;

for alpha = 0.1:0.1:0.9
for i = 1:1

%% Cover Image Loading

cover_image = imread('peppers.png');
cover_image = double(rgb2gray(cover_image));
cover_image = imresize(cover_image,[256,256]);
[H_H,H_W] = size(cover_image);
fprintf('\nLoaded Cover Image Successfully with shape (%d,%d)\n',H_H,H_W);
%% Watermark Image Loading

watermark_image = imread('watermark3.jpg');
watermark_image = double(rgb2gray(watermark_image));
watermark_image = imresize(watermark_image,[256,256]);
%watermark_image = im2bw(watermark_image);
[W_H,W_W] = size(watermark_image);
fprintf('\nLoaded WaterMark Image Successfully with shape (%d,%d)\n',W_H,W_W);

%% Transform of Cover Image

% FIRST LEVEL TRANSFORM
[LL1,HL1,LH1,HH1] = dwt2(cover_image,'haar');


% SECOND LEVEL TRANSFORM
[LL2,HL2,LH2,HH2] = dwt2(LL1,'haar');


transform_shape = size(LL2); %% Host Size: [256,256] Transform Size: [64,64]


%% Watermark Image Processing 

%wm_image = imresize(watermark_image,transform_shape);
[LLw1,HLw1,LHw1,HHw1] = dwt2(watermark_image,'haar');
[LLw2,HLw2,LHw2,HHw2] = dwt2(LLw1,'haar');

%% Embedding Technique

[UC,SC,VS] = svd(double(LL2), 'econ');
[UW,SW,VW] = svd(double(LLw2), 'econ');

%alpha = 0.5;
n = 1;

S_EMB = SC + alpha*SW;
if flag
S_EMB = (1-alpha^n)*SC + (alpha^n)*SW;
end

LL2_EMB = UC*S_EMB*VS';

LL1_EMB = idwt2(LL2_EMB,HL2,LH2,HH2,'haar');
EMB_IMG = idwt2(LL1_EMB,HL1,LH1,HH1,'haar');

TT = EMB_IMG

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

[LL1r,HL1r,LH1r,HH1r] = dwt2(TT,'haar');
[LL2r,HL2r,LH2r,HH2r] = dwt2(LL1r,'haar');

[UR,SR,VR] = svd(double((LL2r)));

S_EMBR = (SR - SC)/alpha;
if flag
S_EMBR = (SR - (1-alpha^n)*SC)/(alpha^n);
end
WMR = UW*S_EMBR*VW';

WMR = idwt2(WMR,HLw2,LHw2,HHw2,'haar');
WMR = idwt2(WMR,HLw1,LHw1,HHw1,'haar');

imwrite(uint8(WMR),strcat('Proposed_alpha2/wm',int2str(i),'_',int2str(alpha*10),'.png'));
imwrite(uint8(TT),strcat('Proposed_alpha2/em',int2str(i),'_',int2str(alpha*10),'.png'));

end
end

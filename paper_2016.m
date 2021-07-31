clc;
close all;
clear all;

alpha = 0.04;
n = 1;
flag = false;

for i = 1:11

IH = imread('peppers.png');
IW = imread('watermark3.jpg');

IH = double(rgb2gray(IH));
IW = double(rgb2gray(IW));

IH = imresize(IH,[256,256]);
IW = imresize(IW,[256,256]);

IHS = zigzag(IH);
IHS = reshape(IHS,[256,256])';

HT = dct(IHS);
WT = dct(IW);

[U,S,V] = svd(HT);
[Uw,Sw,Vw] = svd(WT);

ST = S + alpha * Sw;
if flag
ST = (1-alpha*n)*S + alpha^n*Sw;
end
HTT = U*ST*V';
T = idct(HTT);
TT = inzigzag(reshape(T',[1,256*256]),256,256);
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
%figure;
%subplot(2,2,1)
%imshow(uint8(IH));
%title('HOST IMAGE')
%subplot(2,2,2)
%imshow(uint8(TT));
%title('EMBEDDED IMAGE')

TTS = zigzag(TT);
TTS = reshape(TTS,[256,256])';
TTST = dct(TTS);
[UTT,STT,VTT] = svd(TTST);

RT = (STT-S)/alpha;
if flag
RT = (STT-(1-alpha^n)*S)/alpha^n;
end
RTT = Uw*RT*Vw';
R = idct(RTT);

%subplot(2,2,3)
%imshow(uint8(IW));
%title('ORIGINAL WATERMARK')
%subplot(2,2,4)
%imshow(uint8(R))
%title('EXTRACTED WATERMARK')

%disp(psnr_user(IH,TT));
%ncc_user(IW,R)

%imwrite(uint8(R),strcat('2016_itr_results/wm',int2str(i),'.png'));

imwrite(uint8(TT),strcat('2016.png'));
break
end
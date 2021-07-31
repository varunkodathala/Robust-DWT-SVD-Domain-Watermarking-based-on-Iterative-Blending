clc;
close all;
clear all;


n = 1;
flag = false;
for i = 1:11
IH = imread('peppers.png');
IW = imread('watermark3.jpg');

IH = double(rgb2gray(IH));
IW = double(rgb2gray(IW));

IH = imresize(IH,[256,256]);
IW = imresize(IW,[128,128]);

[LL1,HL1,LH1,HH1] = dwt2(IH,'haar');

[U1,S1,V1] = svd(double(LL1), 'econ');
[U2,S2,V2] = svd(double(HL1), 'econ');
[U3,S3,V3] = svd(double(LH1), 'econ');
[U4,S4,V4] = svd(double(HH1), 'econ');


[Uw,Sw,Vw] = svd(IW,'econ');

alpha = 1/norm(Sw);
%alpha = 0.04;
disp(alpha)

S1t = S1 - alpha*Sw;
S2t = S2 - alpha*Sw;
S3t = S3 - alpha*Sw;
S4t = alpha*Sw*norm(S4);

if flag
    S1t = (1-alpha^n)*S1 + alpha^n*Sw;
    S2t = (1-alpha^n)*S2 + alpha^n*Sw;
    S3t = (1-alpha^n)*S3 + alpha^n*Sw;
    S4t = (1-alpha^n)*S4 + alpha^n*Sw;
end

LL1t = U1*S1t*V1';
HL1t = U2*S2t*V2';
LH1t = U3*S3t*V3';
HH1t = U4*S4t*V4';

EMB_IMG = idwt2(LL1t,HL1t,LH1t,HH1t,'haar');
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

EMB_IMG = TT;

[LLx1,HLx1,LHx1,HHx1] = dwt2(EMB_IMG,'haar');

[U1,Sx1,V1] = svd(double(LLx1), 'econ');
[U2,Sx2,V2] = svd(double(HLx1), 'econ');
[U3,Sx3,V3] = svd(double(LHx1), 'econ');
[U4,Sx4,V4] = svd(double(HHx1), 'econ');

Sw1 = (S1 - Sx1)/alpha;
Sw2 = (S2 - Sx2)/alpha;
Sw3 = (S3 - Sx3)/alpha;
Sw4 = ((Sx4)/alpha)/norm(S4);

if flag
    Sw1 = (Sx1 - (1-alpha^n)*S1)/alpha^n;
    Sw2 = (Sx2 - (1-alpha^n)*S2)/alpha^n;
    Sw3 = (Sx3 - (1-alpha^n)*S3)/alpha^n;
    Sw4 = (Sx4 - (1-alpha^n)*S4)/alpha^n;
end

wm1 = Uw*Sw1*Vw';
wm2 = Uw*Sw2*Vw';
wm3 = Uw*Sw3*Vw';
wm4 = Uw*Sw4*Vw';



%{
figure;
subplot(2,2,1)
imshow(uint8(wm1));
subplot(2,2,2)
imshow(uint8(wm2));
subplot(2,2,3)
imshow(uint8(wm3));
subplot(2,2,4)
imshow(uint8(wm4));
%}

%imwrite(uint8(imresize(wm1,[256,256])),strcat('2015_results/wm_LL',int2str(i),'.png'));
%imwrite(uint8(imresize(wm2,[256,256])),strcat('2015_results/wm_HL',int2str(i),'.png'));
%imwrite(uint8(imresize(wm3,[256,256])),strcat('2015_results/wm_LH',int2str(i),'.png'));
%imwrite(uint8(imresize(wm4,[256,256])),strcat('2015_results/wm_HH',int2str(i),'.png'));

imwrite(uint8(TT),strcat('2015.png'));

break
end
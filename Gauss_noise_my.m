Noise_level = 20; % Noise Level 5,10,15,--, 40
% Reading an image
a=imread('cameraman.tif');%cameraman.tif');
I2 = double(a);
% Adding noise
randn('seed', 0);    %% generate seed
I1 = I2 + (Noise_level)*randn(size(I2)); %% create a noisy image
disp('Noisy Image measure');
PSNR = 10*log10(255*255/mean((I2(:)-I1(:)).^2))

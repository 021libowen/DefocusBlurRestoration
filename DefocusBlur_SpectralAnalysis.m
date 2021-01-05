%得到原图像模糊之后的频谱图
clc;clear all;
img = imread('lena2.png');

H = fspecial('disk',4);
img = imfilter(img,H,'replicate'); 
figure;
imshow(img),title("Defocus blur image");


F = fftshift(fft2(img));  
imF = log10(abs(F)+1);
figure;imshow(imF, []);title("Defocus blur image spectrum");impixelinfo;

psf=fspecial('disk',4.2);
res=deconvblind(img,psf,50);
figure,imshow(res),title('restoration image');impixelinfo




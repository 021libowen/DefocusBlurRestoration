%�õ�ԭͼ���ɢ��ģ�����ͼ���Ƶ��ͼ
clc;clear all;
img = imread('lena2.png');
imshow(img),title("Original image");

F = fftshift(fft2(img));  
imF = log10(abs(F)+1);
figure;imshow(imF, []);title("Original image spectrum");

H = fspecial('disk',5);
img = imfilter(img,H,'replicate'); 
figure;
imshow(img),title("Defocus blur image");


F = fftshift(fft2(img));  
imF = log10(abs(F)+1);
figure;imshow(imF, []);title("Defocus blur image spectrum");
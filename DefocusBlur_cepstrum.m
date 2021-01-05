%通过图像倒谱图和相关曲线得到散焦半径
% clear
% clc
% %'计算中......'
I=imread('lena2.png');
r=6;%散焦半径r
PSF=fspecial('disk',r);   %得到点扩散函数
I1=imfilter(I,PSF,'symmetric','conv');  %实现散焦模糊
figure,imshow(I1);title('blur radius=6');

%得到倒谱图
F=fft2(I1);
F1=log(1+abs(F));
F2=abs(F1).^2;
F3=real(ifft2(F2));
figure;imshow(F3, []);title('cepstrum') 



h=fspecial('Sobel');
s=conv2(I1,h,'same');
IP=abs(fft2(s));
P=fftshift(real(ifft2(IP)));
figure;plot(P);title('autocorrelation') ;

img=I1;
psf=fspecial('disk',6);
res=deconvblind(img,psf,60);
figure,imshow(res);title('复原后的图像');
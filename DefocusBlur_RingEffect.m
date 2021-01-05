%演示1振铃效应随着卷积次数和半径的关系
% clear
% clc
% %'计算中......'
I=imread('lena2.png');
figure,imshow(I);title('原始图像');
r=4;%散焦半径r
PSF=fspecial('disk',r);   %得到点扩散函数
I1=imfilter(I,PSF,'symmetric','conv');  %实现散焦模糊
figure,imshow(I1);title('radius=4');

r=6;
PSF=fspecial('disk',r);   %得到点扩散函数
I2=imfilter(I,PSF,'symmetric','conv');  %实现散焦模糊
figure,imshow(I2);title('radius=6');


psf1=fspecial('disk',4);
psf2=fspecial('disk',6);

res1=deconvblind(I1,psf1,20);
res2=deconvblind(I2,psf2,20);
figure,imshow(res1);title('r=4 复原后的图像');
figure,imshow(res2);title('r=6 复原后的图像');

res=deconvblind(I1,psf1,60);
figure,imshow(res);title('卷积60次复原后的图像');
res=deconvblind(I1,psf1,20);
figure,imshow(res);title('卷积20次复原后的图像');
res=deconvblind(I1,psf1,10);
figure,imshow(res);title('卷积10次复原后的图像');
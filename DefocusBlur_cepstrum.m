%ͨ��ͼ����ͼ��������ߵõ�ɢ���뾶
% clear
% clc
% %'������......'
I=imread('lena2.png');
r=6;%ɢ���뾶r
PSF=fspecial('disk',r);   %�õ�����ɢ����
I1=imfilter(I,PSF,'symmetric','conv');  %ʵ��ɢ��ģ��
figure,imshow(I1);title('blur radius=6');

%�õ�����ͼ
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
figure,imshow(res);title('��ԭ���ͼ��');
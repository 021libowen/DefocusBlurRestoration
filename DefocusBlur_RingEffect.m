%��ʾ1����ЧӦ���ž�������Ͱ뾶�Ĺ�ϵ
% clear
% clc
% %'������......'
I=imread('lena2.png');
figure,imshow(I);title('ԭʼͼ��');
r=4;%ɢ���뾶r
PSF=fspecial('disk',r);   %�õ�����ɢ����
I1=imfilter(I,PSF,'symmetric','conv');  %ʵ��ɢ��ģ��
figure,imshow(I1);title('radius=4');

r=6;
PSF=fspecial('disk',r);   %�õ�����ɢ����
I2=imfilter(I,PSF,'symmetric','conv');  %ʵ��ɢ��ģ��
figure,imshow(I2);title('radius=6');


psf1=fspecial('disk',4);
psf2=fspecial('disk',6);

res1=deconvblind(I1,psf1,20);
res2=deconvblind(I2,psf2,20);
figure,imshow(res1);title('r=4 ��ԭ���ͼ��');
figure,imshow(res2);title('r=6 ��ԭ���ͼ��');

res=deconvblind(I1,psf1,60);
figure,imshow(res);title('���60�θ�ԭ���ͼ��');
res=deconvblind(I1,psf1,20);
figure,imshow(res);title('���20�θ�ԭ���ͼ��');
res=deconvblind(I1,psf1,10);
figure,imshow(res);title('���10�θ�ԭ���ͼ��');
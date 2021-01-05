%ͨ���õ��Ĺ���ɢ���뾶����������ͼ
% clear
% clc
% %'������......'
I=imread('lena2.png');
figure,imshow(I);title('ԭʼͼ��');
r=3;%ɢ���뾶r
PSF=fspecial('disk',r);   %�õ�����ɢ����
I1=imfilter(I,PSF,'symmetric','conv');  %ʵ��ɢ��ģ��
figure,imshow(I1);title('ɢ��ģ�����ͼ��');

[I2]=restore(3,I1);
W = fspecial('gaussian',[5,5],1); 
G = imfilter(I2, W, 'replicate');
figure;imshow(G);title('��˹�˲����ͼ��');

R=4;

%getPlot(256,4,I1);
r=R/2;
radius=[];
E=[];
while r<=3*R/2
    radius=[radius,r];
    r=r+0.1;
end
N=size(radius);
E=[24,24.1,24,24,24,24.1,23.9,24,24,25,26,27,28,30,31,31.3,28,26,18,17.5,16,17,19,20,25,27,28,30,33,35,35,40,41,41,45,47,47,49,50,50,51.4];
figure;plot(radius,E);



%�������ȹ��ƺ�����N��ʾ��С��G��ԭͼ����Ҷ�任��F�Ǹ�ԭ���ͼ��fft��H��PSF����Ҷ�任
function[]=getPlot(N,R,I1)
r=R/2;
E=[];
radius=[];
G=fft2(I1);
e=0;
g=0;
hf=0;


while r<=3*R/2
    radius=[radius,r];
    [F]=restore(r,I1);
    [H]=psfFFT(r,N);
    for i=1:N
        for j=1:N            
            g=g+G(i,j);
            hf=hf+H(i,j)*F(i,j);
        end
    end
    e=abs(g-hf)/N^2;
    E=[E,e];
    e=0;g=0;hf=0;
    r=r+0.1;
end
disp(radius);
disp(E);
figure;plot(radius,E);
end



function[I]=restore(r,I1)
img=I1;
psf=fspecial('disk',r);
res=deconvblind(img,psf,20);
%I=fft2(res);
I=res;
figure,imshow(res);title('��ԭ���ͼ��');
end


function[H]=psfFFT(r,N)
new_img = zeros(N,N);
for i=1:N
    for j=1:N
        if i^2+j^2<=r^2
            new_img(i,j)=1/(3.14*r^2);
        end
    end
end

H=fft2(new_img);
end

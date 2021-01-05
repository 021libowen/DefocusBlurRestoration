%通过得到的估计散焦半径画出误差估计图
% clear
% clc
% %'计算中......'
I=imread('lena2.png');
figure,imshow(I);title('原始图像');
r=3;%散焦半径r
PSF=fspecial('disk',r);   %得到点扩散函数
I1=imfilter(I,PSF,'symmetric','conv');  %实现散焦模糊
figure,imshow(I1);title('散焦模糊后的图像');

[I2]=restore(3,I1);
W = fspecial('gaussian',[5,5],1); 
G = imfilter(I2, W, 'replicate');
figure;imshow(G);title('高斯滤波后的图像');

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



%画出精度估计函数，N表示大小，G是原图傅里叶变换，F是复原后的图像fft，H是PSF傅里叶变换
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
figure,imshow(res);title('复原后的图像');
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

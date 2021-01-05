% clear
% clc
% %'计算中......'
I=imread('lena2.png');
figure,imshow(I);title('原始图像');impixelinfo;
r=4;%散焦半径r
PSF=fspecial('disk',r);   %得到点扩散函数
I1=imfilter(I,PSF,'symmetric','conv');  %实现散焦模糊
figure,imshow(I1);title('散焦模糊后的图像');

% %高斯滤波
% G=I;
% [m,n]=size(G);
% H=fspecial('gaussian', [m,n], 1);
% GH=imfilter(G,H);%对原图像平滑
% figure,imshow(GH),title('原图像高斯平滑');impixelinfo
% I2=imfilter(GH,PSF,'symmetric','conv');  %实现散焦模糊
% figure,imshow(I2);title('高斯散焦模糊后的图像');




x=I1;
[N1,N2]=size(x);
M1=100;
M2=100;
m1=M1/2;
m2=M1/2;

 
%periodic boundary
xep=zeros(N1+2*m1,N2+2*m2);
xep(m1+1:m1+N1,m2+1:m2+N2)=x;
for i=1:m1
    xep(i,:)=xep(N1+i,:);
    xep(i+m1+N1,:)=xep(m1+i,:);
end
for i=1:m2
    xep(:,i)=xep(:,N2+i);
    xep(:,i+m2+N2)=xep(:,m2+i);
end
%  
xep = double(xep)/255;


%Neumann BC
xeN=zeros(N1+2*m1,N2+2*m2);
%xeN(m1+1:m1+N1,m2+1:m2+N2)=I1;
%figure,imshow(xeN);title('加窗后的图像');

for i=m1+1:m1+N1
    for j=m2+1:m2+N2
        xeN(i,j)=I1(i-m1,j-m2);
    end
end
xeN = double(xeN)/255;


for i=1:m1
    xeN(i,:)=xeN(2*m1-i+1,:);
    xeN(i+m1+N1,:)=xeN(N1-i+m1+1,:);
end
for i=1:m2
    xeN(:,i)=xeN(:,2*m2-i+1);
    xeN(:,i+m2+N2)=xeN(:,N2-i+m2+1);
end
%  
%antireflective BC
%f(1-j)=2f(1)-f(1+j)
%f(n+j)=2f(n)-f(n-j)
xea=zeros(N1+2*m1,N2+2*m2);
xea(m1+1:m1+N1,m2+1:m2+N2)=x;
for i=1:m1
    xea(m1+1-i,:)=2*xea(m1+1,:)-xea(m1+1+i,:);
    xea(i+m1+N1,:)=2*xea(m1+N1,:)-xea(m1+N1-i,:);
end
for i=1:m2
    xea(:,m2+1-i)=2*xea(:,m2+1)-xea(:,m2+1+i);
    xea(:,i+m2+N2)=2*xea(:,m2+N2)-xea(:,m2+N2-i);
end
xea = double(xea)/255;

figure,imshow(xeN),title('加窗后的图像');impixelinfo


img=xeN;
psf=fspecial('disk',4);
res=deconvblind(img,psf,50);
figure,imshow(res),title('Neumnan加窗复原图像');impixelinfo

I3=res(m1+1:m1+N1,m2+1:m2+N2);
%xea = double(xea)/255;
figure,imshow(I3),title('Neumnan加窗复原截取后图像');impixelinfo
% 



% img=xea;
% psf=fspecial('disk',4);
% res=deconvblind(img,psf,50);
% figure,imshow(res),title('antireflective加窗复原图像');impixelinfo
% 
% I3=res(m1+1:m1+N1,m2+1:m2+N2);
% %xea = double(xea)/255;
% figure,imshow(I3),title('antireflective加窗复原截取后图像');impixelinfo
% 
% 
% 
% img=xea;
% psf=fspecial('disk',4);
% res=deconvblind(img,psf,50);
% figure,imshow(res),title('periodic加窗复原图像');impixelinfo
% 
% I3=res(m1+1:m1+N1,m2+1:m2+N2);
% %xea = double(xea)/255;
% figure,imshow(I3),title('periodic加窗复原截取后图像');impixelinfo



img=I1;
psf=fspecial('disk',4);
res=deconvblind(img,psf,50);
figure,imshow(res),title('不加窗复原图像');impixelinfo

% %先高斯滤波后加模糊再复原
% res1=deconvblind(I2,psf,20);
% figure,imshow(res1),title('不加窗复原图像--高斯滤波');impixelinfo

% G=I1;
% [m,n]=size(G);
% G=imresize(G,[0.1*m,0.1*n]);
% m=0.1*m;
% n=0.1*n;
% alpha=ceil(n/5);%随便设的宽度
% Ap=zeros(m+2*alpha,n);%A
% Bp=zeros(m,n+2*alpha);
% Cp=zeros(m+2*alpha,n+2*alpha);
% A0=Ap;%A的初始值
% B0=Bp;
% C0=Cp;
% H=fspecial('gaussian', [m,n], 1);
% GH=imfilter(G,H);%对原图像平滑
%  
% lambda=3;
% for i=1:alpha
%     Ap(i,:)=GH(m-alpha-i,:);%根据公式得到A、B、C的边界
%     Ap(m+alpha+i,:)=GH(i,:);
%     Bp(:,i)=GH(:,n-alpha+i);
%     Bp(:,n+alpha+i)=GH(:,i);
%     Cp(i,:)=Bp(m-alpha+i,:);
%     Cp(m+alpha+i,:)=Bp(i,:);
%     Cp(:,i)=Ap(:,n-alpha+i);
%     Cp(:,n+alpha+i)=Ap(:,i);
% end
%  
% fun_A=@(A) sum(sum(lap(A).^2))+lambda*sum(sum(similar(A,Ap,alpha,m,n,'A').^2));%设置A的最小化函数
% fun_B=@(A) sum(sum(lap(A).^2))+lambda*sum(sum(similar(A,Bp,alpha,m,n,'B').^2));
% fun_C=@(A) sum(sum(lap(A).^2))+lambda*sum(sum(similar(A,Cp,alpha,m,n,'C').^2));
% options = optimset('MaxFunEvals ',3e8,'MaxIter',7e5);%设置优化的参数
% A=fminunc(fun_A,A0,options);%调用最小化优化函数得到最优值A
% B=fminunc(fun_B,B0,options);
% C=fminunc(fun_C,C0,options);
% A=A(alpha+1:alpha+m,:);%裁剪得到图像部分
% B=B(:,alpha+1:alpha+n);
% C=C(alpha+1:alpha+m,alpha+1:alpha+n);
% Z=[C,A,C;B,G,B;C,A,C];%拼接得到完整Tail
% T=Z(m/2+1:5/2*m,n/2+1:5/2*n);%根据图示得到最终结果
%  
% 
% figure;imshow(T);
%  
% function s=similar(A,Ap,alpha,m,n,str)
%     if strcmp('A',str)
%         s(1:alpha,:)=A(1:alpha,:)-Ap(1:alpha,:);
%         s(alpha+1:2*alpha,:)=A(m+alpha+1:m+2*alpha,:)-Ap(m+alpha+1:m+2*alpha,:);
%     elseif strcmp('B',str)
%         s(:,1:alpha)=A(:,1:alpha)-Ap(:,1:alpha);
%         s(:,alpha+1:2*alpha)=A(:,n+alpha+1:n+2*alpha)-Ap(:,n+alpha+1:n+2*alpha);
%     else
%         t=1;
%         for i=1:m+2*alpha
%             for j=1:n+2*alpha
%                 if i<=alpha || j<=alpha || i>=m+alpha+1 || j>=n+alpha+1
%                     s(t)=A(i,j)-Ap(i,j);
%                     t=t+1;
%                 end
%             end
%         end
%     end
%         
% end
%  
% function d=lap(A)
%     [m,n]=size(A);
%     d=zeros(m,n);
%     for i=2:m-1
%         for j=2:n-1
%             d(i,j)=A(i+1,j)+A(i-1,j)+A(i,j+1)+A(i,j-1)-4*A(i,j);
%         end
%     end
% end
%    
%  

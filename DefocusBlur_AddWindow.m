% clear
% clc
% %'������......'
I=imread('lena2.png');
figure,imshow(I);title('ԭʼͼ��');impixelinfo;
r=4;%ɢ���뾶r
PSF=fspecial('disk',r);   %�õ�����ɢ����
I1=imfilter(I,PSF,'symmetric','conv');  %ʵ��ɢ��ģ��
figure,imshow(I1);title('ɢ��ģ�����ͼ��');

% %��˹�˲�
% G=I;
% [m,n]=size(G);
% H=fspecial('gaussian', [m,n], 1);
% GH=imfilter(G,H);%��ԭͼ��ƽ��
% figure,imshow(GH),title('ԭͼ���˹ƽ��');impixelinfo
% I2=imfilter(GH,PSF,'symmetric','conv');  %ʵ��ɢ��ģ��
% figure,imshow(I2);title('��˹ɢ��ģ�����ͼ��');




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
%figure,imshow(xeN);title('�Ӵ����ͼ��');

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

figure,imshow(xeN),title('�Ӵ����ͼ��');impixelinfo


img=xeN;
psf=fspecial('disk',4);
res=deconvblind(img,psf,50);
figure,imshow(res),title('Neumnan�Ӵ���ԭͼ��');impixelinfo

I3=res(m1+1:m1+N1,m2+1:m2+N2);
%xea = double(xea)/255;
figure,imshow(I3),title('Neumnan�Ӵ���ԭ��ȡ��ͼ��');impixelinfo
% 



% img=xea;
% psf=fspecial('disk',4);
% res=deconvblind(img,psf,50);
% figure,imshow(res),title('antireflective�Ӵ���ԭͼ��');impixelinfo
% 
% I3=res(m1+1:m1+N1,m2+1:m2+N2);
% %xea = double(xea)/255;
% figure,imshow(I3),title('antireflective�Ӵ���ԭ��ȡ��ͼ��');impixelinfo
% 
% 
% 
% img=xea;
% psf=fspecial('disk',4);
% res=deconvblind(img,psf,50);
% figure,imshow(res),title('periodic�Ӵ���ԭͼ��');impixelinfo
% 
% I3=res(m1+1:m1+N1,m2+1:m2+N2);
% %xea = double(xea)/255;
% figure,imshow(I3),title('periodic�Ӵ���ԭ��ȡ��ͼ��');impixelinfo



img=I1;
psf=fspecial('disk',4);
res=deconvblind(img,psf,50);
figure,imshow(res),title('���Ӵ���ԭͼ��');impixelinfo

% %�ȸ�˹�˲����ģ���ٸ�ԭ
% res1=deconvblind(I2,psf,20);
% figure,imshow(res1),title('���Ӵ���ԭͼ��--��˹�˲�');impixelinfo

% G=I1;
% [m,n]=size(G);
% G=imresize(G,[0.1*m,0.1*n]);
% m=0.1*m;
% n=0.1*n;
% alpha=ceil(n/5);%�����Ŀ��
% Ap=zeros(m+2*alpha,n);%A
% Bp=zeros(m,n+2*alpha);
% Cp=zeros(m+2*alpha,n+2*alpha);
% A0=Ap;%A�ĳ�ʼֵ
% B0=Bp;
% C0=Cp;
% H=fspecial('gaussian', [m,n], 1);
% GH=imfilter(G,H);%��ԭͼ��ƽ��
%  
% lambda=3;
% for i=1:alpha
%     Ap(i,:)=GH(m-alpha-i,:);%���ݹ�ʽ�õ�A��B��C�ı߽�
%     Ap(m+alpha+i,:)=GH(i,:);
%     Bp(:,i)=GH(:,n-alpha+i);
%     Bp(:,n+alpha+i)=GH(:,i);
%     Cp(i,:)=Bp(m-alpha+i,:);
%     Cp(m+alpha+i,:)=Bp(i,:);
%     Cp(:,i)=Ap(:,n-alpha+i);
%     Cp(:,n+alpha+i)=Ap(:,i);
% end
%  
% fun_A=@(A) sum(sum(lap(A).^2))+lambda*sum(sum(similar(A,Ap,alpha,m,n,'A').^2));%����A����С������
% fun_B=@(A) sum(sum(lap(A).^2))+lambda*sum(sum(similar(A,Bp,alpha,m,n,'B').^2));
% fun_C=@(A) sum(sum(lap(A).^2))+lambda*sum(sum(similar(A,Cp,alpha,m,n,'C').^2));
% options = optimset('MaxFunEvals ',3e8,'MaxIter',7e5);%�����Ż��Ĳ���
% A=fminunc(fun_A,A0,options);%������С���Ż������õ�����ֵA
% B=fminunc(fun_B,B0,options);
% C=fminunc(fun_C,C0,options);
% A=A(alpha+1:alpha+m,:);%�ü��õ�ͼ�񲿷�
% B=B(:,alpha+1:alpha+n);
% C=C(alpha+1:alpha+m,alpha+1:alpha+n);
% Z=[C,A,C;B,G,B;C,A,C];%ƴ�ӵõ�����Tail
% T=Z(m/2+1:5/2*m,n/2+1:5/2*n);%����ͼʾ�õ����ս��
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

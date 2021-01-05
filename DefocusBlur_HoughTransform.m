%����任�õ�ɢ���뾶

% clear
% clc
% %'������......'
I=imread('lena2.png');
r=4;%ɢ���뾶r
PSF=fspecial('disk',r);   %�õ�����ɢ����
I1=imfilter(I,PSF,'symmetric','conv');  %ʵ��ɢ��ģ��
figure,imshow(I1);title('blur radius=4');


I = imread('circle2.png'); 
[m,n,l] = size(I); 
if l>1 
    I = rgb2gray(I); 
end 
BW = edge(I,'sobel'); 
step_r = 1; 
step_angle = 0.1; 
r_min = 20; 
r_max = 50; 
thresh = 0.7; 
% %%%%%%%%%%%%%%%%%%%%%%%%%% 
% input 
% BW:��ֵͼ�� 
% step_r:����Բ�뾶���� 
% step_angle:�ǶȲ�������λΪ���� 
% r_min:��СԲ�뾶 
% r_max:���Բ�뾶 
% p:��ֵ��0��1֮����� 
 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% output 
% hough_space:�����ռ䣬h(a,b,r)��ʾԲ����(a,b)�뾶Ϊr��Բ�ϵĵ��� 
% hough_circl:��ֵͼ�񣬼�⵽��Բ 
% para:��⵽��Բ��Բ�ġ��뾶 
[m,n] = size(BW); 
size_r = round((r_max-r_min)/step_r)+1; 
size_angle = round(2*pi/step_angle); 
 
hough_space = zeros(m,n,size_r); 
 
[rows,cols] = find(BW); 
ecount = size(rows); 
 
% Hough�任 
% ��ͼ��ռ�(x,y)��Ӧ�������ռ�(a,b,r) 
% a = x-r*cos(angle) 
% b = y-r*sin(angle) 
for i=1:ecount 
    for r=1:size_r 
        for k=1:size_angle 
            a = round(rows(i)-(r_min+(r-1)*step_r)*cos(k*step_angle)); 
            b = round(cols(i)-(r_min+(r-1)*step_r)*sin(k*step_angle)); 
            if(a>0&a<=m&b>0&b<=n) 
                hough_space(a,b,r) = hough_space(a,b,r)+1; 
            end 
        end 
    end 
end 
 
% ����������ֵ�ľۼ��� 
max_para = max(max(max(hough_space))); 
index = find(hough_space>=max_para*thresh ); 
length = size(index); 
hough_circle = false(m,n); 
for i=1:ecount 
    for k=1:length 
        par3 = floor(index(k)/(m*n))+1; 
        par2 = floor((index(k)-(par3-1)*(m*n))/m)+1; 
        par1 = index(k)-(par3-1)*(m*n)-(par2-1)*m; 
        if((rows(i)-par1)^2+(cols(i)-par2)^2<(r_min+(par3-1)*step_r)^2+5&... 
                (rows(i)-par1)^2+(cols(i)-par2)^2>(r_min+(par3-1)*step_r)^2-5) 
            hough_circle(rows(i),cols(i)) = true; 
        end 
    end 
end 
 
% ��ӡ����� 
for k=1:length 
    par3 = floor(index(k)/(m*n))+1; 
    par2 = floor((index(k)-(par3-1)*(m*n))/m)+1; 
    par1 = index(k)-(par3-1)*(m*n)-(par2-1)*m; 
    par3 = r_min+(par3-1)*step_r; 
    fprintf(1,'Center %d %d radius %d\n',par1,par2,par3); 
    para(:,k) = [par1,par2,par3]; 
end 
subplot(221),imshow(I),title('ԭͼ') 
subplot(222),imshow(BW),title('��Ե') 
subplot(223),imshow(hough_circle),title('�����'),impixelinfo

img=I1;
psf=fspecial('disk',4.1);
res=deconvblind(img,psf,50);
figure,imshow(res);title('��ԭ���ͼ��');


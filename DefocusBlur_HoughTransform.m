%霍夫变换得到散焦半径

% clear
% clc
% %'计算中......'
I=imread('lena2.png');
r=4;%散焦半径r
PSF=fspecial('disk',r);   %得到点扩散函数
I1=imfilter(I,PSF,'symmetric','conv');  %实现散焦模糊
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
% BW:二值图像； 
% step_r:检测的圆半径步长 
% step_angle:角度步长，单位为弧度 
% r_min:最小圆半径 
% r_max:最大圆半径 
% p:阈值，0，1之间的数 
 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% output 
% hough_space:参数空间，h(a,b,r)表示圆心在(a,b)半径为r的圆上的点数 
% hough_circl:二值图像，检测到的圆 
% para:检测到的圆的圆心、半径 
[m,n] = size(BW); 
size_r = round((r_max-r_min)/step_r)+1; 
size_angle = round(2*pi/step_angle); 
 
hough_space = zeros(m,n,size_r); 
 
[rows,cols] = find(BW); 
ecount = size(rows); 
 
% Hough变换 
% 将图像空间(x,y)对应到参数空间(a,b,r) 
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
 
% 搜索超过阈值的聚集点 
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
 
% 打印检测结果 
for k=1:length 
    par3 = floor(index(k)/(m*n))+1; 
    par2 = floor((index(k)-(par3-1)*(m*n))/m)+1; 
    par1 = index(k)-(par3-1)*(m*n)-(par2-1)*m; 
    par3 = r_min+(par3-1)*step_r; 
    fprintf(1,'Center %d %d radius %d\n',par1,par2,par3); 
    para(:,k) = [par1,par2,par3]; 
end 
subplot(221),imshow(I),title('原图') 
subplot(222),imshow(BW),title('边缘') 
subplot(223),imshow(hough_circle),title('检测结果'),impixelinfo

img=I1;
psf=fspecial('disk',4.1);
res=deconvblind(img,psf,50);
figure,imshow(res);title('复原后的图像');


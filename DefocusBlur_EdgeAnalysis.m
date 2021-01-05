clc;clear all;
img = imread('lena2.png');
PSF=fspecial('disk',4);   %得到点扩散函数
I1=imfilter(img,PSF,'symmetric','conv');  %实现散焦模糊
figure,imshow(I1);

img=I1;
[ROW,COL,a] = size(img);
img = double(img);
new_img = zeros(ROW,COL); %新建画布
sobel_x = [-1,0,1;-2,0,2;-1,0,1];
sobel_y = [-1,-2,-1;0,0,0;1,2,1];
for i = 1:ROW - 2
    for j = 1:COL - 2
        funBox = img(i:i+2,j:j+2);
        G_x = sobel_x .* funBox;
        G_x = abs(sum(G_x(:)));
        G_y = sobel_y .* funBox;
        G_y = abs(sum(G_y(:)));
        sobelxy  = G_x * 0.5 + G_y * 0.5;
      
%带有截距的锐化（二值化）
        new_img(i+1,j+1) = sobelxy;
    end
end
figure;
imshow(new_img/255),title("image after Sobel operator");


I = new_img;
I = double(I);
[height,width] = size(I);
J = I;
 
conv = zeros(5,5);%高斯卷积核
sigma = 1;%方差
sigma_2 = sigma * sigma;%临时变量
sum = 0;
for i = 1:5
    for j = 1:5
        conv(i,j) = exp((-(i - 3) * (i - 3) - (j - 3) * (j - 3)) / (2 * sigma_2)) / (2 * 3.14 * sigma_2);%高斯公式
        sum = sum + conv(i,j);
    end
end
conv = conv./sum;%标准化
 
%对图像实施高斯滤波
for i = 1:height
    for j = 1:width
        sum = 0;%临时变量
        for k = 1:5
            for m = 1:5
                if (i - 3 + k) > 0 && (i - 3 + k) <= height && (j - 3 + m) > 0 && (j - 3 + m) < width
                    sum = sum + conv(k,m) * I(i - 3 + k,j - 3 + m);
                end
            end
        end
        J(i,j) = sum;
    end
end
figure,imshow(J,[])
title('高斯滤波后的结果')
%求梯度
dx = zeros(height,width);%x方向梯度
dy = zeros(height,width);%y方向梯度
d = zeros(height,width);
for i = 1:height - 1
    for j = 1:width - 1
        dx(i,j) = J(i,j + 1) - J(i,j);
        dy(i,j) = J(i + 1,j) - J(i,j);
        d(i,j) = sqrt(dx(i,j) * dx(i,j) + dy(i,j) * dy(i,j));
    end
end
figure,imshow(d,[])
title('求梯度后的结果')
 
%局部非极大值抑制
K = d;%记录进行非极大值抑制后的梯度
%设置图像边缘为不可能的边缘点
for j = 1:width
    K(1,j) = 0;
end
for j = 1:width
    K(height,j) = 0;
end
for i = 2:width - 1
    K(i,1) = 0;
end
for i = 2:width - 1
    K(i,width) = 0;
end
 
for i = 2:height - 1
    for j = 2:width - 1
        %当前像素点的梯度值为0，则一定不是边缘点
        if d(i,j) == 0
            K(i,j) = 0;
        else
            gradX = dx(i,j);%当前点x方向导数
            gradY = dy(i,j);%当前点y方向导数
            gradTemp = d(i,j);%当前点梯度
            %如果Y方向幅度值较大
            if abs(gradY) > abs(gradX)
                weight = abs(gradX) / abs(gradY);%权重
                grad2 = d(i - 1,j);
                grad4 = d(i + 1,j);
                %如果x、y方向导数符号相同
                %像素点位置关系
                %g1 g2
                %   C
                %   g4 g3
                if gradX * gradY > 0
                    grad1 = d(i - 1,j - 1);
                    grad3 = d(i + 1,j + 1);
                else
                    %如果x、y方向导数符号反
                    %像素点位置关系
                    %   g2 g1
                    %   C
                    %g3 g4
                    grad1 = d(i - 1,j + 1);
                    grad3 = d(i + 1,j - 1);
                end
            %如果X方向幅度值较大
            else
                weight = abs(gradY) / abs(gradX);%权重
                grad2 = d(i,j - 1);
                grad4 = d(i,j + 1);
                %如果x、y方向导数符号相同
                %像素点位置关系
                %g3
                %g4 C g2
                %     g1
                if gradX * gradY > 0
                    grad1 = d(i + 1,j + 1);
                    grad3 = d(i - 1,j - 1);
                else
                    %如果x、y方向导数符号反
                    %像素点位置关系
                    %     g1
                    %g4 C g2
                    %g3
                    grad1 = d(i - 1,j + 1);
                    grad3 = d(i + 1,j - 1);
                end
            end
            %利用grad1-grad4对梯度进行插值
            gradTemp1 = weight * grad1 + (1 - weight) * grad2;
            gradTemp2 = weight * grad3 + (1 - weight) * grad4;
            %当前像素的梯度是局部的最大值，可能是边缘点
            if gradTemp >= gradTemp1 && gradTemp >= gradTemp2
                K(i,j) = gradTemp;
            else
                %不可能是边缘点
                K(i,j) = 0;
            end
        end
    end
end
figure,imshow(K,[])
title('非极大值抑制后的结果')
%  

img=I1;
psf=fspecial('disk',4);
res=deconvblind(img,psf,100);
figure,imshow(res);title('复原后的图像');

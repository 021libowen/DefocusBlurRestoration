clc;clear all;
img = imread('lena2.png');
PSF=fspecial('disk',4);   %�õ�����ɢ����
I1=imfilter(img,PSF,'symmetric','conv');  %ʵ��ɢ��ģ��
figure,imshow(I1);

img=I1;
[ROW,COL,a] = size(img);
img = double(img);
new_img = zeros(ROW,COL); %�½�����
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
      
%���нؾ���񻯣���ֵ����
        new_img(i+1,j+1) = sobelxy;
    end
end
figure;
imshow(new_img/255),title("image after Sobel operator");


I = new_img;
I = double(I);
[height,width] = size(I);
J = I;
 
conv = zeros(5,5);%��˹�����
sigma = 1;%����
sigma_2 = sigma * sigma;%��ʱ����
sum = 0;
for i = 1:5
    for j = 1:5
        conv(i,j) = exp((-(i - 3) * (i - 3) - (j - 3) * (j - 3)) / (2 * sigma_2)) / (2 * 3.14 * sigma_2);%��˹��ʽ
        sum = sum + conv(i,j);
    end
end
conv = conv./sum;%��׼��
 
%��ͼ��ʵʩ��˹�˲�
for i = 1:height
    for j = 1:width
        sum = 0;%��ʱ����
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
title('��˹�˲���Ľ��')
%���ݶ�
dx = zeros(height,width);%x�����ݶ�
dy = zeros(height,width);%y�����ݶ�
d = zeros(height,width);
for i = 1:height - 1
    for j = 1:width - 1
        dx(i,j) = J(i,j + 1) - J(i,j);
        dy(i,j) = J(i + 1,j) - J(i,j);
        d(i,j) = sqrt(dx(i,j) * dx(i,j) + dy(i,j) * dy(i,j));
    end
end
figure,imshow(d,[])
title('���ݶȺ�Ľ��')
 
%�ֲ��Ǽ���ֵ����
K = d;%��¼���зǼ���ֵ���ƺ���ݶ�
%����ͼ���ԵΪ�����ܵı�Ե��
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
        %��ǰ���ص���ݶ�ֵΪ0����һ�����Ǳ�Ե��
        if d(i,j) == 0
            K(i,j) = 0;
        else
            gradX = dx(i,j);%��ǰ��x������
            gradY = dy(i,j);%��ǰ��y������
            gradTemp = d(i,j);%��ǰ���ݶ�
            %���Y�������ֵ�ϴ�
            if abs(gradY) > abs(gradX)
                weight = abs(gradX) / abs(gradY);%Ȩ��
                grad2 = d(i - 1,j);
                grad4 = d(i + 1,j);
                %���x��y������������ͬ
                %���ص�λ�ù�ϵ
                %g1 g2
                %   C
                %   g4 g3
                if gradX * gradY > 0
                    grad1 = d(i - 1,j - 1);
                    grad3 = d(i + 1,j + 1);
                else
                    %���x��y���������ŷ�
                    %���ص�λ�ù�ϵ
                    %   g2 g1
                    %   C
                    %g3 g4
                    grad1 = d(i - 1,j + 1);
                    grad3 = d(i + 1,j - 1);
                end
            %���X�������ֵ�ϴ�
            else
                weight = abs(gradY) / abs(gradX);%Ȩ��
                grad2 = d(i,j - 1);
                grad4 = d(i,j + 1);
                %���x��y������������ͬ
                %���ص�λ�ù�ϵ
                %g3
                %g4 C g2
                %     g1
                if gradX * gradY > 0
                    grad1 = d(i + 1,j + 1);
                    grad3 = d(i - 1,j - 1);
                else
                    %���x��y���������ŷ�
                    %���ص�λ�ù�ϵ
                    %     g1
                    %g4 C g2
                    %g3
                    grad1 = d(i - 1,j + 1);
                    grad3 = d(i + 1,j - 1);
                end
            end
            %����grad1-grad4���ݶȽ��в�ֵ
            gradTemp1 = weight * grad1 + (1 - weight) * grad2;
            gradTemp2 = weight * grad3 + (1 - weight) * grad4;
            %��ǰ���ص��ݶ��Ǿֲ������ֵ�������Ǳ�Ե��
            if gradTemp >= gradTemp1 && gradTemp >= gradTemp2
                K(i,j) = gradTemp;
            else
                %�������Ǳ�Ե��
                K(i,j) = 0;
            end
        end
    end
end
figure,imshow(K,[])
title('�Ǽ���ֵ���ƺ�Ľ��')
%  

img=I1;
psf=fspecial('disk',4);
res=deconvblind(img,psf,100);
figure,imshow(res);title('��ԭ���ͼ��');

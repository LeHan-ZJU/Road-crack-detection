function [Im4,newIm]=CrackDetectionHanle(A0,Im1,imname)
%% 代码功能：读入道路图像和其对应的U-net检测结果，检测并保存裂缝检测结果（Mask和在原图上的叠加结果）
%by hanlestudy@163.com --2019.5.24
%% 读图
% %A0为待处理裂缝图原图，imname为图像名称
% imname='39.png'; 
% A0=imread('.\0527\39.jpg');
% %Im1为U-net检测结果
% Im1=imread('.\0527\39.png');
%% 预处理
A00=imadjust(A0);  %改进，提升图像对比度
A11=A00*3;   %改进，针对道路线等影响，可以先将图片与自己叠加，然后再计算边缘2019/2/27
Aad=imadjust(A11);  %改进，提升图像对比度
Amid = medfilt2(Aad,[3,3]); %改进，进行中值滤波
se_f11 = strel('diamond', 5);
A = imopen(Amid, se_f11);
B0=A;
if ndims(B0)==3  %如果图像为三通道，将其转为灰度图
    B=rgb2gray(B0);
else B=B0;
end
%%  基于canny边缘检测算子进行裂缝检测
BW=edge(B,'canny',[0.03 0.6],3);  %调参处1：边缘检测的上下阈值0.02 0.5
figure,imshow(BW)
se_f = strel('diamond', 8);     %调参处2：正常宽度值为8，裂缝较宽时值可设置地高一些
crack = imclose(BW, se_f);

Im = ~crack;
bwn=bwareaopen(Im,5000,4);  %移除小目标
bwn = ~bwn;

figure;imshow(bwn);
% se_f2 = strel('diamond', 4);
% new_bwn=imclose(bwn,se_f2);
% figure;imshow(new_bwn);
bwn2=bwareaopen(bwn,500,4);  %移除小目标
bwn2=255*uint8(bwn2);
figure;imshow(bwn2);
B=[0 1 0,  1 1 1, 0 1 0];
A2=imdilate(bwn2,B);%图像A1被结构元素B膨胀
% A2=255*uint8(A2);
figure; imshow(A2)
Im4=FusionIm(Im1,A2); %检测结果和U-net结果结合
figure,imshow(Im4)
newIm=(A0+Im4); %裂缝叠加到原图
figure; imshow(newIm)
%% 保存图像
% direct1=[cd,'\检测结果\'];%合并图
% mkdir(direct1)
% imwrite(Im4,[direct1, 'FusionResult_',sprintf(imname)]); %
% imwrite(newIm,[direct1, 'Result2_',sprintf(imname)]);
function Im4=FusionIm(Im1,Im2)
%% 代码功能：结合裂缝的检测结果和U-net检测结果。
%Im1和Im2分别为U-net和基于形态学检测算法的检测结果。
%Im1中裂缝为白色，背景为黑色，结合的结果中，裂缝为白色，背景为黑色
%by hanlestudy@163.com
% clc
% clear all
% close all
% Im1=imread('\Path of U-net Results\1.jpg');
% Im2=imread('\Path of Detection Results\Result_40sun1_00422.png');
%%
[m,n]=size(Im2);
a=255*ones(m,n);
Im1_1=imresize(Im1,[m,n]);
Im1_2=uint8(a)-Im1_1;
Im4=Im2-(Im2-Im1_2);
%figure
imshow(Im4);
%direct=[cd,'\U-net检测结果\matlabResults\'];   %合并图
%imwrite(Im4,[direct, 'FusionResult_',sprintf(imname)]);
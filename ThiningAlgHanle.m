function [A,length] = ThiningAlgHanle(A0)
%% 代码功能：细化裂缝的检测结果。输入A0为前一步的检测结果。对检测结果迭代细化，并在满足终止条件时结束迭代，并保存结果
%by hanlestudy@163.com --2019.5.24
% clc
% clear all
% close all
%% 读图
% A0=imread('.\检测结果\FusionResult_39.png');
A=floor(A0/255);
figure;
for i=1:15
    A=ThinningIterationHanle(A);
    subplot(5,3,i),imshow(A)
    %figure, imshow(A)
    length0(i)=sum(A(:))
    length=sum(A(:));
end
figure,plot(length0)
%% 保存结果
% direct2=[cd,'\细化算法结果\'];%合并图
% imwrite(A,[direct2, 'Thining_39.png']);
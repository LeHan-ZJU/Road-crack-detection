function [A,length] = ThiningAlgHanle(A0)
%% ���빦�ܣ�ϸ���ѷ�ļ����������A0Ϊǰһ���ļ�������Լ��������ϸ��������������ֹ����ʱ������������������
%by hanlestudy@163.com --2019.5.24
% clc
% clear all
% close all
%% ��ͼ
% A0=imread('.\�����\FusionResult_39.png');
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
%% ������
% direct2=[cd,'\ϸ���㷨���\'];%�ϲ�ͼ
% imwrite(A,[direct2, 'Thining_39.png']);
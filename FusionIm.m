function Im4=FusionIm(Im1,Im2)
%% ���빦�ܣ�����ѷ�ļ������U-net�������
%Im1��Im2�ֱ�ΪU-net�ͻ�����̬ѧ����㷨�ļ������
%Im1���ѷ�Ϊ��ɫ������Ϊ��ɫ����ϵĽ���У��ѷ�Ϊ��ɫ������Ϊ��ɫ
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
%direct=[cd,'\U-net�����\matlabResults\'];   %�ϲ�ͼ
%imwrite(Im4,[direct, 'FusionResult_',sprintf(imname)]);
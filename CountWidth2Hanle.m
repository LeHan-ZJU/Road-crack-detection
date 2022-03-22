function [ResultsDistance, ResultsPixel] = CountWidth2Hanle(Region,Thin,P,In,L)
%% 代码功能：将区域生长和细化结果分为L*L个小块，然后分别计算两个图对于小块内非零像素数。
%各个小块中，区域生长的像素数除以细化结果中像素数为该小块内裂缝的平均宽度
%by hanlestudy@163.com --2019.5.24
%----------------------------输入： -----------------------------
%Region：区域生长结果
%Thin：细化结果
%P、In：相机标定参数
%L：图像分块数
%---------------------------------------------------------------
% clc
% clear all
% close all
%% 读图，预处理----------------------------------------
%imname = '40-sun1._00483'; 
%filename=strcat('DetectionResults', imname, '.xlsx'); %建excel表名
%path =  'E:\Documents\OPTIMAL\高速公路维护项目\中交裂缝检测与测量\代码\裂缝检测程序\Codes\';
%A0 = imread(strcat(path, 'inputs\', imname, '.png'));
%Region = imread(strcat(path, '区域生长结果\RegionGrow_', imname, '.png'));
%Thin=imread(strcat(path, '细化算法结果\Thining_', imname, '.png'));
%Thin=imread('.\细化算法结果\Thining_40-sun1._00483.png');
%A0=imread('.\inputs\40-sun1._00483.png');
%Region=imread('.\区域生长结果\RegionGrow_40-sun1._00483.png');
%Thin=imread('.\细化算法结果\Thining_40-sun1._00483.png');
[m,n]=size(Thin);
R1=double(Region);
T1=double(Thin);
%% 图像分块及矩阵初始化
%L=8;    %图像分块数：L*L
W_vec=zeros(1,L);
H_vec=zeros(1,L);
for x=1:L
    W_vec(1,x)=m/L;
    H_vec(1,x)=n/L;
end
ResultsPixel=zeros(L,L);
ResultsDistance=zeros(L,L);
length=zeros(L,L);
R2=mat2cell(R1,W_vec,H_vec); %区域生长结果图像分块
T2=mat2cell(T1,W_vec,H_vec); %细化结果分块
num1=zeros(L,L);
num2=zeros(L,L);
Coordinates=zeros(L,L,2);
%% 相机参数--------------------------------
% P=[-0.0269918110933597	0.557943437531732	0.829439909004369	1684.01902612949];
% In=[2382.10656348889	0	2083.74278431783
% 0	2384.57097037298	1481.71050080215
% 0	0	1];
% P=[0.00277682478665780,0.575575478935673,0.817743943598529,1740.00545108971];%5.24
% In=[[2598.38397022647,0,2087.08571329072;0,2598.66392100522,1509.97020997474;0,0,1]];%%5.24
%% --------------------------------------------
figure;
k=1;
for i=1:L
        Coordinates(i,:,1)=(i-1)*(m/L)+256; %块中心点横坐标
    for j=1:L
        Coordinates(i,j,2)=(j-1)*(m/L)+256; %块中心点纵坐标
        num1(i,j)=sum(sum(R2{i,j}/255)); %区域生长结果图像小块内非零点数目
        num2(i,j)=sum(sum(T2{i,j}/255)); %细化结果图小块内非零点数目
        if num2(i,j)>1
            Im_points=[Coordinates(i,j,1)-0.5,Coordinates(i,j,2);Coordinates(i,j,1)+0.5,Coordinates(i,j,2)];%相机参数相关
            length(i,j)=test(Im_points,P,In);    %计算每个像素的实际尺寸（以小块中心点为代表计算）
            ResultsPixel(i,j)=num1(i,j)/num2(i,j); %小块内裂缝宽度占平均像素数
            ResultsDistance(i,j)=ResultsPixel(i,j)*length(i,j);%小块内裂缝平均宽度
        end
        subplot(L,L,k),imshow(uint8(R2{i,j})) %分块显示
        k=k+1;
    end
end
figure;
imshow(Region)
figure;imshow(Thin)
%% 将检测结果写入到excel表中
% filespec_user = [pwd '\' filename];
% try
%     Excel = actxGetRunningServer('Excel.Application');
% catch
%     Excel = actxserver('Excel.Application'); 
% end;
% Excel.Visible = 1;    % set(Excel, 'Visible', 1); 
% %Workbook = Excel.Workbooks.Add;
% Workbook = invoke(Excel.Workbooks, 'Add');
% Workbook.SaveAs(filespec_user);
% Sheet1.Range('A1').MergeCells = '[实际距离（mm）]';
% R2=strcat('a',sprintf('%d', L+2));
% Sheet1.Range(R2).MergeCells = '宽度所占像素数';
% % for i=1:L
% %     R3=strcat('A2:',sprintf('%c',char(97+L)), '2');
% % end
% xlswrite(filename,ResultsDistance,'Distance');
% xlswrite(filename,ResultsPixel,'Pixel');
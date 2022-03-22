%function RoadDetectionMain
%% 代码功能：读入道路图像和其对应的U-net检测结果，检测并保存裂缝检测结果、裂缝细化结果、区域生长结果、裂缝宽度和长度
%by hanlestudy@163.com --2019.5.24
%% 读图
clc
clear all
close all
%A0为待处理裂缝图原图，imname为图像名称
imname = '40';
file_path = 'E:\Documents\OPTIMAL\高速公路维护项目\中交裂缝检测与测量\代码\裂缝检测程序\Codes\0527\';
A0 = imread(strcat(file_path, imname, '.jpg'));
%Im1为U-net检测结果
Im1 = imread(strcat(file_path, imname, '.png'));
%% 检测裂缝
[Im4,newIm]=CrackDetectionHanle(A0,Im1,imname);
direct1=[cd,'\检测结果\'];%合并图
mkdir(direct1)
imwrite(Im4,[direct1, 'FusionResult_',sprintf(imname), '.png']); %
imwrite(newIm,[direct1, 'Result2_',sprintf(imname), '.png']);
%% 细化裂缝
[A,LengthCrackP] = ThiningAlgHanle(Im4);  %A为细化结果
direct2=[cd,'\细化算法结果\'];%合并图
mkdir(direct2)
imwrite(A,[direct2, 'Thining_', sprintf(imname), '.png']);
%% 区域增长
[DetectionResult, NewIm]=RegionGrowHanle_NewSeed(A0, A);
direct3=[cd,'\区域生长结果\'];
mkdir(direct3)
imwrite(DetectionResult,[direct3, 'RegionGrow_', sprintf(imname), '.png']);
imwrite(NewIm,[direct3, 'RegionGrowIm_', sprintf(imname), '.png']);
%% 计算宽度和实际长度
P=[0.00277682478665780,0.575575478935673,0.817743943598529,1740.00545108971];%5.24
In=[[2598.38397022647,0,2087.08571329072;0,2598.66392100522,1509.97020997474;0,0,1]];%%5.24
L=8;
[ResultsDistance, ResultsPixel] = CountWidth2Hanle(DetectionResult,A,P,In,L);
DistanceName_sheet=strcat(imname, '_Distance');
PixelName_sheet=strcat(imname, '_Pixel');
xlswrite('width_length.xlsx',ResultsDistance, DistanceName_sheet); %写入裂缝实际宽度
xlswrite('width_length.xlsx',ResultsPixel, PixelName_sheet); %写入裂缝像素宽度
xlswrite('width_length.xlsx',LengthCrackP, PixelName_sheet, 'A10'); %写入裂缝像素长度，表格的A10位置
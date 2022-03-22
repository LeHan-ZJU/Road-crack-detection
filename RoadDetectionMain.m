%function RoadDetectionMain
%% ���빦�ܣ������·ͼ������Ӧ��U-net���������Ⲣ�����ѷ��������ѷ�ϸ���������������������ѷ��Ⱥͳ���
%by hanlestudy@163.com --2019.5.24
%% ��ͼ
clc
clear all
close all
%A0Ϊ�������ѷ�ͼԭͼ��imnameΪͼ������
imname = '40';
file_path = 'E:\Documents\OPTIMAL\���ٹ�·ά����Ŀ\�н��ѷ��������\����\�ѷ������\Codes\0527\';
A0 = imread(strcat(file_path, imname, '.jpg'));
%Im1ΪU-net�����
Im1 = imread(strcat(file_path, imname, '.png'));
%% ����ѷ�
[Im4,newIm]=CrackDetectionHanle(A0,Im1,imname);
direct1=[cd,'\�����\'];%�ϲ�ͼ
mkdir(direct1)
imwrite(Im4,[direct1, 'FusionResult_',sprintf(imname), '.png']); %
imwrite(newIm,[direct1, 'Result2_',sprintf(imname), '.png']);
%% ϸ���ѷ�
[A,LengthCrackP] = ThiningAlgHanle(Im4);  %AΪϸ�����
direct2=[cd,'\ϸ���㷨���\'];%�ϲ�ͼ
mkdir(direct2)
imwrite(A,[direct2, 'Thining_', sprintf(imname), '.png']);
%% ��������
[DetectionResult, NewIm]=RegionGrowHanle_NewSeed(A0, A);
direct3=[cd,'\�����������\'];
mkdir(direct3)
imwrite(DetectionResult,[direct3, 'RegionGrow_', sprintf(imname), '.png']);
imwrite(NewIm,[direct3, 'RegionGrowIm_', sprintf(imname), '.png']);
%% �����Ⱥ�ʵ�ʳ���
P=[0.00277682478665780,0.575575478935673,0.817743943598529,1740.00545108971];%5.24
In=[[2598.38397022647,0,2087.08571329072;0,2598.66392100522,1509.97020997474;0,0,1]];%%5.24
L=8;
[ResultsDistance, ResultsPixel] = CountWidth2Hanle(DetectionResult,A,P,In,L);
DistanceName_sheet=strcat(imname, '_Distance');
PixelName_sheet=strcat(imname, '_Pixel');
xlswrite('width_length.xlsx',ResultsDistance, DistanceName_sheet); %д���ѷ�ʵ�ʿ��
xlswrite('width_length.xlsx',ResultsPixel, PixelName_sheet); %д���ѷ����ؿ��
xlswrite('width_length.xlsx',LengthCrackP, PixelName_sheet, 'A10'); %д���ѷ����س��ȣ�����A10λ��
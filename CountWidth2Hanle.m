function [ResultsDistance, ResultsPixel] = CountWidth2Hanle(Region,Thin,P,In,L)
%% ���빦�ܣ�������������ϸ�������ΪL*L��С�飬Ȼ��ֱ��������ͼ����С���ڷ�����������
%����С���У���������������������ϸ�������������Ϊ��С�����ѷ��ƽ�����
%by hanlestudy@163.com --2019.5.24
%----------------------------���룺 -----------------------------
%Region�������������
%Thin��ϸ�����
%P��In������궨����
%L��ͼ��ֿ���
%---------------------------------------------------------------
% clc
% clear all
% close all
%% ��ͼ��Ԥ����----------------------------------------
%imname = '40-sun1._00483'; 
%filename=strcat('DetectionResults', imname, '.xlsx'); %��excel����
%path =  'E:\Documents\OPTIMAL\���ٹ�·ά����Ŀ\�н��ѷ��������\����\�ѷ������\Codes\';
%A0 = imread(strcat(path, 'inputs\', imname, '.png'));
%Region = imread(strcat(path, '�����������\RegionGrow_', imname, '.png'));
%Thin=imread(strcat(path, 'ϸ���㷨���\Thining_', imname, '.png'));
%Thin=imread('.\ϸ���㷨���\Thining_40-sun1._00483.png');
%A0=imread('.\inputs\40-sun1._00483.png');
%Region=imread('.\�����������\RegionGrow_40-sun1._00483.png');
%Thin=imread('.\ϸ���㷨���\Thining_40-sun1._00483.png');
[m,n]=size(Thin);
R1=double(Region);
T1=double(Thin);
%% ͼ��ֿ鼰�����ʼ��
%L=8;    %ͼ��ֿ�����L*L
W_vec=zeros(1,L);
H_vec=zeros(1,L);
for x=1:L
    W_vec(1,x)=m/L;
    H_vec(1,x)=n/L;
end
ResultsPixel=zeros(L,L);
ResultsDistance=zeros(L,L);
length=zeros(L,L);
R2=mat2cell(R1,W_vec,H_vec); %�����������ͼ��ֿ�
T2=mat2cell(T1,W_vec,H_vec); %ϸ������ֿ�
num1=zeros(L,L);
num2=zeros(L,L);
Coordinates=zeros(L,L,2);
%% �������--------------------------------
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
        Coordinates(i,:,1)=(i-1)*(m/L)+256; %�����ĵ������
    for j=1:L
        Coordinates(i,j,2)=(j-1)*(m/L)+256; %�����ĵ�������
        num1(i,j)=sum(sum(R2{i,j}/255)); %�����������ͼ��С���ڷ������Ŀ
        num2(i,j)=sum(sum(T2{i,j}/255)); %ϸ�����ͼС���ڷ������Ŀ
        if num2(i,j)>1
            Im_points=[Coordinates(i,j,1)-0.5,Coordinates(i,j,2);Coordinates(i,j,1)+0.5,Coordinates(i,j,2)];%����������
            length(i,j)=test(Im_points,P,In);    %����ÿ�����ص�ʵ�ʳߴ磨��С�����ĵ�Ϊ������㣩
            ResultsPixel(i,j)=num1(i,j)/num2(i,j); %С�����ѷ���ռƽ��������
            ResultsDistance(i,j)=ResultsPixel(i,j)*length(i,j);%С�����ѷ�ƽ�����
        end
        subplot(L,L,k),imshow(uint8(R2{i,j})) %�ֿ���ʾ
        k=k+1;
    end
end
figure;
imshow(Region)
figure;imshow(Thin)
%% �������д�뵽excel����
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
% Sheet1.Range('A1').MergeCells = '[ʵ�ʾ��루mm��]';
% R2=strcat('a',sprintf('%d', L+2));
% Sheet1.Range(R2).MergeCells = '�����ռ������';
% % for i=1:L
% %     R3=strcat('A2:',sprintf('%c',char(97+L)), '2');
% % end
% xlswrite(filename,ResultsDistance,'Distance');
% xlswrite(filename,ResultsPixel,'Pixel');
function [Im4,newIm]=CrackDetectionHanle(A0,Im1,imname)
%% ���빦�ܣ������·ͼ������Ӧ��U-net���������Ⲣ�����ѷ�������Mask����ԭͼ�ϵĵ��ӽ����
%by hanlestudy@163.com --2019.5.24
%% ��ͼ
% %A0Ϊ�������ѷ�ͼԭͼ��imnameΪͼ������
% imname='39.png'; 
% A0=imread('.\0527\39.jpg');
% %Im1ΪU-net�����
% Im1=imread('.\0527\39.png');
%% Ԥ����
A00=imadjust(A0);  %�Ľ�������ͼ��Աȶ�
A11=A00*3;   %�Ľ�����Ե�·�ߵ�Ӱ�죬�����Ƚ�ͼƬ���Լ����ӣ�Ȼ���ټ����Ե2019/2/27
Aad=imadjust(A11);  %�Ľ�������ͼ��Աȶ�
Amid = medfilt2(Aad,[3,3]); %�Ľ���������ֵ�˲�
se_f11 = strel('diamond', 5);
A = imopen(Amid, se_f11);
B0=A;
if ndims(B0)==3  %���ͼ��Ϊ��ͨ��������תΪ�Ҷ�ͼ
    B=rgb2gray(B0);
else B=B0;
end
%%  ����canny��Ե������ӽ����ѷ���
BW=edge(B,'canny',[0.03 0.6],3);  %���δ�1����Ե����������ֵ0.02 0.5
figure,imshow(BW)
se_f = strel('diamond', 8);     %���δ�2���������ֵΪ8���ѷ�Ͽ�ʱֵ�����õظ�һЩ
crack = imclose(BW, se_f);

Im = ~crack;
bwn=bwareaopen(Im,5000,4);  %�Ƴ�СĿ��
bwn = ~bwn;

figure;imshow(bwn);
% se_f2 = strel('diamond', 4);
% new_bwn=imclose(bwn,se_f2);
% figure;imshow(new_bwn);
bwn2=bwareaopen(bwn,500,4);  %�Ƴ�СĿ��
bwn2=255*uint8(bwn2);
figure;imshow(bwn2);
B=[0 1 0,  1 1 1, 0 1 0];
A2=imdilate(bwn2,B);%ͼ��A1���ṹԪ��B����
% A2=255*uint8(A2);
figure; imshow(A2)
Im4=FusionIm(Im1,A2); %�������U-net������
figure,imshow(Im4)
newIm=(A0+Im4); %�ѷ���ӵ�ԭͼ
figure; imshow(newIm)
%% ����ͼ��
% direct1=[cd,'\�����\'];%�ϲ�ͼ
% mkdir(direct1)
% imwrite(Im4,[direct1, 'FusionResult_',sprintf(imname)]); %
% imwrite(newIm,[direct1, 'Result2_',sprintf(imname)]);
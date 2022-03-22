function [DetectionResult, NewIm]=RegionGrowHanle_NewSeed(img,seeds)
%% ���빦�ܣ�����·��ԭͼ����һ���ѷ�ϸ�������
%��ϸ�������ÿ����λ���ӵ�����������������������У��Ե�ǰ�����������Сֵ��λ�µ����ӵ㣬ֱ��û�з������������ص�Ϊֹ
%by hanlestudy@163.com --2019.5.24
%% ��ͼ
% clc
% clear all
% close all
% img=imread('.\0527\39.jpg');
% % img2=im2bw(img,0.28);
% %figure,subplot(1,2,1),imshow(img);
% % subplot(1,2,2),imshow(~img2)
% seeds=imread('.\ϸ���㷨���\Thining_39.png');
img2=double(img);
%% ��ʼ�����󣬴��������������
[m,n]=size(img);
NewMask=zeros(m,n);
[row,col]=find(seeds~=0);
nums = length(row);
NewMask1=img2.*(seeds/255); %��ʼ���������
means=sum(sum(NewMask1))/nums
Directions=[-1,1;0,1;1,1;1,0;1,-1;0,-1;-1,-1;-1,0]; %�����������
%% �����㷨
for i=1:nums
    NewMask(row(i),col(i))=img(row(i),col(i));
    r_new=row(i);
    c_new=col(i);
    %Neighbor=ones(8,3);
    label1=1;
    label2=1;
    while label1==label2
        k=0;
        Neighbor=ones(8,3)*300;
        for j=1:8 %��ȡ���ӵ�������ڵ��ֵ
            r1=r_new+Directions(j,1);  %���������
            c1=c_new+Directions(j,2);
            Condition=(r1>0) && (r1<=m) && (c1>0) && (c1<=n); %�б�õ��Ƿ���ͼ��Χ��
            if Condition && (NewMask(r1,c1)==0) %���õ�������������֮ǰû�б���⣬�������������У�����һ�����
                k=k+1;
                Neighbor(j,:)=[r1,c1,img2(r1,c1)];
            end
        end
        label1=label1+1;
        if k>0
            Nei_min=min(Neighbor(:,3));
            if (Nei_min<means || Nei_min-means<20) %�б�����
                seq=find(Neighbor(:,3)==Nei_min); %�ҵ���Сֵ��Neighbor�е�λ�ã���Ϊ��һ�����ӵ�
                r_new=Neighbor(seq(1),1);  %�������ӵ�
                c_new=Neighbor(seq(1),2);
                NewMask(r_new,c_new)=img(r_new,c_new); %�������������ĵ������������
                label2=label2+1;
                %lab=label1-label2
            end
        else
            break
        end
    end
    i
end
DetectionResult=uint8(255*NewMask);
figure,imshow(DetectionResult)
NewIm=DetectionResult+img; %�������ԭͼ����
figure,imshow(NewIm)
%% ������
% direct3=[cd,'\�����������\'];
% imwrite(DetectionResult,[direct3, 'RegionGrow_39.png']);
% imwrite(NewIm,[direct3, 'RegionGrowIm_39.png']);
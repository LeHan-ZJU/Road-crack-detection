function [DetectionResult, NewIm]=RegionGrowHanle_NewSeed(img,seeds)
%% 代码功能：读入路面原图和上一步裂缝细化结果。
%以细化结果中每个点位种子点进行区域生长，生长过程中，以当前点八邻域内最小值点位新的种子点，直至没有符合条件的像素点为止
%by hanlestudy@163.com --2019.5.24
%% 读图
% clc
% clear all
% close all
% img=imread('.\0527\39.jpg');
% % img2=im2bw(img,0.28);
% %figure,subplot(1,2,1),imshow(img);
% % subplot(1,2,2),imshow(~img2)
% seeds=imread('.\细化算法结果\Thining_39.png');
img2=double(img);
%% 初始化矩阵，创建八邻域方向矩阵
[m,n]=size(img);
NewMask=zeros(m,n);
[row,col]=find(seeds~=0);
nums = length(row);
NewMask1=img2.*(seeds/255); %初始化结果矩阵
means=sum(sum(NewMask1))/nums
Directions=[-1,1;0,1;1,1;1,0;1,-1;0,-1;-1,-1;-1,0]; %八邻域方向矩阵
%% 生长算法
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
        for j=1:8 %获取种子点八邻域内点的值
            r1=r_new+Directions(j,1);  %跟邻领域点
            c1=c_new+Directions(j,2);
            Condition=(r1>0) && (r1<=m) && (c1>0) && (c1<=n); %判别该点是否在图像范围内
            if Condition && (NewMask(r1,c1)==0) %若该点满足条件并且之前没有被检测，则加入八邻域结果中，待下一步检测
                k=k+1;
                Neighbor(j,:)=[r1,c1,img2(r1,c1)];
            end
        end
        label1=label1+1;
        if k>0
            Nei_min=min(Neighbor(:,3));
            if (Nei_min<means || Nei_min-means<20) %判别条件
                seq=find(Neighbor(:,3)==Nei_min); %找到最小值在Neighbor中的位置，作为下一个种子点
                r_new=Neighbor(seq(1),1);  %更新种子点
                c_new=Neighbor(seq(1),2);
                NewMask(r_new,c_new)=img(r_new,c_new); %将该满足条件的点放入结果矩阵中
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
NewIm=DetectionResult+img; %检测结果与原图叠加
figure,imshow(NewIm)
%% 保存结果
% direct3=[cd,'\区域生长结果\'];
% imwrite(DetectionResult,[direct3, 'RegionGrow_39.png']);
% imwrite(NewIm,[direct3, 'RegionGrowIm_39.png']);
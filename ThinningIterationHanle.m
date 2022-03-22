function Duplicate2=ThinningIterationHanle(A)
%% 代码功能：实现论文《A fast parallel algorithm for thinning digital patterns》
%通过四个判别条件细化道路裂缝
%by hanlestudy@163.com --2019.5.24
[m,n]=size(A);
Duplicate=zeros(m,n);
Duplicate2=zeros(m,n);
%%
for i=2:m-1 %第一次子迭代
    for j=2:n-1
        if A(i,j)==1
            Region=[A(i-1,j),A(i-1,j+1),A(i,j+1),A(i+1,j+1),A(i+1,j),A(i+1,j-1),A(i,j-1),A(i-1,j-1)]; %[p2-p9]
            C1=sum(Region);      %2<= p2+p3+p4+p5+p6+p7+p8+p9<=6
            C3=A(i-1,j)*A(i,j+1)*A(i+1,j);  %P2*p4*p6 = 0
            C4=A(i,j+1)*A(i+1,j)*A(i,j-1);  %p4*p6*p8 = 0
            C2=0;
            for k=1:7  %统p2-p9的01模式数目
                if Region(k)==0&&Region(k+1)==1
                    C2=C2+1;
                end
            end
            if (C1<=6)&&(C1>=2)&&(C2==1)&&(C3==0)&&(C4==0)
                Duplicate(i,j)=0;
            else
                Duplicate(i,j)=1;
            end
        else
            Duplicate(i,j)=0;
        end
    end
end
%%
for i=2:m-1  %第二次子迭代
    for j=2:n-1
        if Duplicate(i,j)==1
            Region2=[Duplicate(i-1,j),Duplicate(i-1,j+1),Duplicate(i,j+1),Duplicate(i+1,j+1),Duplicate(i+1,j),Duplicate(i+1,j-1),Duplicate(i,j-1),Duplicate(i-1,j-1)]; %[p2-p9]
            C11=sum(Region2);      %2<= p2+p3+p4+p5+p6+p7+p8+p9<=6
            C33=Duplicate(i-1,j)*Duplicate(i,j+1)*Duplicate(i,j-1);  %P2*p4*p8 = 0
            C44=Duplicate(i-1,j)*Duplicate(i+1,j)*Duplicate(i,j-1);  %p2*p6*p8 = 0
            C22=0;
            for k=1:7  %统p2-p9的01模式数目
                if Region2(k)==0&&Region2(k+1)==1
                    C22=C22+1;
                end
            end
            if (C11<=6)&&(C11>=2)&&(C22==1)&&(C33==0)&&(C44==0)
                Duplicate2(i,j)=0;
            else
                Duplicate2(i,j)=1;
            end
        else
            Duplicate2(i,j)=0;
        end
    end
end
%figure,imshow(Duplicate2)
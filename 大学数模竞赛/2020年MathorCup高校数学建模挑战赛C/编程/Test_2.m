%NUM = zeros(1,3000);%货格号的一维数组
S1 = zeros(1,3000);
i = 1;
a = 0.8;
d = 0.75;
b = 2;


%建立基础坐标数组
p1 = 3 - 0.75;
jcp = zeros(1,26);
S3 = zeros(1,3000);
for i = 1:26
    jcp(1,i) = p1+(i-1)*(2*a+2*d);
end
%复核台水平坐标
fhs = 36;
fhs1 = 1; 
    for j = 1:3000
        A2 = floor(NUM(1,j)/100);
        B2 = mod(NUM(1,j),100);
        n2 = floor(A2/8);
        m2 = mod(A2,8);
        %确定终点位置
        %行判定
        if m2==1 || m2==2
            h2 = 1;
        end
        if m2==3 || m2==4
            h2 = 2;
        end
        if m2==5 || m2==6
            h2 = 3;
        end
        if m2==7 || m2==0
            h2 = 4;
        end
        %列判断
        l2 = n2+1;
        if m2 == 0
            l2 = n2;
        end
        %左右侧判断
        if mod(m2,2)==0
            ce2 = 0;
        else
            ce2 = 1;
        end
        %接下来判断情况
        %竖直第一步的偏移量 从复核台到水平轨道
        S3(1,j) = S3(1,j)+((3-0.75) - 1);
        %第二步判断是哪个轨道的
        if ce2==1
            guidao = l2;
        else
            guidao = l2+1;
        end
        %第三步加上水平轨道的偏移量
        S3(1,j) = S3(1,j)+abs(jcp(1,guidao) - fhs);
        %第四步加上竖直方向的偏移量
        S3(1,j) = S3(1,j)+(B2 - 1)*a+0.5*a+d+d+(h2-1)*(15*a+b);
    end
S4 = S3';
pos1 = 1;
pos2 = 1;
for i = 1:3000
    if NUM(1,i) == 9403
        pos1 = i;
    end
    if NUM(1,i) == 10103
        pos2 = i;
    end
end

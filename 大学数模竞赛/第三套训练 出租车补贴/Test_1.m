%计算两家公司的缓解率
%xx,xy为设定好的因子数据
%首先计算没有减费时各个城市的供求匹配程度
ori = pipei(xx,xy,0);
%手动敲入快的和滴滴的补贴政策 KD_butie DD_butie
%接下来建立两种结果的矩阵 每一列是相对应的城市供求匹配程度
KD_result = zeros(8,9);
DD_result = zeros(8,8);
for i = 1:9
    temp = pipei(xx,xy,KD_butie(1,i));
    KD_result(:,i) = temp(:,1);
end
for i = 1:8
    temp = pipei(xx,xy,DD_butie(1,i));
    DD_result(:,i) = temp(:,1);
end
%接下来计算缓解率
KD_huanjie = zeros(8,9);
DD_huanjie = zeros(8,8);
for i = 1:9
    for j = 1:8
        KD_huanjie(j,i) = (KD_result(j,i) - ori(j,1))/ori(j,1);
    end
end
for i = 1:8
    for j = 1:8
        DD_huanjie(j,i) = (DD_result(j,i) - ori(j,1))/ori(j,1);
    end
end
%接下来计算对于每个补贴金额 对于所有城市的平均缓解率
KD_huanjie_mean = zeros(1,9);
DD_huanjie_mean = zeros(1,8);
for i = 1:9 
    KD_huanjie_mean(1,i) = sum(KD_huanjie(:,i))/8;
end
for i = 1:8 
    DD_huanjie_mean(1,i) = sum(DD_huanjie(:,i))/8;
end
%接下来计算两个平台在政策实行时间内的加权平均缓解率
%DD_time和KD_time是手动输入的相对应的政策实行时间
temp = 0;
for i = 1:9
    temp = temp+KD_time(1,i)*KD_huanjie_mean(1,i);
end
KD_huanjie_jiaquan = temp/sum(KD_time(1,:));
temp = 0;
for i = 1:8
    temp = temp+DD_time(1,i)*DD_huanjie_mean(1,i);
end
DD_huanjie_jiaquan = temp/sum(DD_time(1,:));
%政策实行期间各个城市的加权平均缓解率

KD_huanjie_city = zeros(8,1);
for j = 1:8
    temp = 0;
    for i = 1:9
        temp = temp+KD_time(1,i)*KD_huanjie(j,i);
    end
    KD_huanjie_city(j,1) = temp/sum(KD_time(1,:));
end

DD_huanjie_city = zeros(8,1);
for j = 1:8
    temp = 0;
    for i = 1:8
        temp = temp+DD_time(1,i)*DD_huanjie(j,i);
    end
    DD_huanjie_city(j,1) = temp/sum(DD_time(1,:));
end

%Test_1
%�����ͼ 
%map1�ǵ�һ�ص��ڽӾ���
maptest = map1;
for i = 1:27
    for j = 1:27
        if maptest(i,j) == 0 && i ~= j
            maptest(i,j) = inf;
        end
    end
end
[result1,result2] = floyd(maptest,12,27);
%Test_1
%处理地图 
%map1是第一关的邻接矩阵
maptest = map1;
for i = 1:27
    for j = 1:27
        if maptest(i,j) == 0 && i ~= j
            maptest(i,j) = inf;
        end
    end
end
[result1,result2] = floyd(maptest,12,27);
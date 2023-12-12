%计算风险价值 并储存在一维向量对应的空间里
Svar = zeros(1,10);
for i = 1:10
    for j = 1:57
        Svar(i) = Svar(i)+ money(i,j) * vvar(1,j);
    end
end
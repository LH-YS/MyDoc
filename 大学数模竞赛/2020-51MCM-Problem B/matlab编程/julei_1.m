%变量b直接在工作区进行赋值
by = pdist(b,'cityblock');%求两两向量之间的绝对值距离
bc = squareform(by);%距离矩阵
bz = linkage(by);%等级聚类树
dendrogram(bz);%画聚类图
T = cluster(bz,'maxclust',6);
for i = 1:6
    tm = find(T == i);
    tm = reshape(tm,1,length(tm));
    fprintf('第%d类的有%s\n',i,int2str(tm));
end
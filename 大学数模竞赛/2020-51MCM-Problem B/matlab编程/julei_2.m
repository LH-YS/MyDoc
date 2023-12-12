%变量p直接在工作区进行赋值
py = pdist(p,'cityblock');%求两两向量之间的绝对值距离
pc = squareform(py);%距离矩阵
pz = linkage(py);%等级聚类树
dendrogram(pz);%画聚类图
T = cluster(pz,'maxclust',6);
for i = 1:6
    tm = find(T == i);
    tm = reshape(tm,1,length(tm));
    fprintf('第%d类的有%s\n',i,int2str(tm));
end
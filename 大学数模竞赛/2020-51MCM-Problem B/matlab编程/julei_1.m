%����bֱ���ڹ��������и�ֵ
by = pdist(b,'cityblock');%����������֮��ľ���ֵ����
bc = squareform(by);%�������
bz = linkage(by);%�ȼ�������
dendrogram(bz);%������ͼ
T = cluster(bz,'maxclust',6);
for i = 1:6
    tm = find(T == i);
    tm = reshape(tm,1,length(tm));
    fprintf('��%d�����%s\n',i,int2str(tm));
end
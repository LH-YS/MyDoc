%����pֱ���ڹ��������и�ֵ
py = pdist(p,'cityblock');%����������֮��ľ���ֵ����
pc = squareform(py);%�������
pz = linkage(py);%�ȼ�������
dendrogram(pz);%������ͼ
T = cluster(pz,'maxclust',6);
for i = 1:6
    tm = find(T == i);
    tm = reshape(tm,1,length(tm));
    fprintf('��%d�����%s\n',i,int2str(tm));
end
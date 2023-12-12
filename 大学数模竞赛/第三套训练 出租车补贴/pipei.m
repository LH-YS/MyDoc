%计算各个城市的供求匹配程度
function[score] = pipei(xx,xy,c)
[F1,FF1] = PCA(xx,c);
[F2,FF2] = PCA(xy,c);
for i = 1:8
    fangcha_1 = sum((FF1(:,1)-mean(FF1)).^2)/(length(FF1));
    fangcha_2 = sum((FF2(:,1)-mean(FF2)).^2)/(length(FF2));
end
score1 = zeros(8,1);
for i = 1:8
u1 = exp(-((0.2*FF1(i,1)).^2)/fangcha_1);
u2 = exp(-((0.2*FF2(i,1)).^2)/fangcha_2);
temp = 1;
if u1>u2
    temp = u2/u1;
    score1(i,1) = temp;
else
    temp = u1/u2;
    score1(i,1) = temp;
end
end
score = score1;
end
ltime = booltemp/1.5;%��·���ѵ�ʱ��
xtime = 0;
for i = 1:rwnum
    if rw(i,2) < 3
        xtime = xtime + rw(i,2)*5;
    else
        xtime = xtime + rw(i,2)*4;
    end
end
alltime = ltime+xtime;
hgsx = zeros(1,rwnum);
ii = 1;
for i = bestj:rwnum
    hgsx(1,ii) = rw(subPath(i),1);
    ii = ii+1;
end
for i = 1:besti
    hgsx(1,ii) = rw(subPath(i),1);
    ii = ii+1;
end
hgsx = hgsx';
%����Ŀ����ȡ�������
%Ŀ���������� �������Ŀ�������е�����
rwnum = 0;
rwname = 6;
for i = 1:1200
    if RWnum(i,1) == rwname
        rwnum = rwnum+1;
    end
end
%��������������������
rw = zeros(rwnum,2);
temp1 = 1;
for i = 1:1200
    if RWnum(i,1) == rwname
        rw(temp1,1) = RWnum(i,2);
        rw(temp1,2) = RWnum(i,3);
        temp1 = temp1+1;
    end
end
%�������񵥵����ݽ����������
pos1 = 1;
pos2 = 1;
Drw = zeros(rwnum,rwnum);
for i = 1:rwnum
    r1 = rw(i,1);
    for j = 1:rwnum
        r2 = rw(j,1);
        for i1 = 1:3000
            if NUM(1,i1) == r1
                pos1 = i1;
            end
            if NUM(1,i1) == r2
                pos2 = i1;
            end
        end
        Drw(i,j) = S(pos1,pos2);
    end
end

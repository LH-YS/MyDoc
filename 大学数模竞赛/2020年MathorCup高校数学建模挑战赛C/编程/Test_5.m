SUM = 0;
for i = 1:rwnum-1
    for i1 = 1:3000
    if NUM(1,i1) == rw(subPath(i))
        pos4 = i1;
    end
    if NUM(1,i1) == rw(subPath(i+1))
        pos5 = i1;
    end
    end
    SUM = SUM+S(pos4,pos5);
end
    if NUM(1,i1) == rw(subPath(1))
        pos4 = i1;
    end
    if NUM(1,i1) == rw(subPath(23))
        pos5 = i1;
    end
SUM = SUM+S(pos4,pos5);
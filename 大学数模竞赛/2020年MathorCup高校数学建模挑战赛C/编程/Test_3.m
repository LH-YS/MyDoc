%计算复核台之间的距离
%fhzb = zeros(13,2);
fhjl = zeros(13,13);   
for i = 1:13
    for j = 1:13
        fhjl(i,j) = (abs(fhzb(i,1) - fhzb(j,1))+abs(fhzb(i,2) - fhzb(j,2)))/1000;
    end
end
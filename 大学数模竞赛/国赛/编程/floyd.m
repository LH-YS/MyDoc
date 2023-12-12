%利用Floyd算法求出最短路
function [distance,minpath] = floyd(A,firstpoint,lastpoint)
n = size(A,1);
path = zeros(n);
for k = 1:n
    for i = 1:n
        for j = 1:n
            if A(i,j) > A(i,k) + A(k,j)
                A(i,j) = A(i,k) + A(k,j);
                path(i,j) = k;
            end
        end
    end
end
distance = A(firstpoint,lastpoint);
parent = path(firstpoint,:);
parent(parent == 0) = firstpoint;
minpath = [lastpoint];
temp = lastpoint;
while temp ~= firstpoint
    p = parent(temp);
    minpath = [p,minpath];
    temp = p;
end
end
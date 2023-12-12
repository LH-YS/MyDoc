%一维搜索求最优解算法
ii = 1;%迭代次数
AA = 17.3;%效用最大时A值的下临界值
%根据R给A赋值
A = zeros(57,114);
for i = 1:57
    for j = 1:57
        A(i,j) = data_R(1,j);
    end
end
for i = 1:57
    A(i+57,i) = -1;
end
%二次规划求解
data_dR = data_R';
f = fuF .* data_dR;
H = zeros(114,114);
for i = 58:114
    H(i,i) = AA*(1/(i-57));
end
Aeq = F';
Beq = 1;
lb = zeros(114,1);
B = fuF(1:57,1) .* data_dR(1:57,1);
[xx,fval,exitflag,output,lambda] = quadprog(H,f,A,B,Aeq,Beq,lb);
xxx = xx';
result = zeros(1,100);
up_fval = fval + 0.0001;%规定区间上界
while fval <= up_fval
    data_dR = data_R';
    f = fuF .* data_dR;
    H = zeros(114,114);
    for i = 58:114
        H(i,i) = AA*(1/(i-57));
    end
    Aeq = F';
    Beq = 1;
    lb = zeros(114,1);
    B = fuF(1:57,1) .* data_dR(1:57,1);
    [xx,fval,exitflag,output,lambda] = quadprog(H,f,A,B,Aeq,Beq,lb);
    xxx = xx';
    vvalue = 24675114.49 * xxx(1,1:57);%分配的钱
    result(1,ii) = vvalue * vvar';
    ii = ii + 1;
    AA = AA + 0.001;
end
iii = 2;
min_var = result(1);
min_number = 1;
%风险价值最小的值和迭代次数
while result(1,iii) ~= 0
    if result(1,iii) < result(1,iii - 1)
        min_var = result(1,iii);
        min_number = iii;
        iii = iii + 1;
    end
end
%运行完毕后min_var有最小风险价值
AA = AA + 0.01*(min_number - 1);
%求出此时的最优分配方案
data_dR = data_R';
f = fuF .* data_dR;
H = zeros(114,114);
for i = 58:114
    H(i,i) = AA*(1/(i-57));
end
Aeq = F';
Beq = 1;
lb = zeros(114,1);
B = fuF(1:57,1) .* data_dR(1:57,1);
[xx,fval,exitflag,output,lambda] = quadprog(H,f,A,B,Aeq,Beq,lb);
best_solve = xx';%此时里面有最优投资组合
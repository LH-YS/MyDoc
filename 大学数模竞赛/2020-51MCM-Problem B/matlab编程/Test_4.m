%һά���������Ž��㷨
ii = 1;%��������
AA = 17.3;%Ч�����ʱAֵ�����ٽ�ֵ
%����R��A��ֵ
A = zeros(57,114);
for i = 1:57
    for j = 1:57
        A(i,j) = data_R(1,j);
    end
end
for i = 1:57
    A(i+57,i) = -1;
end
%���ι滮���
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
up_fval = fval + 0.0001;%�涨�����Ͻ�
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
    vvalue = 24675114.49 * xxx(1,1:57);%�����Ǯ
    result(1,ii) = vvalue * vvar';
    ii = ii + 1;
    AA = AA + 0.001;
end
iii = 2;
min_var = result(1);
min_number = 1;
%���ռ�ֵ��С��ֵ�͵�������
while result(1,iii) ~= 0
    if result(1,iii) < result(1,iii - 1)
        min_var = result(1,iii);
        min_number = iii;
        iii = iii + 1;
    end
end
%������Ϻ�min_var����С���ռ�ֵ
AA = AA + 0.01*(min_number - 1);
%�����ʱ�����ŷ��䷽��
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
best_solve = xx';%��ʱ����������Ͷ�����
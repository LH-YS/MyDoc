%for i=1:114, eval(sprintf('syms x%i;X(i,1)=x%i;',i,i));end
data_dR = data_R';
f = fuF .* data_dR;
AA = 17.2;
A = zeros(57,114);
for i = 1:57
    for j = 1:57
        A(i,j) = data_R(1,j);
    end
end
for i = 1:57
    A(i+57,i) = -1;
end
H = zeros(114,114);
for i = 58:114
    H(i,i) = AA*(1/(i-57));
end
Aeq = F';
Beq = 1;
lb = zeros(114,1);
B = fuF(1:57) .* data_dR(1:57);
[xx,fval,exitflag,output,lambda] = quadprog(H,f,A,B,Aeq,Beq,lb);
xxx = xx';
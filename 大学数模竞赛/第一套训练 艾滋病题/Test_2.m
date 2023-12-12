%求最佳Q值 停止时间等
T = 50;
%疗法1
t = 0;
Q1B = -9999999;
W1 = 0;
Q1J = zeros(1,5000);
J = 1;                                      
C1J = zeros(1,5000);
J1 = 1;
while(t<T)
    if mod(round((t*7)/30),2) == 0
        C1 = (7*(t+1)/2)*(1.6+0.85);
    else
        C1 = ((round((t*7)/30)+1)/2)*30*1.6+((round((t*7)/30)-1)/2)*30*0.85;
    end
    W1 = W1+y1(t);
    Q1 = W1/C1;
    Q1J(1,J) = Q1;
    C1J(1,J1) = C1;
    if Q1>Q1B
        Bt1 = t+1;
        W1B = W1;
        Q1B = Q1;
        C1B = C1;
    end
    t = t+0.01;
    J = J+1;
    J1 = J1+1;
end
%疗法2
t = 0;
Q2B = -9999999;
W2 = 0;
Q2J = zeros(1,5000);
J = 1;
C2J = zeros(1,5000);
J1 = 1;
while(t<T)
    %首先是算出当前时间t的费用
    C2 = 7*(t+1)*(1.6+1.85);
    W2 = W2+y2(t);
    Q2 = W2/C2;
    Q2J(1,J) = Q2;
    C2J(1,J1) = C2;
    if Q2>Q2B
        Bt2 = t+1;
        W2B = W2;
        Q2B = Q2;
        C2B = C2;
    end
    t = t+0.01;
    J = J+1;
    J1 = J1+1;
end
%疗法3
t = 0;
Q3B = -9999999;
W3 = 0;
Q3J = zeros(1,5000);
J = 1;
C3J = zeros(1,5000);
J1 = 1;
while(t<T)
    %首先是算出当前时间t的费用
    C3 = 7*(t+1)*(1.6+0.85);
    W3 = W3+y3(t);
    Q3 = W3/C3;
    Q3J(1,J) = Q3;
    C3J(1,J1) = C3;
    if Q3>Q3B
        Bt3 = t+1;
        W3B = W3;
        Q3B = Q3;
        C3B = C3;
    end
    t = t+0.01;
    J = J+1;
    J1 =J1+1;
end

%疗法4
t = 0;
Q4B = -9999999;
W4 = 0;
Q4J = zeros(1,5000);
J = 1;
C4J = zeros(1,5000);
J1 = 1;
while(t<T)
    %首先是算出当前时间t的费用
    C4 = 7*(t+1)*(1.6+0.85+1.2);
    W4 = W4+y4(t);
    Q4 = W4/C4;
    Q4J(1,J) = Q4;
    C4J(1,J1) = C4;
    if Q4>Q4B
        Bt4 = t+1;
        W4B = W4;
        Q4B = Q4;
        C4B = C4;
    end
    t = t+0.01;
    J = J+1;
    J1 = J1+1;
end
function [result] = y1(x)
result = 4.325e-08*x.^5 -4.307e-06*x.^4 + 0.0001744*x.^3 -0.003735*x.^2 +0.04114*x -0.1875;
end
function [result] = y2(x)
result = 6.352e-08*x.^5 -6.512e-06*x.^4 + 0.0002588*x.^3 -0.004772*x.^2 + 0.03407*x -0.02457;
end
function [result] = y3(x)
result = -1.542e-07*x.^4 + 2.992e-05*x.^3 -0.001151*x.^2 + 0.007704*x +0.05437;
end
function [result] = y4(x)
result = 3.363e-07*x.^5 -3.61e-05*x.^4 + 0.001391*x.^3 -0.02295*x.^2 + 0.1447*x -0.115;
end

%预测的函数
lastday = 244;%最后的天数
lastpride =13.13;%最后的价格
R = zeros(3,1);
R(1,1) = log(solve(lastday+45)/lastpride)/45;
R(2,1) = log(solve(lastday+90)/lastpride)/90;
R(3,1) = log(solve(lastday+180)/lastpride)/180;
R %输出不同天数后的预测值
%用cftool拟合后将参数信息写入fx中
function fx = solve(x)
       p1 =  -9.722e-16;
       p2 =   9.075e-13;
       p3 =  -3.346e-10;
       p4 =   6.139e-08;
       p5 =   -5.76e-06;
       p6 =   0.0002503;
       p7 =   -0.003844;
       p8 =     0.06599;
       p9 =        11.6;

    fx = p1*x^8 + p2*x^7 + p3*x^6 + p4*x^5 + p5*x^4 + p6*x^3 + p7*x^2 + p8*x + p9;
end

 

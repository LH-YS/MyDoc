%求期望时间
function[y,y1] = logistic(xm,r,x0,t)
y = xm/(1+((xm/x0)-1)*exp(-r*t));
y1 = r*y*(1-y/xm);
end

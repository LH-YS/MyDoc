for i=1:55


    y2=polyfit(x,y,i);


    Y=polyval(y2,x);%������Ϻ�����x����ֵ��


    if sum((Y-y).^2)<0.1


      


        c=i;  


        break;


    end


end

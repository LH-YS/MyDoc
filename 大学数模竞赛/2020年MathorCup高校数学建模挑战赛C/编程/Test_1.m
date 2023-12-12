%NUM = zeros(1,3000);%货格号的一维数组
S = zeros(3000,3000);
a = 0.8;
d = 0.75;
b = 2;
for i = 1:3000
    A1 = floor(NUM(1,i)/100);
    B1 = mod(NUM(1,i),100);
    n1 = floor(A1/8);
    m1 = mod(A1,8);
    %确定起点位置
    %行判定
    if m1==1 || m1==2
        h1 = 1;
    end
    if m1==3 || m1==4
        h1 = 2;
    end
    if m1==5 || m1==6
        h1 = 3;
    end
    if m1==7 || m1==0
        h1 = 4;
    end
    %列判断
    l1 = n1+1;
    if m1 == 0
        l1 = n1;
    end
    if mod(m1,2)==0
            ce1 = 0;
    else
            ce1 = 1;
    end
    for j = 1:3000
        A2 = floor(NUM(1,j)/100);
        B2 = mod(NUM(1,j),100);
        n2 = floor(A2/8);
        m2 = mod(A2,8);
        %确定终点位置
        %行判定
        if m2==1 || m2==2
            h2 = 1;
        end
        if m2==3 || m2==4
            h2 = 2;
        end
        if m2==5 || m2==6
            h2 = 3;
        end
        if m2==7 || m2==0
            h2 = 4;
        end
        %列判断
        l2 = n2+1;
        if m2 == 0
            l2 = n2;
        end
        %左右侧判断
        if mod(m2,2)==0
            ce2 = 0;
        else
            ce2 = 1;
        end
        %接下来判断情况
        %相同列相同行
        if h1==h2 && l1==l2
            %同一侧
            if ce1 == ce2
                if B1 == B2
                    S(i,j) = 0;
                else
                    S(i,j) = abs(B1- B2)*a+2*d;
                end
            else
                %不同侧
                if B1 > 8
                    S(i,j) = ((15-B1)+(15-B2))*a+6*d+3*a;
                end
                if B1 < 8
                    S(i,j) = ((B1-1)+(B2-1))*a+6*d+3*a;
                end
                if B1==8
                    if B2 > 8
                        S(i,j) = ((15-B1)+(15-B2))*a+6*d+3*a;
                    end
                    if B2 <= 8
                        S(i,j) = ((B1-1)+(B2-1))*a+6*d+3*a;
                    end
                end
            end
        end
        %相同列不同行
        if h1~=h2 && l1==l2
            kh = h1-h2;%行差
            if ce1 == ce2
                %同侧的时候
                if kh  < 0 %从下到上
                    S(i,j) = ((15-B1)+(B2-1))*a+abs(kh)*b+(abs(kh)-1)*15*a+2*d+a;
                end
                if kh  > 0 %从上到下
                    S(i,j) = ((B1-1)+(15-B2))*a+kh*b+(kh-1)*15*a+2*d+a;
                end
            else
                %不同侧
                if kh  < 0 %从下到上
                    S(i,j) = ((15-B1)+(B2-1))*a+abs(kh)*b+(abs(kh)-1)*15*a+2*d+a+2*d+2*a;
                end
                if kh  > 0 %从上到下
                    S(i,j) = ((B1-1)+(15-B2))*a+kh*b+(kh-1)*15*a+2*d+a+2*d+2*a;
                end
            end
        end
        %相同行不同列
        if h1==h2 && l1~=l2
            kl = l1-l2;
            %左侧到右侧
            if ce1==1&&ce2==0
                if kl < 0
                    if B1 > 8
                        S(i,j)=((15-B1)+(15-B2))*a+6*d+3*a+(-kl-1)*(2*a+2*d);
                    end
                    if B1 < 8
                        S(i,j)=((B1-1)+(B2-1))*a+6*d+3*a+(-kl-1)*(2*a+2*d);
                    end
                    if B1==8
                        if B2 > 8
                            S(i,j) = ((15-B1)+(15-B2))*a+6*d+3*a+(-kl-1)*(2*a+2*d);
                        end
                        if B2 <= 8
                            S(i,j) = ((B1-1)+(B2-1))*a+6*d+3*a+(-kl-1)*(2*a+2*d);
                        end
                    end
                end
                if kl>0%从右到左
                    if kl == 1
                        S(i,j) = 2*d+abs(B1- B2)*a;
                    else
                        if B1 > 8
                            S(i,j)=((15-B1)+(15-B2))*a+6*d+3*a+(kl-2)*(2*a+2*d);
                        end
                        if B1 < 8
                            S(i,j)=((B1-1)+(B2-1))*a+6*d+3*a+(kl-2)*(2*a+2*d);
                        end
                        if B1==8
                            if B2 > 8
                                S(i,j) = ((15-B1)+(15-B2))*a+6*d+3*a+(kl-2)*(2*a+2*d);
                            end
                            if B2 <= 8
                                S(i,j) = ((B1-1)+(B2-1))*a+6*d+3*a+(kl-2)*(2*a+2*d);
                            end
                        end
                    end
                end
            end
            %右侧到左侧
            if ce1==0&&ce2==1
                if kl < 0%从左到右
                    if kl == -1
                        S(i,j) = 2*d+abs(B1- B2)*a;
                    else
                        if B1 > 8
                            S(i,j)=((15-B1)+(15-B2))*a+6*d+3*a+(-kl-2)*(2*a+2*d);
                        end
                        if B1 < 8
                            S(i,j)=((B1-1)+(B2-1))*a+6*d+3*a+(-kl-2)*(2*a+2*d);
                        end
                        if B1==8
                            if B2 > 8
                                S(i,j) = ((15-B1)+(15-B2))*a+6*d+3*a+(-kl-2)*(2*a+2*d);
                            end
                            if B2 <= 8
                                S(i,j) = ((B1-1)+(B2-1))*a+6*d+3*a+(-kl-2)*(2*a+2*d);
                            end
                        end
                    end
                end
                if kl >0%从右到左
                        if B1 > 8
                            S(i,j)=((15-B1)+(15-B2))*a+6*d+3*a+(kl-1)*(2*a+2*d);
                        end
                        if B1 < 8
                            S(i,j)=((B1-1)+(B2-1))*a+6*d+3*a+(kl-1)*(2*a+2*d);
                        end
                        if B1==8
                            if B2 > 8
                                S(i,j) = ((15-B1)+(15-B2))*a+6*d+3*a+(kl-1)*(2*a+2*d);
                            end
                            if B2 <= 8
                                S(i,j) = ((B1-1)+(B2-1))*a+6*d+3*a+(kl-1)*(2*a+2*d);
                            end
                        end
                end
            end
            %同侧到同侧
            if (ce1==1&&ce2==1)||(ce1==0&&ce2==0)
                
                        if B1 > 8
                            S(i,j)=((15-B1)+(15-B2))*a+6*d+3*a+(abs(kl)-1)*(2*a+2*d);
                        end
                        if B1 < 8
                            S(i,j)=((B1-1)+(B2-1))*a+6*d+3*a+(abs(kl)-1)*(2*a+2*d);
                        end
                        if B1==8
                            if B2 > 8
                                S(i,j) = ((15-B1)+(15-B2))*a+6*d+3*a+(abs(kl)-1)*(2*a+2*d);
                            end
                            if B2 <= 8
                                S(i,j) = ((B1-1)+(B2-1))*a+6*d+3*a+(abs(kl)-1)*(2*a+2*d);
                            end
                        end
            end
            
        end
        %不同行不同列
        
        if h1~=h2 && l1~=l2
            kl = l1-l2;
            kh = h1-h2;
            %左侧到右侧
            if ce1==1&&ce2==0
                if kl < 0
                    if kh < 0%从下到上
                        S(i,j)=((15-B1)+(B2-1))*a+4*d+3*a+(-kl-1)*(2*a+2*d)+abs(kh)*b+(abs(kh)-1)*15*a;
                    else
                        S(i,j)=((B1-1)+(15-B2))*a+4*d+3*a+(-kl-1)*(2*a+2*d)+abs(kh)*b+(abs(kh)-1)*15*a;
                    end
                end
                if kl>0%从右到左
                    if kl == 1
                        if kh < 0%从下到上
                            S(i,j)=((15-B1)+(B2-1))*a+2*d+abs(kh)*b+(abs(kh)-1)*15*a;
                        else
                            S(i,j)=((B1-1)+(15-B2))*a+2*d+abs(kh)*b+(abs(kh)-1)*15*a;
                        end
                    else
                        if kh < 0%从下到上
                            S(i,j)=((15-B1)+(B2-1))*a+4*d+3*a+(kl-2)*(2*a+2*d)+abs(kh)*b+(abs(kh)-1)*15*a;
                        else
                            S(i,j)=((B1-1)+(15-B2))*a+4*d+3*a+(kl-2)*(2*a+2*d)+abs(kh)*b+(abs(kh)-1)*15*a;
                        end
                    end
                end
            end
            %右侧到左侧
            if ce1==0&&ce2==1
                if kl < 0%从左到右
                    if kl == -1
                        if kh < 0%从下到上
                            S(i,j)=((15-B1)+(B2-1))*a+2*d+abs(kh)*b+(abs(kh)-1)*15*a;
                        else
                            S(i,j)=((B1-1)+(15-B2))*a+2*d+abs(kh)*b+(abs(kh)-1)*15*a;
                        end
                    else
                        if kh < 0%从下到上
                            S(i,j)=((15-B1)+(B2-1))*a+4*d+3*a+(-kl-2)*(2*a+2*d)+abs(kh)*b+(abs(kh)-1)*15*a;
                        else
                            S(i,j)=((B1-1)+(15-B2))*a+4*d+3*a+(-kl-2)*(2*a+2*d)+abs(kh)*b+(abs(kh)-1)*15*a;
                        end
                    end
                end
                if kl >0%从右到左
                        if kh <0
                            S(i,j)=((15-B1)+(B2-1))*a+4*d+3*a+(kl-1)*(2*a+2*d)+abs(kh)*b+(abs(kh)-1)*15*a;
                        else
                             S(i,j)=((B1-1)+(15-B2))*a+4*d+3*a+(kl-1)*(2*a+2*d)+abs(kh)*b+(abs(kh)-1)*15*a;
                        end
                        
                end
            end
            %同侧到同侧
            if (ce1==1&&ce2==1)||(ce1==0&&ce2==0)
                 if kh < 0
                      S(i,j)=((15-B1)+(B2-1))*a+4*d+3*a+(abs(kl)-1)*(2*a+2*d)+abs(kh)*b+(abs(kh)-1)*15*a;
                 else
                     S(i,j)=((B1-1)+(15-B2))*a+4*d+3*a+(abs(kl)-1)*(2*a+2*d)+abs(kh)*b+(abs(kh)-1)*15*a;
                 end
            end
            
        end
    end
end
pos1 = 1;
pos2 = 1;
for i = 1:3000
    if NUM(1,i) == 9403
        pos1 = i;
    end
    if NUM(1,i) == 10103
        pos2 = i;
    end
end
S(pos1,pos2)
%����һ�غ͵ڶ���
%weather�ж�Ӧ��1��ʾ���� 2��ʾ���� 3 ��ʾɳ��
%cost��ʾ��Ӧ�����Ļ���������
%cost = zeros(2,3);
%weather = zeros(1,30);
%weight = zeros(1,2);
%���ȼ���ֱ���յ���ʽ�
Money_start = 10000;
money_0_cost = 0;
[dis_0,path_0] = floyd(maptest,1,27);
for i = 1:dis_0
    money_0_cost = money_0_cost + 2*(cost(1,weather(1,i))*5 + cost(2,weather(1,i))*10);
end
money_0 = Money_start - money_0_cost;
%������㵽��ׯһֱ���ߵ�������Դ
[dis_11,path_1] = floyd(maptest,12,27);
dis_1 = dis_11;
money_1_cost = 0;
food_1_cost = 0;
water_1_cost = 0;
weight_1_cost = 0;

ii = 1;
while dis_1 > 0
    if weather(1,ii) == 3
        dis_1 = dis_1+1;
        money_1_cost = money_1_cost + cost(1,weather(1,ii))*5 + cost(2,weather(1,ii))*10;
        food_1_cost = food_1_cost + cost(2,weather(1,ii));
        water_1_cost = water_1_cost + cost(1,weather(1,ii));
        weight_1_cost = weight_1_cost+3*cost(1,weather(1,ii))+2*cost(2,weather(1,ii));
    else
        money_1_cost = money_1_cost + 2*(cost(1,weather(1,ii))*5 + cost(2,weather(1,ii))*10);
        food_1_cost = food_1_cost + 2*cost(2,weather(1,ii));
        water_1_cost = water_1_cost + 2*cost(1,weather(1,ii));
        weight_1_cost = weight_1_cost+3*cost(1,weather(1,ii))+2*cost(2,weather(1,ii));
    end
    ii = ii+1;
    dis_1 = dis_1 - 1;
end
weight_2_cost = 0;
dis_1 = 10
ii = 8;
while dis_1 > 0
    if weather(1,ii) == 3
       
        money_1_cost = money_1_cost + cost(1,weather(1,ii))*5 + cost(2,weather(1,ii))*10;
        food_1_cost = food_1_cost + cost(2,weather(1,ii));
        water_1_cost = water_1_cost + cost(1,weather(1,ii));
        weight_2_cost = weight_2_cost+3*(3*cost(1,weather(1,ii))+2*cost(2,weather(1,ii)));
    else
        money_1_cost = money_1_cost + 3*(2*(cost(1,weather(1,ii))*5 + cost(2,weather(1,ii))*10));
        food_1_cost = food_1_cost + 2*cost(2,weather(1,ii));
        water_1_cost = water_1_cost + 2*cost(1,weather(1,ii));
        weight_2_cost = weight_2_cost+3*(3*cost(1,weather(1,ii))+2*cost(2,weather(1,ii)));
    end
    ii = ii+1;
    dis_1 = dis_1 - 1;
end
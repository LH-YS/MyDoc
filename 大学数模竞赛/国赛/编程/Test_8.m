%风险决策模型
%单人游戏中每一步的前进都要取决于风险决策和自身情况的限定
%根据马科维茨的思想 将风险定义为损益率的方差 即自身资源消耗过程中不同选择的方差
%单人游戏中都在最短路上前进 因此在大体路线上已经确定为1-4-3-9-11-13
minpath_3 = [1,4,3,9,11,13];
weather = zeros(1,10);
cost_3 = [3,9,10,4,9,10];%基础消耗量
%这里我们暂且先赋值abc
a = 0.6;
b = 0.4;
c = 0;
weather = randsrc(1,10,[1 2 3;a b c]);
%其中abc为不同天气的概率
Time = 1;
A = 0;%A值为给定的界限值
pos = 1;%玩家的出发地址在1

water_now_3 = 240;
food_now_3 = 240;
money_now_3 = 10000 - water_now_3*5 - food_now_3*10;
%开始游戏
%针对本张地图 到达矿山需要3天
while fishgame ~= 1%当游戏还没有结束时 继续游戏
    
    %时刻监测是否达到离开的临界
    [dis_least,p1] = floyd(theree,pos,13);
    water_least = dis_least*2*(a*cost_3(2,1)+b*cost_3(2,2));
    food_least = dis_least*2*(a*cost_3(2,1)+b*cost_3(2,2));
    if(food_now_3 < food_least || water_now_3 < water_least)
        state = 3;
        break;
    end
    
    %计算当天条件下 消耗的资源数
    %如果处于矿山前的阶段 根据计算不同操作之间的方差 来确定风险
    %计算不同操作对于不同资源下降的方差
    low_move_1 = 2*cost_3(2,weather(1,Time))/food_now_3;
    low_move_2 = 2*cost_3(1,weather(1,Time))/water_now_3;
    low_stay_1 = cost_3(2,weather(1,Time))/food_now_3;
    low_stay_2 = cost_3(1,weather(1,Time))/water_now_3;
    cov_1 = cov([low_move_1,low_move_2]);%下降比例的方差 也就是损害率的方差
    cov_2 = cov([low_stay_1,low_stay_2]);
    %计算Q值
    Q1 = 2*cost_3(2,weather(1,Time))*10 / cov_1;
    Q2 = 2*cost_3(1,weather(1,Time))*5 / cov_2;
    %在安全的情况下 如果遇到了高温天 则选择Q值最大的进行选择
    Time = Time+1;
end
if state == 3
        for i = 1:dis_least
            food_now_3 = food_now_3 - 2*cost_3(1,weather(1,Time+i));
            water_now_3 = water_now_3 - 2*cost_3(1,weather(1,Time+i));
        end
end
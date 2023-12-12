%风险决策模型
%单人游戏中每一步的前进都要取决于风险决策和自身情况的限定
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
state = 1;%玩家的初始状态为前往矿山的路上
%在这里我们设定1为前往矿山的路上 2为处于矿山 3为前往终点的路上
food_now_3 = 240;
water_now_3 = 240;
money_now_3 = 10000 - food_now*5 - water_now*10;
%在已知概率下求出移动的期望消耗
food_E_move = 2*a*cost_3(2,1)+2*b*cost_3(2,2);
water_E_move = 2*a*cost_3(1,1)+2*b*cost_3(1,2);
%挖矿的期望消耗
food_E_earn = a*3*cost(2,1)+b*3*cost_3(2,2);
water_E_move = a*3*cost(1,1)+b*3*cost_3(1,2);
state_1 = 1;%1表示移动或者挖矿 2 表示停留
while fishgame ~= 1%当游戏还没有结束时 继续游戏
       %首先出于安全性的考虑 要在决策之前分清自己的安全状态
       %在第三关中没有矿山 因此考虑的是此时当前位置和直达终点之间的关系
       %如果食物和水足够当前位置直达终点的最坏情况 则继续前进
       %如果不够最坏情况 却大于期望消耗 此时判断风险值指标和给定的关系
       %因为存在如果继续前进到达矿山还能赚回来的情况 这是一种风险决策
       %如果不够期望消耗，则必须立即返回
       [dis_deadline,p1] = floyd(three,pos,13);
       %计算直通终点最坏情况消耗和期望消耗
       food_worst_baack = 0;%设立初始值
       water_worst = 0;%设立初始值
       food_worst_back = food_worst_baack + 2*cost(2,2)*dis_deadline;
       water_worst_back = water_worst + 2*cost(1,2)*dis_deadline;
       food_E_back = (a*cost(2,1)+b*cost(2,2))/2;
       water_E_back = (a*cost(1,1)+b*cost(2,1))/2;
       %动态过程 首先是要判断玩家处于哪个状态
    if state == 1
       %说明此时处于前往矿山的路上
       %首先判断是否满足立马回去的期望值
       if food_now_3 < food_E_back || water_now_3 < water_E_back
           %则此时立马开始回去 在这里不减少时间
           state = 3;
           break;
           %在这里改变状态后在后面直接进入前往终点的过程
       end
       %在已知当日天气的情况下 决定是否前进或者休息
       %此时分类讨论 计算不同决策下风险和总资金的关系
      
       if pos == 1
           if 10-5-Time+1 < 0
               state = 3;
               
           else
           %此时未来计算两层的时候不涉及到挖矿
           %当选择走的时候 分别计算如果下一天的天气是晴天或者高温天且后面都是理想状态下的最终总额
           %这两个值表示的是假设下一天是晴天 到终点的食物和水还有多少
           food_test_sun = food_now_3 - 2*cost_3(2,weather(1,Time)) - 2*cost_3(2,1) - food_E_move*3 - (10-5-Time+1)*food_E_earn;
           water_test_sun = water_now_3 - 2*cost_3(1,weather(1,Time)) - 2*cost_3(1,1)- water_E_move*3 -(10-5-Time+1)*water_E_earn;
           food_test_hot = food_now_3 - 2*cost_3(2,weather(1,Time)) - 2*cost_3(2,2) - food_E_move*3 - (10-5-Time+1)*food_E_earn;
           water_test_hot = water_now_3 - 2*cost_3(1,weather(1,Time)) - 2*cost_3(1,2)- water_E_move*3 -(10-5-Time+1)*water_E_earn;
           run_sun = money_now_3 + (10-5-Time+1)*200 + food_test_sun*2.5 + water_test_sun*2.5;
           run_hot = money_now_3 + (10-5-Time+1)*200 + food_test_hot*2.5 + water_test_hot*2.5;
           run_E = a*run_sun+b*run_hot;
           cov_run_E = cov([run_sun,run_hot]);
           Q_run = run_E / cov_run_E;
           
           %接下来是停的情况
           food_stay_sun = food_now_3 - cost_3(2,weather(1,Time)) - 2*cost_3(2,1) - food_E_move*4 - (10-6-Time+1)*food_E_earn;
           water_stay_sun = water_now_3 - cost_3(1,weather(1,Time)) - 2*cost_3(1,1)- water_E_move*4 -(10-6-Time+1)*water_E_earn;
           food_stay_hot = food_now_3 - cost_3(2,weather(1,Time)) - 2*cost_3(2,2) - food_E_move*4 - (10-6-Time+1)*food_E_earn;
           water_stay_hot = water_now_3 - cost_3(1,weather(1,Time)) - 2*cost_3(1,2)- water_E_move*4 -(10-6-Time+1)*water_E_earn;
           stay_sun = money_now_3 + (10-6-Time+1)*200 + food_stay_sun*5 + water_stay_sun*2.5;
           stay_hot = money_now_3 + (10-6-Time+1)*200 + food_stay_hot*5 + water_stay_hot*2.5;
           stay_E = a*stay_sun+b*stay_hot;
           cov_stay_E = cov([stay_sun,stay_hot]);
           Q_stay = stay_E / cov_stay_E;
           
           %最后是直接去终点的情况 只需比较终点时的收益即可
           [dis_back_1,p2] = floyd(three,1,13);
           food_back_sun = food_now_3 - food_E_back*(dis_back_1-2) - 2*cost(2,weather(1,Time)) - 2*cost_3(2,1);
           water_back_sun = food_now_3 - water_E_back*(dis_back_1-2) - 2*cost(1,weather(1,Time)) - 2*cost_3(1,1);
           food_back_hot = food_now_3 - food_E_back*(dis_back_1-2) - 2*cost(2,weather(1,Time)) - 2*cost_3(2,2);
           water_back_hot = food_now_3 - water_E_back*(dis_back_1-2) - 2*cost(1,weather(1,Time)) - 2*cost_3(1,2);
           back_money_sun = money_now_3 + food_back_sun*5 + water_back_sun*2.5;
           back_money_hot = money_now_3 + food_back_hot*5 + water_back_hot*2.5;
           back_money_E = a*back_money_sun+b*back_money;
           %在完成计算之后开始比较Q值
           if back_money_E > stay_E && back_money_E > run_E
               state = 3;
           else
               if Q_run >= Q_stay
                   state_1 = 1;
               else
                   state_1 = 2;
               end
           end
           end
       end
       if pos == 2
           if 10-5-Time+1 < 0
               state = 3;
               
           else
           %此时未来计算两层的时候不涉及到挖矿
           %当选择走的时候 分别计算如果下一天的天气是晴天或者高温天且后面都是理想状态下的最终总额
           %这两个值表示的是假设下一天是晴天 到终点的食物和水还有多少
           food_test_sun = food_now_3 - 2*cost_3(2,weather(1,Time)) - 2*cost_3(2,1) - food_E_move*2 - (10-5-Time+1)*food_E_earn;
           water_test_sun = water_now_3 - 2*cost_3(1,weather(1,Time)) - 2*cost_3(1,1)- water_E_move*2 -(10-5-Time+1)*water_E_earn;
           food_test_hot = food_now_3 - 2*cost_3(2,weather(1,Time)) - 2*cost_3(2,2) - food_E_move*2 - (10-5-Time+1)*food_E_earn;
           water_test_hot = water_now_3 - 2*cost_3(1,weather(1,Time)) - 2*cost_3(1,2)- water_E_move*2 -(10-5-Time+1)*water_E_earn;
           run_sun = money_now_3 + (10-5-Time+1)*200 + food_test_sun*2.5 + water_test_sun*2.5;
           run_hot = money_now_3 + (10-5-Time+1)*200 + food_test_hot*2.5 + water_test_hot*2.5;
           run_E = a*run_sun+b*run_hot;
           cov_run_E = cov([run_sun,run_hot]);
           Q_run = run_E / cov_run_E;
           
           %接下来是停的情况
           food_stay_sun = food_now_3 - cost_3(2,weather(1,Time)) - 2*cost_3(2,1) - food_E_move*3 - (10-6-Time+1)*food_E_earn;
           water_stay_sun = water_now_3 - cost_3(1,weather(1,Time)) - 2*cost_3(1,1)- water_E_move*3 -(10-6-Time+1)*water_E_earn;
           food_stay_hot = food_now_3 - cost_3(2,weather(1,Time)) - 2*cost_3(2,2) - food_E_move*3 - (10-6-Time+1)*food_E_earn;
           water_stay_hot = water_now_3 - cost_3(1,weather(1,Time)) - 2*cost_3(1,2)- water_E_move*3 -(10-6-Time+1)*water_E_earn;
           stay_sun = money_now_3 + (10-6-Time+1)*200 + food_stay_sun*5 + water_stay_sun*2.5;
           stay_hot = money_now_3 + (10-6-Time+1)*200 + food_stay_hot*5 + water_stay_hot*2.5;
           stay_E = a*stay_sun+b*stay_hot;
           cov_stay_E = cov([stay_sun,stay_hot]);
           Q_stay = stay_E / cov_stay_E;
           
           %最后是直接去终点的情况 只需比较终点时的收益即可
           [dis_back_1,p2] = floyd(three,1,13);
           food_back_sun = food_now_3 - food_E_back*(dis_back_1-2) - 2*cost(2,weather(1,Time)) - 2*cost_3(2,1);
           water_back_sun = food_now_3 - water_E_back*(dis_back_1-2) - 2*cost(1,weather(1,Time)) - 2*cost_3(1,1);
           food_back_hot = food_now_3 - food_E_back*(dis_back_1-2) - 2*cost(2,weather(1,Time)) - 2*cost_3(2,2);
           water_back_hot = food_now_3 - water_E_back*(dis_back_1-2) - 2*cost(1,weather(1,Time)) - 2*cost_3(1,2);
           back_money_sun = money_now_3 + food_back_sun*5 + water_back_sun*2.5;
           back_money_hot = money_now_3 + food_back_hot*5 + water_back_hot*2.5;
           back_money_E = a*back_money_sun+b*back_money;
           %在完成计算之后开始比较Q值
           if back_money_E > stay_E && back_money_E > run_E
               state = 3;
           else
               if Q_run >= Q_stay
                   state_1 = 1;
               else
                   state_1 = 2;
               end
           end
           end
       end
       if pos == 3
           if 10-5-Time+1 < 0
               state = 3;
               
           else
           %此时未来计算两层的时候不涉及到挖矿
           %当选择走的时候 分别计算如果下一天的天气是晴天或者高温天且后面都是理想状态下的最终总额
           %这两个值表示的是假设下一天是晴天 到终点的食物和水还有多少
           food_test_sun = food_now_3 - 2*cost_3(2,weather(1,Time)) - 2*cost_3(2,1) - food_E_move*2 - (10-5-Time+1-1)*food_E_earn - 3*cost_3(2,1);
           water_test_sun = water_now_3 - 2*cost_3(1,weather(1,Time)) - 2*cost_3(1,1)- water_E_move*2 -(10-5-Time+1-1)*water_E_earn-3*cost_3(1,1);
           food_test_hot = food_now_3 - 2*cost_3(2,weather(1,Time)) - 2*cost_3(2,2) - food_E_move*2 - (10-5-Time+1-1)*food_E_earn-3*cost_3(1,2);
           water_test_hot = water_now_3 - 2*cost_3(1,weather(1,Time)) - 2*cost_3(1,2)- water_E_move*2 -(10-5-Time+1-1)*water_E_earn-3*cost_3(2,2);
           run_sun = money_now_3 + (10-5-Time+1-1)*200 + food_test_sun*2.5 + water_test_sun*2.5+200;
           run_hot = money_now_3 + (10-5-Time+1-1)*200 + food_test_hot*2.5 + water_test_hot*2.5+200;
           run_E = a*run_sun+b*run_hot;
           cov_run_E = cov([run_sun,run_hot]);
           Q_run = run_E / cov_run_E;
           
           %接下来是停的情况
           food_stay_sun = food_now_3 - cost_3(2,weather(1,Time)) - 2*cost_3(2,1) - food_E_move*3 - (10-6-Time+1)*food_E_earn;
           water_stay_sun = water_now_3 - cost_3(1,weather(1,Time)) - 2*cost_3(1,1)- water_E_move*3 -(10-6-Time+1)*water_E_earn;
           food_stay_hot = food_now_3 - cost_3(2,weather(1,Time)) - 2*cost_3(2,2) - food_E_move*3 - (10-6-Time+1)*food_E_earn;
           water_stay_hot = water_now_3 - cost_3(1,weather(1,Time)) - 2*cost_3(1,2)- water_E_move*3 -(10-6-Time+1)*water_E_earn;
           stay_sun = money_now_3 + (10-6-Time+1)*200 + food_stay_sun*5 + water_stay_sun*2.5;
           stay_hot = money_now_3 + (10-6-Time+1)*200 + food_stay_hot*5 + water_stay_hot*2.5;
           stay_E = a*stay_sun+b*stay_hot;
           cov_stay_E = cov([stay_sun,stay_hot]);
           Q_stay = stay_E / cov_stay_E;
           
           %最后是直接去终点的情况 只需比较终点时的收益即可
           [dis_back_1,p2] = floyd(three,1,13);
           food_back_sun = food_now_3 - food_E_back*(dis_back_1-2) - 2*cost(2,weather(1,Time)) - 2*cost_3(2,1);
           water_back_sun = food_now_3 - water_E_back*(dis_back_1-2) - 2*cost(1,weather(1,Time)) - 2*cost_3(1,1);
           food_back_hot = food_now_3 - food_E_back*(dis_back_1-2) - 2*cost(2,weather(1,Time)) - 2*cost_3(2,2);
           water_back_hot = food_now_3 - water_E_back*(dis_back_1-2) - 2*cost(1,weather(1,Time)) - 2*cost_3(1,2);
           back_money_sun = money_now_3 + food_back_sun*5 + water_back_sun*2.5;
           back_money_hot = money_now_3 + food_back_hot*5 + water_back_hot*2.5;
           back_money_E = a*back_money_sun+b*back_money;
           %在完成计算之后开始比较Q值
           if back_money_E > stay_E && back_money_E > run_E
               state = 3;
           else
               if Q_run >= Q_stay
                   state_1 = 1;
               else
                   state_1 = 2;
               end
           end
           end
       end
    end
    
end
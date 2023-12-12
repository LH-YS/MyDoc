daytime = 30;
maxGEN = 100;
popSize = 100; % 遗传算法种群大小
crossoverProbabilty = 0.9; %交叉概率
mutationProbabilty = 0.1; %变异概率
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gbest = Inf;
% 计算上述生成的城市距离
distances = maptest;
% 生成种群 为30长度的二进制码
pop = zeros(popSize, daytime);
for i=1:popSize
    for j = 1:30
       pop(i,:) = randsrc(1,30,[1 0;0.8 0.2]);
    end
end
offspring = zeros(popSize,daytime);
%保存每代的最小路劲便于画图
minPathes = zeros(maxGEN,1);
% GA算法
Money_start = 10000;
for  gen=1:maxGEN
% 计算适应度的值，即路径总距离
[fval, sumDistance, minPath, maxPath,best] = fitness(distances, pop,Money_start,maptest,weather,cost);
% 轮盘赌选择
tournamentSize=4; %设置大小
for k=1:popSize
% 选择父代进行交叉
tourPopDistances=zeros( tournamentSize,1);
for i=1:tournamentSize
randomRow = randi(popSize);
tourPopDistances(i,1) = sumDistance(randomRow,1);
end
% 选择最好的，即距离最小的
parent1  = min(tourPopDistances);
[parent1X,parent1Y] = find(sumDistance==parent1,1, 'first');
parent1Path = pop(parent1X(1,1),:);
for i=1:tournamentSize
randomRow = randi(popSize);
tourPopDistances(i,1) = sumDistance(randomRow,1);
end
parent2  = min(tourPopDistances);
[parent2X,parent2Y] = find(sumDistance==parent2,1, 'first');
parent2Path = pop(parent2X(1,1),:);
subPath = crossover(parent1Path, parent2Path, crossoverProbabilty);%交叉
subPath = mutate(subPath, mutationProbabilty);%变异
offspring(k,:) = subPath(1,:);
minPathes(gen,1) = minPath; 
end
fprintf('代数:%d   最短路径:%.2fM \n', gen,minPath);
% 更新
pop = offspring;
if minPath < gbest
gbest = minPath;
%paint(cities, pop, gbest, sumDistance,gen);
end
end
%figure 
%plot(minPathes, 'MarkerFaceColor', 'red','LineWidth',1);
%title('收敛曲线图（每一代的最短路径）');
%set(gca,'ytick',500:100:5000); 
%ylabel('路径长度');
%xlabel('迭代次数');


    

function [childPath] = crossover(parent1Path, parent2Path, prob)
% 交叉
random = rand();
if prob >= random
    [l, length] = size(parent1Path);
    childPath = zeros(l,length);
    for i = 1:length
        childPath(1,i) = -1;
    end
    setSize = floor(length/2) -1;
    offset = randi(setSize);
    for i=offset:setSize+offset-1
        childPath(1,i) = parent1Path(1,i);
    end
    iterator = i+1;
    j = iterator;
    while any(childPath == -1)
        if j > length
            j = 1;
        end
        if iterator > length
            iterator = 1;
        end
        %交叉采用随机交叉的方法 其余的位置直接交叉
        childPath(1,iterator) = parent2Path(1,j);
        iterator = iterator+1;
        j = j + 1;
    end
else
        childPath = parent1Path;
end
end

function [ fitnessvar, sumDistances,minPath, maxPath, best ] = fitness( distances, pop,Money_start,maptest,weather,cost )
% 计算整个种群的适应度值 即最后的资金大小 然后取最优
[popSize, col] = size(pop);
%col长度为30
bool_success = zeros(1,popSize);
sumDistances = zeros(popSize,1);
fitnessvar = zeros(popSize,1);
for i=1:popSize
    water_now = 240;
    food_now = 240;
    money_now = Money_start - water_now*5.4 - food_now*10;
    %针对每一个种群的个体进行计算
    %在给定初始购买后进行第一阶段 行走阶段的计算
%当二进制码累加超过最短路距离时即为到达目的地
tempnum1 = 0;%记录路程数
tempnum2 = 1;%记录累加数
[dis1,p1] = floyd(maptest,1,12);
while tempnum1 < dis1
    if tempnum1 == dis1-2
        %到达矿山前经过村庄 此时补充补给到满
       money_now = money_now - 20*(240-food_now) - 10.8*(240-water_now);
       food_now = 240;
       water_now = 240;
       if money_now <0%防止没有资金购买的保险措施
          money_now = money_now + 20*5 - 10.8*5;
          food_now = food_now-5;
          water_now = water_now-5;
       end
    end
    if weather(1,tempnum2) == 3
        %如果是沙暴天 直接停靠
        food_now = food_now - cost(2,weather(1,tempnum2));
        water_now = water_now - cost(1,weather(1,tempnum2));
    else
        tempnum1 = tempnum1 + pop(i,tempnum2);
        if pop(i,tempnum2) == 1
            %说明当天选择行进 此时消耗水和食物
            food_now = food_now - 2*cost(2,weather(1,tempnum2));
            water_now = water_now - 2*cost(1,weather(1,tempnum2));
        else
            %说明当天选择停靠
            food_now = food_now - cost(2,weather(1,tempnum2));
            water_now = water_now - cost(1,weather(1,tempnum2));
        end
    end
    tempnum2 = tempnum2 + 1;
end
cf = 0;%记录是否从村庄返程
%为了撤离 提前计算该个体的临界逃离时间和所需要的物资
[dis2,p1] = floyd(maptest,12,27);
templeast = 0;%用来计数
tempnum4 = 30;
least_time = 30;%记录最迟时间
while templeast < dis2
    if pop(i,tempnum4) == 1 &&weather(1,tempnum4)~=3
       templeast = templeast + pop(i,tempnum4);
    end
    least_time = least_time - 1;
    tempnum4 = tempnum4 - 1;
end
food_least = 0;%记录最少需要多少食物
water_least = 0;%记录最少需要多少水
%已知该个体的最迟撤离时间 就可以算出最少需要多少资源
for l = least_time : 30
    if weather(1,l) == 3
       food_least = food_least + cost(2,weather(1,l));
       water_least = water_least + cost(1,weather(1,l));
    else
       food_least = food_least + 2*cost(2,weather(1,l));
       water_least = water_least + 2*cost(1,weather(1,l));
    end
end
%到达矿山后开始改变编码意义 此时的0-1表示是否挖矿以及当需要 补给的时候是否补给
tempnum3 = 1;%记录进入第二阶段的时间
tempnum5 = 0;%记录完成补给的走路路程
befalse = 0;
while tempnum2 < least_time
    %说明此时还可以挖矿
    if food_now <= 2*cost(2,weather(1,tempnum2+1))+2*cost(2,weather(1,tempnum2+2))+ 3*cost(2,weather(1,tempnum2))|| water_now <= 2*cost(1,weather(1,tempnum2+1))+2*cost(1,weather(1,tempnum2+2))+3*cost(1,weather(1,tempnum2))
       %说明此时需要补给 因为今天如果选择工作后不能及时去补给
       if food_now <= 2*cost(2,weather(1,tempnum2+1))+2*cost(2,weather(1,tempnum2+2))|| water_now <= 2*cost(1,weather(1,tempnum2+1))+2*cost(1,weather(1,tempnum2+2))
          %如果此时仍小于 这说明已经失败
          bool_success(1,i) = -1;
          break;
       end
       %但是此时如果未来有沙暴 则会多承受一轮移动 浪费时间在多余的路程也视为失败
       if weather(1,tempnum2+1) == 3 || weather(1,tempnum2+2) == 3
          bool_success(1,i) = -1;
          break;
       end
       %因为该情况下必定可以到达村庄 所以直接进行扣除
       tempwalk = 0;
       while tempwalk <2
           if weather(1,tempnum2) == 3
                   %此时停留
                   food_now = food_now - cost(2,weather(1,tempnum2));
                   water_now = water_now - cost(1,weather(1,tempnum2));
           else%此时行走一个单位
                   food_now = food_now - 2*cost(2,weather(1,tempnum2));
                   water_now = water_now- 2*cost(1,weather(1,tempnum2));
                   tempwalk = tempwalk +1;
           end
           if food_now<0||water_now < 0
               bool_success(1,i) = -1;
           end
            tempnum2 = tempnum2+1;%时间流逝    
       end
      
       %如果可以进行补给，则进入补给阶段
       %在已知未来的天气情况下 补给的数量应该是固定的
       %此时应该有两种情况 第一种是此时如果离最后离开期限小于3天的话建议直接离开 因为无法挖矿
       %如果返回路上同样要出现沙暴 也建议不要浪费时间 直接前往终点
       if least_time - tempnum2 < 3 || weather(1,tempnum2) == 3|| weather(1,tempnum2+1) == 3
           %此时补给的数量为补到正好可以回去 并且开始前往终点
           %首先计算此时回去需要多少资源
           %先计算在当前决策序列上需要多少天回去 需要的资源则是需要补充的资源
           back_need = 0;%记录需要多少天回去
           tempnum6 = 0;%记录里程数
           food_least2 = 0;
           water_least2 = 0;
           [dis3,p1] = floyd(maptest,15,27);
           while tempnum6 < dis3
               if tempnum2+back_need >30
                   befalse = 1;
                   bool_success(1,i) = 0;
                   break;
               end
               if weather(1,tempnum2+back_need) == 3
                   %此时停留
                   food_least2 = food_least2 + cost(2,weather(1,tempnum2+back_need));
                   water_least2 = water_least2+cost(1,weather(1,tempnum2+back_need));
               else%此时行走一个单位
                   food_least2 = food_least2 + 2*cost(2,weather(1,tempnum2+back_need));
                   water_least2 = water_least2+ 2*cost(1,weather(1,tempnum2+back_need));
                   tempnum6 = tempnum6 +1;
               end
               back_need = back_need+1;
           end
           %然后根据计算结果进行补给
           if befalse == 1
               break;
           end
           if food_least2 - food_now >0 && water_least2 - water_now >0
               %此时都缺
               money_now = money_now - 20*(food_least2 - food_now) - 10.8*(water_least2 - water_now);
               food_now = food_least2;
               water_now = water_least2;
           elseif food_least2 - food_now >0 && water_least2 - water_now <=0
               food_now = food_least2;
               money_now = money_now - 20*(food_least2 - food_now);
           else
               water_now = water_least2;
               money_now = money_now - 10.8*(water_least2 - water_now);
           end
           %补给结束后直接跳出 进行返程
           cf = 1;
           break;
       end
       if befalse == 1
               break;
       end
       %如果还可以返回挖金 那么补给的数量要计算上最迟返回
       earnmore_time = least_time - tempnum2 - 2;
       money_now = money_now - 20*(food_least - food_now + 2*(cost(2,weather(1,tempnum2))+cost(2,weather(1,tempnum2+1))));
       money_now = money_now - 10.8*(water_least - water_now + 2*(cost(1,weather(1,tempnum2))+cost(1,weather(1,tempnum2+1))));
       food_now = food_least+ 2*(cost(2,weather(1,tempnum2))+cost(2,weather(1,tempnum2+1)));
       water_now = water_least+ 2*(cost(1,weather(1,tempnum2))+cost(1,weather(1,tempnum2+1)));
       %接着是补充在矿上还要工作的分量
       
       for ll = 1:earnmore_time
           money_now = money_now - 3*20*(cost(2,weather(1,tempnum2+2+ll)));
           food_now = food_now+3*cost(2,weather(1,tempnum2+ll+2));
           money_now = money_now - 3*10.8*(cost(1,weather(1,tempnum2+2+ll)));
           water_now = water_now+3*cost(1,weather(1,tempnum2+ll+2));
       end
       tempnum2 = tempnum2+2;%时间流逝
       %然后是返回之后开始挖矿，此时已经不需要二次补给了
       money_now = money_now + 1000*earnmore_time;
       food_now = food_least;
       water_now = water_least;
       tempnum2 = tempnum2+earnmore_time;
       continue;
    end
     if tempnum3== 1
%         %说明此时第一次进入矿山 无法挖矿
%         %此时只能停留
%         food_now = food_now - cost(2,weather(1,tempnum2));
%         water_now = water_now - cost(2,weather(1,tempnum2));
%         tempnum3 = 0;
%         tempnum2 = tempnum2+1;%时间流逝
         %否则根据编码选择是否挖矿
        if pop(i,tempnum2) == 1 
            %说明要选择挖矿
            money_now = money_now + 1000;
            food_now = food_now - 3*cost(2,weather(1,tempnum2));
            water_now = water_now - 3*cost(2,weather(1,tempnum2));
            tempnum2 = tempnum2+1;%时间流逝
        else%否则停留
            food_now = food_now - cost(2,weather(1,tempnum2));
            water_now = water_now - cost(2,weather(1,tempnum2));
            tempnum2 = tempnum2+1;%时间流逝
        end
    end
     
end
%此时结束循环之后检查记录失败的数组 如果失败直接淘汰
%如果没有失败 就计算最后的行程 并将最后的金额作为适应度值
if bool_success(1,i) == -1
    sumDistances(i) = 0;
else
    %如果物资不够可以购买
    
    %进行最终进程 根据指令序列进行返程
    if cf ==1%此时从村庄返程
        for kk = 1 : back_need
            if weather(1,tempnum2+kk-1) == 3
                food_now = food_now - cost(2,weather(1,tempnum2+kk-1));
                water_now = water_now - cost(1,weather(1,tempnum2+kk-1));
            else
                food_now = food_now - 2*cost(2,weather(1,tempnum2+kk-1));
                water_now = water_now - 2*cost(1,weather(1,tempnum2+kk-1));
            end
%             if food_now <0||water_now<0
%                 bool_success(1,i) = -1;
%                 break;
%             end
        end
    else%此时从矿山返程
        if food_least - food_now >0 && water_least - water_now >0
               %此时都缺
               money_now = money_now - 20*(food_least - food_now) - 10.8*(water_least - water_now);
               food_now = food_least;
               water_now = water_least;
       elseif food_least - food_now >0 && water_least - water_now <0
               food_now = food_least;
               money_now = money_now - 20*(food_least - food_now);
        elseif food_least - food_now <0 && water_least - water_now >0
               water_now = water_least;
               money_now = money_now - 10.8*(water_least - water_now);
        end
        for kk = tempnum2 : col
            if weather == 3
                food_now = food_now - cost(2,weather(1,kk));
                water_now = water_now - cost(1,weather(1,kk));
            else
                food_now = food_now - 2*cost(2,weather(1,kk));
                water_now = water_now - 2*cost(1,weather(1,kk));
            end
%             if food_now <0||water_now<0
%                 bool_success(1,i) = -1;
%                 break;
%             end
        end
    end
end
if bool_success(1,i) == -1
    sumDistances(i) = 0;
else
     sumDistances(i) = money_now + food_now*2.7+ water_now*5;
end 
end
mmax = 0;
mmax_pos = 1;
for i = 1:popSize
    if sumDistances(i) > mmax
        mmax = sumDistances(i);
        mmax_pos = i;
    end
end
best = zeros(1,30);
best = pop(mmax_pos,:);
sumDistances = -1*sumDistances;
minPath = min(sumDistances);
maxPath = max(sumDistances);
for i=1:length(sumDistances)
fitnessvar(i,1)=(maxPath - sumDistances(i,1)+0.000001) / (maxPath-minPath+0.00000001);
end
end

function [ mutatedPath ] = mutate( path, prob )
%对指定的路径利用指定的概率进行更新
random = rand();
if random <= prob
[l,length] = size(path);
index1 = randi(length);
index2 = randi(length);
%交换
temp = path(l,index1);
path(l,index1) = path(l,index2);
path(l,index2)=temp;
end
mutatedPath = path; 
end

function [ output_args ] = paint( cities, pop, minPath, totalDistances,gen)
gNumber=gen;
[~, length] = size(cities);
xDots = cities(1,:);
yDots = cities(2,:);
%figure(1);
title('GA TSP');
plot(xDots,yDots, 'p', 'MarkerSize', 14, 'MarkerFaceColor', 'blue');
xlabel('横坐标');
ylabel('纵坐标');
axis equal
hold on
[minPathX,~] = find(totalDistances==minPath,1, 'first');
bestPopPath = pop(minPathX, :);
bestX = zeros(1,length);
bestY = zeros(1,length);
for j=1:length
bestX(1,j) = cities(1,bestPopPath(1,j));
bestY(1,j) = cities(2,bestPopPath(1,j));
end
title('最佳路线示意图（仅表示路线顺序）');
plot(bestX(1,:),bestY(1,:), 'red', 'LineWidth', 1.25);
legend('目标货格', '路径');
axis equal
grid on
%text(5,0,sprintf('迭代次数: %d 总路径长度: %.2f',gNumber, minPath),'FontSize',10);
drawnow

hold off
end

function [n_citys,city_position] = Read(filename)
fid = fopen(filename,'rt');
location=[];
A = [1 2];
tline = fgetl(fid);
while ischar(tline)
if(strcmp(tline,'NODE_COORD_SECTION'))
while ~isempty(A)
A=fscanf(fid,'%f',[3,1]);
if isempty(A)
break;
end
location=[location;A(2:3)'];
end
end
tline = fgetl(fid); 
if strcmp(tline,'EOF')
break;
end
end
[m,n]=size(location);
n_citys = m;
city_position=location;
fclose(fid);
end

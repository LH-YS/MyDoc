daytime = 30;
maxGEN = 100;
popSize = 100; % �Ŵ��㷨��Ⱥ��С
crossoverProbabilty = 0.9; %�������
mutationProbabilty = 0.1; %�������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gbest = Inf;
% �����������ɵĳ��о���
distances = maptest;
% ������Ⱥ Ϊ30���ȵĶ�������
pop = zeros(popSize, daytime);
for i=1:popSize
    for j = 1:30
       pop(i,:) = randsrc(1,30,[1 0;0.8 0.2]);
    end
end
offspring = zeros(popSize,daytime);
%����ÿ������С·�����ڻ�ͼ
minPathes = zeros(maxGEN,1);
% GA�㷨
Money_start = 10000;
for  gen=1:maxGEN
% ������Ӧ�ȵ�ֵ����·���ܾ���
[fval, sumDistance, minPath, maxPath,best] = fitness(distances, pop,Money_start,maptest,weather,cost);
% ���̶�ѡ��
tournamentSize=4; %���ô�С
for k=1:popSize
% ѡ�񸸴����н���
tourPopDistances=zeros( tournamentSize,1);
for i=1:tournamentSize
randomRow = randi(popSize);
tourPopDistances(i,1) = sumDistance(randomRow,1);
end
% ѡ����õģ���������С��
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
subPath = crossover(parent1Path, parent2Path, crossoverProbabilty);%����
subPath = mutate(subPath, mutationProbabilty);%����
offspring(k,:) = subPath(1,:);
minPathes(gen,1) = minPath; 
end
fprintf('����:%d   ���·��:%.2fM \n', gen,minPath);
% ����
pop = offspring;
if minPath < gbest
gbest = minPath;
%paint(cities, pop, gbest, sumDistance,gen);
end
end
%figure 
%plot(minPathes, 'MarkerFaceColor', 'red','LineWidth',1);
%title('��������ͼ��ÿһ�������·����');
%set(gca,'ytick',500:100:5000); 
%ylabel('·������');
%xlabel('��������');


    

function [childPath] = crossover(parent1Path, parent2Path, prob)
% ����
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
        %��������������ķ��� �����λ��ֱ�ӽ���
        childPath(1,iterator) = parent2Path(1,j);
        iterator = iterator+1;
        j = j + 1;
    end
else
        childPath = parent1Path;
end
end

function [ fitnessvar, sumDistances,minPath, maxPath, best ] = fitness( distances, pop,Money_start,maptest,weather,cost )
% ����������Ⱥ����Ӧ��ֵ �������ʽ��С Ȼ��ȡ����
[popSize, col] = size(pop);
%col����Ϊ30
bool_success = zeros(1,popSize);
sumDistances = zeros(popSize,1);
fitnessvar = zeros(popSize,1);
for i=1:popSize
    water_now = 240;
    food_now = 240;
    money_now = Money_start - water_now*5.4 - food_now*10;
    %���ÿһ����Ⱥ�ĸ�����м���
    %�ڸ�����ʼ�������е�һ�׶� ���߽׶εļ���
%�����������ۼӳ������·����ʱ��Ϊ����Ŀ�ĵ�
tempnum1 = 0;%��¼·����
tempnum2 = 1;%��¼�ۼ���
[dis1,p1] = floyd(maptest,1,12);
while tempnum1 < dis1
    if tempnum1 == dis1-2
        %�����ɽǰ������ׯ ��ʱ���䲹������
       money_now = money_now - 20*(240-food_now) - 10.8*(240-water_now);
       food_now = 240;
       water_now = 240;
       if money_now <0%��ֹû���ʽ���ı��մ�ʩ
          money_now = money_now + 20*5 - 10.8*5;
          food_now = food_now-5;
          water_now = water_now-5;
       end
    end
    if weather(1,tempnum2) == 3
        %�����ɳ���� ֱ��ͣ��
        food_now = food_now - cost(2,weather(1,tempnum2));
        water_now = water_now - cost(1,weather(1,tempnum2));
    else
        tempnum1 = tempnum1 + pop(i,tempnum2);
        if pop(i,tempnum2) == 1
            %˵������ѡ���н� ��ʱ����ˮ��ʳ��
            food_now = food_now - 2*cost(2,weather(1,tempnum2));
            water_now = water_now - 2*cost(1,weather(1,tempnum2));
        else
            %˵������ѡ��ͣ��
            food_now = food_now - cost(2,weather(1,tempnum2));
            water_now = water_now - cost(1,weather(1,tempnum2));
        end
    end
    tempnum2 = tempnum2 + 1;
end
cf = 0;%��¼�Ƿ�Ӵ�ׯ����
%Ϊ�˳��� ��ǰ����ø�����ٽ�����ʱ�������Ҫ������
[dis2,p1] = floyd(maptest,12,27);
templeast = 0;%��������
tempnum4 = 30;
least_time = 30;%��¼���ʱ��
while templeast < dis2
    if pop(i,tempnum4) == 1 &&weather(1,tempnum4)~=3
       templeast = templeast + pop(i,tempnum4);
    end
    least_time = least_time - 1;
    tempnum4 = tempnum4 - 1;
end
food_least = 0;%��¼������Ҫ����ʳ��
water_least = 0;%��¼������Ҫ����ˮ
%��֪�ø������ٳ���ʱ�� �Ϳ������������Ҫ������Դ
for l = least_time : 30
    if weather(1,l) == 3
       food_least = food_least + cost(2,weather(1,l));
       water_least = water_least + cost(1,weather(1,l));
    else
       food_least = food_least + 2*cost(2,weather(1,l));
       water_least = water_least + 2*cost(1,weather(1,l));
    end
end
%�����ɽ��ʼ�ı�������� ��ʱ��0-1��ʾ�Ƿ��ڿ��Լ�����Ҫ ������ʱ���Ƿ񲹸�
tempnum3 = 1;%��¼����ڶ��׶ε�ʱ��
tempnum5 = 0;%��¼��ɲ�������··��
befalse = 0;
while tempnum2 < least_time
    %˵����ʱ�������ڿ�
    if food_now <= 2*cost(2,weather(1,tempnum2+1))+2*cost(2,weather(1,tempnum2+2))+ 3*cost(2,weather(1,tempnum2))|| water_now <= 2*cost(1,weather(1,tempnum2+1))+2*cost(1,weather(1,tempnum2+2))+3*cost(1,weather(1,tempnum2))
       %˵����ʱ��Ҫ���� ��Ϊ�������ѡ�������ܼ�ʱȥ����
       if food_now <= 2*cost(2,weather(1,tempnum2+1))+2*cost(2,weather(1,tempnum2+2))|| water_now <= 2*cost(1,weather(1,tempnum2+1))+2*cost(1,weather(1,tempnum2+2))
          %�����ʱ��С�� ��˵���Ѿ�ʧ��
          bool_success(1,i) = -1;
          break;
       end
       %���Ǵ�ʱ���δ����ɳ�� �������һ���ƶ� �˷�ʱ���ڶ����·��Ҳ��Ϊʧ��
       if weather(1,tempnum2+1) == 3 || weather(1,tempnum2+2) == 3
          bool_success(1,i) = -1;
          break;
       end
       %��Ϊ������±ض����Ե����ׯ ����ֱ�ӽ��п۳�
       tempwalk = 0;
       while tempwalk <2
           if weather(1,tempnum2) == 3
                   %��ʱͣ��
                   food_now = food_now - cost(2,weather(1,tempnum2));
                   water_now = water_now - cost(1,weather(1,tempnum2));
           else%��ʱ����һ����λ
                   food_now = food_now - 2*cost(2,weather(1,tempnum2));
                   water_now = water_now- 2*cost(1,weather(1,tempnum2));
                   tempwalk = tempwalk +1;
           end
           if food_now<0||water_now < 0
               bool_success(1,i) = -1;
           end
            tempnum2 = tempnum2+1;%ʱ������    
       end
      
       %������Խ��в���������벹���׶�
       %����֪δ������������� ����������Ӧ���ǹ̶���
       %��ʱӦ����������� ��һ���Ǵ�ʱ���������뿪����С��3��Ļ�����ֱ���뿪 ��Ϊ�޷��ڿ�
       %�������·��ͬ��Ҫ����ɳ�� Ҳ���鲻Ҫ�˷�ʱ�� ֱ��ǰ���յ�
       if least_time - tempnum2 < 3 || weather(1,tempnum2) == 3|| weather(1,tempnum2+1) == 3
           %��ʱ����������Ϊ�������ÿ��Ի�ȥ ���ҿ�ʼǰ���յ�
           %���ȼ����ʱ��ȥ��Ҫ������Դ
           %�ȼ����ڵ�ǰ������������Ҫ�������ȥ ��Ҫ����Դ������Ҫ�������Դ
           back_need = 0;%��¼��Ҫ�������ȥ
           tempnum6 = 0;%��¼�����
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
                   %��ʱͣ��
                   food_least2 = food_least2 + cost(2,weather(1,tempnum2+back_need));
                   water_least2 = water_least2+cost(1,weather(1,tempnum2+back_need));
               else%��ʱ����һ����λ
                   food_least2 = food_least2 + 2*cost(2,weather(1,tempnum2+back_need));
                   water_least2 = water_least2+ 2*cost(1,weather(1,tempnum2+back_need));
                   tempnum6 = tempnum6 +1;
               end
               back_need = back_need+1;
           end
           %Ȼ����ݼ��������в���
           if befalse == 1
               break;
           end
           if food_least2 - food_now >0 && water_least2 - water_now >0
               %��ʱ��ȱ
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
           %����������ֱ������ ���з���
           cf = 1;
           break;
       end
       if befalse == 1
               break;
       end
       %��������Է����ڽ� ��ô����������Ҫ��������ٷ���
       earnmore_time = least_time - tempnum2 - 2;
       money_now = money_now - 20*(food_least - food_now + 2*(cost(2,weather(1,tempnum2))+cost(2,weather(1,tempnum2+1))));
       money_now = money_now - 10.8*(water_least - water_now + 2*(cost(1,weather(1,tempnum2))+cost(1,weather(1,tempnum2+1))));
       food_now = food_least+ 2*(cost(2,weather(1,tempnum2))+cost(2,weather(1,tempnum2+1)));
       water_now = water_least+ 2*(cost(1,weather(1,tempnum2))+cost(1,weather(1,tempnum2+1)));
       %�����ǲ����ڿ��ϻ�Ҫ�����ķ���
       
       for ll = 1:earnmore_time
           money_now = money_now - 3*20*(cost(2,weather(1,tempnum2+2+ll)));
           food_now = food_now+3*cost(2,weather(1,tempnum2+ll+2));
           money_now = money_now - 3*10.8*(cost(1,weather(1,tempnum2+2+ll)));
           water_now = water_now+3*cost(1,weather(1,tempnum2+ll+2));
       end
       tempnum2 = tempnum2+2;%ʱ������
       %Ȼ���Ƿ���֮��ʼ�ڿ󣬴�ʱ�Ѿ�����Ҫ���β�����
       money_now = money_now + 1000*earnmore_time;
       food_now = food_least;
       water_now = water_least;
       tempnum2 = tempnum2+earnmore_time;
       continue;
    end
     if tempnum3== 1
%         %˵����ʱ��һ�ν����ɽ �޷��ڿ�
%         %��ʱֻ��ͣ��
%         food_now = food_now - cost(2,weather(1,tempnum2));
%         water_now = water_now - cost(2,weather(1,tempnum2));
%         tempnum3 = 0;
%         tempnum2 = tempnum2+1;%ʱ������
         %������ݱ���ѡ���Ƿ��ڿ�
        if pop(i,tempnum2) == 1 
            %˵��Ҫѡ���ڿ�
            money_now = money_now + 1000;
            food_now = food_now - 3*cost(2,weather(1,tempnum2));
            water_now = water_now - 3*cost(2,weather(1,tempnum2));
            tempnum2 = tempnum2+1;%ʱ������
        else%����ͣ��
            food_now = food_now - cost(2,weather(1,tempnum2));
            water_now = water_now - cost(2,weather(1,tempnum2));
            tempnum2 = tempnum2+1;%ʱ������
        end
    end
     
end
%��ʱ����ѭ��֮�����¼ʧ�ܵ����� ���ʧ��ֱ����̭
%���û��ʧ�� �ͼ��������г� �������Ľ����Ϊ��Ӧ��ֵ
if bool_success(1,i) == -1
    sumDistances(i) = 0;
else
    %������ʲ������Թ���
    
    %�������ս��� ����ָ�����н��з���
    if cf ==1%��ʱ�Ӵ�ׯ����
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
    else%��ʱ�ӿ�ɽ����
        if food_least - food_now >0 && water_least - water_now >0
               %��ʱ��ȱ
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
%��ָ����·������ָ���ĸ��ʽ��и���
random = rand();
if random <= prob
[l,length] = size(path);
index1 = randi(length);
index2 = randi(length);
%����
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
xlabel('������');
ylabel('������');
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
title('���·��ʾ��ͼ������ʾ·��˳��');
plot(bestX(1,:),bestY(1,:), 'red', 'LineWidth', 1.25);
legend('Ŀ�����', '·��');
axis equal
grid on
%text(5,0,sprintf('��������: %d ��·������: %.2f',gNumber, minPath),'FontSize',10);
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

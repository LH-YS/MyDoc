%����Ŀ����ȡ�������
%Ŀ���������� �������Ŀ�������е�����
rwnum = 0;
rwname = 49;
for i = 1:1200
    if RWnum(i,1) == rwname
        rwnum = rwnum+1;
    end
end
%��������������������
rw = zeros(rwnum,2);
temp1 = 1;
for i = 1:1200
    if RWnum(i,1) == rwname
        rw(temp1,1) = RWnum(i,2);
        rw(temp1,2) = RWnum(i,3);
        temp1 = temp1+1;
    end
end
%�������񵥵����ݽ����������
pos1 = 1;
pos2 = 1;
Drw = zeros(rwnum,rwnum);
for i = 1:rwnum
    r1 = rw(i,1);
    for j = 1:rwnum
        r2 = rw(j,1);
        for i1 = 1:3000
            if NUM(1,i1) == r1
                pos1 = i1;
            end
            if NUM(1,i1) == r2
                pos2 = i1;
            end
        end
        Drw(i,j) = S(pos1,pos2);
    end
end



tStart = tic; % �㷨��ʱ��
%%%%%%%%%%%%�Զ������%%%%%%%%%%%%%
%[cityNum,cities] = Read('dsj1000.tsp');
%�������񵥵����궨��cities
cities = zeros(rwnum,2);
title1 = 1;
for i = 1:rwnum
    for i1 = 1:3000
    if NUM(1,i1) == rw(i,1)
        pos1 = i1;
    end
    cities(i,1) = citiesall(pos1,1);
    cities(i,2) = citiesall(pos1,2);
    end
end
%cities(24,1) = cities(title1,1);
%cities(24,2) = cities(title1,2);

cities = cities';
cityNum = rwnum;
maxGEN = 1000;
popSize = 100; % �Ŵ��㷨��Ⱥ��С
crossoverProbabilty = 0.9; %�������
mutationProbabilty = 0.1; %�������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gbest = Inf;
% ������ɳ���λ��
%cities = rand(2,cityNum) * 100;%100����Զ����
% �����������ɵĳ��о���
distances = Drw;
% ������Ⱥ��ÿ���������һ��·��
pop = zeros(popSize, cityNum);
for i=1:popSize
pop(i,:) = randperm(cityNum); 
end
offspring = zeros(popSize,cityNum);
%����ÿ������С·�����ڻ�ͼ
minPathes = zeros(maxGEN,1);
% GA�㷨
for  gen=1:maxGEN
% ������Ӧ�ȵ�ֵ����·���ܾ���
[fval, sumDistance, minPath, maxPath] = fitness(distances, pop);
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
% ������ǰ״̬�µ����·��
if minPath < gbest
gbest = minPath;
paint(cities, pop, gbest, sumDistance,gen);
end
end
figure 
plot(minPathes, 'MarkerFaceColor', 'red','LineWidth',1);
title('��������ͼ��ÿһ�������·����');
set(gca,'ytick',500:100:5000); 
ylabel('·������');
xlabel('��������');
grid on
tEnd = toc(tStart);
fprintf('ʱ��:%d ��  %f ��.\n', floor(tEnd/60), rem(tEnd,60));
SUM = 0;
for i = 1:rwnum-1
    for i1 = 1:3000
    if NUM(1,i1) == rw(subPath(i))
        pos4 = i1;
    end
    if NUM(1,i1) == rw(subPath(i+1))
        pos5 = i1;
    end
    end
    SUM = SUM+S(pos4,pos5);
end
    if NUM(1,i1) == rw(subPath(1))
        pos4 = i1;
    end
    if NUM(1,i1) == rw(subPath(rwnum))
        pos5 = i1;
    end
SUM = SUM+S(pos4,pos5);
%SUM������̻�·
%������������Թ滮ģ��
%�����趨 ��·���Ͼ���SUM
%����̨���ϲ���Ҫ�����趨 ��Ҫ��ʱ��ֱ�Ӳ�� ֻ�Ǹ�����Ŀ����Ҫ��һ��
%��ⷽ�����Ǳ������е���������Ž�
booltemp = 9999999;%�ȸ�һ�����Դ������Ϊ��ʼ��

for i = 1:rwnum-1
    %�ҵ�vij
    for i1 = 1:3000
        if NUM(1,i1) == rw(subPath(i))
            pos4 = i1;
        end
        if NUM(1,i1) == rw(subPath(i+1))
            pos5 = i1;
        end
    end
    for j = 1:4
        for k = 1:4
            templength = SUM - S(pos4,pos5)+S(3000+fhjh(1,j),pos4)+S(3000+fhjh(1,k),pos5);
            if(templength < booltemp)
                %��¼��ʱ����ѽ�
                besti = i;
                bestj = i+1;
                bestfh1 = fhjh(1,j);
                bestfh2 = fhjh(1,k);
                booltemp = templength;
            end
        end
    end
end
%���һ����� ��β������
    for i1 = 1:3000
        if NUM(1,i1) == rw(subPath(1))
            pos4 = i1;
        end
        if NUM(1,i1) == rw(subPath(rwnum))
            pos5 = i1;
        end
    end
    for j = 1:4
        for k = 1:4
            templength = SUM - S(pos4,pos5)+S(3000+fhjh(1,j),pos4)+S(3000+fhjh(1,k),pos5);
            if(templength < booltemp)
                %��¼��ʱ����ѽ�
                besti = i;
                bestj = i+1;
                bestfh1 = fhjh(1,j);
                bestfh2 = fhjh(1,k);
                booltemp = templength;
            end
        end
    end

ltime = booltemp/1.5;%��·���ѵ�ʱ��
xtime = 0;
for i = 1:rwnum
    if rw(i,2) < 3
        xtime = xtime + rw(i,2)*5;
    else
        xtime = xtime + rw(i,2)*4;
    end
end
alltime = ltime+xtime;
hgsx = zeros(1,rwnum);
ii = 1;
for i = bestj:rwnum
    hgsx(1,ii) = rw(subPath(i),1);
    ii = ii+1;
end
for i = 1:besti
    hgsx(1,ii) = rw(subPath(i),1);
    ii = ii+1;
end
hgsx = hgsx';    
    

function [childPath] = crossover(parent1Path, parent2Path, prob)
% ����
random = rand();
if prob >= random
[l, length] = size(parent1Path);
childPath = zeros(l,length);
setSize = floor(length/2) -1;
offset = randi(setSize);
for i=offset:setSize+offset-1
childPath(1,i) = parent1Path(1,i);
end
iterator = i+1;
j = iterator;
while any(childPath == 0)
if j > length
j = 1;
end
if iterator > length
iterator = 1;
end
if ~any(childPath == parent2Path(1,j))
childPath(1,iterator) = parent2Path(1,j);
iterator = iterator + 1;
end
j = j + 1;
end
else
childPath = parent1Path;
end
end

function [ fitnessvar, sumDistances,minPath, maxPath ] = fitness( distances, pop )
% ����������Ⱥ����Ӧ��ֵ
[popSize, col] = size(pop);
sumDistances = zeros(popSize,1);
fitnessvar = zeros(popSize,1);
for i=1:popSize
for j=1:col-1
sumDistances(i) = sumDistances(i) + distances(pop(i,j),pop(i,j+1));
end 
end
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

%���վ���ģ��
%������Ϸ��ÿһ����ǰ����Ҫȡ���ڷ��վ��ߺ�����������޶�
%�������ά�ĵ�˼�� �����ն���Ϊ�����ʵķ��� ��������Դ���Ĺ����в�ͬѡ��ķ���
%������Ϸ�ж������·��ǰ�� ����ڴ���·�����Ѿ�ȷ��Ϊ1-4-3-9-11-13
minpath_3 = [1,4,3,9,11,13];
weather = zeros(1,10);
cost_3 = [3,9,10,4,9,10];%����������
%�������������ȸ�ֵabc
a = 0.6;
b = 0.4;
c = 0;
weather = randsrc(1,10,[1 2 3;a b c]);
%����abcΪ��ͬ�����ĸ���
Time = 1;
A = 0;%AֵΪ�����Ľ���ֵ
pos = 1;%��ҵĳ�����ַ��1

water_now_3 = 240;
food_now_3 = 240;
money_now_3 = 10000 - water_now_3*5 - food_now_3*10;
%��ʼ��Ϸ
%��Ա��ŵ�ͼ �����ɽ��Ҫ3��
while fishgame ~= 1%����Ϸ��û�н���ʱ ������Ϸ
    
    %ʱ�̼���Ƿ�ﵽ�뿪���ٽ�
    [dis_least,p1] = floyd(theree,pos,13);
    water_least = dis_least*2*(a*cost_3(2,1)+b*cost_3(2,2));
    food_least = dis_least*2*(a*cost_3(2,1)+b*cost_3(2,2));
    if(food_now_3 < food_least || water_now_3 < water_least)
        state = 3;
        break;
    end
    
    %���㵱�������� ���ĵ���Դ��
    %������ڿ�ɽǰ�Ľ׶� ���ݼ��㲻ͬ����֮��ķ��� ��ȷ������
    %���㲻ͬ�������ڲ�ͬ��Դ�½��ķ���
    low_move_1 = 2*cost_3(2,weather(1,Time))/food_now_3;
    low_move_2 = 2*cost_3(1,weather(1,Time))/water_now_3;
    low_stay_1 = cost_3(2,weather(1,Time))/food_now_3;
    low_stay_2 = cost_3(1,weather(1,Time))/water_now_3;
    cov_1 = cov([low_move_1,low_move_2]);%�½������ķ��� Ҳ�������ʵķ���
    cov_2 = cov([low_stay_1,low_stay_2]);
    %����Qֵ
    Q1 = 2*cost_3(2,weather(1,Time))*10 / cov_1;
    Q2 = 2*cost_3(1,weather(1,Time))*5 / cov_2;
    %�ڰ�ȫ������� ��������˸����� ��ѡ��Qֵ���Ľ���ѡ��
    Time = Time+1;
end
if state == 3
        for i = 1:dis_least
            food_now_3 = food_now_3 - 2*cost_3(1,weather(1,Time+i));
            water_now_3 = water_now_3 - 2*cost_3(1,weather(1,Time+i));
        end
end
%���վ���ģ��
%������Ϸ��ÿһ����ǰ����Ҫȡ���ڷ��վ��ߺ�����������޶�
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
state = 1;%��ҵĳ�ʼ״̬Ϊǰ����ɽ��·��
%�����������趨1Ϊǰ����ɽ��·�� 2Ϊ���ڿ�ɽ 3Ϊǰ���յ��·��
food_now_3 = 240;
water_now_3 = 240;
money_now_3 = 10000 - food_now*5 - water_now*10;
%����֪����������ƶ�����������
food_E_move = 2*a*cost_3(2,1)+2*b*cost_3(2,2);
water_E_move = 2*a*cost_3(1,1)+2*b*cost_3(1,2);
%�ڿ����������
food_E_earn = a*3*cost(2,1)+b*3*cost_3(2,2);
water_E_move = a*3*cost(1,1)+b*3*cost_3(1,2);
state_1 = 1;%1��ʾ�ƶ������ڿ� 2 ��ʾͣ��
while fishgame ~= 1%����Ϸ��û�н���ʱ ������Ϸ
       %���ȳ��ڰ�ȫ�ԵĿ��� Ҫ�ھ���֮ǰ�����Լ��İ�ȫ״̬
       %�ڵ�������û�п�ɽ ��˿��ǵ��Ǵ�ʱ��ǰλ�ú�ֱ���յ�֮��Ĺ�ϵ
       %���ʳ���ˮ�㹻��ǰλ��ֱ���յ������ �����ǰ��
       %����������� ȴ������������ ��ʱ�жϷ���ֵָ��͸����Ĺ�ϵ
       %��Ϊ�����������ǰ�������ɽ����׬��������� ����һ�ַ��վ���
       %��������������ģ��������������
       [dis_deadline,p1] = floyd(three,pos,13);
       %����ֱͨ�յ��������ĺ���������
       food_worst_baack = 0;%������ʼֵ
       water_worst = 0;%������ʼֵ
       food_worst_back = food_worst_baack + 2*cost(2,2)*dis_deadline;
       water_worst_back = water_worst + 2*cost(1,2)*dis_deadline;
       food_E_back = (a*cost(2,1)+b*cost(2,2))/2;
       water_E_back = (a*cost(1,1)+b*cost(2,1))/2;
       %��̬���� ������Ҫ�ж���Ҵ����ĸ�״̬
    if state == 1
       %˵����ʱ����ǰ����ɽ��·��
       %�����ж��Ƿ����������ȥ������ֵ
       if food_now_3 < food_E_back || water_now_3 < water_E_back
           %���ʱ����ʼ��ȥ �����ﲻ����ʱ��
           state = 3;
           break;
           %������ı�״̬���ں���ֱ�ӽ���ǰ���յ�Ĺ���
       end
       %����֪��������������� �����Ƿ�ǰ��������Ϣ
       %��ʱ�������� ���㲻ͬ�����·��պ����ʽ�Ĺ�ϵ
      
       if pos == 1
           if 10-5-Time+1 < 0
               state = 3;
               
           else
           %��ʱδ�����������ʱ���漰���ڿ�
           %��ѡ���ߵ�ʱ�� �ֱ���������һ���������������߸������Һ��涼������״̬�µ������ܶ�
           %������ֵ��ʾ���Ǽ�����һ�������� ���յ��ʳ���ˮ���ж���
           food_test_sun = food_now_3 - 2*cost_3(2,weather(1,Time)) - 2*cost_3(2,1) - food_E_move*3 - (10-5-Time+1)*food_E_earn;
           water_test_sun = water_now_3 - 2*cost_3(1,weather(1,Time)) - 2*cost_3(1,1)- water_E_move*3 -(10-5-Time+1)*water_E_earn;
           food_test_hot = food_now_3 - 2*cost_3(2,weather(1,Time)) - 2*cost_3(2,2) - food_E_move*3 - (10-5-Time+1)*food_E_earn;
           water_test_hot = water_now_3 - 2*cost_3(1,weather(1,Time)) - 2*cost_3(1,2)- water_E_move*3 -(10-5-Time+1)*water_E_earn;
           run_sun = money_now_3 + (10-5-Time+1)*200 + food_test_sun*2.5 + water_test_sun*2.5;
           run_hot = money_now_3 + (10-5-Time+1)*200 + food_test_hot*2.5 + water_test_hot*2.5;
           run_E = a*run_sun+b*run_hot;
           cov_run_E = cov([run_sun,run_hot]);
           Q_run = run_E / cov_run_E;
           
           %��������ͣ�����
           food_stay_sun = food_now_3 - cost_3(2,weather(1,Time)) - 2*cost_3(2,1) - food_E_move*4 - (10-6-Time+1)*food_E_earn;
           water_stay_sun = water_now_3 - cost_3(1,weather(1,Time)) - 2*cost_3(1,1)- water_E_move*4 -(10-6-Time+1)*water_E_earn;
           food_stay_hot = food_now_3 - cost_3(2,weather(1,Time)) - 2*cost_3(2,2) - food_E_move*4 - (10-6-Time+1)*food_E_earn;
           water_stay_hot = water_now_3 - cost_3(1,weather(1,Time)) - 2*cost_3(1,2)- water_E_move*4 -(10-6-Time+1)*water_E_earn;
           stay_sun = money_now_3 + (10-6-Time+1)*200 + food_stay_sun*5 + water_stay_sun*2.5;
           stay_hot = money_now_3 + (10-6-Time+1)*200 + food_stay_hot*5 + water_stay_hot*2.5;
           stay_E = a*stay_sun+b*stay_hot;
           cov_stay_E = cov([stay_sun,stay_hot]);
           Q_stay = stay_E / cov_stay_E;
           
           %�����ֱ��ȥ�յ����� ֻ��Ƚ��յ�ʱ�����漴��
           [dis_back_1,p2] = floyd(three,1,13);
           food_back_sun = food_now_3 - food_E_back*(dis_back_1-2) - 2*cost(2,weather(1,Time)) - 2*cost_3(2,1);
           water_back_sun = food_now_3 - water_E_back*(dis_back_1-2) - 2*cost(1,weather(1,Time)) - 2*cost_3(1,1);
           food_back_hot = food_now_3 - food_E_back*(dis_back_1-2) - 2*cost(2,weather(1,Time)) - 2*cost_3(2,2);
           water_back_hot = food_now_3 - water_E_back*(dis_back_1-2) - 2*cost(1,weather(1,Time)) - 2*cost_3(1,2);
           back_money_sun = money_now_3 + food_back_sun*5 + water_back_sun*2.5;
           back_money_hot = money_now_3 + food_back_hot*5 + water_back_hot*2.5;
           back_money_E = a*back_money_sun+b*back_money;
           %����ɼ���֮��ʼ�Ƚ�Qֵ
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
           %��ʱδ�����������ʱ���漰���ڿ�
           %��ѡ���ߵ�ʱ�� �ֱ���������һ���������������߸������Һ��涼������״̬�µ������ܶ�
           %������ֵ��ʾ���Ǽ�����һ�������� ���յ��ʳ���ˮ���ж���
           food_test_sun = food_now_3 - 2*cost_3(2,weather(1,Time)) - 2*cost_3(2,1) - food_E_move*2 - (10-5-Time+1)*food_E_earn;
           water_test_sun = water_now_3 - 2*cost_3(1,weather(1,Time)) - 2*cost_3(1,1)- water_E_move*2 -(10-5-Time+1)*water_E_earn;
           food_test_hot = food_now_3 - 2*cost_3(2,weather(1,Time)) - 2*cost_3(2,2) - food_E_move*2 - (10-5-Time+1)*food_E_earn;
           water_test_hot = water_now_3 - 2*cost_3(1,weather(1,Time)) - 2*cost_3(1,2)- water_E_move*2 -(10-5-Time+1)*water_E_earn;
           run_sun = money_now_3 + (10-5-Time+1)*200 + food_test_sun*2.5 + water_test_sun*2.5;
           run_hot = money_now_3 + (10-5-Time+1)*200 + food_test_hot*2.5 + water_test_hot*2.5;
           run_E = a*run_sun+b*run_hot;
           cov_run_E = cov([run_sun,run_hot]);
           Q_run = run_E / cov_run_E;
           
           %��������ͣ�����
           food_stay_sun = food_now_3 - cost_3(2,weather(1,Time)) - 2*cost_3(2,1) - food_E_move*3 - (10-6-Time+1)*food_E_earn;
           water_stay_sun = water_now_3 - cost_3(1,weather(1,Time)) - 2*cost_3(1,1)- water_E_move*3 -(10-6-Time+1)*water_E_earn;
           food_stay_hot = food_now_3 - cost_3(2,weather(1,Time)) - 2*cost_3(2,2) - food_E_move*3 - (10-6-Time+1)*food_E_earn;
           water_stay_hot = water_now_3 - cost_3(1,weather(1,Time)) - 2*cost_3(1,2)- water_E_move*3 -(10-6-Time+1)*water_E_earn;
           stay_sun = money_now_3 + (10-6-Time+1)*200 + food_stay_sun*5 + water_stay_sun*2.5;
           stay_hot = money_now_3 + (10-6-Time+1)*200 + food_stay_hot*5 + water_stay_hot*2.5;
           stay_E = a*stay_sun+b*stay_hot;
           cov_stay_E = cov([stay_sun,stay_hot]);
           Q_stay = stay_E / cov_stay_E;
           
           %�����ֱ��ȥ�յ����� ֻ��Ƚ��յ�ʱ�����漴��
           [dis_back_1,p2] = floyd(three,1,13);
           food_back_sun = food_now_3 - food_E_back*(dis_back_1-2) - 2*cost(2,weather(1,Time)) - 2*cost_3(2,1);
           water_back_sun = food_now_3 - water_E_back*(dis_back_1-2) - 2*cost(1,weather(1,Time)) - 2*cost_3(1,1);
           food_back_hot = food_now_3 - food_E_back*(dis_back_1-2) - 2*cost(2,weather(1,Time)) - 2*cost_3(2,2);
           water_back_hot = food_now_3 - water_E_back*(dis_back_1-2) - 2*cost(1,weather(1,Time)) - 2*cost_3(1,2);
           back_money_sun = money_now_3 + food_back_sun*5 + water_back_sun*2.5;
           back_money_hot = money_now_3 + food_back_hot*5 + water_back_hot*2.5;
           back_money_E = a*back_money_sun+b*back_money;
           %����ɼ���֮��ʼ�Ƚ�Qֵ
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
           %��ʱδ�����������ʱ���漰���ڿ�
           %��ѡ���ߵ�ʱ�� �ֱ���������һ���������������߸������Һ��涼������״̬�µ������ܶ�
           %������ֵ��ʾ���Ǽ�����һ�������� ���յ��ʳ���ˮ���ж���
           food_test_sun = food_now_3 - 2*cost_3(2,weather(1,Time)) - 2*cost_3(2,1) - food_E_move*2 - (10-5-Time+1-1)*food_E_earn - 3*cost_3(2,1);
           water_test_sun = water_now_3 - 2*cost_3(1,weather(1,Time)) - 2*cost_3(1,1)- water_E_move*2 -(10-5-Time+1-1)*water_E_earn-3*cost_3(1,1);
           food_test_hot = food_now_3 - 2*cost_3(2,weather(1,Time)) - 2*cost_3(2,2) - food_E_move*2 - (10-5-Time+1-1)*food_E_earn-3*cost_3(1,2);
           water_test_hot = water_now_3 - 2*cost_3(1,weather(1,Time)) - 2*cost_3(1,2)- water_E_move*2 -(10-5-Time+1-1)*water_E_earn-3*cost_3(2,2);
           run_sun = money_now_3 + (10-5-Time+1-1)*200 + food_test_sun*2.5 + water_test_sun*2.5+200;
           run_hot = money_now_3 + (10-5-Time+1-1)*200 + food_test_hot*2.5 + water_test_hot*2.5+200;
           run_E = a*run_sun+b*run_hot;
           cov_run_E = cov([run_sun,run_hot]);
           Q_run = run_E / cov_run_E;
           
           %��������ͣ�����
           food_stay_sun = food_now_3 - cost_3(2,weather(1,Time)) - 2*cost_3(2,1) - food_E_move*3 - (10-6-Time+1)*food_E_earn;
           water_stay_sun = water_now_3 - cost_3(1,weather(1,Time)) - 2*cost_3(1,1)- water_E_move*3 -(10-6-Time+1)*water_E_earn;
           food_stay_hot = food_now_3 - cost_3(2,weather(1,Time)) - 2*cost_3(2,2) - food_E_move*3 - (10-6-Time+1)*food_E_earn;
           water_stay_hot = water_now_3 - cost_3(1,weather(1,Time)) - 2*cost_3(1,2)- water_E_move*3 -(10-6-Time+1)*water_E_earn;
           stay_sun = money_now_3 + (10-6-Time+1)*200 + food_stay_sun*5 + water_stay_sun*2.5;
           stay_hot = money_now_3 + (10-6-Time+1)*200 + food_stay_hot*5 + water_stay_hot*2.5;
           stay_E = a*stay_sun+b*stay_hot;
           cov_stay_E = cov([stay_sun,stay_hot]);
           Q_stay = stay_E / cov_stay_E;
           
           %�����ֱ��ȥ�յ����� ֻ��Ƚ��յ�ʱ�����漴��
           [dis_back_1,p2] = floyd(three,1,13);
           food_back_sun = food_now_3 - food_E_back*(dis_back_1-2) - 2*cost(2,weather(1,Time)) - 2*cost_3(2,1);
           water_back_sun = food_now_3 - water_E_back*(dis_back_1-2) - 2*cost(1,weather(1,Time)) - 2*cost_3(1,1);
           food_back_hot = food_now_3 - food_E_back*(dis_back_1-2) - 2*cost(2,weather(1,Time)) - 2*cost_3(2,2);
           water_back_hot = food_now_3 - water_E_back*(dis_back_1-2) - 2*cost(1,weather(1,Time)) - 2*cost_3(1,2);
           back_money_sun = money_now_3 + food_back_sun*5 + water_back_sun*2.5;
           back_money_hot = money_now_3 + food_back_hot*5 + water_back_hot*2.5;
           back_money_E = a*back_money_sun+b*back_money;
           %����ɼ���֮��ʼ�Ƚ�Qֵ
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
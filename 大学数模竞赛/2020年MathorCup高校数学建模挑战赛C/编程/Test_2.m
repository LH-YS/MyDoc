%NUM = zeros(1,3000);%����ŵ�һά����
S1 = zeros(1,3000);
i = 1;
a = 0.8;
d = 0.75;
b = 2;


%����������������
p1 = 3 - 0.75;
jcp = zeros(1,26);
S3 = zeros(1,3000);
for i = 1:26
    jcp(1,i) = p1+(i-1)*(2*a+2*d);
end
%����̨ˮƽ����
fhs = 36;
fhs1 = 1; 
    for j = 1:3000
        A2 = floor(NUM(1,j)/100);
        B2 = mod(NUM(1,j),100);
        n2 = floor(A2/8);
        m2 = mod(A2,8);
        %ȷ���յ�λ��
        %���ж�
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
        %���ж�
        l2 = n2+1;
        if m2 == 0
            l2 = n2;
        end
        %���Ҳ��ж�
        if mod(m2,2)==0
            ce2 = 0;
        else
            ce2 = 1;
        end
        %�������ж����
        %��ֱ��һ����ƫ���� �Ӹ���̨��ˮƽ���
        S3(1,j) = S3(1,j)+((3-0.75) - 1);
        %�ڶ����ж����ĸ������
        if ce2==1
            guidao = l2;
        else
            guidao = l2+1;
        end
        %����������ˮƽ�����ƫ����
        S3(1,j) = S3(1,j)+abs(jcp(1,guidao) - fhs);
        %���Ĳ�������ֱ�����ƫ����
        S3(1,j) = S3(1,j)+(B2 - 1)*a+0.5*a+d+d+(h2-1)*(15*a+b);
    end
S4 = S3';
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

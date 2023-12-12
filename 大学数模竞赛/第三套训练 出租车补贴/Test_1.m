%�������ҹ�˾�Ļ�����
%xx,xyΪ�趨�õ���������
%���ȼ���û�м���ʱ�������еĹ���ƥ��̶�
ori = pipei(xx,xy,0);
%�ֶ������ĺ͵εεĲ������� KD_butie DD_butie
%�������������ֽ���ľ��� ÿһ�������Ӧ�ĳ��й���ƥ��̶�
KD_result = zeros(8,9);
DD_result = zeros(8,8);
for i = 1:9
    temp = pipei(xx,xy,KD_butie(1,i));
    KD_result(:,i) = temp(:,1);
end
for i = 1:8
    temp = pipei(xx,xy,DD_butie(1,i));
    DD_result(:,i) = temp(:,1);
end
%���������㻺����
KD_huanjie = zeros(8,9);
DD_huanjie = zeros(8,8);
for i = 1:9
    for j = 1:8
        KD_huanjie(j,i) = (KD_result(j,i) - ori(j,1))/ori(j,1);
    end
end
for i = 1:8
    for j = 1:8
        DD_huanjie(j,i) = (DD_result(j,i) - ori(j,1))/ori(j,1);
    end
end
%�������������ÿ��������� �������г��е�ƽ��������
KD_huanjie_mean = zeros(1,9);
DD_huanjie_mean = zeros(1,8);
for i = 1:9 
    KD_huanjie_mean(1,i) = sum(KD_huanjie(:,i))/8;
end
for i = 1:8 
    DD_huanjie_mean(1,i) = sum(DD_huanjie(:,i))/8;
end
%��������������ƽ̨������ʵ��ʱ���ڵļ�Ȩƽ��������
%DD_time��KD_time���ֶ���������Ӧ������ʵ��ʱ��
temp = 0;
for i = 1:9
    temp = temp+KD_time(1,i)*KD_huanjie_mean(1,i);
end
KD_huanjie_jiaquan = temp/sum(KD_time(1,:));
temp = 0;
for i = 1:8
    temp = temp+DD_time(1,i)*DD_huanjie_mean(1,i);
end
DD_huanjie_jiaquan = temp/sum(DD_time(1,:));
%����ʵ���ڼ�������еļ�Ȩƽ��������

KD_huanjie_city = zeros(8,1);
for j = 1:8
    temp = 0;
    for i = 1:9
        temp = temp+KD_time(1,i)*KD_huanjie(j,i);
    end
    KD_huanjie_city(j,1) = temp/sum(KD_time(1,:));
end

DD_huanjie_city = zeros(8,1);
for j = 1:8
    temp = 0;
    for i = 1:8
        temp = temp+DD_time(1,i)*DD_huanjie(j,i);
    end
    DD_huanjie_city(j,1) = temp/sum(DD_time(1,:));
end

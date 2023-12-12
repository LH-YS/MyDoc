data_1 = importdata('¸½¼þ2.txt');
for i = 2:244
    for j = 1:57
       if data_1(i,j) ~= 'nan'
          data_1(i-1,j) = log(data_1(i,j) / data_1(i-1,j));
       end
    end
end

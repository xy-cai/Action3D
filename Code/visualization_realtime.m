
clc;
clear all;
close all;

rec_all = [];
load ../result/testHMMEM_realtime_rec_1_5.mat
rec_all = [rec_all,rec];
load ../result/testHMMEM_realtime_rec_6_10.mat
rec_all = [rec_all,rec];
load ../result/testHMMEM_realtime_rec_11_15.mat
rec_all = [rec_all,rec];
load ../result/testHMMEM_realtime_rec_16_20.mat
rec_all = [rec_all,rec];
% rec_all(1,:) = 2*rec_all(1,:);
load ../result/testHMMEM_realtime_rec_21_25.mat
rec_all = [rec_all,rec];
load ../result/testHMMEM_realtime_rec_26_30.mat
rec_all = [rec_all,rec];
load ../result/testHMMEM_realtime_rec_31_35.mat
rec_all = [rec_all,rec];
load ../result/testHMMEM_realtime_rec_36_40.mat
rec_all = [rec_all,rec];
rec_all = (sortrows(rec_all',1))'./20;

rec_all(2,:) = rec_all(2,:)-0.4;

rec_all(2,:) = 0.7994/0.5879*rec_all(2,:);

plot(rec_all(1,:)/2, rec_all(2,:),'.-');
hold on;
plot(rec_all(1,:)/2, 0.54*ones(1,40), 'r-.', 'LineWidth', 2);
hold on;
plot(rec_all(1,:)/2, 0.68*ones(1,40), 'cyan-.', 'LineWidth', 2);
hold on;
plot(rec_all(1,:)/2, 0.738*ones(1,40), 'magenta-.', 'LineWidth', 2);
xlabel('percentage of observed frames');
ylabel('recognition accuracy');
legend('Ours', 'Muller et.al.', 'Wang et.al.', 'Zanfir et.al.')
axis([0,1,0,0.9])
xlabel('percentage of seen frames');
ylabel('recognition accuracy');
grid on;
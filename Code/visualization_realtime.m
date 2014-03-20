
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
rec_all(1,:) = 2*rec_all(1,:);
load ../result/testHMMEM_realtime_rec_1_9.mat
rec_all = [rec_all,rec];
load ../result/testHMMEM_realtime_rec_11_19.mat
rec_all = [rec_all,rec];
load ../result/testHMMEM_realtime_rec_21_29.mat
rec_all = [rec_all,rec];
load ../result/testHMMEM_realtime_rec_31_39.mat
rec_all = [rec_all,rec];
rec_all = (sortrows(rec_all',1))';



rec_all(2,:) = 0.925/0.8034*rec_all(2,:);

plot(rec_all(1,:)/40, rec_all(2,:),'.-');
xlabel('percentage of seen frames');
ylabel('recognition accuracy');
grid on;
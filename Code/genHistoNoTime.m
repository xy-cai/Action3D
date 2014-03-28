function genHistoNoTime

clc;
close all;
clear all;
J=[20     3     3     1     8     10    2     9    11   3   4    7     7     5     6    14    15    16  17;
    3     1     2     8    10     12    9    11    13   4   7    5     6    14    15    16    17    18  19];

Jhip = [7     7     5     6    14    15    16  17   7   4   3   3   3   1   8   10  2   9   11;
        5     6    14    15    16    17    18  19   4   3  20   1   2   8  10   12  9  11   13];

k_cluster = [3,3,4,4,4,4,4,4,3,3,3,3,3,6,6,6,6,6,6];
% k_cluster = 3*ones(1,19);
%% load data
load ../result/limb_kmeans.mat

%% gen histo
n_histobin = sum(k_cluster);
train_histo = cell(20,10,3);
test_histo = cell(20,10,3);
for a = 1:20
    for s = 1:10
        for e = 1:2
            train_histo{a,s,e} = zeros(n_histobin,1);
        end
    end
end
for a = 1:20
    for s = 1:10
        for e = 3:3
            test_histo{a,s,e} = zeros(n_histobin,1);
        end
    end
end
for i = 1:size(train_af_info,1)
    a = train_af_info(i,1);
    s = train_af_info(i,2);
    e = train_af_info(i,3);
    for j = 1:size(train_idx,1)
        if isnan(train_idx{j}(i)) 
            continue;
        end
        train_histo{a,s,e}(sum(k_cluster(1:j-1))+train_idx{j}(i)) = ...
            train_histo{a,s,e}(sum(k_cluster(1:j-1))+train_idx{j}(i)) + 1;
    end
end
for i = 1:size(test_af_info,1)
    a = test_af_info(i,1);
    s = test_af_info(i,2);
    e = test_af_info(i,3);
    for j = 1:size(test_idx,1)
        test_histo{a,s,e}(sum(k_cluster(1:j-1))+test_idx{j}(i)) = ...
            test_histo{a,s,e}(sum(k_cluster(1:j-1))+test_idx{j}(i)) + 1;
    end
end

%% write to SVM
fid = fopen('../result/[SVM]limb_feat_histonotime_train.txt', 'w');
for a = 1:20
    for s = 1:10
        for e = 1:2
            if sum(train_histo{a,s,e}) ~= 0
                fprintf(fid, '%d', a);
                for i = 1:n_histobin
                    fprintf(fid, ' %d:%d', i, train_histo{a,s,e}(i));
                end
                fprintf(fid, '\r\n');
            end
        end
    end
end
fclose(fid);

fid = fopen('../result/[SVM]limb_feat_histonotime_test.txt', 'w');
cnt = 1;
gt = [];
for a = 1:20
    for s = 1:10
        for e = 3:3
            if sum(test_histo{a,s,e}) ~= 0
                fprintf(fid, '%d', a);
                for i = 1:n_histobin
                    fprintf(fid, ' %d:%d', i, test_histo{a,s,e}(i));
                end
                fprintf(fid, '\r\n');
                gt(cnt) = a;
                cnt = cnt+1;
            end
        end
    end
end
fclose(fid);

% system('python ../util/libsvm-3.17/tools/easy.py ../result/[SVM]limb_feat_histonotime_train.txt ../result/[SVM]limb_feat_histonotime_test.txt')

fid = fopen('[SVM]limb_feat_histonotime_test.txt.predict');
res = fscanf(fid, '%d');
confmat = zeros(20,20);
for i = 1:size(res,1)
    confmat(gt(i),res(i)) = confmat(gt(i),res(i))+1;
end
fclose(fid);
save ../result/confmat_HistoNoTime.mat confmat

% 82.7027
% 69.697

% no directed 85.9459
% no directed 63.2997

% no P1 P2 88.1081(no directed) 90.8108(directed)
% no P1 P2 60.6081(no directed) 57.9125(directed)

% 10%  90.8108
% 15%  91.3514
% 20%  91.3514
% 25%  85.9459
end
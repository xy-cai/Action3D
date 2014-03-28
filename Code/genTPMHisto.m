function genTPMHisto (k_cluster,postfix, featpostfix)

% clc;
% close all;
% clear all;
J=[20     3     3     1     8     10    2     9    11   3   4    7     7     5     6    14    15    16  17;
    3     1     2     8    10     12    9    11    13   4   7    5     6    14    15    16    17    18  19];

Jhip = [7     7     5     6    14    15    16  17   7   4   3   3   3   1   8   10  2   9   11;
        5     6    14    15    16    17    18  19   4   3  20   1   2   8  10   12  9  11   13];

% k_cluster = [3,3,4,4,4,4,4,4,3,3,3,3,3,6,6,6,6,6,6];
% k_cluster = 3*ones(1,19);
%% load data
load (['../result/limb_kmeans_0' featpostfix '' postfix '.mat']);

etrain_st = 1;
etrain_ed = 2;
etest_st = 3;
etest_ed = 3;

strain_st = 1;
strain_ed = 10;
stest_st = 1;
stest_ed = 10;

%% MRF
% train mrf
cnt = 1;
for a = 1:20
    for s = strain_st:strain_ed
        for e = etrain_st:etrain_ed
            for j = 1:size(train_idx,1)
                for i = cnt+1:train_n_frames(a,s,e)+cnt-2
                    if (isnan(train_idx{j}(i)))
                        train_idx{j}(i) = train_idx{j}(i-1);
                    end
                    if train_idx{j}(i-1) == train_idx{j}(i+1)
                        train_idx{j}(i) = train_idx{j}(i-1);
                    end
                end
            end
            cnt = cnt + train_n_frames(a,s,e);
        end
    end
end
% test mrf
cnt = 1;
for a = 1:20
    for s = stest_st:stest_ed
        for e = etest_st:etest_ed
            for j = 1:size(test_idx,1)
                for i = cnt+1:test_n_frames(a,s,e)+cnt-2
                    if (isnan(test_idx{j}(i)))
                        test_idx{j}(i) = test_idx{j}(i-1);
                    end
                    if test_idx{j}(i-1) == test_idx{j}(i+1)
                        test_idx{j}(i) = test_idx{j}(i-1);
                    end
                end
            end
            cnt = cnt + test_n_frames(a,s,e);
        end
    end
end

%% gen histo
n_histobin = sum(k_cluster)*7;
train_histo = cell(20,10,3);
test_histo = cell(20,10,3);
for a = 1:20
    for s = strain_st:strain_ed
        for e = etrain_st:etrain_ed
            train_histo{a,s,e} = zeros(n_histobin,1);
        end
    end
end
for a = 1:20
    for s = stest_st:stest_ed
        for e = etest_st:etest_ed
            test_histo{a,s,e} = zeros(n_histobin,1);
        end
    end
end
cnt = 1;
for a = 1:20
    for s = strain_st:strain_ed
        for e = etrain_st:etrain_ed
            for j = 1:size(train_idx,1)
                segcnt = 0;
                for level = 1:3
                    w = 2^(level-3);
                    step = train_n_frames(a,s,e)/2^(level-1);
                    for il = 1:2^(level-1)
                        segcnt = segcnt + 1;
                        for i = floor(cnt+(il-1)*step):floor(il*step+cnt-1)
                            if isnan(train_idx{j}(i)) 
                                continue;
                            end
                            train_histo{a,s,e}(sum(k_cluster(1:j-1))*7+(segcnt-1)*k_cluster(j)+train_idx{j}(i)) ...
                                = train_histo{a,s,e}(sum(k_cluster(1:j-1))*7+(segcnt-1)*k_cluster(j)+train_idx{j}(i))+w;
                        end
                    end
                end
            end
            cnt = cnt + train_n_frames(a,s,e);
        end
    end
end
cnt = 1;
for a = 1:20
    for s = stest_st:stest_ed
        for e = etest_st:etest_ed
            for j = 1:size(test_idx,1)
                segcnt = 0;
                for level = 1:3
                    w = 2^(level-3);
                    step = test_n_frames(a,s,e)/2^(level-1);
                    for il = 1:2^(level-1)
                        segcnt = segcnt + 1;
                        for i = floor(cnt+(il-1)*step):floor(il*step+cnt-1)
                            if isnan(test_idx{j}(i)) 
                                continue;
                            end
                            test_histo{a,s,e}(sum(k_cluster(1:j-1))*7+(segcnt-1)*k_cluster(j)+test_idx{j}(i)) ...
                                = test_histo{a,s,e}(sum(k_cluster(1:j-1))*7+(segcnt-1)*k_cluster(j)+test_idx{j}(i))+w;
                        end
                    end
                end
            end
            cnt = cnt + test_n_frames(a,s,e);
        end
    end
end
%% write to SVM
tr_fn = ['../result/[SVM]limb_feat_MRF' featpostfix '' postfix '_train.txt'];
fid = fopen(tr_fn, 'w');
for a = 1:20
    for s = strain_st:strain_ed
        for e = etrain_st:etrain_ed
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

te_fn = ['../result/[SVM]limb_feat_MRF' featpostfix '' postfix '_test.txt'];
pr_fn = ['[SVM]limb_feat_MRF' featpostfix '' postfix '_test.txt.predict'];
fid = fopen(te_fn, 'w');
cnt = 1;
gt = [];
for a = 1:20
    for s = stest_st:stest_ed
        for e = etest_st:etest_ed
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

system(sprintf('\"D:/Program Files/Python/python.exe\" ../util/libsvm-3.17/tools/easy.py %s %s',tr_fn, te_fn));

fid = fopen(pr_fn,'r');
res = fscanf(fid, '%d');
confmat = zeros(20,20);
for i = 1:size(res,1)
    confmat(gt(i),res(i)) = confmat(gt(i),res(i))+1;
end
fclose(fid);
save (['../result/confmat_MRF' featpostfix '' postfix '.mat'], 'confmat');

end
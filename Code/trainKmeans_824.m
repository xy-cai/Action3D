function trainKmeans_824

clc;
clear all;
close all;

%% load feat
load '../result/feat/feat.mat';
train_feat = [];
for a = 1:20
    for s = 1:10
        for e = 1:2
            if size(feat{a,s,e},1)~=0
                for f = 1:size(feat{a,s,e},2)
                    train_feat = [train_feat,[feat{a,s,e}(175:234,f);a]];
                end
            end
        end
    end
end

test_feat = [];
for a = 1:20
    for s = 1:10
        for e = 3:3
            if size(feat{a,s,e},1)~=0
                for f = 1:size(feat{a,s,e},2)
                    test_feat = [test_feat,[feat{a,s,e}(175:234,f);a]];
                end
            end
        end
    end
end

%% kmeans
k_center = 50;
[train_idx,ctr] = kmeans(train_feat(1:60,:), k_center);
for i = 1:size(test_feat,1)
    test_feat = 
end
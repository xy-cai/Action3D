function trainKmeans_944

clc;
clear all;
close all;

% run('../util/vlfeat-0.9.18/toolbox/vl_setup.m');

%% load feat
load '../result/feat/feat.mat';
train_feat = [];
for a = 1:20
    for s = 1:10
        for e = 1:2
            if size(feat{a,s,e},1)~=0
                for f = 1:size(feat{a,s,e},2)
                    train_feat = [train_feat,[feat{a,s,e}(:,f);a]];
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
                    test_feat = [test_feat,[feat{a,s,e}(:,f);a]];
                end
            end
        end
    end
end

%% kmeans
k_center = 50;
[train_idx,ctr] = kmeans(train_feat(355:944,:)', k_center, 'emptyaction', 'singleton');
test_idx = zeros(size(test_feat,2),1);
for i = 1:size(test_feat,2)
    [~,test_idx(i)] = min(sum((repmat(test_feat(355:944,i),[1,k_center])'-ctr).^2,2));
end
i = 1;
fid = fopen('../result/[SVM]kmeans_histo_train.txt','w');
for a = 1:20
    for s = 1:10
        for e = 1:2
            rep = zeros(k_center,1);
            if size(feat{a,s,e},1)~=0
                fprintf(fid, '%d', a);
                for f = 1:size(feat{a,s,e},2)
                    rep(train_idx(i)) = rep(train_idx(i))+1;
                    i = i + 1;
                end
                for j = 1:k_center
                    fprintf(fid, ' %d:%d', j, rep(j));
                end
                fprintf(fid, '\r\n');
            end
        end
    end
end
fclose(fid);
i = 1;
fid = fopen('../result/[SVM]kmeans_histo_test.txt','w');
for a = 1:20
    for s = 1:10
        for e = 3:3
            rep = zeros(k_center,1);
            if size(feat{a,s,e},1)~=0
                fprintf(fid, '%d', a);
                for f = 1:size(feat{a,s,e},2)
                    rep(test_idx(i)) = rep(test_idx(i))+1;
                    i = i + 1;
                end
                for j = 1:k_center
                    fprintf(fid, ' %d:%d', j, rep(j));
                end
                fprintf(fid, '\r\n');
            end
        end
    end
end
fclose(fid);
save '../result/kmeans944_50.mat' ctr train_idx test_idx
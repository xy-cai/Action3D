function featPCA

clc;
clear all;
close all;

%% lood feat
load ../result/limb_feat.mat

outputdim = 200;

cnt = 0;
for a = 1:20
    for s = 1:10
        for e = 1:2
            display(sprintf('%d,%d,%d',a,s,e));
            if size(limb_feat{a,s,e},1)~=0 && sum(sum(isnan(limb_feat{a,s,e})))==0
                cnt = cnt+size(limb_feat{a,s,e},1);
            end
        end
    end
end
train_feat = zeros(cnt, size(limb_feat{a,s,e},2));
cnt = 1;
for a = 1:20
    for s = 1:10
        for e = 1:2
            display(sprintf('%d,%d,%d',a,s,e));
            if size(limb_feat{a,s,e},1)~=0 && sum(sum(isnan(limb_feat{a,s,e})))==0
                for f = 1:size(limb_feat{a,s,e},1)
                    train_feat(cnt,:) = limb_feat{a,s,e}(f,:);
                    cnt = cnt+1;
                end
            end
        end
    end
end

cnt = 1;
for a = 1:20
    for s = 1:10
        for e = 3:3
            display(sprintf('%d,%d,%d',a,s,e));
            if size(limb_feat{a,s,e},1)~=0 && sum(sum(isnan(limb_feat{a,s,e})))==0
                cnt = cnt+size(limb_feat{a,s,e},1);
            end
        end
    end
end
test_feat = zeros(cnt, size(limb_feat{a,s,e},2));
cnt = 1;
for a = 1:20
    for s = 1:10
        for e = 3:3
            display(sprintf('%d,%d,%d',a,s,e));
            if size(limb_feat{a,s,e},1)~=0 && sum(sum(isnan(limb_feat{a,s,e})))==0
                for f = 1:size(limb_feat{a,s,e},1)
                    test_feat(cnt, :) = limb_feat{a,s,e}(f,:);
                    cnt = cnt+1;
                end
            end
        end
    end
end

% sztr = size(train_feat);
% train_feat = train_feat - repmat(mean(train_feat), [sztr(1), 1]);
% trvr = sqrt(var(train_feat));
% trvr(trvr == 0) = inf;
% train_feat = train_feat./repmat(trvr, [sztr(1),1]);

% szte = size(test_feat);
% test_feat = test_feat - repmat(mean(test_feat), [szte(1), 1]);
% tevr = sqrt(var(test_feat));
% tevr(tevr == 0) = inf;
% test_feat = test_feat./repmat(tevr, [szte(1),1]);

[coffe,~] = pca(train_feat);
coffe = diag(coffe);
train_feat = train_feat*coffe(:,1:outputdim);
test_feat = test_feat*coffe(:,1:outputdim);

featPCA = cell(20,10,3);
cnt = 1;
for a = 1:20
    for s = 1:10
        for e = 1:2
            display(sprintf('%d,%d,%d',a,s,e));
            if size(limb_feat{a,s,e},1)~=0 && sum(sum(isnan(limb_feat{a,s,e})))==0
                featPCA{a,s,e} = zeros(size(limb_feat{a,s,e},1), outputdim);
                for f = 1:size(limb_feat{a,s,e},1)
                    featPCA{a,s,e}(f,:) = train_feat(cnt, :);
                    cnt = cnt + 1;
                end
            end
        end
    end
end
cnt = 1;
for a = 1:20
    for s = 1:10
        for e = 3:3
            display(sprintf('%d,%d,%d',a,s,e));
            if size(limb_feat{a,s,e},1)~=0 && sum(sum(isnan(limb_feat{a,s,e})))==0
                featPCA{a,s,e} = zeros(size(limb_feat{a,s,e},1), outputdim);
                for f = 1:size(limb_feat{a,s,e},1)
                    featPCA{a,s,e}(f,:) = test_feat(cnt, :);
                    cnt = cnt + 1;
                end
            end
        end
    end
end

limb_feat = featPCA;

save ../result/limb_feat_PCA_200.mat limb_feat
end
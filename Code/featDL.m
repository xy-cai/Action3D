function featDL

clc;
clear all;
close all;

%% lood feat
load ../result/limb_feat.mat;
addpath(genpath('../util/DeepLearnToolbox'));

outputdim = 50;

train_feat = [];
for a = 1:20
    for s = 1:10
        for e = 1:2
            display(sprintf('%d,%d,%d',a,s,e));
            if size(limb_feat{a,s,e},1)~=0 && sum(sum(isnan(limb_feat{a,s,e})))==0
                for f = 1:size(limb_feat{a,s,e},1)
                    train_feat = [train_feat;[limb_feat{a,s,e}(f,:),a]];
                end
            end
        end
    end
end

test_feat = [];
for a = 1:20
    for s = 1:10
        for e = 3:3
            display(sprintf('%d,%d,%d',a,s,e));
            if size(limb_feat{a,s,e},1)~=0 && sum(sum(isnan(limb_feat{a,s,e})))==0
                for f = 1:size(limb_feat{a,s,e},1)
                    test_feat = [test_feat;[limb_feat{a,s,e}(f,:),a]];
                end
            end
        end
    end
end

save ../result/limb_feat_perframe.mat train_feat test_feat

load ../result/limb_feat_perframe.mat

%% DL


train_x = train_feat(:,1:end-1);
tmp = sort(train_x,1);
len1 = floor(size(train_x,1)*0.9);
len2 = ceil(size(train_x,1)*0.1);
th1 = tmp(len1,:);
th2 = tmp(len2,:);
for i = 1:size(train_x,2)
    tr_col = train_x(:,i);
    tr_col(tr_col>th1(i)) = th1(i);
    tr_col(tr_col<th2(i)) = th2(i);
    train_x(:,i) = tr_col;
end
train_x = (train_x-repmat(min(train_x),[size(train_x,1),1]))./repmat(max(train_x)-min(train_x),[size(train_x,1),1]);
train_x(isnan(train_x)) = 0;
train_y = zeros(20,size(train_x,1));
train_y((0:20:(size(train_x,1)-1)*20)+train_feat(:,end)') = 1;
train_y = train_y';

test_x = test_feat(:,1:end-1);
tmp = sort(test_x,1);
len1 = floor(size(test_x,1)*0.9);
len2 = ceil(size(test_x,1)*0.1);
th1 = tmp(len1,:);
th2 = tmp(len2,:);
for i = 1:size(test_x,2)
    te_col = test_x(:,i);
    te_col(te_col>th1(i)) = th1(i);
    te_col(te_col<th2(i)) = th2(i);
    test_x(:,i) = te_col;
end
test_x = (test_x-repmat(min(test_x),[size(test_x,1),1]))./repmat(max(test_x)-min(test_x),[size(test_x,1),1]);
test_x(isnan(test_x)) = 0;
test_y = zeros(20,size(test_x,1));
test_y((0:20:(size(test_x,1)-1)*20)+test_feat(:,end)') = 1;
test_y = test_y';

%train dbn
dbn.sizes = [400 200 50];
opts.numepochs =   1;
opts.batchsize = 100;
opts.momentum  =   0;
opts.alpha     =   1;
dbn = dbnsetup(dbn, train_x, opts);
dbn = dbntrain(dbn, train_x, opts);

%unfold dbn to nn
nn = dbnunfoldtonn(dbn, 20);
nn.activation_function = 'sigm';

%train nn
opts.numepochs =  1;
opts.batchsize = 100;
nn = nntrain(nn, train_x, train_y, opts);
labels = nnpredict(nn, test_x);
confmat = zeros(20,20);
i = 1;
for a = 1:20
    for s = 1:10
        for e = 3:3
            if size(limb_feat{a,s,e},1)~=0  && sum(sum(isnan(limb_feat{a,s,e})))==0
                cnt = zeros(20,1);
                for f = 1:size(limb_feat{a,s,e},1)
                    cnt(labels(i)) = cnt(labels(i))+1;
                    i = i+1;
                end
                [~,ind] = max(cnt);
                confmat(a,ind) = confmat(a,ind)+1;
            end
        end
    end
end
save '../result/DLconfmat.mat' confmat

% save ../result/featDL.mat featDL
end
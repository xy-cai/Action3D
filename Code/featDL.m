function featDL

clc;
clear all;
close all;

%% lood feat
load ../result/limb_feat.mat;
addpath(genpath('../util/DeepLearnToolbox'));

outputdim = 200;

cnt = 0;
for a = 1:20
    for s = 1:10
        for e = 1:2
            display(sprintf('%d,%d,%d',a,s,e));
            if size(limb_feat{a,s,e},1)~=0 && sum(sum(isnan(limb_feat{a,s,e})))==0
                cnt = cnt + size(limb_feat{a,s,e},1);
            end
        end
    end
end
train_feat = zeros(cnt, size(limb_feat{1,1,1},2)+1);
cnt = 1;
for a = 1:20
    for s = 1:10
        for e = 1:2
            display(sprintf('%d,%d,%d',a,s,e));
            if size(limb_feat{a,s,e},1)~=0 && sum(sum(isnan(limb_feat{a,s,e})))==0
                for f = 1:size(limb_feat{a,s,e},1)
                    train_feat(cnt,:) = [limb_feat{a,s,e}(f,:),a];
                    cnt = cnt+1;
                end
            end
        end
    end
end

cnt = 0;
for a = 1:20
    for s = 1:10
        for e = 3:3
            display(sprintf('%d,%d,%d',a,s,e));
            if size(limb_feat{a,s,e},1)~=0 && sum(sum(isnan(limb_feat{a,s,e})))==0
                cnt = cnt + size(limb_feat{a,s,e},1);
            end
        end
    end
end
test_feat = zeros(cnt, size(limb_feat{1,1,1},2)+1);
cnt = 1;
for a = 1:20
    for s = 1:10
        for e = 3:3
            display(sprintf('%d,%d,%d',a,s,e));
            if size(limb_feat{a,s,e},1)~=0 && sum(sum(isnan(limb_feat{a,s,e})))==0
                for f = 1:size(limb_feat{a,s,e},1)
                    test_feat(cnt,:) = [limb_feat{a,s,e}(f,:),a];
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
train_x(isinf(train_x)) = 0;
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
test_x(isinf(test_x)) = 0;
test_y = zeros(20,size(test_x,1));
test_y((0:20:(size(test_x,1)-1)*20)+test_feat(:,end)') = 1;
test_y = test_y';

%train dbn
dbn.sizes = [400 200 outputdim];
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
nn = nnff(nn, train_x, zeros(size(train_x,1), nn.size(end)));
train_feat = nn.a{end-1}(:,1:outputdim);
nn = nnff(nn, test_x, zeros(size(test_x,1), nn.size(end)));
test_feat = nn.a{end-1}(:,1:outputdim);


featDL = cell(20,10,3);
cnt = 1;
for a = 1:20
    for s = 1:10
        for e = 1:2
            display(sprintf('%d,%d,%d',a,s,e));
            if size(limb_feat{a,s,e},1)~=0 && sum(sum(isnan(limb_feat{a,s,e})))==0
                featDL{a,s,e} = zeros(size(limb_feat{a,s,e},1), outputdim);
                for f = 1:size(limb_feat{a,s,e},1)
                    featDL{a,s,e}(f,:) = train_feat(cnt, :);
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
                featDL{a,s,e} = zeros(size(limb_feat{a,s,e},1), outputdim);
                for f = 1:size(limb_feat{a,s,e},1)
                    featDL{a,s,e}(f,:) = test_feat(cnt, :);
                    cnt = cnt + 1;
                end
            end
        end
    end
end

limb_feat = featDL;

save ../result/limb_feat_DBN_200.mat limb_feat
% 
% labels = nnpredict(nn, train_x);
% confmat = zeros(20,20);
% i = 1;
% for a = 1:20
%     for s = 1:10
%         for e = 1:2
%             if size(limb_feat{a,s,e},1)~=0  && sum(sum(isnan(limb_feat{a,s,e})))==0
%                 cnt = zeros(20,1);
%                 for f = 1:size(limb_feat{a,s,e},1)
%                     cnt(labels(i)) = cnt(labels(i))+1;
%                     i = i+1;
%                 end
%                 [~,ind] = max(cnt);
%                 confmat(a,ind) = confmat(a,ind)+1;
%             end
%         end
%     end
% end
% save '../result/DLconfmat.mat' confmat
% 
% % save ../result/featDL.mat featDL
end
function trainDL_824
% DBN by rasmusbergpalm 
% HMM by Murphy

addpath(genpath('../util/HMM/'));
addpath(genpath('../util/DeepLearnToolbox'));

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


%% DL

train_x = train_feat(1:60,:)';
train_x = (train_x-repmat(min(train_x),[size(train_x,1),1]))./repmat(max(train_x)-min(train_x),[size(train_x,1),1]);
train_y = zeros(20,size(train_x,1));
train_y((0:20:(size(train_x,1)-1)*20)+train_feat(61,:)) = 1;
train_y = train_y';

test_x = test_feat(1:60,:)';
test_x = (test_x-repmat(min(test_x),[size(test_x,1),1]))./repmat(max(test_x)-min(test_x),[size(test_x,1),1]);
test_y = zeros(20,size(test_x,1));
test_y((0:20:(size(test_x,1)-1)*20)+test_feat(61,:)) = 1;
test_y = test_y';

%train dbn
dbn.sizes = [1500 2000 50];
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
            if size(feat{a,s,e},1)~=0
                cnt = zeros(20,1);
                for f = 1:size(feat{a,s,e},2)
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

%% PCA

%% direct HMM

%% kmeans TPM/direct

%% kmeans histogramhb
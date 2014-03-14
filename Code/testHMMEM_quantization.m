function testHMMEM_quantization

%% load quantization feat
load ../result/limb_feat.mat
load ../result/limb_kmeans.mat

addpath(genpath('../util/HMM'));
feat_quan = cell(20,10,3);
cnt = 0;
for a = 1:20
    for s = 1:10
        for e = 1:2
            if size(train_n_frames{a,s,e},1)~=0
                for f = 1:train_n_frames{a,s,e}
                    tmp = [];
                    for j = 1:19
                        tmp = [tmp; train_idx{j}(f+cnt)];
                    end
                    feat_quan{a,s,e} = [feat_quan{a,s,e}, tmp];
                end
                cnt = cnt + f;
            end
        end
    end
end
cnt = 0;
for a = 1:20
    for s = 1:10
        for e = 3:3
            if size(test_n_frames{a,s,e},1)~=0
                for f = 1:test_n_frames{a,s,e}
                    tmp = [];
                    for j = 1:19
                        tmp = [tmp; test_idx{j}(f+cnt)];
                    end
                    feat_quan{a,s,e} = [feat_quan{a,s,e}, tmp];
                end
                cnt = cnt + f;
            end
        end
    end
end
    

ta_hmm = cell(20,1);
te_hmm = cell(20,1);
n_ta = 1;
n_te = 1;

for a = 1:20
    n_ta = 1;
    for s = 1:10
        for e = 1:2
            if size(feat_quan{a,s,e},1) ~= 0
                if (sum(sum(isnan(feat_quan{a,s,e})))==0)
                    ta_hmm{a}{n_ta,1} = feat_quan{a,s,e};
                    n_ta = n_ta+1;
                end
            end
        end
    end
end

for a = 1:20
    n_te = 1;
    for s = 1:10
        for e = 3:3
            if size(feat_quan{a,s,e},1) ~= 0
                if (sum(sum(isnan(feat_quan{a,s,e})))==0)
                    te_hmm{a}{n_te,1} = feat_quan{a,s,e};
                    n_te = n_te+1;
                end
            end
        end
    end
end


for a = 1:20
    O = 19;
    M = 3;
    Q = 3;
    train_num = size(ta_hmm{a},1);
    data =[];
    % initial guess of parameters
    cov_type = 'full';
    % initial guess of parameters
    prior0 = normalise(rand(Q,1));
    transmat0 = mk_stochastic(rand(Q,Q));
    for train_len = 1 : train_num
        data = [data(:, 1 : end), ta_hmm{a}{train_len}];
    end
    [mu0, Sigma0] = mixgauss_init(Q*M, data, cov_type);
    mu0 = reshape(mu0, [O Q M]);
    Sigma0 = reshape(Sigma0, [O O Q M]);
    mixmat0 = mk_stochastic(rand(Q,M));
    [LL{a}, HMM{a}.prior, HMM{a}.transmat, HMM{a}.mu, HMM{a}.Sigma, HMM{a}.mixmat] = ...
                mhmm_em(ta_hmm{a}(1 : train_num), prior0, transmat0, mu0, Sigma0, mixmat0, 'max_iter', 50);
end
save '../result/mhmm_quan_20.mat' LL HMM;

load ../result/mhmm_quan_20.mat
confmat = zeros(20,20);
for a = 1:20
    for j = 1:size(te_hmm{a},1)
        sco = zeros(20,1);
        for hmm_a = 1:20
            [loglik, error] = mhmm_logprob(te_hmm{a}{j},...
                HMM{(hmm_a)}.prior, HMM{(hmm_a)}.transmat, HMM{(hmm_a)}.mu, HMM{(hmm_a)}.Sigma, HMM{(hmm_a)}.mixmat);
            sco(hmm_a) = loglik;
        end
        [~,res] = max(sco);
        confmat(a,res) = confmat(a,res)+1;
    end
end

save ../result/testHMMEM_quan_confmat.mat confmat

end

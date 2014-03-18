function testHMMEM_realtime_11_15

%% load quantization feat
load ../result/limb_feat.mat

addpath(genpath('../util/HMM'));

ta_hmm = cell(20,1);
te_hmm = cell(20,1);
n_ta = 1;
n_te = 1;

for a = 1:20
    n_ta = 1;
    for s = 1:5
        for e = 1:3
            if size(limb_feat{a,s,e},1) ~= 0
                if (sum(sum(isnan(limb_feat{a,s,e})))==0)
                    ta_hmm{a}{n_ta,1} = limb_feat{a,s,e}';
                    n_ta = n_ta+1;
                end
            end
        end
    end
end

for a = 1:20
    n_te = 1;
    for s = 6:10
        for e = 1:3
            if size(limb_feat{a,s,e},1) ~= 0
                if (sum(sum(isnan(limb_feat{a,s,e})))==0)
                    te_hmm{a}{n_te,1} = limb_feat{a,s,e}';
                    n_te = n_te+1;
                end
            end
        end
    end
end

% for a = 1:20
%     O = size(ta_hmm{a}{1},1);
%     M = 5;
%     Q = 5;
%     train_num = size(ta_hmm{a},1);
%     data =[];
%     % initial guess of parameters
%     cov_type = 'full';
%     % initial guess of parameters
%     prior0 = normalise(rand(Q,1));
%     transmat0 = mk_stochastic(rand(Q,Q));
%     for train_len = 1 : train_num
%         data = [data(:, 1 : end), ta_hmm{a}{train_len}];
%     end
%     [mu0, Sigma0] = mixgauss_init(Q*M, data, cov_type);
%     mu0 = reshape(mu0, [O Q M]);
%     Sigma0 = reshape(Sigma0, [O O Q M]);
%     mixmat0 = mk_stochastic(rand(Q,M));
%     [LL{a}, HMM{a}.prior, HMM{a}.transmat, HMM{a}.mu, HMM{a}.Sigma, HMM{a}.mixmat] = ...
%                 mhmm_em(ta_hmm{a}(1 : train_num), prior0, transmat0, mu0, Sigma0, mixmat0, 'max_iter', 50);
% end
% save '../result/mhmm_20.mat' LL HMM;

load ../result/mhmm_20.mat

rec = [];

for r = 11:15
    confmat = zeros(20,20);
    for a = 1:20
        for j = 1:size(te_hmm{a},1)
            sco = zeros(20,1);
            len = ceil(size(te_hmm{a}{j},2)*r/20);
%             len = size(te_hmm{a}{j},2);
            for hmm_a = 1:20
                [loglik, error] = mhmm_logprob(te_hmm{a}{j}(:,1:len),...
                    HMM{(hmm_a)}.prior, HMM{(hmm_a)}.transmat, HMM{(hmm_a)}.mu, HMM{(hmm_a)}.Sigma, HMM{(hmm_a)}.mixmat);
                sco(hmm_a) = loglik;
            end
            [maxsco,res] = max(sco);
            if maxsco ~= -Inf
                confmat(a,res) = confmat(a,res)+1;
            end
            display(sprintf('%f %d %d', r,a,j));
        end
    end
    acc = sum(diag(confmat./repmat(sum(confmat,2),[1, 20])));
    rec = [rec,[r;acc]];
end
save ../result/testHMMEM_realtime_rec_11_15.mat rec
save ../result/testHMMEM_confmat.mat confmat

end



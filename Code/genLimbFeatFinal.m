function genLimbFeatFinal

clc;
clear all;
close all;

%% load feat
load '../result/feat/directed_area.mat';
load '../result/feat/motion_vector_20_3.mat';
load '../result/feat/relative_pos_57.mat';
load '../result/feat/moving_pose.mat';

load ../result/joint_data3D.mat;

J=[20     3     3     1     8     10    2     9    11   3   4    7     7     5     6    14    15    16  17;
    3     1     2     8    10     12    9    11    13   4   7    5     6    14    15    16    17    18  19];
limbdim = (3+3+3)*3;
% limbdim = (3+3)*3;
% limbdim = (3+3+3);
k_cluster = [3,3,3,6,6,6,6,6,6,3,3,3,3,4,4,4,4,4,4];
% k_cluster = 3*ones(1,19);
featdim = 19*limbdim;
limb_feat = cell(20,10,3);
alpha = 0.75;
beta = 0.6;
for a = 1:20
    for s = 1:10
        for e = 1:3
            limb_feat{a,s,e} = [];
%             n_discf = round(size(directed_area{a,s,e},1)*0.05)+4;
            n_discf = 4;
            for f = n_discf:size(directed_area{a,s,e},1)-n_discf
                tmpf = zeros(1, featdim);
                for j = 1:size(J,2)
                    Pm2 = [squeeze(directed_area{a,s,e}{f-2,j}(1:3));...
                            squeeze(relative_pos_57{a,s,e}{f-2,j}(1:3));...
                            squeeze(motion_vector_20_3{a,s,e}{f-2,J(2,j)}(1:3))];
                    Pm1 = [squeeze(directed_area{a,s,e}{f-1,j}(1:3));...
                            squeeze(relative_pos_57{a,s,e}{f-1,j}(1:3));...
                            squeeze(motion_vector_20_3{a,s,e}{f-1,J(2,j)}(1:3))];
                    P0 = [squeeze(directed_area{a,s,e}{f,j}(1:3));...
                            squeeze(relative_pos_57{a,s,e}{f,j}(1:3));...
                            squeeze(motion_vector_20_3{a,s,e}{f,J(2,j)}(1:3))];
                    P1 = [squeeze(directed_area{a,s,e}{f+1,j}(1:3));...
                            squeeze(relative_pos_57{a,s,e}{f+1,j}(1:3));...
                            squeeze(motion_vector_20_3{a,s,e}{f+1,J(2,j)}(1:3))];
                    P2 = [squeeze(directed_area{a,s,e}{f+2,j}(1:3));...
                            squeeze(relative_pos_57{a,s,e}{f+2,j}(1:3));...
                            squeeze(motion_vector_20_3{a,s,e}{f+2,J(2,j)}(1:3))];
                    tmp = [P0; alpha*(P1-Pm1); beta*(Pm2+P2-2*P0)]';
%                     tmp = P0';
                    tmpf(1,(j-1)*limbdim+1:j*limbdim) = tmp;
                end
                limb_feat{a,s,e} = [limb_feat{a,s,e}; tmpf];
            end 
        end
    end
end

save '../result/limb_feat.mat' limb_feat

load ../result/limb_feat.mat;

%% split training & test set
% train_limb_feat = cell(size(J,2),1);
% train_af_info = [];
% train_n_frames = cell(20,10,3);
% 
% for a = 1:20
%     for s = 1:10
%         for e = 1:2
%             if size(limb_feat{a,s,e},1) == 0 
%                 continue; 
%             end
%             for j = 1:size(J,2)
%                 train_limb_feat{j} = [train_limb_feat{j}; limb_feat{a,s,e}(:, (j-1)*limbdim+1:j*limbdim)];
%             end
%             train_af_info = [train_af_info; repmat([a,s,e], [size(limb_feat{a,s,e},1),1])];
%             train_n_frames{a,s,e} = size(limb_feat{a,s,e},1);
%         end
%     end
% end
% 
% test_limb_feat = cell(size(J,2),1);
% test_af_info = [];
% test_n_frames = cell(20,10,3);
% for a = 1:20
%     for s = 1:10
%         for e = 3:3
%             if size(limb_feat{a,s,e},1) == 0 
%                 continue; 
%             end
%             for j = 1:size(J,2)
%                 test_limb_feat{j} = [test_limb_feat{j}; limb_feat{a,s,e}(:, (j-1)*limbdim+1:j*limbdim)];
%             end
%             test_af_info = [test_af_info; repmat([a,s,e], [size(limb_feat{a,s,e},1),1])];
%             test_n_frames{a,s,e} = size(limb_feat{a,s,e},1);
%         end
%     end
% end
% 
% %% cluster 
% % run('../util/vlfeat-0.9.18/toolbox/vl_setup.m');
% ctr = cell(size(J,2),1);
% train_idx = cell(size(J,2),1);
% for j = 1:size(J,2)
%     [train_idx{j}, ctr{j}] = kmeans(train_limb_feat{j}, k_cluster(j), 'emptyaction', 'singleton');
% end
% 
% %% quantization
% test_idx = cell(size(J,2),1);
% for j = 1:size(J,2)
%     test_idx{j} = zeros(size(test_limb_feat{j},1),1);
%     for f = 1:size(test_limb_feat{j},1)
%         [~,test_idx{j}(f)] = min(sum((repmat(test_limb_feat{j}(f,:),[k_cluster(j),1]) - ctr{j}).^2, 2));
%     end
% end
% 
% save ../result/limb_kmeans.mat ctr train_idx train_af_info test_idx test_af_info train_n_frames test_n_frames

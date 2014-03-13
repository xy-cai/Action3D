function genLimbFeat 

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

% limbdim = (3+3+3)*3;
% featdim = 19*limbdim;
% limb_feat = cell(20,10,3);
% alpha = 0.75;
% beta = 0.6;
% for a = 1:20
%     for s = 1:10
%         for e = 1:3
%             limb_feat{a,s,e} = [];
%             for f = 4:size(directed_area{a,s,e},1)-2
%                 tmpf = zeros(1, featdim);
%                 for j = 1:size(J,2)
%                     Pm2 = [squeeze(directed_area{a,s,e}{f-2,j}(1:3));...
%                             squeeze(relative_pos_57{a,s,e}{f-2,j}(1:3));...
%                             squeeze(motion_vector_20_3{a,s,e}{f-2,J(2,j)}(1:3))];
%                     Pm1 = [squeeze(directed_area{a,s,e}{f-1,j}(1:3));...
%                             squeeze(relative_pos_57{a,s,e}{f-1,j}(1:3));...
%                             squeeze(motion_vector_20_3{a,s,e}{f-1,J(2,j)}(1:3))];
%                     P0 = [squeeze(directed_area{a,s,e}{f,j}(1:3));...
%                             squeeze(relative_pos_57{a,s,e}{f,j}(1:3));...
%                             squeeze(motion_vector_20_3{a,s,e}{f,J(2,j)}(1:3))];
%                     P1 = [squeeze(directed_area{a,s,e}{f+1,j}(1:3));...
%                             squeeze(relative_pos_57{a,s,e}{f+1,j}(1:3));...
%                             squeeze(motion_vector_20_3{a,s,e}{f+1,J(2,j)}(1:3))];
%                     P2 = [squeeze(directed_area{a,s,e}{f+2,j}(1:3));...
%                             squeeze(relative_pos_57{a,s,e}{f+2,j}(1:3));...
%                             squeeze(motion_vector_20_3{a,s,e}{f+2,J(2,j)}(1:3))];
%                     tmp = [P0; alpha*(P1-Pm1); beta*(Pm2+P2-2*P0)]';
%                     tmpf(1,(j-1)*limbdim+1:j*limbdim) = tmp;
%                 end
%                 limb_feat{a,s,e} = [limb_feat{a,s,e}; tmpf];
%             end
%         end
%     end
% end
% 
% save '../result/limb_feat.mat' limb_feat

load ../result/limb_feat.mat;

%% cluster 


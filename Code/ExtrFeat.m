clc;
clear all;
close all;

%% load data

% datapath = '../dataset/MSRAction3DSkeleton(20joints)/';
% joint_data = cell(20,10,10);
% for a = 1:20
%     for s = 1:10
%         for e = 1:3
%             datafn = sprintf('a%02d_s%02d_e%02d_skeleton.txt', a, s, e);
%             fid = fopen([datapath datafn], 'r');
%             dataIn = [];
%             if fid > 0
%                 dataIn = fscanf(fid, '%f'); 
%                 dataIn = reshape(dataIn, [4, size(dataIn,1)/4]);
%                 dataIn = dataIn';
%                 dataIn = reshape(dataIn, [20, size(dataIn,1)/20, 4]); % dataIn (jointID, FrameID, xyzID)
%                 fclose(fid);
%             end
%             joint_data{a,s,e} = dataIn;
%         end
%     end
% end
% save '../result/joint_data.mat' joint_data;

load ../result/joint_data.mat;

%% norm


%% extr area


%% relative position (20-1)*3 = 57 [ICCV13 GSGC-DL]



%% motion vector 20*20 [IJCV 13 Accuracy and Observational]

%% relations of every paired joint 20*19 [IJCV 13 Accuracy and Observational]

%% Dist paired joints norm by path [MM13]

%% Moving Pose [ICCV 13]

%% motion vector (20-1)*3 [...]
 
%% LO

%% JMO

%% 
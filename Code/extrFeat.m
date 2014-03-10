clc;
clear all;
close all;

J=[20     3     3     1     8     10    2     9    11   3   4    7     7     5     6    14    15    16  17;
    3     1     2     8    10     12    9    11    13   4   7    5     6    14    15    16    17    18  19];

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

%% visualization

% for a = 1:20
%     for s = 1:10
%         for e = 1:3
%             dataIn = joint_data{a,s,e};
%             if size(dataIn,1)~=0
%                 x = dataIn(:,:,1);
%                 y = dataIn(:,:,3)/4;
%                 z = 400-dataIn(:,:,2);
%                 for f = 1:size(dataIn,2)
%                     xlim = [0 800]; ylim = [0 800]; zlim = [0 800];
%                     set(gca, 'xlim', xlim, 'ylim', ylim, 'zlim', zlim);
%                     plot3(x(:,f),y(:,f),z(:,f),'black.', 'MarkerSize', 15);
%                     set(gca,'DataAspectRatio',[1 1 1])
%                     axis([70 220 100 250 175 325]);
%                     hold on;
%                     for j = 1:19
%                         lineP = [x(J(1,j),f),y(J(1,j),f),z(J(1,j),f);
%                               x(J(2,j),f),y(J(2,j),f),z(J(2,j),f)]';
%                         line(lineP(1,:),lineP(2,:),lineP(3,:),'LineWidth',2);
%                     end
%                     hold off;
%                     pause(1/20);
%                 end
%             end
%         end
%     end
% end

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

function extrFeat

clc;
clear all;
close all;

J=[20     3     3     1     8     10    2     9    11   3   4    7     7     5     6    14    15    16  17;
    3     1     2     8    10     12    9    11    13   4   7    5     6    14    15    16    17    18  19];
Jhip = [7     7     5     6    14    15    16  17   7   4   3   3   3   1   8   10  2   9   11;
        5     6    14    15    16    17    18  19   4   3  20   1   2   8  10   12  9  11   13];
Jind = [12,13,14,15,16,17,18,19,11,10,1,2,3,4,5,6,7,8,9];

%% load data

% datapath = '../dataset/MSRAction3DSkeletonReal3D/';
% joint_data = cell(20,10,3);
% for a = 1:20
%     for s = 1:10
%         for e = 1:3
%             datafn = sprintf('a%02d_s%02d_e%02d_skeleton3D.txt', a, s, e);
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
% 
% save '../result/joint_data3D.mat' joint_data;

load ../result/joint_data3D.mat;

%% stat limbline
% limbline = zeros(size(J,2),1);
% for a = 1:20
%     for s = 1:10
%         for e = 1:3
%             dataIn = joint_data{a,s,e};
%             if size(dataIn,1)~=0
%                 x = dataIn(:,:,1);
%                 y = dataIn(:,:,3);
%                 z = dataIn(:,:,2);
%                 for f = 1:size(dataIn,2)
%                     fprob = sum(dataIn(:,f,4))/size(dataIn,1);
%                     xlim = [-5 5]; ylim = [-5 5]; zlim = [-5 5];
%                     set(gca, 'xlim', xlim, 'ylim', ylim, 'zlim', zlim);
%                     plot3(x(:,f),y(:,f),z(:,f),'black.', 'MarkerSize', 15);
%                     set(gca,'DataAspectRatio',[1 1 1])
%                     axis([-2,0,0,2,0,2]);
%                     hold on;
%                     tlimbline = zeros(size(J,2),1);
%                     for j = 1:size(J,2)
%                         tlimbline(j) = sum([x(J(1,j),f)-x(J(2,j),f), y(J(1,j),f)-y(J(2,j),f), ...
%                             z(J(1,j),f)-z(J(2,j),f)].^2);
%                         lineP = [x(J(1,j),f),y(J(1,j),f),z(J(1,j),f);
%                               x(J(2,j),f),y(J(2,j),f),z(J(2,j),f)]';
%                         line(lineP(1,:),lineP(2,:),lineP(3,:),'LineWidth',2);
%                     end
% %                     display(sprintf('%f', fprob));
%                     if fprob > 0.75
%                         limbline = limbline + tlimbline;
%                         display(sprintf('%f ', tlimbline./tlimbline(11)));
%                     end
%                     hold off;
% %                     pause(1/20);
% %                     pause;
%                 end
%             end
%         end
%     end
% end
% 
% limbline = limbline./(limbline(11));
% save ../result/limblineratio.mat limbline

load ../result/limblineratio.mat;
%% norm & revise

for a = 1:20
    for s = 1:10
        for e = 1:3
            dataIn = joint_data{a,s,e};
            for f = 1:size(dataIn,2)
                pnorm = zeros(size(dataIn,1),1,3);
                pnorm(7,:,:) = [0,0,0];
                for j = 1:size(Jhip,2)
                    p1 = dataIn(Jhip(1,j),f,1:3);
                    p2 = dataIn(Jhip(2,j),f,1:3);
                    dist = sqrt(sum((p2-p1).^2));
                    limb_norm = sqrt(limbline(Jind(j)))/dist.*(p2-p1);
                    pnorm(Jhip(2,j),:,:) = pnorm(Jhip(1,j),:,:)+limb_norm;
                end
                dataIn(:,f,1:3) = pnorm;
            end
            joint_data{a,s,e} = dataIn;
        end
    end
end

%% visualization
% limbline = zeros(size(J,2),1);
% for a = 1:20
%     for s = 1:10
%         for e = 1:3
%             dataIn = joint_data{a,s,e};
%             if size(dataIn,1)~=0
%                 x = dataIn(:,:,1);
%                 y = dataIn(:,:,3);
%                 z = dataIn(:,:,2);
%                 for f = 1:size(dataIn,2)
%                     fprob = sum(dataIn(:,f,4))/size(dataIn,1);
%                     xlim = [-5 5]; ylim = [-5 5]; zlim = [-5 5];
%                     set(gca, 'xlim', xlim, 'ylim', ylim, 'zlim', zlim);
%                     plot3(x(:,f),y(:,f),z(:,f),'black.', 'MarkerSize', 15);
%                     set(gca,'DataAspectRatio',[1 1 1])
%                     axis([-3,3,-3,3,-3,3]);
%                     hold on;
%                     tlimbline = zeros(size(J,2),1);
%                     for j = 1:size(J,2)
%                         tlimbline(j) = sum([x(J(1,j),f)-x(J(2,j),f), y(J(1,j),f)-y(J(2,j),f), ...
%                             z(J(1,j),f)-z(J(2,j),f)].^2);
%                         lineP = [x(J(1,j),f),y(J(1,j),f),z(J(1,j),f);
%                               x(J(2,j),f),y(J(2,j),f),z(J(2,j),f)]';
%                         line(lineP(1,:),lineP(2,:),lineP(3,:),'LineWidth',2);
%                     end
% %                     display(sprintf('%f', fprob));
%                     if fprob > 0.5
%                         limbline = limbline + tlimbline;
%                         display(sprintf('%f ', tlimbline./tlimbline(11)));
%                     end
%                     hold off;
%                     pause(1/20);
% %                     pause;
%                 end
%             end
%         end
%     end
% end

%% extr area 19*3
% directed_area{a,s,e}{f,j} action a, subject s, environment e, frame f,
% limb j; f start from 2

display('extr area 19*3');
directed_area = cell(20,10,3);

for a = 1:20
    for s = 1:10
        for e = 1:3
            dataIn = joint_data{a,s,e};
            if (size(dataIn,2)~=0)
                directed_area_one_video = cell(size(dataIn,2),size(J,2));
                for f = 3:size(dataIn,2)
                    for j = 1:size(Jhip,2)
                        p1 = squeeze(dataIn(Jhip(1,j),f,:));
                        p2 = squeeze(dataIn(Jhip(2,j),f,:));
                        last_p1 = squeeze(dataIn(Jhip(1,j),f-1,:));
                        last_p2 = squeeze(dataIn(Jhip(2,j),f-1,:));
                        last2_p1 = squeeze(dataIn(Jhip(1,j),f-2,:));
                        last2_p2 = squeeze(dataIn(Jhip(2,j),f-2,:));
                        cur_limb = p2(1:3)-p1(1:3);
                        last_limb = last_p2(1:3)-last_p1(1:3);
                        last2_limb = last2_p2(1:3)-last2_p1(1:3);
                        norm_vec = (cross(last_limb, cur_limb) - cross(last2_limb,cur_limb))/limbline(j);
                        directed_area_one_video{f,j} = [norm_vec; (p1(4)+p2(4)+last_p1(4)+last_p2(4))/4];
                    end
                end
                directed_area{a,s,e} = directed_area_one_video;
            end
        end
    end
end

save '../result/feat/directed_area.mat' directed_area

%% relative position (20-1)*3 = 57 [ICCV13 GSGC-DL]
% relative_position{a,s,e}{f,j} action a, subject s, environment e, frame f,
% limb j 4x1

display('relative position (20-1)*3 = 57 [ICCV13 GSGC-DL]');

relative_pos_57 = cell(20,10,3);
for a = 1:20
    for s = 1:10
        for e = 1:3
            dataIn = joint_data{a,s,e};
            if (size(dataIn,2)~=0)
                relative_pos_57_one_video = cell(size(dataIn,2),size(J,2));
                for f = 1:size(dataIn,2)
                    for j = 1:size(Jhip,2)
                        p1 = squeeze(dataIn(Jhip(1,j),f,:));
                        p2 = squeeze(dataIn(Jhip(2,j),f,:));
                        relative_pos_57_one_video{f,j} = [p2(1:3)-p1(1:3); (p2(4)+p1(4))/2];
                    end
                end
                relative_pos_57{a,s,e} = relative_pos_57_one_video;
            end
        end
    end
end

save '../result/feat/relative_pos_57.mat' relative_pos_57

%% motion vector 20*3 [...]
% motion_vector_20_3{a,s,e}{f,j} f start from 2 4x1

display('motion vector 20*3 [...]');
motion_vector_20_3 = cell(20,10,3);

for a = 1:20
    for s = 1:10
        for e = 1:3
            dataIn = joint_data{a,s,e};
            motion_vector_20_3_one_video = cell(size(dataIn,2),size(dataIn,1));
            for f = 2:size(dataIn,2)
                for j = 1:size(Jhip,2)
                    p1 = squeeze(dataIn(Jhip(2,j), f, :));
                    p2 = squeeze(dataIn(Jhip(2,j), f-1, :));
                    motion_vector_20_3_one_video{f,j} = [(p1(1:3)-p2(1:3))/limbline(j); (p1(4)+p2(4))/2];
                end
            end
            motion_vector_20_3{a,s,e} = motion_vector_20_3_one_video;
        end
    end
end

save '../result/feat/motion_vector_20_3.mat' motion_vector_20_3

%% motion vector 20*20 [IJCV 13 Accuracy and Observational]
% motion_vector_20_20{a,s,e}{f} (400+1)x1 action a, subject s, enviroment e, frame
% f; f start from 2

% display('motion vector 20*20 [IJCV 13 Accuracy and Observational]')
% 
% motion_vector_20_20 = cell(20,10,3);
% 
% for a = 1:20
%     for s = 1:10
%         for e = 1:3
%             dataIn = joint_data{a,s,e};
%             motion_vector_20_20_one_video = cell(size(dataIn,2),1);
%             for f = 2:size(dataIn,2)
%                 motion_vector_20_20_one_video{f} = zeros(size(dataIn,1)*size(dataIn,1)+1,1);
%                 sum_prob = 0;
%                 for i = 1:size(dataIn,1)
%                     for j = 1:size(dataIn,1)
%                         p1 = squeeze(dataIn(i,f,:));
%                         p2 = squeeze(dataIn(j,f-1,:));
%                         motion_vector_20_20_one_video{f}((i-1)*size(dataIn,1)+j) = sqrt(sum((p1(1:3)-p2(1:3)).^2));
%                         sum_prob = sum_prob + p1(4)+p2(4);
%                     end
%                 end
%                 motion_vector_20_20_one_video{f}(size(dataIn,1)*size(dataIn,1)+1) = sum_prob/(2*size(dataIn,1)*size(dataIn,1));
%                 
%             end
%             motion_vector_20_20{a,s,e} = motion_vector_20_20_one_video;
%         end
%     end
% end
% 
% save '../result/feat/motion_vector_20_20.mat' motion_vector_20_20

%% relations of every paired joint 20*19/2 [IJCV 13 Accuracy and Observational]
% relations_20_19{a,s,e}{f} action a subject s enviroment e frame f 190x1

% display('relations of every paired joint 20*19/2 [IJCV 13 Accuracy and Observational]');
% 
% relations_20_19 = cell(20,10,3);
% 
% for a = 1:20
%     for s = 1:10
%         for e = 1:3
%             dataIn = joint_data{a,s,e};
%             relations_20_19_one_video = cell(size(dataIn,2),1);
%             for f = 1:size(dataIn,2)
%                 relations_20_19_one_video{f} = zeros(size(dataIn,1)*(size(dataIn,1)-1)/2+1,1);
%                 sum_prob = 0;
%                 cnt = 1;
%                 for i = 1:size(dataIn,1)
%                     for j = i+1:size(dataIn,1)
%                         p1 = squeeze(dataIn(i,f,:));
%                         p2 = squeeze(dataIn(j,f,:));
%                         relations_20_19_one_video{f}(cnt) = sqrt(sum((p1(1:3)-p2(1:3)).^2));
%                         cnt = cnt+1;
%                         sum_prob = sum_prob+p1(4)+p2(4);
%                     end
%                 end 
%                 relations_20_19_one_video{f}(cnt) = sum_prob/(2*(cnt-1));
%             end
%             relations_20_19{a,s,e} = relations_20_19_one_video;
%         end
%     end
% end
% 
% save '../result/feat/relations_20_19.mat' relations_20_19

%% Dist paired joints norm by path [MM13]

%% Moving Pose [ICCV 13]
% moving_pose{a,s,e}{f} f start from 3, end to size(dataIn,2)-2 (60*3+1)x1

% display('Moving Pose [ICCV 13]');
% 
% moving_pose = cell(20,10,3);
% alpha = 0.75;
% beta = 0.6;
% 
% for a = 1:20
%     for s = 1:10
%         for e = 1:3
%             dataIn = joint_data{a,s,e};
%             moving_pose_one_video = cell(size(dataIn,2),1);
%             for f = 3:size(dataIn,2)-2
%                 P2 = zeros(size(dataIn,1)*3,1);
%                 P1 = zeros(size(dataIn,1)*3,1);
%                 P0 = zeros(size(dataIn,1)*3,1);
%                 Pm1 = zeros(size(dataIn,1)*3,1);
%                 Pm2 = zeros(size(dataIn,1)*3,1);
%                 sum_prob = 0;
%                 for i = 1:size(dataIn,1)
%                     P2((i-1)*3+1:i*3) = squeeze(dataIn(i, f+2, 1:3));
%                     P1((i-1)*3+1:i*3) = squeeze(dataIn(i, f+1, 1:3));
%                     P0((i-1)*3+1:i*3) = squeeze(dataIn(i, f, 1:3));
%                     Pm1((i-1)*3+1:i*3) = squeeze(dataIn(i, f-1, 1:3));
%                     Pm2((i-1)*3+1:i*3) = squeeze(dataIn(i, f-2, 1:3));
%                     sum_prob = sum_prob + sum(squeeze(dataIn(i, f-2:f+2, 4)));
%                 end
%                 sum_prob = sum_prob/(5*size(dataIn,1));
%                 moving_pose_one_video{f} = [P0; alpha*(P1-Pm1); beta*(P2+Pm2-2*P0); sum_prob];
%             end
%             moving_pose{a,s,e} = moving_pose_one_video;
%         end
%     end
% end
% 
% save '../result/feat/moving_pose.mat' moving_pose
 
%% LO

%% JMO

%% 
end

function [a,b] = swap(a,b)
    tmp = a;
    a = b;
    b = tmp;
end
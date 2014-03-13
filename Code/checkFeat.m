function checkFeat

clc;
clear all;
close all;

%% load feat

load '../result/feat/directed_area.mat';
load '../result/feat/motion_vector_20_3.mat';
load '../result/feat/relative_pos_57.mat';
load '../result/feat/moving_pose.mat';
load '../result/feat/motion_vector_20_20.mat';
load '../result/feat/relations_20_19.mat';
load ../result/joint_data.mat;

%% show each dim of feat and its confidence
figure(1);
title('relative position 57');
cntvalid = 0;
cntall = 0;
for a = 1:20
    for s = 1:10
        for e = 1:3
            dataIn = joint_data{a,s,e};
            for f = 1:size(relative_pos_57{a,s,e},1)
                cntall = cntall + 1;
                if sum(dataIn(:,f,4))/size(dataIn,1) > 0.5
                    cntvalid = cntvalid + 1;
                    for j = 1:size(relative_pos_57{a,s,e},2)
                        blueratio = 1-relative_pos_57{a,s,e}{f,j}(4);
                        redratio = relative_pos_57{a,s,e}{f,j}(4);
                        if relative_pos_57{a,s,e}{f,j}(4)>0.5
                            greenratio = 1-relative_pos_57{a,s,e}{f,j}(4);
                        else
                            greenratio = relative_pos_57{a,s,e}{f,j}(4);
                        end
                        plot3(relative_pos_57{a,s,e}{f,j}(1),...
                            relative_pos_57{a,s,e}{f,j}(2),...
                            relative_pos_57{a,s,e}{f,j}(3),...
                            'Color', [redratio, greenratio, blueratio]);
                        hold on;
                    end
                end
            end
        end
    end
end
hold off;
cntvalid/cntall

figure(2);
title('motion vector 60');
for a = 1:20
    for s = 1:10
        for e = 1:3
            dataIn = joint_data{a,s,e};
            for f = 2:size(motion_vector_20_3{a,s,e},1)
                if sum(dataIn(:,f,4))/size(dataIn,1) > 0.5
                    for j = 1:size(motion_vector_20_3{a,s,e},2)
                        blueratio = 1-motion_vector_20_3{a,s,e}{f,j}(4);
                        redratio = motion_vector_20_3{a,s,e}{f,j}(4);
                        if motion_vector_20_3{a,s,e}{f,j}(4)>0.5
                            greenratio = 1-motion_vector_20_3{a,s,e}{f,j}(4);
                        else
                            greenratio = motion_vector_20_3{a,s,e}{f,j}(4);
                        end
                        plot3(motion_vector_20_3{a,s,e}{f,j}(1),...
                            motion_vector_20_3{a,s,e}{f,j}(2),...
                            motion_vector_20_3{a,s,e}{f,j}(3),...
                            'Color', [redratio, greenratio, blueratio]);
                        hold on;
                    end
                end
            end
        end
    end
end
hold off;
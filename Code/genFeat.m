function genFeat

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

% 19*3+20*3+19*3+60*3+400+190
fdim = 944;
feat = cell(20,10,3);
for a = 1:20
    for s = 1:10
        for e = 1:3
            feat{a,s,e} = [];
            if (size(directed_area{a,s,e},1)>4) 
                feat{a,s,e} = zeros(fdim,size(directed_area{a,s,e},1)-4);
                for f = 3:size(directed_area{a,s,e},1)-2
                    cnt = 1;
                    display(sprintf('%d %d %d %d\n',a,s,e,f));
                    for j = 1:size(directed_area{a,s,e},2)
                        feat{a,s,e}(cnt:cnt+2,f-2) = directed_area{a,s,e}{f,j}(1:3);
                        cnt = cnt+3;
                    end
                    for j = 1:size(motion_vector_20_3{a,s,e},2)
                        feat{a,s,e}(cnt:cnt+2,f-2) = motion_vector_20_3{a,s,e}{f,j}(1:3);
                        cnt = cnt+3;
                    end
                    for j = 1:size(relative_pos_57{a,s,e},2)
                        feat{a,s,e}(cnt:cnt+2,f-2) = relative_pos_57{a,s,e}{f,j}(1:3);
                        cnt = cnt+3;
                    end
                    feat{a,s,e}(cnt:cnt+179,f-2) = moving_pose{a,s,e}{f}(1:180);
                    cnt = cnt+180;
                    feat{a,s,e}(cnt:cnt+399,f-2) = motion_vector_20_20{a,s,e}{f}(1:400);
                    cnt = cnt+400;
                    feat{a,s,e}(cnt:cnt+189,f-2) = relations_20_19{a,s,e}{f}(1:190);
                    cnt = cnt+190;
                end
            end
        end
    end
end

save '../result/feat/feat.mat' feat
            

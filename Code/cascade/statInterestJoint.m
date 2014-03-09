function statInterestJoint

clc;
close all;
clear all;

a1 = 1; a2 = 20;
s1 = 1; s2 = 10;
e1 = 1; e2 = 3;

StatMat = zeros(20,20);

for a = a1:a2
    for s = s1:s2
        for e = e1:e2
            in_fn = sprintf('../MSRAction3DSkeletonReal3D/a%02i_s%02i_e%02i_skeleton3D.txt',a,s,e);
            InterestJoint = detectImportJoint(in_fn);
            if InterestJoint ~= -1
                StatMat(a, InterestJoint) = StatMat(a, InterestJoint)+1;
            end
        end
    end
end

end
function readVideoSkeleton

clc;
close all;
clear all;

a1 = 1; a2 = 20;
s1 = 1; s2 = 10;
e1 = 1; e2 = 3;

for a = a1:a2
    for s = s1:s2
        for e = e1:e2
            in_fn = sprintf('../MSRAction3DSkeletonReal3D/a%02i_s%02i_e%02i_skeleton3D.txt',a,s,e);
            fid = fopen(in_fn, 'r');
            if (fid > 0)
                A = fscanf(fid, '%f');
                fclose(fid);
                len = size(A,1)/4;
                A = reshape(A,4,len);
                A = A';
                A = reshape(A, 20, len/20, 4);
                
                drawTrajectory(A, 11, 'r.');
                drawTrajectory(A, 10, 'b.');
                drawTrajectory(A, 17, 'g.');
                h = drawTrajectory(A, 16, 'y.');
%                 close(h);
%                 pause(1/20);


                title(sprintf('a%02ds%02de%02d', a,s,e));
                print(h, '-dpng', '-r300', sprintf('trajectorypng/a%02d_s%02d_e%02d.png', a,s,e));
                pause(1/20);
                
                close(h);
            end
        end
    end
            
end

end
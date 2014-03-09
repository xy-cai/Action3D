function h = drawTrajectory(A, JointIndex, colorstr)
    nframes = size(A,2);
    h = figure(1);
    
%     plot3(A(JointIndex, 1, 1), A(JointIndex, 1, 3), A(JointIndex, 1, 2), colorstr);
    for nf = 2:nframes
        
        if nf/nframes >= 0.2 && nf/nframes <= 0.8
            xlim = [-1 1];
            ylim = [2 3];
            zlim = [-1 1];
            set(gca, 'xlim', xlim, ...
                     'ylim', ylim, ...
                     'zlim', zlim);

            plot3(A(JointIndex, nf, 1), A(JointIndex, nf, 3), A(JointIndex, nf, 2), colorstr, 'MarkerSize', 15);

            blueratio = 1-nf/nframes;
            redratio = nf/nframes;
            if 2*nf>=nframes
                greenratio = 1 - (2*nf-nframes)/nframes;
            else
                greenratio = 2*nf/nframes;
            end

            line([A(JointIndex, nf, 1), A(JointIndex, nf-1, 1)], ...
                [A(JointIndex, nf, 3), A(JointIndex, nf-1, 3)], ...
                [A(JointIndex, nf, 2), A(JointIndex, nf-1, 2)],...
                'LineWidth', 3, 'Color', [redratio, greenratio, blueratio]);
            hold on;
        end
        
    end
end
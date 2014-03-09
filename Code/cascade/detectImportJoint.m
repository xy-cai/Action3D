function JointIndex = detectImportJoint(filename)
    fid = fopen(filename, 'r');
    if (fid > 0)
        A = fscanf(fid, '%f');
        fclose(fid);
        len = size(A,1)/4;
        A = reshape(A,4,len);
        A = A';
        A = reshape(A, 20, len/20, 4);
        
        movedis = zeros(20,1);
        
        for nf = 2:len/20
            movedis = movedis + sum(squeeze(A(:, nf, 1:3)-A(:, nf-1, 1:3)).^2, 2);
        end
        
        [~, JointIndex] = max(movedis);
        
    else
        JointIndex = -1;
    end
end
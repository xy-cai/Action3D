function mergeResImage
    
    path = 'trajectorypng\';
%     imagelist = dir(path);
    allpng = cell(20,1);
    bigpng = [];
    for i = 1:20
        allpng{i} = [];
    end
%     for i = 3:size(imagelist,1)
%         img = imread([path, imagelist(i).name]);
%         img = imresize(img, [600, 450]);
%         a = str2double(imagelist(i).name(2:3));
%         allpng{a} = [allpng{a}; img];
%     end
%     for i = 1:20
%         bigpng = [bigpng, allpng{i}];
%     end
%     imwrite(bigpng, 'traj.png', 'png');

    for a = 1:20
        for s = 1:10
            for e = 1:3
                fn = sprintf('a%02d_s%02d_e%02d.png', a, s, e);
                fid = fopen([path fn], 'r');
                if fid == -1
                    img = 255*ones(900, 1200, 3);
                else
                    fclose(fid);
                    img = imread([path, fn]);
                    img = imresize(img, [900, 1200]);
                end
                allpng{a} = [allpng{a}, img];
            end
        end
    end
    for i = 1:20
        bigpng = [bigpng; allpng{i}];
    end
%     bigpng = bigpng/255;
    imwrite(bigpng, 'traj.png', 'png');
end
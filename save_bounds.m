function bounds = save_bounds(listnames, path)
    % bounds = uint32(zeros(length(listnames),4));
    bounds = cell(length(listnames),1);

    %%% load images
    for k = 1:length(listnames)
    %     i = 3;
        close all;    
        imageAddress = [path listnames{k}];
        img = imread(imageAddress);
        
        %%% if not map: resize image (smaller size smaller or equal 1024)
        if ~(strcmp(path(length(path)-4:end),'map/'))
            resize1024andSave(img,imageAddress);
            img = imread(imageAddress);
        end
        
        %%% show image
        imshow(img);
        title('Use mouse to choose bounds top-left and bottom-right. Enter when you are done.');
        showaxes('show');

        %%% observing clicks' coordinates
        [x,y] = ginput; % keep observing on current image until pressing ENTER
        x(x<0) = 1;
        y(y<0) = 1;
        x(x>size(img,2)) = size(img,2);
        y(y>size(img,1)) = size(img,1);

        %%% saving coordinates to bounds{}
        for j=1:length(x)
            bounds{k} = [bounds{k} x(j) y(j)];
        end
    end
    close all;
end
function CutImages(img_path,subimg_path)
    %%% The function supports user in defining bounding boxes by displaying 
    %%% images and observing user's mouse-clicks
    %%% root_path: path of the parent directory which includes 5 class
    %%% directories
    %%% Example: ChooseBounds('D:\ARCHIVES-jpg\')

    clear all; clc;

    %%% initialize
    classes = {'graph','photo','map','text-hand','text-print'};
    
    %         rootpath = 'D:\Education\USTH\Master\M1-Intership\matlab\PreProcessing\';
    %         img_path = [rootpath 'ARCHIVES-jpg\'];
    %         subimg_path = [rootpath 'ARCHIVES-subimg\'];
    
    for class_id = 1:5

        class_img_path = [img_path class '\'];
        class_subimg_path = [subimg_path class '\'];
        undefined_class_subimg_path = [subimg_path 'undefined' '\'];

        %%% get bounds from file
        bounds_mat = dlmread([img_path 'bounds-' class '.txt']);
        bounds = cell(size(bounds_mat,1),1); % convert matrix to cell
        for i = 1:size(bounds_mat,1)
            for j = 1:size(bounds_mat,2)
                if bounds_mat(i,j) ~= 0
                    bounds{i} = [bounds{i} bounds_mat(i,j)];
                end
            end
        end

        %%% get list names from folder path
        listnames = create_listnames(class_img_path);

        %%% cut sub images from images
        % count_imgs = 0;
        ws = 224; % windows size

        for k = 1:length(listnames)-1
        %     close all;
        %     k = 3;

            %%% load image
            imageAddress = [class_img_path listnames{k}];
            img = imread(imageAddress);

            %%% if this is a map, let me choose the windows size by mouse
        %     if (strcmp(class_img_path(length(class_img_path)-3:end),'map\'))
        %         imshow(img);
        %         hold on;
        %         title('Choose an ideal window size');
        %         showaxes('show');
        %         %%% wait for input -> define subimage -> ratio -> resize img
        %         [x,y] = ginput(2); 
        %         ws2 = (x(2)-x(1) + y(2)-y(1))/2;
        %         if ws2 > ws1
        %             ratio = ws/ws2;
        %             img = imresize(img,ratio);
        %             str = sprintf('Ratio: %0.2f New size: %d x %d', ratio, size(img,1), size(img,2));
        %             title(str);
        %         end
        %     end

            if (isempty(bounds{k}) == 1)
                boundEmpty = 1;
            else
                boundEmpty = 0;
            end

            if (size(img,1) > ws) && (size(img,2) > ws)
                for i = 1:(ws/2):size(img,1)-ws
                    for j = 1:(ws/2):size(img,2)-ws
                        % take a  subimage
                        subimg = img(i:i+ws-1,j:j+ws-1,:);

                        % if there is no bound, slide the window on the whole image
                        if (boundEmpty == 1)
                            %%% write to class' folder
                            imwrite_new_number(subimg, class_subimg_path)
                        else
                            bounds{k} = bounds{k}(1:length(bounds{k})-(mod(length(bounds{k}),4)));
                            for b = 1:4:length(bounds{k})
                                x1 = bounds{k}(b);
                                y1 = bounds{k}(b+1);
                                x2 = bounds{k}(b+2);
                                y2 = bounds{k}(b+3);
                                if (j> x1)&& (j+ws < x2) && (i > y1) && (i+ws < y2) % the windows must be inside the bound                
                                    %%% write the sub image to class' folder
        %                             imwrite_new_number(subimg, class_subimg_path)

                                    %%% fliping
                                    subimg_fl = flip(subimg,2);

                                    %%% rotation
                                    [subimg_rot1, subimg_rot2, subimg_rot3] = rotate_orthogonal(subimg);
                                    [subimg_fl_rot1,subimg_fl_rot2, subimg_fl_rot3] = rotate_orthogonal(subimg_fl);                            

                                    %%% write rotated sub-images
                                    list_subimgs = {subimg, subimg_rot1, subimg_rot2, subimg_rot3, subimg_fl, subimg_fl_rot1,subimg_fl_rot2, subimg_fl_rot3};
                                    write_list_subimgs(list_subimgs, class_subimg_path);

        %                             imwrite_new_number(subimg_fl_1, class_subimg_path);
        %                             imwrite_new_number(subimg_fl_2, class_subimg_path);
        %                             imwrite_new_number(subimg_fl_3, class_subimg_path);
                                end
                            end
                        end
                    end
                end
            end
            close all;    
        end
    end
end
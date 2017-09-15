function RotateNonOrtho_CreateMoreSize(root_path)
%%% The function implements Non-orthogonal rotation and Pyramid sizing on
%%% images of each class.
%%% root_path: path of the parent directory which includes 5 class
%%% directories
%%% Example: RotateNonOrtho_CreateMoreSize('D:\ARCHIVES-jpg\')
    
    classes = {'graph','photo','map','text-hand','text-print'};

    % validate path
    root_path = validate_path(root_path);
    
    for class_id = 1:5
        disp(['Class ' int2str(class_id)]);    
        classname = classes{class_id}; % choose class here

        path = [root_path classname '\'];
        
        % create "done" folder if not exist
        done_path = [path 'done'];
        if (exist(done_path, 'dir') ~= 7)
            disp('Making done folder');
            mkdir(path,'done');
        end
        
        listnames = create_listnames(path);
        

        %% Rotation
        disp('Creating images by rotating...');
        for i = 1:length(listnames)
            %%% read image
            img = imread([path listnames{i}]);
            copyfile([path listnames{i}], [path 'done\' listnames{i}]);

            %%% rotate angle based on class
            if strcmp(classname,'map')
                rotate_angle = 45;
            else
                rotate_angle = 5;
            end
            img_rot_left = imrotate(img,rotate_angle);
            img_rot_right = imrotate(img,-rotate_angle);

            %%% write rotated image files
            imwrite(img_rot_left, [path listnames{i}(1:length(listnames{i})-4) '_left' '.jpg']);
            imwrite(img_rot_right, [path listnames{i}(1:length(listnames{i})-4) '_right' '.jpg']);

        end
        disp('Done Rotating!');
        %% Create More Sizes
        disp('Creating images by resizing...');
        listnames = create_listnames(path);
        for i = 1:length(listnames)
            %%% read image
            img = imread([path listnames{i}]);

            %%% resize images
            if size(img,1) < size(img,2)
                shorter_side = 1;
            else
                shorter_side = 2;
            end
            shorter_value = size(img,shorter_side);
            sizes = [1024 512 256];

            for size_num = 1:length(sizes)
                scale = sizes(size_num)/shorter_value;
                if shorter_value > sizes(size_num)
                    img_resized = imresize(img, scale);
                    imwrite(img_resized,[path listnames{i}(1:length(listnames{i})-4) '_' num2str(sizes(size_num)) '.jpg']);
                end
            end
        end
        disp('Done Resizing!');
    end
end
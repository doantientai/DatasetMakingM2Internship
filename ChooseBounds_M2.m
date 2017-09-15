%%% Choosing Bounding Boxes
clear;
%% DATA PATH
classname = ['text-print' '\'];

PATH_DATA = 'C:\Tai\Education\USTH\Master\M2-Internship\Matlab\M2-data\';
PATH_IMAGES = [ PATH_DATA 'ARCHIVES-imgs-raw\' classname ];
PATH_MASKS = [ PATH_DATA 'ARCHIVES-imgs-mask\' classname ];
PATH_PATCHES = [ PATH_DATA 'ARCHIVES-imgs-patch\' classname ];
PATH_PYRAMID_IMGS = [ PATH_DATA 'ARCHIVES-imgs-pyramid\' classname ];
PATH_ROTATE5_IMGS = [ PATH_DATA 'ARCHIVES-imgs-rotate5\' classname ];
PATH_FLIP_ROTATE90_IMGS = [ PATH_DATA 'ARCHIVES-imgs-flip-rotate90\' classname ];
% PATH_PYRAMID_PATCHES = [ PATH_DATA 'ARCHIVES-imgs-pyramid_imgs_pathces\' classname ];
list_image_names = create_listnames(PATH_IMAGES);

%% Choosing Bounding Boxes
list_masks_exist = create_listnames(PATH_MASKS);
for i = 1:length(list_image_names)
    % check if the mask has been created before
    if (ismember([list_image_names{i}(1:end-4) '.bmp'],list_masks_exist))
        continue
    end
    imgpath = [PATH_IMAGES list_image_names{i}];
    img = imread(imgpath);
    mask = roipoly(img);
    close all;
    imwrite(mask,[PATH_MASKS list_image_names{i}(1:end-4) '.bmp']);
end

%% Pyramids and auto ratio
pyramid_M2(PATH_IMAGES, PATH_PYRAMID_IMGS, 'image')
pyramid_M2(PATH_MASKS, PATH_MASKS, 'mask')

%% +-5* Rotate
rotate5_M2(PATH_PYRAMID_IMGS, PATH_ROTATE5_IMGS, 'image')
rotate5_M2(PATH_MASKS, PATH_MASKS, 'mask')

%% Flip + Orthogonal Rotate
flip_rotate90_M2(PATH_ROTATE5_IMGS, PATH_FLIP_ROTATE90_IMGS, 'image')
flip_rotate90_M2(PATH_MASKS, PATH_MASKS, 'mask')

%% Sliding window
% window size 224
ws = 224;

% load image from pyramid folder and read mask to run sliding window
list_image_names = create_listnames(PATH_FLIP_ROTATE90_IMGS);

% make a cell of image folder names
folder_names = {};

for k = 1:length(list_image_names)
    image_file_name = list_image_names{k};
    image_file_prefix = image_file_name(1:14);
    
    % load this image
    imgpath = [PATH_FLIP_ROTATE90_IMGS image_file_name]; 
    img = imread(imgpath);
        
    % check if file name exists
    path_patches_this_image = [PATH_PATCHES image_file_prefix];
    if (ismember(image_file_prefix, folder_names) == 0)
        % if not, make a new one
        display(['making folder ' image_file_prefix]);
        mkdir(path_patches_this_image);
        folder_names{length(folder_names)+1} = image_file_prefix;
    end
    
    % load mask of the image
    maskpath = [PATH_MASKS image_file_name(1:end-4) '.bmp'];
    mask = imread(maskpath);
    for i = 1:(ws):size(mask,1)- ws
        for j = 1:(ws):size(mask,2)- ws
            % take the area on the mask according to the coordinates
            window_on_mask = mask(i:i+ws-1,j:j+ws-1);
            
            % if the whole window is on the mask (value = 1), then take a
            % window on the image
            if all(all(window_on_mask))
                window_on_img = img(i:i+ws-1,j:j+ws-1,:);
                
                % save patch to the patches folder of the image
                D = dir([path_patches_this_image, '\*.jpg']);
                count_patches_exist = length(D(not([D.isdir])));
                patch_name = [image_file_name(1:end-4) '_' num2str(count_patches_exist + 1) '.jpg'];
                imwrite(window_on_img,[path_patches_this_image '\' patch_name]);
            end            
        end
    end
end

display('ALL DONE!')
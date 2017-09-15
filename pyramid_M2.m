function pyramid_M2(PATH_IMAGES, PATH_PYRAMID_IMGS, mode)
display('Pyramid...');
extension = img_or_patch(PATH_IMAGES, PATH_PYRAMID_IMGS, mode);

list_image_names = create_listnames(PATH_IMAGES);
sizes = [1024 512 256];
for i = 1:length(list_image_names)
% for i = 1:length(list_image_names)
    imgpath = [PATH_IMAGES list_image_names{i}];
    img = imread(imgpath);    
    
    % find which side is shorter
    if size(img,1) < size(img,2)
        shorter_side = 1;
    else
        shorter_side = 2;
    end
    shorter_value = size(img,shorter_side);
    sizes = [1024 512 256];
    
    % resize and save
    for size_num = 1:length(sizes)
        scale = sizes(size_num)/shorter_value;
        if shorter_value > sizes(size_num)
            img_resized = imresize(img, scale);
            imwrite(img_resized,[PATH_PYRAMID_IMGS list_image_names{i}(1:length(list_image_names{i})-4) '_' num2str(sizes(size_num)) extension]);
%             display('writing image');
        end
    end
    
    % COPY the original image to PATH_OUTPUT if this is image mode
    if (strcmp(mode,'image'))
        imwrite(img,[PATH_PYRAMID_IMGS list_image_names{i}]);
    end
end
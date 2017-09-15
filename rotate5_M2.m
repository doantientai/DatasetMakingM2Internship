function rotate5_M2(PATH_INPUT, PATH_OUTPUT, mode)
display('Rotate +- 5 degrees...');
extension = img_or_patch(PATH_INPUT, PATH_OUTPUT,mode);

list_image_names = create_listnames(PATH_INPUT);

for i = 1:length(list_image_names)
    imgpath = [PATH_INPUT list_image_names{i}];
    img = imread(imgpath);
    
    img_rot_left = imrotate(img, -5);
    img_rot_right = imrotate(img, 5);
    
    imwrite(img_rot_left,[PATH_OUTPUT list_image_names{i}(1:length(list_image_names{i})-4) '_left'  extension]);
    imwrite(img_rot_right,[PATH_OUTPUT list_image_names{i}(1:length(list_image_names{i})-4) '_right'  extension]);
    
    % COPY the original image to PATH_OUTPUT if this is image mode
    if (strcmp(mode,'image'))
        imwrite(img,[PATH_OUTPUT list_image_names{i}]);
    end
end
function flip_rotate90_M2(PATH_INPUT, PATH_OUTPUT, mode)
display('Flip and Rotate Orthogonally...');

extension = img_or_patch(PATH_INPUT, PATH_OUTPUT, mode);

list_image_names = create_listnames(PATH_INPUT);

for i = 1:length(list_image_names)
    imgpath = [PATH_INPUT list_image_names{i}];
    img = imread(imgpath);
    
    imgs_output = containers.Map;
    
    %%% fliping
    imgs_output('flip') = flip(img,2);

    %%% rotation    
    [imgs_output('rot90'), imgs_output('rot180'), imgs_output('rot270')] = rotate_orthogonal(img);
    [imgs_output('flip_rot90'), imgs_output('flip_rot180'), imgs_output('flip_rot270')] = rotate_orthogonal(imgs_output('flip'));
    
    K = keys(imgs_output);
    
    for key_ind=1:length(K)
        imwrite(imgs_output(char(K{key_ind})),[PATH_OUTPUT list_image_names{i}(1:length(list_image_names{i})-4) '_' char(K{key_ind}) extension]);
%         display([PATH_OUTPUT list_image_names{i}(1:length(list_image_names{i})-4) '_' K(key_ind) extension])
    end
    
    % COPY the original image to PATH_OUTPUT if this is image mode
    if (strcmp(mode,'image'))
        imwrite(img,[PATH_OUTPUT list_image_names{i}]);
    end
end
function extension = img_or_patch(PATH_INPUT, PATH_OUTPUT,input_mode)
    if (strcmp(input_mode,'image'))
        extension = '.jpg';
        display('Working on images')
    elseif (strcmp(input_mode,'mask') && strcmp(PATH_INPUT,PATH_OUTPUT))
        extension = '.bmp';
        display('Working on masks')
    else
        display('ERROR: wrong syntax!');
        return
    end
end
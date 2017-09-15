function write_list_subimgs(list_imgs, path)
    for i = 1:length(list_imgs)
        img = list_imgs{i};
        imwrite_new_number(img, path);
    end
end
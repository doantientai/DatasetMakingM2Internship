function img = resize1024andSave(img,imageAddress)
    if size(img,1) < size(img,2) % heigh < width
        if (size(img,1) > 1024)
            img = imresize(img, 1024/size(img,1));
            imwrite(img,imageAddress);
        end
    else
        if (size(img,2) > 1024)
            img = imresize(img, 1024/size(img,2));
            imwrite(img,imageAddress);
        end
    end
end
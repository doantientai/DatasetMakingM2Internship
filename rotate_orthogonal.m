function [rota90, rota180, rota270] = rotate_orthogonal(img)
    rota90 = imrotate(img, 90);
    rota180 = imrotate(img, 180);
    rota270 = imrotate(img, 270);
end
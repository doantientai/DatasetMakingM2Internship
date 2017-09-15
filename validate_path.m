function validated_path = validate_path(path)
    validated_path = strrep(path,'/', '\');
    if (validated_path(end) ~= '/') && (validated_path(end) ~= '\')
        validated_path(end+1) = '\';
    end
end
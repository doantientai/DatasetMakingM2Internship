function listnames = create_listnames(path)
    listfiles = dir(path);
    listnames = cell(25,1);
    for i = 1:length(listfiles)
        listnames{i} = listfiles(i).name;
    end

    %%% remove  [], '.', '..', and pdf
%     listnames(~cellfun('isempty',listnames));
    listnames = listnames(~cellfun(@isempty, listnames));
    [~, index] = ismember('.', listnames);
    if index ~= 0
        listnames(index) = [];
    end
    [~, index] = ismember('..', listnames);
    if index ~= 0
        listnames(index) = [];
    end
    [~, index] = ismember('.pdf', listnames);
    if index ~= 0
        listnames(index) = [];
    end
    [~, index] = ismember('.PDF', listnames);
    if index ~= 0
        listnames(index) = [];
    end
    [~, index] = ismember('done', listnames);
    if index ~= 0
        listnames(index) = [];
    end
end
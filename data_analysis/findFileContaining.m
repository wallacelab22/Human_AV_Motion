function fileName = findFileContaining(fileList, pattern)
    % Helper function to find a file in the directory containing a specific pattern
    fileName = '';
    for i = 1:length(fileList)
        if contains(fileList(i).name, pattern)
            fileName = fileList(i).name;
            return;
        end
    end
end
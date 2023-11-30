for i = 1:length(whos)
    if ~isempty(whos('i'))
        % Variable exists
        disp('The variable exists.')
    else
        % Variable does not exist
        disp('The variable does not exist.')
    end
end

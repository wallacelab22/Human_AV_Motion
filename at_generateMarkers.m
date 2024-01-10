function [markers] = at_generateMarkers(data_output, ii, EEG_nature, block)
% Create marker for EEG
if EEG_nature == 1 && ~contains('AV', block)
    dir_id = num2str(data_output(ii,1));
    coh_id = num2str(data_output(ii,2));
    markers = strcat([dir_id coh_id]); % unique identifier for LSL
elseif EEG_nature == 1 && contains('AV', block)
    auddir_id = num2str(data_output(ii,1));
    audcoh_id = num2str(data_output(ii,2));
    visdir_id = num2str(data_output(ii,3));
    viscoh_id = num2str(data_output(ii,4));
    markers = strcat([auddir_id audcoh_id visdir_id viscoh_id]); %unique identifier for LSL
else
    markers = NaN; % needed for function at_presentDot
end

end
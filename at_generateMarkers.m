function [markers] = at_generateMarkers(data_output, ii, EEG_nature)
% Create marker for EEG
if EEG_nature == 1
    dir_id = num2str(data_output(ii,1));
    coh_id = num2str(data_output(ii,2));
    markers = strcat([dir_id coh_id]); % unique identifier for LSL
else
    markers = NaN; % needed for function at_presentDot
end

end
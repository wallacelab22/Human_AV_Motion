function [data_output] = coh_level_correction(data_output, script_file_directory, ...
    task_file_directory, save_name)

cd(task_file_directory)

% Replace aud coherence levels with coherences
if contains(save_name, 'Aud') || contains(save_name, 'AV')
    aud_to_replace = [7 6 5 4 3 2 1];  % Values to replace
    aud_replace = coherence_calc(data_output);  % Values to replace with
    for ii = 1:numel(aud_to_replace)
        idx = ismember(data_output(:,2),aud_to_replace(ii));
        data_output(idx,2) = aud_replace.cohSet(ii);
    end
end

% Replace vis coherence levels with coherences
if contains(save_name, 'AV')
    vis_to_replace = [7 6 5 4 3 2 1];  % Values to replace
    vis_replace = coherence_calc(data_output);  % Values to replace with
    for ii = 1:numel(vis_to_replace)
        idx = ismember(data_output(:,4),vis_to_replace(ii));
        data_output(idx,4) = vis_replace.cohSet(ii);
    end
end

if contains(save_name, 'Vis')
    vis_to_replace = [7 6 5 4 3 2 1];  % Values to replace
    vis_replace = coherence_calc(data_output);  % Values to replace with
    for ii = 1:numel(vis_to_replace)
        idx = ismember(data_output(:,2),vis_to_replace(ii));
        data_output(idx,2) = vis_replace.cohSet(ii);
    end
end

cd(script_file_directory)

end
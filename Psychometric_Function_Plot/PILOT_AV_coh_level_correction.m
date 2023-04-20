function [data_output] = PILOT_AV_coh_level_correction(data_output, aud_replace, vis_replace)

% Replace values in the second and fourth column
to_replace = [1 2 3 5 6 7];  % Values to replace
replace_with = [7 6 5 3 2 1];  % Values to replace with

modified_rows = false(size(data_output, 1), 1); % Keep track of which rows have already been modified

for ii = 1:numel(to_replace)
    idx = ismember(data_output(:,[2 4]),to_replace(ii));
    idx(:,1) = idx(:,1) & ~modified_rows; % Only modify rows that haven't been modified before
    idx(:,2) = idx(:,2) & ~modified_rows;
    data_output(idx(:,1),2) = replace_with(ii);
    data_output(idx(:,2),4) = replace_with(ii);
    modified_rows = modified_rows | any(idx, 2); % Mark the modified rows as already modified
end


% Replace aud coherence levels with coherences
aud_to_replace = [1 2 3 4 5 6 7];  % Values to replace
if aud_replace == 0
    aud_replace = [0.0247 0.0346 0.0484 0.0678 0.0949 0.1328 0.1859];  % Values to replace with
end

for ii = 1:numel(aud_to_replace)
    idx = ismember(data_output(:,2),aud_to_replace(ii));
    data_output(idx,2) = aud_replace(ii);
end

% Replace vis coherence levels with coherences
vis_to_replace = [1 2 3 4 5 6 7];  % Values to replace
if vis_replace == 0
    vis_replace = [0.0346 0.0484 0.0678 0.0949 0.1328 0.1859 0.2603];  % Values to replace with
end

for ii = 1:numel(vis_to_replace)
    idx = ismember(data_output(:,4),vis_to_replace(ii));
    data_output(idx,4) = vis_replace(ii);
end
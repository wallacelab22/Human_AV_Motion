% Replace values in the second and fourth column
to_replace = [1 2 3 5 6 7];  % Values to replace
replace_with = [7 6 5 3 2 1];  % Values to replace with

for ii = 1:numel(to_replace)
    idx = ismember(data_output(:,[2 4]),to_replace(ii));
    data_output(idx(:,1),2) = replace_with(ii);
    data_output(idx(:,2),4) = replace_with(ii);
end


% Replace aud coherence levels with coherences
aud_to_replace = [1 2 3 4 5 6 7];  % Values to replace
aud_replace = [0.0247 0.0346 0.0484 0.0678 0.0949 0.1328 0.1859];  % Values to replace with

for ii = 1:numel(aud_to_replace)
    idx = ismember(data_output(:,2),aud_to_replace(ii));
    data_output(idx,2) = aud_replace(ii);
end

% Replace vis coherence levels with coherences
vis_to_replace = [1 2 3 4 5 6 7];  % Values to replace
vis_replace = [0.0346 0.0484 0.0678 0.0949 0.1328 0.1859 0.2603];  % Values to replace with

for ii = 1:numel(vis_to_replace)
    idx = ismember(data_output(:,4),vis_to_replace(ii));
    data_output(idx,4) = vis_replace(ii);
end
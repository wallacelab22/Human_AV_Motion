function [data_output] = coh_level_correction(data_output, aud_replace, vis_replace)


% Replace aud coherence levels with coherences
if contains(save_name, 'Aud') || contains(save_name, 'AV')
    aud_to_replace = [1 2 3 4 5 6 7];  % Values to replace
    cd()
    aud_replace = coherence_calc();  % Values to replace with

    for ii = 1:numel(aud_to_replace)
        idx = ismember(data_output(:,2),aud_to_replace(ii));
        data_output(idx,2) = aud_replace(ii);
    end
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
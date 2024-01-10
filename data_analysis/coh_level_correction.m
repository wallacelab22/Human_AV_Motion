function [outdata, cohlvlcoh] = coh_level_correction(outdata, subjnum_s, ...
    group_s, sex_s, age_s, script_file_directory, data_file_directory, ...
    task_file_directory, save_name)

if any(outdata(:, 2) > 1)
    % Replace aud coherence levels with coherences
    if contains(save_name, 'Aud') || contains(save_name, 'AV')
        aud_to_replace = (unique(outdata(:,2)))';
        aud_to_replace = sort(aud_to_replace, 'descend');
        aud_to_replace = aud_to_replace(aud_to_replace ~= 0); % Values to replace
        cd(data_file_directory)
        stairAud = sprintf('RDKHoop_stairAud_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
        load(stairAud, 'data_output')
        cd(task_file_directory)
        aud_replace = coherence_calc(data_output);  % Values to replace with
        for ii = 1:numel(aud_to_replace)
            idx = ismember(outdata(:,2),aud_to_replace(ii));
            outdata(idx,2) = aud_replace.cohSet(ii);
        end
    end
    
    % Replace vis coherence levels with coherences
    if contains(save_name, 'AV')
        vis_to_replace = (unique(outdata(:,4)))';
        vis_to_replace = sort(vis_to_replace, 'descend');
        vis_to_replace = vis_to_replace(vis_to_replace ~= 0); % Values to replace
        cd(data_file_directory)
        stairVis = sprintf('RDKHoop_stairVis_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
        load(stairVis, 'data_output')
        cd(task_file_directory)
        vis_replace = coherence_calc(data_output);  % Values to replace with
        for ii = 1:numel(vis_to_replace)
            idx = ismember(outdata(:,4),vis_to_replace(ii));
            outdata(idx,4) = vis_replace.cohSet(ii);
        end
    end
    
    if contains(save_name, 'Vis')
        vis_to_replace = (unique(outdata(:,2)))';
        vis_to_replace = sort(vis_to_replace, 'descend');
        vis_to_replace = vis_to_replace(vis_to_replace ~= 0); % Values to replace
        cd(data_file_directory)
        stairVis = sprintf('RDKHoop_stairVis_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
        load(stairVis, 'data_output')
        cd(task_file_directory)
        vis_replace = coherence_calc(data_output);  % Values to replace with
        for ii = 1:numel(vis_to_replace)
            idx = ismember(outdata(:,2),vis_to_replace(ii));
            outdata(idx,2) = vis_replace.cohSet(ii);
        end
    end
end

if contains(save_name, 'Aud')
    cohlvlcoh = [aud_to_replace; aud_replace.cohSet];
elseif contains(save_name, 'Vis')
    cohlvlcoh = [vis_to_replace; vis_replace.cohSet];
elseif contains(save_name, 'AV')
    cohlvlcoh = [aud_to_replace; aud_replace.cohSet; vis_to_replace; vis_replace.cohSet];
end


cd(script_file_directory)


end
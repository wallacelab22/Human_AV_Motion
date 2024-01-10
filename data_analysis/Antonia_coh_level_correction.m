function [outdata, cohlvlcoh] = Antonia_coh_level_correction(outdata, save_name)

if any(outdata(:, 2) > 1)
    % Replace aud coherence levels with coherences
    if contains(save_name, 'Aud') || contains(save_name, 'AV')
        aud_to_replace = [5 4 3 2 1 0]; % Values to replace
        aud_replace = [0.55 0.45 0.35 0.25 0.1 0];  % Values to replace with
        for ii = 1:numel(aud_to_replace)
            idx = ismember(outdata(:,2),aud_to_replace(ii));
            outdata(idx,2) = aud_replace(ii);
        end
    end
    
    % Replace vis coherence levels with coherences
    if contains(save_name, 'AV')
        vis_to_replace = [5 4 3 2 1 0]; % Values to replace
        vis_replace = [0.45 0.35 0.25 0.15 0.05 0];  % Values to replace with
        for ii = 1:numel(vis_to_replace)
            idx = ismember(outdata(:,4),vis_to_replace(ii));
            outdata(idx,4) = vis_replace(ii);
        end
    end
    
    if contains(save_name, 'Vis')
        vis_to_replace = [5 4 3 2 1 0]; % Values to replace
        vis_replace = [0.45 0.35 0.25 0.15 0.05 0];  % Values to replace with
        for ii = 1:numel(vis_to_replace)
            idx = ismember(outdata(:,2),vis_to_replace(ii));
            outdata(idx,2) = vis_replace(ii);
        end
    end
end

if contains(save_name, 'Aud')
    cohlvlcoh = [aud_to_replace; aud_replace];
elseif contains(save_name, 'Vis')
    cohlvlcoh = [vis_to_replace; vis_replace];
elseif contains(save_name, 'AV')
    cohlvlcoh = [aud_to_replace; aud_replace; vis_to_replace; vis_replace];
end

end
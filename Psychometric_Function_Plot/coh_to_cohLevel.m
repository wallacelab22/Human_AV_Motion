function [outdata] = coh_to_cohLevel(outdata, stimcoh_list, save_name)
%  Replace coherence levels percentages (0-1) to whole number integers (1-5)

if any(outdata(:, 2) > 0 & outdata(:, 2) < 1)
    % Replace aud coherence levels with coherences
    if contains(save_name, 'Aud') || contains(save_name, 'AV')
        aud_to_replace = [stimcoh_list(1,:), 0]; % Values to replace
        aud_replace = [7 6 5 4 3 2 1 0]; % Values to replace with
        for ii = 1:numel(aud_to_replace)
            idx = ismember(outdata(:,2),aud_to_replace(ii));
            outdata(idx,2) = aud_replace(ii);
        end
        rows_to_keep = ismember(outdata(:, 2), aud_replace);
        % Keep rows where the value in column 2 is a whole number value
        outdata = outdata(rows_to_keep, :);
    end
    
    % Replace vis coherence levels with coherences
    if contains(save_name, 'AV')
        vis_to_replace = [stimcoh_list(2,:), 0]; % Values to replace
        vis_replace = [7 6 5 4 3 2 1 0]; % Values to replace with
        for ii = 1:numel(vis_to_replace)
            idx = ismember(outdata(:,4),vis_to_replace(ii));
            outdata(idx,4) = vis_replace(ii);
        end
        rows_to_keep = ismember(outdata(:, 4), vis_replace);
        % Keep rows where the value in column 2 is a whole number value
        outdata = outdata(rows_to_keep, :);
    end
    
    if contains(save_name, 'Vis')
        vis_to_replace = [stimcoh_list(2,:), 0]; % Values to replace
        vis_replace = [7 6 5 4 3 2 1 0]; % Values to replace with
        for ii = 1:numel(vis_to_replace)
            idx = ismember(outdata(:,2),vis_to_replace(ii));
            outdata(idx,2) = vis_replace(ii);
        end
        rows_to_keep = ismember(outdata(:, 2), vis_replace);
        % Keep rows where the value in column 2 is a whole number value
        outdata = outdata(rows_to_keep, :);
    end
end

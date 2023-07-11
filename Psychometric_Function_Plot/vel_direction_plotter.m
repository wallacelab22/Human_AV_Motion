function [right_vs_left, right_group, left_group, catch_group] = vel_direction_plotter(data_output)

% Group trials based on stimulus direction--> 1 = right, 2 = left, 3 = catch
right_or_left = data_output(:, 1);
right_vs_left = splitapply(@(x){x}, data_output, right_or_left);

% Isolate coherences for right and left groups and catch
right_group = findgroups(right_vs_left{1,1}(:,7));
left_group = findgroups(right_vs_left{2,1}(:,7));
if size(right_vs_left, 1) >= 3 && size(right_vs_left{3,1}, 2) >= 2
    catch_group = findgroups(right_vs_left{3,1}(:,7));
end

end
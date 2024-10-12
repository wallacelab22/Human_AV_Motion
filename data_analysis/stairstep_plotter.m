function [stairstep] = stairstep_plotter(data_output, save_name, vel_stair)
% Extract velocity or coherence
if vel_stair == 1
    trial_vel = data_output(:, 7);
else
    trial_coh = data_output(:, 2);
end

% Generate the trial numbers as the row numbers
trial_num = 1:size(data_output, 1);

% Plot the stairstep graph
figure;
if contains(save_name, 'Aud')
    if vel_stair == 1
        stairstep = stairs(trial_num, trial_vel, 'LineWidth', 2, 'Color', 'r');
    else
        stairstep = stairs(trial_num, trial_coh, 'LineWidth', 2, 'Color', 'r');
    end
elseif contains(save_name, 'Vis')
    if vel_stair == 1
        stairstep = stairs(trial_num, trial_vel, 'LineWidth', 2, 'Color', 'b');
    else
        stairstep = stairs(trial_num, trial_coh, 'LineWidth', 2, 'Color', 'b');
    end
end
grid on

% Label the axes and title
if vel_stair == 1
    title(sprintf('Staircase Coherences by Trial Number: \n %s',save_name), 'Interpreter','none');
    ylabel('Velocity')
else
    title(sprintf('Staircase Coherences by Trial Number: \n %s',save_name), 'Interpreter','none');
    ylabel('Coherence');
end
xlabel('Trial number');
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
end
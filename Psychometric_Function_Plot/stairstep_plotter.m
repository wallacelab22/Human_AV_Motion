function [stairstep] = stairstep_plotter(data_output, save_name)
% Extract coherence levels
trial_coh = data_output(:, 2);

% Generate the trial numbers as the row numbers
trial_num = 1:size(data_output, 1);

% Plot the stairstep graph
figure;
if contains(save_name, 'Aud')
    stairstep = stairs(trial_num, trial_coh, 'LineWidth', 2, 'Color', 'r');
elseif contains(save_name, 'Vis')
    stairstep = stairs(trial_num, trial_coh, 'LineWidth', 2, 'Color', 'b');
end
grid on

% Label the axes and title
title(sprintf('Staircase Coherences by Trial Number: \n %s',save_name), 'Interpreter','none');
xlabel('Trial number');
ylabel('Coherence level');
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
end
function [stairstep] = stairstep_plotter(data_output)
% Extract coherence levels
trial_coh = data_output(:, 2);

% Generate the trial numbers as the row numbers
trial_num = 1:size(data_output, 1);

% Plot the stairstep graph
figure;
stairstep = stairs(trial_num, trial_coh);
grid on

% Label the axes
xlabel('Trial number');
ylabel('Coherence level');
end
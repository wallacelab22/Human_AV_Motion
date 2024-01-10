function [reactiontime_graph, sz] = reactiontime_plotter(right_vs_left, right_group, left_group, save_name)
% Create x bins for the bar plot by finding all coherence levels
right_coh_vals = right_vs_left{1,1}(:, 2);
left_coh_vals = right_vs_left{2,1}(:, 2);
combined_coh = [right_coh_vals; left_coh_vals];
coh_bins = sort(combined_coh, 'ascend');
coh_bins = unique(coh_bins, 'stable')';

% Create the y variable for the bar plot
coh_rt = [];
frequency = [];

% Loop through each coherence level and find the accuracy
for i = 1:length(coh_bins)
    right_group_coh = right_vs_left{1,1}(right_group == i, :);
    right_rt = sum(right_group_coh(:,4)) / size(right_group_coh(:, 4), 1);
    right_freq = size(right_group_coh(:, 4), 1);
    left_group_coh = right_vs_left{2,1}(left_group == i, :);
    left_rt = sum(left_group_coh(:,4)) / size(left_group_coh(:, 4), 1);
    left_freq = size(left_group_coh(:, 4), 1);
    coh_rt = [coh_rt; right_rt left_rt];
    frequency = [frequency; right_freq left_freq];
end
sz = 10*frequency;
sz(sz==0) = NaN;

% Plot the bar graph and label the axes
figure;
reactiontime_graph = plot(coh_bins, coh_rt, 'LineWidth', 2, 'MarkerFaceColor', 'g', 'MarkerSize', 15);
hold on
scatter(coh_bins, coh_rt, sz, 'MarkerEdgeColor', 'k', 'LineWidth', 2);
title(sprintf('Leftward v. Rightward Reaction Time: \n %s',save_name), 'Interpreter','none');
xlabel('Coherence Levels');
ylabel('Reaction Time (in sec)');
legend('Leftward trials', 'Rightward trials', 'Location', 'southeast');
ylim([0 3]);
grid on
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)

end
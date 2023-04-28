function [accuracy_graph, sz] = accuracy_plotter(right_vs_left, right_group, left_group)
% Create x bins for the bar plot by finding all coherence levels
right_coh_vals = right_vs_left{1,1}(:, 2);
left_coh_vals = right_vs_left{2,1}(:, 2);
combined_coh = [right_coh_vals; left_coh_vals];
coh_bins = sort(combined_coh, 'ascend');
coh_bins = unique(coh_bins, 'stable')';

% Create the y variable for the bar plot
coh_accuracy = [];
frequency = [];

% Loop through each coherence level and find the accuracy
for i = 1:length(coh_bins)
    right_group_coh = right_vs_left{1,1}(right_group == i, :);
    right_correct = sum(right_group_coh(:,6)) / size(right_group_coh(:, 2), 1);
    right_freq = size(right_group_coh(:, 2), 1);
    left_group_coh = right_vs_left{2,1}(left_group == i, :);
    left_correct = sum(left_group_coh(:,6)) / size(left_group_coh(:, 2), 1);
    left_freq = size(left_group_coh(:, 2), 1);
    coh_accuracy = [coh_accuracy; right_correct left_correct];
    frequency = [frequency; right_freq left_freq];
end
sz = 10*frequency;
sz(sz==0) = NaN;

% Plot the bar graph and label the axes
figure;
accuracy_graph = plot(coh_bins, coh_accuracy, 'LineWidth', 2, 'MarkerFaceColor', 'g', 'MarkerSize', 15);
hold on
scatter(coh_bins, coh_accuracy, sz, 'MarkerEdgeColor', 'k', 'LineWidth', 2);
title('Accuracy');
xlabel('Coherence Levels');
ylabel('Accuracy');
legend('Leftward trials', 'Rightward trials', 'Location', 'southeast');
ylim([0 1]);
grid on


end
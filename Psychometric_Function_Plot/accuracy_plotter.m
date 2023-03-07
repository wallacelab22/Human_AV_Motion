function [bar_graph] = accuracy_plotter(data_output, right_group, left_group, coherence_lvls)
% Create the x and y variables for the bar plot
coh_bins = findgroups(data_output(:,2));
coh_accuracy = [];

% Loop through each coherence level and find the accuracy
for i = 1:max(coh_bins)
    right_group_coh = right_group(coh_bins == i, :);
    right_correct = sum(right_group_coh(:,6))/size(right_group_coh(:,2), 1);
    left_group_coh = left_group(coh_bins == i, :);
    left_correct = sum(left_group_coh(:,6))/size(left_group_coh(:,2), 1);
    coh_accuracy = [coh_accuracy; left_correct right_correct];
end

% Group left and right coherence together by removing the negative
% coherences (left coherences)
positive_index = coherence_lvls > 0;
coh_bins = coherence_lvls(positive_index);

% Plot the bar graph and label the axes
figure;
bar_graph = bar(coh_bins, coh_accuracy,);
 b.BarWidth = 1.4;
 b.BarSpacing = 0.5;
grid on
title('Accuracy');
xlabel('Coherence Levels');
ylabel('Accuracy');


end
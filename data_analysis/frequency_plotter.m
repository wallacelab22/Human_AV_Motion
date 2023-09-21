function [total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, coherence_counts, coherence_frequency] = frequency_plotter(data_output, right_vs_left)
% Create vector of coherences
coh_bins = (unique(data_output(:,2)))';
coh_bins = sort(coh_bins, 'ascend');

% Initialize a variable to store the frequency counts
coh_counts = zeros(1, length(coh_bins));

% Iterate over the coherences trial by trial and count the frequency of each coherence
for i = 1:length(coh_bins)
    coh_counts(i) = sum(ismember(data_output(:,2), coh_bins(i)));
end

% Create a frequency matrix
total_coh_frequency = vertcat(coh_bins, coh_counts);

% Create vector of coherence levels
right_coh_vals = right_vs_left{1,1}(:, 2);
left_coh_vals = -right_vs_left{2,1}(:, 2);
combined_coh = [right_coh_vals; left_coh_vals];
if size(right_vs_left, 1) >= 3 && size(right_vs_left{3,1}, 2) >= 2
    combined_coh = [right_coh_vals; left_coh_vals; 0];
end
coherence_lvls = sort(combined_coh, 'ascend');
coherence_lvls = unique(coherence_lvls, 'stable')';

coherence_counts = zeros(1, length(coherence_lvls));

for i = 1:length(coherence_lvls)
    if coherence_lvls(i) < 0
        coherence_counts(i) = sum(ismember(right_vs_left{2,1}(:,2), -coherence_lvls(i)));
    elseif coherence_lvls(i) > 0
        coherence_counts(i) = sum(ismember(right_vs_left{1,1}(:,2), coherence_lvls(i)));
    end
end

coherence_frequency = vertcat(coherence_lvls, coherence_counts);

end
function [total_vel_frequency, left_vel_vals, right_vel_vals, velocity_lvls, velocity_counts, velocity_frequency] = vel_frequency_plotter(data_output, right_vs_left)
% Create vector of coherences
vel_bins = (unique(data_output(:,7)))';
vel_bins = sort(vel_bins, 'descend');

% Initialize a variable to store the frequency counts
vel_counts = zeros(1, length(vel_bins));

% Iterate over the coherences trial by trial and count the frequency of each coherence
for i = 1:length(vel_bins)
    vel_counts(i) = sum(ismember(data_output(:,2), vel_bins(i)));
end

% Create a frequency matrix
total_vel_frequency = vertcat(vel_bins, vel_counts);

% Create vector of coherence levels
right_vel_vals = right_vs_left{1,1}(:, 7);
left_vel_vals = -right_vs_left{2,1}(:, 7);
combined_vel = [right_vel_vals; left_vel_vals];
if size(right_vs_left, 1) >= 3 && size(right_vs_left{3,1}, 2) >= 2
    combined_vel = [right_vel_vals; left_vel_vals; 0];
end
velocity_lvls = sort(combined_vel, 'descend');
velocity_lvls = unique(velocity_lvls, 'stable')';

velocity_counts = zeros(1, length(velocity_lvls));

for i = 1:length(velocity_lvls)
    if velocity_lvls(i) < 0
        velocity_counts(i) = sum(ismember(right_vs_left{2,1}(:,7), -velocity_lvls(i)));
    elseif velocity_lvls(i) > 0
        velocity_counts(i) = sum(ismember(right_vs_left{1,1}(:,7), velocity_lvls(i)));
    end
end

velocity_frequency = vertcat(velocity_lvls, velocity_counts);

end
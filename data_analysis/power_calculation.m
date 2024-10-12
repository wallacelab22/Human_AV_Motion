function [cohens_d_paired, required_sample_size] = power_calculation(delta)
% Define the mean and standard deviation of the differences

mean_diff = mean(delta);  % Mean difference between the two conditions
std_diff = std(delta);   % Standard deviation of the differences

% Cohen's D for paired samples
cohens_d_paired = mean_diff / std_diff;
fprintf('Cohen''s D (Paired Samples): %.2f\n', cohens_d_paired);

% Power analysis for paired samples
alpha = 0.05;  % Significance level
power = 0.80;  % Desired power

% Calculate the required sample size for a paired-sample t-test
required_sample_size = sampsizepwr('t', [mean_diff, std_diff], 0, power, [], 'Alpha', alpha);

% Display the result
fprintf('Required sample size for paired t-test: %.2f\n', required_sample_size);

end
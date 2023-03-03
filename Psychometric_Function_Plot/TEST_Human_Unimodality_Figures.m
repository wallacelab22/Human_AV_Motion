%% TEST Human Unimodality Figures %%%%%%%%%%
% written 02/16/23 - Adam Tiesman
clear;
close all;
sca;

% Version info
Version = 'TEST_Human_Visual_v.1.1' ; % after code changes, change version
file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/Psychometric_Function_Plot';
data_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/Psychometric_Function_Plot';
figure_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/Psychometric_Function_Plot/Human_Figures';

% Load the experimental data
load("RDKHoop_stairVis_23_23_03_23.mat");

% Provide specific variables 
chosen_threshold = 0.72; % Ask Mark about threshold
right_var = 1;
left_var = 2;
catch_var = 0;

% Replace all the 0s to 3s for catch trials for splitapply
data_output(data_output(:, 1) == 0, 1) = 3; 

% Replace coherence levels percentages (0-1) to whole number integers (1-5)
% Find the unique values in column 2
unique_vals = unique(data_output(:, 2));

% Initialize a map to keep track of which values have been assigned an integer
val_map = containers.Map('KeyType', 'double', 'ValueType', 'double');

% Initialize a counter variable
counter = 1;

% Loop through the unique values in column 2
for i = 1:length(unique_vals)
    % Get the current value
    curr_val = unique_vals(i);
    
    % Check if the current value has already been assigned an integer
    if isKey(val_map, curr_val)
        % If so, assign the same integer as the previous occurrence
        data_output(data_output(:, 2) == curr_val, 2) = val_map(curr_val);
    else
        % Otherwise, assign a new integer and update the map
        data_output(data_output(:, 2) == curr_val, 2) = counter;
        val_map(curr_val) = counter;
        counter = counter + 1;
    end
end

% Group trials based on stimulus direction--> 1 = right, 2 = left, 3 = catch
right_or_left = data_output(:, 1);
right_vs_left = splitapply(@(x){x}, data_output, right_or_left);

% Isolate coherences for right and left groups and catch
right_group = findgroups(right_vs_left{1,1}(:,2));
left_group = findgroups(right_vs_left{2,1}(:,2));
if size(right_vs_left, 1) >= 3 && size(right_vs_left{3,1}, 2) >= 2
    catch_group = findgroups(right_vs_left{3,1}(:,2));
end

%Initialize an empty array to store rightward_prob for all coherences
rightward_prob = [];

% Loop over each coherence level and extract the corresponding rows of the matrix for
% i = max(left_group):-1:1 for leftward trials
for i = max(left_group):-1:1
    group_rows = right_vs_left{2,1}(left_group == i, :);
    logical_array = group_rows(:, 3) == left_var;
    count = sum(logical_array);
    percentage = 1 - (count/ size(group_rows, 1));
    rightward_prob = [rightward_prob percentage];
end

% Add to the righward_prob vector the catch trials
if size(right_vs_left, 1) >= 3 && size(right_vs_left{3,1}, 2) >= 2
    group_rows = right_vs_left{3,1};
    logical_array = group_rows(:, 3) == right_var;
    count = sum(logical_array);
    percentage = (count/ size(group_rows, 1));
    rightward_prob = [rightward_prob percentage];
end

% Loop over each coherence level and extract the corresponding rows of the matrix for
% i = 1:max(right_group) for rightward trials
for i = 1:max(right_group)
    group_rows = right_vs_left{1,1}(right_group == i, :);
    logical_array = group_rows(:, 3) == right_var;
    count = sum(logical_array);
    percentage = count/ size(group_rows, 1);
    rightward_prob = [rightward_prob percentage];
end

% Create vector of coherence levels
right_coh_vals = right_vs_left{1,1}(:, 2);
left_coh_vals = -right_vs_left{2,1}(:, 2);
combined_coh = [right_coh_vals; left_coh_vals];
coherence_lvls = sort(combined_coh, 'ascend');
coherence_lvls = unique(coherence_lvls, 'stable')';

% Create a Normal Cumulative Distribution Function (NormCDF)
%
% X input : coherence_lvls
% Y input : rightward_prob
%
% Define the mean and standard deviation of the normal distribution
[xData, yData] = prepareCurveData(coherence_lvls, rightward_prob);

mu = mean(yData);
sigma = std(yData);
parms = [mu, sigma];

fun_1 = @(b, x)cdf('Normal', x, b(1), b(2));
fun = @(b)sum((fun_1(b,xData) - yData).^2); 
opts = optimset('MaxFunEvals',50000, 'MaxIter',10000); 
fit_par = fminsearch(fun, parms, opts);

x = min(left_coh_vals):.01:max(right_coh_vals);

[p_values, bootstat, ci] = p_value_calc(yData, parms);

p = cdf('Normal', x, fit_par(1), fit_par(2));

threshold_location = find(p >= chosen_threshold, 1);
threshold = x(1, threshold_location);

% Plot fit with data.
fig = figure( 'Name', 'Psychometric Function' );
scatter(xData, yData)
hold on 
plot(x, p);
legend('% Rightward Resp. vs. Coherence', 'NormCDF', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
% title(sprintf('Auditory Psych. Func. L&R\n%s',save_name), 'Interpreter','none');
xlabel( 'Coherence ((+)Rightward, (-)Leftward)', 'Interpreter', 'none' );
ylabel( '% Rightward Response', 'Interpreter', 'none' );
xlim([min(left_coh_vals) max(right_coh_vals)])
ylim([0 1])
grid on
text(0,.2,"p value for CDF coeffs. (mean): " + p_values(1))
text(0,.1, "p value for CDF coeffs. (std): " + p_values(2))

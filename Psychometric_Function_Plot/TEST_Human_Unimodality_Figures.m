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
load("RDKHoop_psyVis_01_01_02_24.mat");

% Provide specific variables 
chosen_threshold = 0.72; %Ask Mark about threshold

% Replace all the 0s to 3s for catch trials for splitapply
data_output(data_output(:, 1) == 0, 1) = 3; 

%Group trials based on stimulus direction--> 1 = right, 2 = left, 3 = catch
right_or_left = data_output(:, 1);
right_vs_left = splitapply(@(x){x}, data_output, right_or_left);

% Isolate coherences for right and left groups and catch
right_group = findgroups(right_vs_left{1,1}(:,2));
left_group = findgroups(right_vs_left{2,1}(:,2));
catch_group = findgroups(right_vs_left{3,1}(:,2));

%Initialize an empty array to store rightward_prob for all coherences
rightward_prob = [];

% Loop over each coherence level and extract the corresponding rows of the matrix for
% i = max(left_group):-1:1 for leftward trials
for i = max(left_group):-1:1
    group_rows = right_vs_left{2,1}(left_group == i, :);
    left_var = 2;
    logical_array = group_rows(:, 3) == left_var;
    count = sum(logical_array);
    percentage = 1 - (count/ size(group_rows, 1));
    rightward_prob = [rightward_prob percentage];
end

% Add to the righward_prob vector the catch trials
group_rows = right_vs_left{3,1};
right_var = 1;
logical_array = group_rows(:, 3) == right_var;
count = sum(logical_array);
percentage = (count/ size(group_rows, 1));
rightward_prob = [rightward_prob percentage];

% Loop over each coherence level and extract the corresponding rows of the matrix for
% i = 1:max(right_group) for rightward trials
for i = 1:max(right_group)
    group_rows = right_vs_left{1,1}(right_group == i, :);
    right_var = 1;
    logical_array = group_rows(:, 3) == right_var;
    count = sum(logical_array);
    percentage = count/ size(group_rows, 1);
    rightward_prob = [rightward_prob percentage];
end

% Display prob of right response at each coherence from -5 to 5 (neg being
% leftward trials and pos being rightward trials)
coherence_lvls = [-5, -4, -3, -2, -1, 0, 1, 2, 3 , 4, 5];
scatter(coherence_lvls, rightward_prob);

% Add title and labels to the x and y axis
xlabel('Coherence Level');
ylabel('Rightward Response Probability');
title('TEST Human Visual Psychometric Plot');

% Create a Normal Cumulative Distribution Function (NormCDF)
%
% X input : coherence_lvls
% Y input : rightward_prob
%
% Define the mean and standard deviation of the normal distribution
[xData, yData] = prepareCurveData(coherence_lvls, rightward_prob)

mu = mean(yData);
sigma = std(yData);
parms = [mu, sigma]

fun_1 = @(b, x)cdf('Normal', x, b(1), b(2));
fun = @(b)sum((fun_1(b,xData) - yData).^2); 
opts = optimset('MaxFunEvals',50000, 'MaxIter',10000); 
fit_par = fminsearch(fun, parms, opts);

x = -1:.01:1;

[p_values, bootstat, ci] = p_value_calc(yData, parms);

threshold_location = find(p >= chosen_threshold, 1);
threshold = x(1, threshold_location);


% Calculate the CDF for each value of x
y = normcdf(rightward_prob, mu, sigma);

% Plot the CDF
plot(coherence_lvls, y);

% Add labels to the x-axis and y-axis
xlabel('Coherence Levels');
ylabel('Cumulative Probability');

% Add a title to the plot
title('Normal Cumulative Distribution Function');

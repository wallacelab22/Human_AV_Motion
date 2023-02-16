%% TEST Human Visual Figures %%%%%%%%%%
% written 02/16/23 - Adam Tiesman
clear all;
close all;
sca;

% Version info
Version = 'TEST_Human_Visual_v.1.0' ; % after code changes, change version
file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/Psychometric_Function_Plot';
data_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/Psychometric_Function_Plot';
figure_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/Psychometric_Function_Plot/Human_Figures';

% Add the experimental data to path
load("RDKHoop_psyVis_01_01_02_24.mat");

% Provide specific variables 
chosen_threshold = 0.72; %Ask Mark about threshold

% Replace all the 0s to 3s for catch trials for splitapply
data_output(data_output(:, 1) == 0, 1) = 3; 

%Group trials based on stimulus--> 1 = right, 2 = left, 3 = catch
% right_or_left = data_output(:, 1);
% right_vs_left = splitapply(@(x){x}, data_output, right_or_left);

% Group the rows by the coherences
groups = findgroups(data_output(:,2));

% Loop over each coherence level and extract the corresponding rows of the matrix for
% i = 1:max(groups)
for i = 1:max(groups)
    group_rows = data_output(groups == i, :);
    right_or_left = group_rows(:, 3);
    right_vs_left = splitapply(@(x){x}, group_rows, right_or_left);
    disp(right_vs_left)
end

% Display the groups
disp(groups_rows)

% Provide coherence levels
coherences = 0:0.01:1;

% Define the psychometric function parameters
threshold = 0.5;  % coherence at which probability of rightward response is 50%
slope = 2;        % slope of the psychometric function
guess = 0.5;      % probability of rightward response for zero coherence
lapse = 0.05;     % probability of a random incorrect response

% Define the psychometric function
prob_right = guess + (1 - guess - lapse) * (1 - 1./(1+exp(slope*(threshold-coherences))));

% Plot the psychometric function
plot(coherences, prob_right, 'LineWidth', 2);

% Set axis labels and plot title
xlabel('Coherence');
ylabel('Probability of rightward response');
title('Psychometric Function');
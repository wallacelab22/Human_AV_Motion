%% TEST Human Multimodality Figures %%%%%%%%%%
% written on 02/21/23 - Adam Tiesman
clear;
close all;
sca;

% Version info
Version = 'TEST_Human_Visual_v.1.1' ; % after code changes, change version
file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/Psychometric_Function_Plot';
data_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/Psychometric_Function_Plot';
figure_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/Psychometric_Function_Plot/Human_Figures';

% Load the experimental data
% load("PUT EXP DATA FOR AV TRIAL HERE")
data_output = randi([0 9], 250, 7)

% Provide specific variables
chosen_threshold = 0.72; % Ask Mark about threshold
right_var = 1;
left_var = 2;

% Replace all the 0s to 3s for catch trials for splitapply
data_output(data_output(:, 1) == 0, 1) = 3; 

% Extract and separate congruent AV trials from incongruent AV tirals
idx = data_output(:,1) == data_output(:,3);
congruent_trials = data_output(idx, :);
incongruent_trials = data_output(~idx, :);

% Group trials based on stimulus direction --> 1 = right, 
% 2 = left, 3 = catch
right_or_left = congruent_trials(:, 1);
right_vs_left = splitapply(@(x){x}, congruent_trials, right_or_left);

% Isolate coherences for right and left groups and catch
right_group = findgroups(right_vs_left{1,1}(:,2));
left_group = findgroups(right_vs_left{2,1}(:,2));
catch_group = findgroups(right_vs_left{3,1}(:,2));

% Initialize an empty array to store rightward_prob for all coherences
rightward_prob = [];




%% TEST Human Multimodality Figures %%%%%%%%%%
% written on 02/21/23 - Adam Tiesman
clear;
close all;
sca;

% Version info
Version = 'TEST_Human_Multisensory_v.1.1' ; % after code changes, change version
file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/Psychometric_Function_Plot';
data_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/Psychometric_Function_Plot';
figure_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/Psychometric_Function_Plot/Human_Figures';

% Load the experimental data --> load("PUT EXP DATA FOR AV TRIAL HERE")
data = input('Enter data file: ');
load(data);
save_name = data;
data_output = MAT;

% Provide specific variables
chosen_threshold = 0.72; % Ask Mark about threshold
right_var = 1;
left_var = 2;
catch_var = 0;

% Replace all the 0s to 3s for catch trials for splitapply
data_output(data_output(:, 1) == 0, 1) = 3;
data_output(data_output(:, 3) == 0, 1) = 3;

% Extract and separate AV congruent trials from AV incongruent trials
idx = data_output(:,1) == data_output(:,3);
congruent_trials = data_output(idx, :);
incongruent_trials = data_output(~idx, :);

% Group AV congruent trials based on stimulus direction --> 1 = right,
% 2 = left, and 3 = catch
[groups, values] = findgroups(congruent_trials(:, 1));

% Create a cell with 3 groups based on stimulus direction
stimulus_direction = cell(numel(values), 1);
for i = 1:numel(values)
    idx = groups == i;
    matrix = congruent_trials(idx, :);
    stimulus_direction{i} = matrix;
end

% Group trials again based on AUDITORY coherence for AV congruent 
% RIGHTWARD motion --> 1 = lowest coherence, 7 = highest coherence
[groups, values] = findgroups(stimulus_direction{1,1}(:, 2));

% Create a cell with 7 groups based on AUDITORY coherence for AV congruent
% RIGHTWARD motion
right_auditory_coherence = cell(numel(values), 1);
for i = 1:numel(values)
    idx = groups == i;
    matrix = stimulus_direction{1,1}(idx, :);
    right_auditory_coherence{i} = matrix;
end

% Group trials again based on AUDITORY coherence for LEFTWARD motion --> 
% 1 = lowest coherence, 5 = highest coherence
[groups, values] = findgroups(stimulus_direction{2,1}(:, 2));

% Create a cell with 5 groups based on AUDITORY coherence for AV congruent 
% LEFTWARD motion
left_auditory_coherence = cell(numel(values), 1);
for i = 1:numel(values)
    idx = groups == i;
    matrix = stimulus_direction{2,1}(idx, :);
    left_auditory_coherence{i} = matrix;
end

% % Isolate VISUAL coherences for right and left groups and catch
% rightcoh1_group = findgroups(right_auditory_coherence{1,1}(:,4));
% rightcoh2_group = findgroups(right_auditory_coherence{2,1}(:,4));
% rightcoh3_group = findgroups(right_auditory_coherence{3,1}(:,4));
% rightcoh4_group = findgroups(right_auditory_coherence{4,1}(:,4));
% rightcoh5_group = findgroups(right_auditory_coherence{5,1}(:,4));
% 
% leftcoh1_group = findgroups(left_auditory_coherence{1,1}(:,4));
% leftcoh2_group = findgroups(left_auditory_coherence{2,1}(:,4));
% leftcoh3_group = findgroups(left_auditory_coherence{3,1}(:,4));
% leftcoh4_group = findgroups(left_auditory_coherence{4,1}(:,4));
% leftcoh5_group = findgroups(left_auditory_coherence{5,1}(:,4));

% catch_group = findgroups(stimulus_direction(:,4));% this should all be 0

% Initialize an empty arrays to store rightward_prob for all coherences at
% varying auditory coherences

right_group = findgroups(stimulus_direction{1,1}(:,2));
left_group = findgroups(stimulus_direction{2,1}(:,2));

rightward_prob = multisensory_rightward_prob_calc(stimulus_direction, right_group, left_group, right_var, left_var);


% Create vector of coherence levels
right_coh_vals = stimulus_direction{1,1}(:,2);
left_coh_vals = -stimulus_direction{2,1}(:,2);
combined_coh = [right_coh_vals; left_coh_vals];
if size(stimulus_direction, 1) >= 3 && size(stimulus_direction{3,1}, 2) >= 2
    combined_coh = [right_coh_vals; left_coh_vals; 0];
end
coherence_lvls = sort(combined_coh, 'ascend');
coherence_lvls = unique(coherence_lvls, 'stable');

%% Create a Normal Cumulative Distribution Function (normCDF)
normCDF_plotter(coherence_lvls, rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, save_name);





rightward_prob_coh = {};

for i = 1:5
    for j = 5:-1:1
    rightward_prob_coh = rightward_prob_calc(stimulus_direction,... 
                                             right_auditory_coherence{i, 1},...
                                             left_auditory_coherence{j, 1},...
                                             right_var,...
                                             left_var);
    end
end



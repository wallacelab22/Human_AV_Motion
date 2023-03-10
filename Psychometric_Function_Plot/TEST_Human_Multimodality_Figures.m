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

% Load the experimental data --> load("PUT EXP DATA FOR AV TRIAL HERE")
load('RDKHoop_psyAV_18_03_1_20.mat')
data_output = MAT;

% Provide specific variables
chosen_threshold = 0.72; % Ask Mark about threshold
right_var = 1;
left_var = 2;
catch_var = 0;

% Extract and separate AV congruent trials from AV incongruent trials
idx = data_output(:,1) == data_output(:,3);
congruent_trials = data_output(idx, :);
incongruent_trials = data_output(~idx, :);

% Group AV congruent trials based on stimulus direction --> 1 = right,
% 2 = left, and 0 = catch
[groups, values] = findgroups(congruent_trials(:, 1));

% Create a cell with 3 groups based on stimulus direction
stimulus_direction = cell(numel(values), 1);
for i = 1:numel(values)
    idx = groups == i;
    matrix = congruent_trials(idx, :);
    stimulus_direction{i} = matrix;
end

% Group trials again based on AUDITORY coherence for AV congruent 
% RIGHTWARD motion --> 1 = lowest coherence, 5 = highest coherence
[groups, values] = findgroups(stimulus_direction{2,1}(:, 2));

% Create a cell with 5 groups based on AUDITORY coherence for AV congruent
% RIGHTWARD motion
right_auditory_coherence = cell(numel(values), 1);
for i = 1:numel(values)
    idx = groups == i;
    matrix = stimulus_direction{2,1}(idx, :);
    right_auditory_coherence{i} = matrix;
end

% Group trials again based on AUDITORY coherence for LEFTWARD motion --> 
% 1 = lowest coherence, 5 = highest coherence
[groups, values] = findgroups(stimulus_direction{3,1}(:, 2));

% Create a cell with 5 groups based on AUDITORY coherence for AV congruent 
% LEFTWARD motion
left_auditory_coherence = cell(numel(values), 1);
for i = 1:numel(values)
    idx = groups == i;
    matrix = stimulus_direction{3,1}(idx, :);
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

% catc_group = findgroups(stimulus_direction(:,4));% this should all be 0

% Initialize an empty arrays to store rightward_prob for all coherences at
% varying auditory coherences

rightward_prob_coh = {};

for i = 1:5
    for j = 5:-1:1
    rightward_prob_coh = rightward_prob_calc(stimulus_direction,... 
                                             right_auditory_coherence{i, 1},...
                                             left_auditory_coherence{j, 1},...
                                             right_var,...
                                             left_var,...
                                             rightward_prob_coh);
    end
end

% % Loop over each coherence level and extract the corresponding rows of the matrix for
% % i = max(left_group):-1:1 for leftward trials
% for i = max(left_group):-1:1
%     group_rows = right_vs_left{2,1}(left_group == i, :);
%     logical_array = group_rows(:, 3) == left_var;
%     count = sum(logical_array);
%     percentage = 1 - (count/ size(group_rows, 1));
%     rightward_prob = [rightward_prob percentage];
% end
% 
% % Add to the righward_prob vector the catch trials
% group_rows = right_vs_left{3,1};
% logical_array = group_rows(:, 3) == right_var;
% count = sum(logical_array);
% percentage = (count/ size(group_rows, 1));
% rightward_prob = [rightward_prob percentage];
% 
% % Loop over each coherence level and extract the corresponding rows of the matrix for
% % i = 1:max(right_group) for rightward trials
% for i = 1:max(right_group)
%     group_rows = right_vs_left{1,1}(right_group == i, :);
%     logical_array = group_rows(:, 3) == right_var;
%     count = sum(logical_array);
%     percentage = count/ size(group_rows, 1);
%     rightward_prob = [rightward_prob percentage];
% end


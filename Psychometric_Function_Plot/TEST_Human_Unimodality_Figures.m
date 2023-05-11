%% TEST Human Unimodality Figures %%%%%%%%%%
% written 02/16/23 - Adam Tiesman
clear all;
close all;

% Version info
Version = 'TEST_Human_Unimodal_v.2.0' ; % after code changes, change version
task_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion';
script_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/Psychometric_Function_Plot';
data_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/data';
figure_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/Psychometric_Function_Plot/Human_Figures';

cd(data_file_directory)

%% Load the experimental data
subjnum = input('Enter the subject''s number: ');
subjnum_s = num2str(subjnum);
if length(subjnum_s) < 2
    subjnum_s = strcat(['0' subjnum_s]);
end
group = input('Enter the test group: ');
group_s = num2str(group);
if length(group_s) < 2
    group_s = strcat(['0' group_s]);
end
sex = input('Enter the subject''s sex (1 = female; 2 = male): ');
sex_s=num2str(sex);
if length(sex_s) < 2
    sex_s = strcat(['0' sex_s]);
end
age = input('Enter the subject''s age: ');
age_s=num2str(age);
if length(age_s) < 2
    age_s = strcat(['0' age_s]);
end

block = input('1 = stairAud, 2 = stairVis, 3 = psyAud, 4 = psyVis, 5 = trainAud, 6 = trainVis ');
if block == 1
    block_analysis = 'stairAud';
elseif block == 2
    block_analysis = 'stairVis';
elseif block == 3
    block_analysis = 'psyAud';
elseif block == 4
    block_analysis = 'psyVis';
elseif block == 5
    block_analysis = 'trainAud';
elseif block == 6
    block_analysis = 'trainVis';
end

underscore = '_';
save_name = strcat('RDKHoop_', block_analysis, underscore, subjnum_s, ...
    underscore, group_s, underscore, sex_s, underscore, age_s);
identifier = strcat(subjnum_s, underscore, group_s, underscore, sex_s, underscore, age_s);
sprintf(save_name);
load(save_name);


cd(script_file_directory)
%% Provide specific v4ariables 
chosen_threshold = 0.72;
right_var = 1;
left_var = 2;
catch_var = 0;
compare_plot = input('Psychometric Function Comparison? 0 for NO, 1 for YES: ');
coh_change = input('Coherence level to coherence correction? 0 for No, 1 for YES: ');

% Replace all the 0s to 3s for catch trials for splitapply
data_output(data_output(:, 1) == 0, 1) = 3; 

if coh_change == 1
    data_output = coh_level_correction(data_output, script_file_directory, task_file_directory, save_name);
end

%% Split the data by direction of motion for the trial
[right_vs_left, right_group, left_group] = direction_plotter(data_output);

%% Loop over each coherence level and extract the corresponding rows of the matrix for leftward, catch, and rightward trials
rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);

%% Create frequency count for each coherence level
[total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, coherence_counts, coherence_frequency] = frequency_plotter(data_output, right_vs_left);

%% Create a graph of percent correct at each coherence level
accuracy_plotter(right_vs_left, right_group, left_group, save_name);

%% Create a stairstep graph for visualizing staircase
if contains(save_name, 'stair') || contains(save_name, 'train')
    stairstep_plotter(data_output, save_name);
end

%% Compare CDF plots
if compare_plot == 1
    fig = figure('Name', sprintf('%s CDF Comparison ', identifier));
    % Generate a figure comparing psychometric curves
    compare_figure = compare_plotter(compare_plot, coh_change, ...
        data_file_directory, script_file_directory, task_file_directory, ...
        subjnum_s, group_s, sex_s, age_s, identifier, save_name);
elseif compare_plot == 0
    normCDF_plotter(coherence_lvls, rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, coherence_frequency, compare_plot, save_name);
end





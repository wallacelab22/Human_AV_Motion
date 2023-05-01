%% TEST Human Unimodality Figures %%%%%%%%%%
% written 02/16/23 - Adam Tiesman
clear all;
%close all;

% Version info
Version = 'TEST_Human_Unimodal_v.2.0' ; % after code changes, change version
file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/Psychometric_Function_Plot';
data_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/Psychometric_Function_Plot';
figure_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/Psychometric_Function_Plot/Human_Figures';

% Load the experimental data
data = input('Enter data file: ');
load(data);
save_name = data;

% Provide specific variables 
chosen_threshold = 0.72;
right_var = 1;
left_var = 2;
catch_var = 0;

% % Replace all the 0s to 3s for catch trials for splitapply
% data_output(data_output(:, 1) == 0, 1) = 3; 

% %  Replace coherence levels percentages (0-1) to whole number integers (1-5)
% if data_output(:, 2) <= 1
%     unique_vals = unique(data_output(:, 2));
%     val_map = containers.Map('KeyType', 'double', 'ValueType', 'double');
%     counter = 1;
%     for i = 1:length(unique_vals)
%         curr_val = unique_vals(i);
%         
%         if isKey(val_map, curr_val)
%             data_output(data_output(:, 2) == curr_val, 2) = val_map(curr_val);
%         else
%             data_output(data_output(:, 2) == curr_val, 2) = counter;
%             val_map(curr_val) = counter;
%             counter = counter + 1;
%         end
%     end 
% end

%% Split the data by direction of motion for the trial
[right_vs_left, right_group, left_group] = direction_plotter(data_output);

%% Loop over each coherence level and extract the corresponding rows of the matrix for leftward, catch, and rightward trials
rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);

%% Create frequency count for each coherence level
[total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, coherence_counts, coherence_frequency] = frequency_plotter(data_output, right_vs_left);

%% Create a graph of percent correct at each coherence level
accuracy_plotter(right_vs_left, right_group, left_group, save_name);

%% Create a Normal Cumulative Distribution Function (NormCDF)
normCDF_plotter(coherence_lvls, rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, coherence_frequency, save_name);

%% Create a stairstep graph for visualizing staircase
stairstep_plotter(data_output, save_name);



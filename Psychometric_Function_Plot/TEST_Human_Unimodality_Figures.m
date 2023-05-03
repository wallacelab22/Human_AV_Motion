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

block = input('1 = stairAud, 2 = stairVis, 3 = psyAud, 4 = psyVis? ');
if block == 1
    block_analysis = 'stairAud';
elseif block == 2
    block_analysis = 'stairVis';
elseif block == 3
    block_analysis = 'psyAud';
elseif block == 4
    block_analysis = 'psyVis';
end

underscore = '_';
save_name = strcat('RDKHoop_',block_analysis,underscore,subjnum_s,underscore,group_s, underscore, sex_s, underscore, age_s);
sprintf(save_name)
load(save_name)

% % Load the experimental data
% data = input('Enter data file: ');
% load(data);
% save_name = data;

cd(script_file_directory)
% Provide specific variables 
chosen_threshold = 0.72;
right_var = 1;
left_var = 2;
catch_var = 0;
compare_plot = input('Psychometric Function Comparison? 0 for NO, 1 for YES: ');
coh_level_to_coh = input('Coherence level to coherence correction? 0 for No, 1 for YES: ');

% Replace all the 0s to 3s for catch trials for splitapply
data_output(data_output(:, 1) == 0, 1) = 3; 

if coh_level_to_coh == 1
    data_output = coh_level_correction(data_output, script_file_directory, task_file_directory, save_name);
end

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
%accuracy_plotter(right_vs_left, right_group, left_group, save_name);

%% Create a Normal Cumulative Distribution Function (NormCDF)
normCDF_plotter(coherence_lvls, rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, coherence_frequency, compare_plot, save_name);

%% Create a stairstep graph for visualizing staircase
if contains(save_name, 'stair')
    stairstep_plotter(data_output, save_name);
end

% %% Compare plots
% if compare_plot == 1
%     % Find the positions of the underscores in the input string
%     underscore_pos = strfind(save_name, '_');
%     % Extract the numerical substrings based on their positions
%     subjnum_s = save_name(underscore_pos(2)+1:underscore_pos(2)+2);
%     group_s = save_name(underscore_pos(3)+1:underscore_pos(3)+2);
%     sex_s = save_name(underscore_pos(4)+1:underscore_pos(4)+2);
%     age_s = save_name(underscore_pos(5)+1:underscore_pos(5)+2);
%     % Generate a figure comparing psychometric curves
%     compare_figure = compare_plotter(compare_plot, data_file_directory, script_file_directory, ...
%     subjnum_s, group_s, sex_s, age_s, save_name);
% end





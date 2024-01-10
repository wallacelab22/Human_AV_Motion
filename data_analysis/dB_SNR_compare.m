%% 1, 3, and 6 db SNR plot comparison
% written 05/04/23 - Adam Tiesman
% x = 1 dB SNR
% y = 3 dB SNR
% z = 6 dB SNR
%
% Auditory and Visual CDF comparison are showing normal Vis stim and z dB
% SNR Aud stim

clear all;
close all;

% Version info
Version = 'PILOT db SNR comparisons' ; % after code changes, change version
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

%% Provide specific variables 
chosen_threshold = 0.72;
right_var = 1;
left_var = 2;
catch_var = 0;
compare_plot = 1;
coh_change = 0;

%% Plot auditory staircase at x dB SNR
cd(data_file_directory)
xdB_filename = sprintf('RDKHoop_stairAud_%s_05_%s_%s.mat', subjnum_s, sex_s, age_s);
load(xdB_filename, 'data_output');
save_name = xdB_filename;
cd(script_file_directory)
[right_vs_left, right_group, left_group] = direction_plotter(data_output);
rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
[total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, ...
    coherence_counts, coherence_frequency] = frequency_plotter(data_output, right_vs_left);
[fig, p_values, ci, threshold, xData, yData, x, p, sz] = normCDF_plotter(coherence_lvls, ...
rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
coherence_frequency, compare_plot, save_name);
scatter(xData, yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', [0.9290,0.6940,0.1250], 'HandleVisibility', 'off');
hold on
plot(x, p, 'LineWidth', 3, 'Color', [0.9290,0.6940,0.1250], 'DisplayName', '1 dB SNR');

%% Plot auditory staircase at y dB SNR
cd(data_file_directory)
ydB_filename = sprintf('RDKHoop_stairAud_%s_04_%s_%s.mat', subjnum_s, sex_s, age_s);
load(ydB_filename, 'data_output');
save_name = ydB_filename;
cd(script_file_directory)
[right_vs_left, right_group, left_group] = direction_plotter(data_output);
rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
[total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, ...
    coherence_counts, coherence_frequency] = frequency_plotter(data_output, right_vs_left);
[fig, p_values, ci, threshold, xData, yData, x, p, sz] = normCDF_plotter(coherence_lvls, ...
rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
coherence_frequency, compare_plot, save_name);
scatter(xData, yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', [0.3010, 0.7450, 0.9330], 'HandleVisibility', 'off');
hold on
plot(x, p, 'LineWidth', 3, 'Color', [0.3010, 0.7450, 0.9330], 'DisplayName', '3 dB SNR');

%% Plot auditory staircase at z dB SNR
cd(data_file_directory)
zdB_filename = sprintf('RDKHoop_stairAud_%s_03_%s_%s.mat', subjnum_s, sex_s, age_s);
load(zdB_filename, 'data_output');
save_name = zdB_filename;
cd(script_file_directory)
[right_vs_left, right_group, left_group] = direction_plotter(data_output);
rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
[total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, ...
    coherence_counts, coherence_frequency] = frequency_plotter(data_output, right_vs_left);
[fig, p_values, ci, threshold, xData, yData, x, p, sz] = normCDF_plotter(coherence_lvls, ...
rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
coherence_frequency, compare_plot, save_name);
scatter(xData, yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', [0.6350, 0.0780, 0.1840], 'HandleVisibility', 'off');
hold on
plot(x, p, 'LineWidth', 3, 'Color', [0.6350, 0.0780, 0.1840], 'DisplayName', '6 dB SNR');

%% Set figure properties
title(sprintf('Psych. Comparison Function: \n %s',save_name), 'Interpreter','none');
legend('Location', 'NorthWest', 'Interpreter', 'none');
xlabel( 'Coherence ((+)Rightward, (-)Leftward)', 'Interpreter', 'none');
ylabel( '% Rightward Response', 'Interpreter', 'none');
xlim([min(left_coh_vals) max(right_coh_vals)])
ylim([0 1])
grid on
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)

%% Compare Auditory staircase at z dB SNR to Visual staircase
group_s = '03';
underscore = '_';
identifier = strcat(subjnum_s, underscore, group_s, underscore, sex_s, underscore, age_s);
fig = figure('Name', sprintf('%s CDF Comparison ', identifier));
% Generate a figure comparing psychometric curves
compare_figure = compare_plotter(compare_plot, coh_change, ...
    data_file_directory, script_file_directory, task_file_directory, ...
    subjnum_s, group_s, sex_s, age_s, identifier, save_name);
legend('6 dB Aud', 'Normal Vis', 'Location', 'NorthWest', 'Interpreter', 'none');

%% Compare normal Visual staircase and pixel size change Visual staircase

% Provide specific variables 
chosen_threshold = 0.72;
right_var = 1;
left_var = 2;
catch_var = 0;
compare_plot = 1;
coh_change = 0;
fig = figure('Name', sprintf('%s Visual Staircase Comparison', identifier));

%Plot normal visual staircase
cd(data_file_directory)
normVis_filename = sprintf('RDKHoop_stairVis_%s_03_%s_%s.mat', subjnum_s, sex_s, age_s);
load(normVis_filename, 'data_output');
save_name = normVis_filename;
cd(script_file_directory)
[right_vs_left, right_group, left_group] = direction_plotter(data_output);
rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
[total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, ...
    coherence_counts, coherence_frequency] = frequency_plotter(data_output, right_vs_left);
[fig, p_values, ci, threshold, xData, yData, x, p, sz] = normCDF_plotter(coherence_lvls, ...
rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
coherence_frequency, compare_plot, save_name);
scatter(xData, yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', [0.6350, 0.0780, 0.1840], 'HandleVisibility', 'off');
hold on
plot(x, p, 'LineWidth', 3, 'Color', [0.6350, 0.0780, 0.1840], 'DisplayName', 'norm Vis');

% Plot pixel size change visual staircase
cd(data_file_directory)
pixVis_filename = sprintf('RDKHoop_stairVis_%s_04_%s_%s.mat', subjnum_s, sex_s, age_s);
load(pixVis_filename, 'data_output');
save_name = pixVis_filename;
cd(script_file_directory)
[right_vs_left, right_group, left_group] = direction_plotter(data_output);
rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
[total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, ...
    coherence_counts, coherence_frequency] = frequency_plotter(data_output, right_vs_left);
[fig, p_values, ci, threshold, xData, yData, x, p, sz] = normCDF_plotter(coherence_lvls, ...
rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
coherence_frequency, compare_plot, save_name);
scatter(xData, yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', [0.9290,0.6940,0.1250], 'HandleVisibility', 'off');
hold on
plot(x, p, 'LineWidth', 3, 'Color', [0.9290,0.6940,0.1250], 'DisplayName', 'Increase pixel size Vis');

% Set figure properties
title(sprintf('Visual Staircase Comparison Function: \n %s',save_name), 'Interpreter','none');
legend('Location', 'NorthWest', 'Interpreter', 'none');
xlabel( 'Coherence ((+)Rightward, (-)Leftward)', 'Interpreter', 'none');
ylabel( '% Rightward Response', 'Interpreter', 'none');
xlim([min(left_coh_vals) max(right_coh_vals)])
ylim([0 1])
grid on
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)

clear;
close all;
clc;

%% Set variables
SEVEN = 1;
vel_stair = 0;

%% Load the data
task_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/';
script_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/data_analysis/';
data_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/data/';
figure_file_directory = '/Users/a.tiesman/Documents/Research/Meeting_figures/';

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

cd(data_file_directory)
if SEVEN
    psyAV_filename = sprintf('RDKHoop_psyAV_%s_16_%s_%s.mat', subjnum_s, sex_s, age_s);
else
    psyAV_filename = sprintf('RDKHoop_psyAV_%s_15_%s_%s.mat', subjnum_s, sex_s, age_s);
end
load(psyAV_filename)
cd(script_file_directory)

PERFvsSTIM_accuracy_plotter(data_output, subjnum_s, group_s);

clear data_output
cd(data_file_directory)

if SEVEN
    stairAud_filename = sprintf('RDKHoop_stairAud_%s_16_%s_%s.mat', subjnum_s, sex_s, age_s);
else
    stairAud_filename = sprintf('RDKHoop_stairAud_%s_15_%s_%s.mat', subjnum_s, sex_s, age_s);
end
load(stairAud_filename)
save_name = 'stairAud';
dataAud = data_output;

for i = 1:length(dataAud)
    if dataAud(i, 2:7) == 0
        stopRow = i;
        break;
    end
end

dataAud = dataAud(1:stopRow-1, :);

cd(script_file_directory)
stairstep_plotter(dataAud, save_name, vel_stair);
cd(data_file_directory)

clear save_name
clear data_output

if SEVEN
    stairVis_filename = sprintf('RDKHoop_stairVis_%s_16_%s_%s.mat', subjnum_s, sex_s, age_s);
else
    stairVis_filename = sprintf('RDKHoop_stairVis_%s_15_%s_%s.mat', subjnum_s, sex_s, age_s);
end
load(stairVis_filename)
save_name = 'stairVis';
dataVis = data_output;

for i = 1:length(dataVis)
    if dataVis(i, 2:7) == 0
        stopRow = i;
        break;
    end
end

dataVis = dataVis(1:stopRow-1, :);

cd (script_file_directory)
stairstep_plotter(dataVis, save_name, vel_stair);
cd(data_file_directory)

clear save_name
clear data_output

cd(script_file_directory)

save_name = 'stair';
dataALL = {};
dataALL{1}.dataRaw = dataAud;
dataALL{2}.dataRaw = dataVis;

right_var = 1;
left_var = 2;
catch_var = 0;
chosen_threshold = 0.72;
compare_plot = 0;
vel_stair = 0;

fig = figure('Name', sprintf('%d_%d CDF Comparison ', subjnum, 16));

for i = 1:2
    dataALL{i}.dataRaw(dataALL{i}.dataRaw(:, 1) == 0, 1) = 3; 
    [right_vs_left, right_group, left_group] = direction_plotter(dataALL{i}.dataRaw);
    rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
    [total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, coherence_counts, coherence_frequency] = frequency_plotter(dataALL{i}.dataRaw, right_vs_left);
    [fig, p_values, ci, threshold, dataALL{i}.xData, dataALL{i}.yData, x, p, sz, dataALL{i}.std_gaussian, dataALL{i}.mdl] = normCDF_plotter(coherence_lvls, ...
    rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
    coherence_frequency, compare_plot, save_name, vel_stair);    
    if i == 1
        scatter(dataALL{i}.xData, dataALL{i}.yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'r', 'HandleVisibility', 'off');
        hold on
        plot(x, p, 'LineWidth', 3, 'Color', 'r', 'DisplayName', 'Aud unisensory');
    elseif i == 2
        scatter(dataALL{i}.xData, dataALL{i}.yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'b', 'HandleVisibility', 'off');
        hold on
        plot(x, p, 'LineWidth', 3, 'Color', 'b', 'DisplayName', 'Vis unisensory');
    end
end

%% Set figure properties
title(sprintf('Psych. Function Comparison: \n %s %s', subjnum_s, group_s), 'Interpreter','none');
legend('Location', 'NorthWest', 'Interpreter', 'none');
xlabel( 'Coherence ((-)Leftward, (+)Rightward)', 'Interpreter', 'none');
ylabel( '% Rightward Response', 'Interpreter', 'none');
xlim([-1 1])
axis equal
ylim([0 1])
grid on
text(0,0.2,"aud cumulative gaussian std: " + dataALL{1}.std_gaussian)
text(0,0.15,"vis cumulative gaussian std: " + dataALL{2}.std_gaussian)
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)

beautifyplot;
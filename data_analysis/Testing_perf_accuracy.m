clear;
close all;
clc;

%% Set variables
vel_stair = 0;
save_fig = 0;
estimated_AV = 1;

%% Load the data
task_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/';
script_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/data_analysis/';
data_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/data/';
figure_file_directory = '/Volumes/WallaceLab/AdamTiesman/individual_figures_IMRF';
addpath('/Volumes/WallaceLab/AdamTiesman/individual_figures_IMRF')
addpath('/Users/a.tiesman/Documents/Research/Human_AV_Motion/data_analysis/RSE-box-master');
addpath('/Users/a.tiesman/Documents/Research/Human_AV_Motion/data_analysis/RSE-box-master/analysis');


%% Load the experimental data
subjnum = input('Enter the subject''s number: ');
subjnum_s = num2str(subjnum);
if length(subjnum_s) < 2
    subjnum_s = strcat(['0' subjnum_s]);
end
group = input('Enter the subject''s group: ');
group_s = num2str(group);
if length(group_s) < 2
    group_s = strcat(['0' group_s]);
end
sex = input('Enter the subject''s sex (1 = female; 2 = male): ');
sex_s = num2str(sex);
if length(sex_s) < 2
    sex_s = strcat(['0' sex_s]);
end
age = input('Enter the subject''s age: ');
age_s = num2str(age);
if length(age_s) < 2
    age_s = strcat(['0' age_s]);
end

cd(data_file_directory)
psyAV_filename = sprintf('RDKHoop_psyAV_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
load(psyAV_filename)
cd(script_file_directory)

[boxplot_accuracies, violation, gain, aud_coh, vis_coh, AV_accuracy_CDF_points] = PERFvsSTIM_accuracy_plotter(data_output, subjnum_s, group_s, figure_file_directory, save_fig);

clear data_output
cd(data_file_directory)
stairAud_filename = sprintf('RDKHoop_stairAud_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
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
%stairstep_plotter(dataAud, save_name, vel_stair);
cd(data_file_directory)

clear save_name
clear data_output

stairVis_filename = sprintf('RDKHoop_stairVis_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
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
%stairstep_plotter(dataVis, save_name, vel_stair);
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

if estimated_AV
    plot_num = 3;
else
    plot_num = 2;
end
for i = 1:plot_num
    if i == 1 || i == 2
        dataALL{i}.dataRaw(dataALL{i}.dataRaw(:, 1) == 0, 1) = 3; 
        [right_vs_left, right_group, left_group] = direction_plotter(dataALL{i}.dataRaw);
        rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
        [total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, coherence_counts, coherence_frequency] = frequency_plotter(dataALL{i}.dataRaw, right_vs_left);
        [fig, p_values, ci, threshold, dataALL{i}.xData, dataALL{i}.yData, x, p, sz, dataALL{i}.std_gaussian, dataALL{i}.mdl] = normCDF_plotter(coherence_lvls, ...
        rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
        coherence_frequency, compare_plot, save_name, vel_stair);    
    elseif i == 3
        [Results_MLE] = MLE_Calculations_A_V(dataALL{1}.mdl, dataALL{2}.mdl, dataALL{1}.yData, dataALL{2}.yData, dataALL{1}.xData, dataALL{2}.xData);
        plotEstimatedAV(Results_MLE.AV_EstimatedSD, [dataALL{1}.mdl.Coefficients{1,1} dataALL{2}.mdl.Coefficients{1,1}], [Results_MLE.AUD_Westimate Results_MLE.VIS_Westimate], aud_coh, vis_coh, AV_accuracy_CDF_points)
    end
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
hold on
text(0.3,0.2,"aud std (sensitivity): " + dataALL{1}.std_gaussian)
text(0.3,0.1,"aud mu (PSE): " + dataALL{1}.mdl.Coefficients{1,1})
text(0.3,0.15,"vis std (sensitivity): " + dataALL{2}.std_gaussian)
text(0.3,0.05,"vis mu (PSE): " + dataALL{2}.mdl.Coefficients{1,1})
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)

%beautifyplot;
%set(gcf, 'Units', 'normalized', 'OuterPosition', [0 0 1 1]);
cdf = gcf;
fig_type = 'cdf';
filename = fullfile(figure_file_directory, [subjnum_s '_' group_s '_' fig_type '.jpg']);
if save_fig
    saveas(cdf, filename, 'jpeg');
end



%boxplot_accuracies


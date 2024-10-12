clear;
close all;
clc;

%% Set variables
vel_stair = 0;
save_fig = 0;
estimated_AV = 0;
figures = 1;
analyze_halves = 0;
remove_early = 0;

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

data_output_half1 = data_output(1:150, :);
data_output_half2 = data_output(151:300, :);

%[boxplot_accuracies, violation, RT_gain, aud_coh, vis_coh, AV_accuracy_CDF_points] = PERFvsSTIM_accuracy_plotter(data_output, subjnum_s, group_s, figure_file_directory, save_fig, figures);
if analyze_halves
    [boxplot_accuracies_half1, violation_half1, RT_gain_half1, ~, ~, AV_accuracy_CDF_points_half1] = PERFvsSTIM_accuracy_plotter(data_output_half1, subjnum_s, 'First Half', figure_file_directory, save_fig, figures);
    [boxplot_accuracies_half2, violation_half2, RT_gain_half2, ~, ~, AV_accuracy_CDF_points_half2] = PERFvsSTIM_accuracy_plotter(data_output_half2, subjnum_s, 'Second Half', figure_file_directory, save_fig, figures);
end


clear data_output
cd(data_file_directory)
stairAud_filename = sprintf('RDKHoop_stairAud_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
load(stairAud_filename)
save_name = 'stairAud';
dataAud = data_output;
if remove_early
    dataAud = dataAud(30:end, :);
end

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

stairVis_filename = sprintf('RDKHoop_stairVis_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
load(stairVis_filename)
save_name = 'stairVis';
dataVis = data_output;
if remove_early
    dataVis = dataVis(30:end, :);
end

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
        plotEstimatedAV(Results_MLE.AV_EstimatedSD, [dataALL{1}.mdl.Coefficients{1,1} dataALL{2}.mdl.Coefficients{1,1}], [Results_MLE.AUD_Westimate Results_MLE.VIS_Westimate], aud_coh, vis_coh, AV_accuracy_CDF_points, Results_MLE.AUD_Variance, Results_MLE.VIS_Variance)
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
ylabel( 'Proportion Rightward Response', 'Interpreter', 'none');
xlim([-1 1])
axis equal
ylim([0 1])
grid on
hold on

aud_mu = dataALL{1}.mdl.Coefficients{1,1};
vis_mu = dataALL{2}.mdl.Coefficients{1,1};

% Draw horizontal dotted lines
% plot([-1, aud_mu], [0.5, 0.5], 'k:', 'LineWidth', 3, 'Color', [0.5 0.5 0.5], 'DisplayName', 'PSE');
% plot([-1, vis_mu], [0.5, 0.5], 'k:', 'LineWidth', 3, 'Color', [0.5 0.5 0.5], 'HandleVisibility', 'off');
% 
% % Draw vertical dotted lines
% plot([aud_mu, aud_mu], [0.5, 0], 'k:', 'LineWidth', 3, 'Color', [0.5 0.5 0.5], 'HandleVisibility', 'off');
% plot([vis_mu, vis_mu], [0.5, 0], 'k:', 'LineWidth', 3, 'Color', [0.5 0.5 0.5], 'HandleVisibility', 'off');

aud_std = dataALL{1}.std_gaussian;
vis_std = dataALL{2}.std_gaussian;


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

[Results_MLE] = MLE_Calculations_A_V(dataALL{1}.mdl, dataALL{2}.mdl, dataALL{1}.yData, dataALL{2}.yData, dataALL{1}.xData, dataALL{2}.xData);


%% Read variables into excel sheet
aud_stair_thres = aud_coh;
vis_stair_thres = vis_coh;
maxA_V = max(boxplot_accuracies(1:2));
AV_perf = boxplot_accuracies(3);
MS_Gain = (AV_perf - maxA_V)/(maxA_V);
SD_diff = aud_std - vis_std;
Mu_diff = aud_mu - vis_mu;
SD_ratio = aud_std/vis_std;
Mu_ratio = aud_mu/vis_mu;
aud_weight = Results_MLE.AUD_Westimate;
vis_weight = Results_MLE.VIS_Westimate;
AV_estimated_SD = Results_MLE.AV_EstimatedSD;
aud_r2 = Results_MLE.AUD_R2;
vis_r2 = Results_MLE.VIS_R2;
AO = boxplot_accuracies(1);
VO = boxplot_accuracies(2);
Av_stim = boxplot_accuracies(4);
aV_stim = boxplot_accuracies(5);
A_Vnoise = boxplot_accuracies(6);
V_Anoise = boxplot_accuracies(7);

% Define variable names
variableNames = {'subjnum', 'group', 'sex', 'age', 'aud_coh', 'vis_coh', ...
    'aud_stair_thres', 'vis_stair_thres', 'aud_std', 'vis_std', 'aud_mu', 'vis_mu', ...
    'AO', 'VO', 'AV_perf', 'Av_stim', 'aV_stim', 'A_Vnoise', 'V_Anoise', ...
    'maxA_V', 'MS_Gain', 'SD_diff', 'Mu_diff', 'SD_ratio', 'Mu_ratio', ...
    'violation', 'RT_gain', 'aud_weight', 'vis_weight', 'AV_estimated_SD', 'aud_r2', 'vis_r2'};

% Create the data table
dataTable = table(subjnum, group, sex, age, aud_coh, vis_coh, ...
    aud_stair_thres, vis_stair_thres, aud_std, vis_std, aud_mu, vis_mu, ...
    AO, VO, AV_perf, Av_stim, aV_stim, A_Vnoise, V_Anoise, maxA_V, MS_Gain, SD_diff, Mu_diff, ...
    SD_ratio, Mu_ratio, violation, RT_gain, aud_weight, vis_weight, ...
    AV_estimated_SD, aud_r2, vis_r2, 'VariableNames', variableNames);

% Excel file and sheet name
excelFileName = 'group_perf_data.xlsx';
sheetName = 'data_out';

% Check if the file exists
try
    [~, ~, raw] = xlsread(excelFileName, sheetName);
    lastRow = size(raw, 1);
catch
    % If the file or sheet does not exist, initialize the file
    lastRow = 0;
end

% Determine the starting cell
startCell = ['A' num2str(lastRow + 1)];

% Ensure the file has headers if it's a new file
if lastRow == 0
    writecell(variableNames, excelFileName, 'Sheet', sheetName, 'Range', 'A1');
    startCell = 'A2';
end

% Write the data to the next available row
writetable(dataTable, excelFileName, 'Sheet', sheetName, 'Range', startCell, 'WriteVariableNames', false);

disp('Data written successfully to Excel!');

% %% Modeling accuracy data
% A_AV_V_cond = (AO_acc >= AV_perf) & (AV_perf >= VO_acc);
% V_AV_A_cond = (VO_acc >= AV_perf) & (AV_perf >= AO_acc);
% AV_enhance_cond = (AV_perf > AO_acc) & (AV_perf > VO_acc);
% AV_depress_cond = (AV_perf < AO_acc) & (AV_perf < VO_acc);

if group == 23
    auditory_cue = 1; visual_cue = 2; audiovisual_cue = 3; no_cue = 0;
    accuracies = zeros(1, 4);
    for cueType = 1:4
        switch cueType
            case 1
                idx = data_output(:,9) == auditory_cue;
                correctResponses = data_output(idx, 1) == data_output(idx, 5);
                dataAud_cue = data_output(idx, :);
            case 2
                idx = data_output(:,9) == visual_cue;
                correctResponses = data_output(idx, 3) == data_output(idx, 5);
                dataVis_cue = data_output(idx, :);
            case 3
                idx = data_output(:,9) == audiovisual_cue;
                correctResponses = data_output(idx, 1) == data_output(idx, 3) & data_output(idx, 3) == data_output(idx, 5);
                dataAV_cue = data_output(idx, :);
            case 4
                idx = data_output(:,9) == no_cue;
                correctResponses = data_output(idx, 1) == data_output(idx, 3) & data_output(idx, 3) == data_output(idx, 5);
                dataNO_cue = data_output(idx, :);
        end
        
        accuracies(cueType) = sum(correctResponses) / length(correctResponses);

    end
end

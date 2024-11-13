%% Perf Task Publication Quality Figures
clear; close all; clc;

%% Figure variables to keep uniform throughout
scatter_size = 500;
aud_color = '#d73027'; vis_color = '#4575b4'; both_color = '#009304'; extra_color = '#';
aud_icon = 'o'; vis_icon = '^'; both_icon = 's';
figure_font_size = 30; single_group = 1;
save_jpg_figures = 0; save_eps_figures = 0; save_names = {};

aud_color = hex2rgb('#d73027');
vis_color = hex2rgb('#4575b4');
both_color = hex2rgb('#009304');

data_analysis_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/data_analysis';
figure_file_directory = '/Users/a.tiesman/Documents/Research/Paper Figures';

addpath('/Users/a.tiesman/Documents/Research/Human_AV_Motion/data_analysis/Violin_plots_MATLAB');
addpath('/Users/a.tiesman/Documents/Research/Human_AV_Motion/data_analysis/Violin_plots_MATLAB/daviolinplot/');


%% Load in the group data
cd(data_analysis_directory)

dataAll = readtable('group_perf_data.xlsx',  'Sheet', 'data_to_analyze');

AO_Accuracy = table2array(dataAll(:, 13));
VO_Accuracy = table2array(dataAll(:, 14));
AV_Accuracy = table2array(dataAll(:, 15));
CA_Accuracy = table2array(dataAll(:, 37));
MLE_Mu = table2array(dataAll(:, 38));
MLE_Std = table2array(dataAll(:, 34));
Aud_Coh = table2array(dataAll(:, 5));
Vis_Coh = table2array(dataAll(:, 6));


num_participants = size(dataAll, 1);
AudCoh_MLE_Accuracy = zeros(num_participants, 1);
VisCoh_MLE_Accuracy = zeros(num_participants, 1);
Average_MLE_Accuracy = zeros(num_participants, 1);

for i = 1:num_participants
    right_aud_coh = Aud_Coh(i);
    left_aud_coh = -1*Aud_Coh(i);
    right_vis_coh = Vis_Coh(i);
    left_vis_coh = -1*Vis_Coh(i);

    Aud_MLE_prob_right_for_right = 0.5 * (1 + erf((right_aud_coh - MLE_Mu(i)) / (MLE_Std(i) * sqrt(2))));
    Aud_MLE_prob_right_for_left = 0.5 * (1 + erf((left_aud_coh - MLE_Mu(i)) / (MLE_Std(i) * sqrt(2))));
    Aud_MLE_right_acc = Aud_MLE_prob_right_for_right;
    Aud_MLE_left_acc = 1 - Aud_MLE_prob_right_for_left;
    
    Aud_MLE_acc = (Aud_MLE_right_acc + Aud_MLE_left_acc) / 2;

    Vis_MLE_prob_right_for_right = 0.5 * (1 + erf((right_vis_coh - MLE_Mu(i)) / (MLE_Std(i) * sqrt(2))));
    Vis_MLE_prob_right_for_left = 0.5 * (1 + erf((left_vis_coh - MLE_Mu(i)) / (MLE_Std(i) * sqrt(2))));
    Vis_MLE_right_acc = Vis_MLE_prob_right_for_right;
    Vis_MLE_left_acc = 1 - Vis_MLE_prob_right_for_left;
    
    Vis_MLE_acc = (Vis_MLE_right_acc + Vis_MLE_left_acc) / 2;

    AudCoh_MLE_Accuracy(i) = Aud_MLE_acc;
    VisCoh_MLE_Accuracy(i) = Vis_MLE_acc;

    Average_MLE_Accuracy(i) = (Aud_MLE_acc + Vis_MLE_acc) / 2
end


dataAV = [AV_Accuracy, AudCoh_MLE_Accuracy, VisCoh_MLE_Accuracy, CA_Accuracy];
dataAV(any(isnan(dataAV), 2), :) = [];
num_AVparticipants = size(dataAV, 1);
dataAV_groups = [ones(num_AVparticipants, 1); 2 * ones(num_AVparticipants, 1); 3 * ones(num_AVparticipants, 1); 4 * ones(num_AVparticipants, 1)];
dataAV_combined = [dataAV(:,1); dataAV(:,2); dataAV(:,3); dataAV(:,4)];

dataEMP_groups = [ones(1, 50); 2 * ones(1, 50); 3 * ones(1, 50)];
dataEMP = [AO_Accuracy, VO_Accuracy, AV_Accuracy];
dataEMP(any(isnan(dataEMP), 2), :) = [];
groups = [ones(num_participants, 1); 2 * ones(num_participants, 1); 3 * ones(num_participants, 1)];
dataEMP_combined = [dataEMP(:, 1); dataEMP(:, 2); dataEMP(:, 3)];


AO_name = 'Auditory Only';
VO_name = 'Visual Only';
AV_name = 'Performance Matched Audiovisual';
CA_name = 'Cue Averaging Estimated Audiovisual';
MLE_name = 'Maximum Likelihood Estimated Audiovisual';


group_names = {AV_name, MLE_name, CA_name};

figure;
h = daviolinplot(dataAV_combined, 'groups', dataAV_groups, 'violin', 'half', ...
    'violinwidth', 2, 'xtlabels', {'Audiovisual', 'Aud MLE', 'Vis MLE', 'Cue Averaging'}, 'scattercolors', 'same', ...
    'scatter', 2, 'box', 0, 'boxcolors', 'k', 'scatteralpha', 0.7, 'scattersize', 20, ...
    'bins', 12, 'jitter', 2, 'jitterspacing', 0.6, 'colors', [hex2rgb('#009304'); hex2rgb('#d73027'); hex2rgb('#4575b4'); hex2rgb('#8ce086')]);


%ylim([0 1]);
ylabel('Proportion Correct')
ylim([0 1.4]);
xl = xlim; xlim([xl(1)-0.2, xl(2)+0.4]); % make more space for the legend


beautifyplot;
unmatlabifyplot;
set(findall(gcf, '-property', 'FontSize'), 'FontSize', figure_font_size);


dataCAvsMLE = [AV_Accuracy, Average_MLE_Accuracy, CA_Accuracy];
dataCAvsMLE(any(isnan(dataCAvsMLE), 2), :) = [];
num_CAvsMLEparticipants = size(dataCAvsMLE, 1);
dataCAvsMLE_groups = [ones(num_CAvsMLEparticipants, 1); 2 * ones(num_CAvsMLEparticipants, 1); 3 * ones(num_CAvsMLEparticipants, 1)];
dataCAvsMLE_combined = [dataCAvsMLE(:,1); dataCAvsMLE(:,2); dataCAvsMLE(:,3)];


figure;
h = daviolinplot(dataCAvsMLE_combined, 'groups', dataCAvsMLE_groups, 'violin', 'half', ...
    'violinwidth', 2, 'xtlabels', group_names, 'scattercolors', 'same', ...
    'scatter', 2, 'box', 0, 'boxcolors', 'k', 'scatteralpha', 0.7, 'scattersize', 20, ...
    'bins', 12, 'jitter', 2, 'jitterspacing', 0.6, 'colors', [hex2rgb('#009304'); hex2rgb('#d73027'); hex2rgb('#4575b4')]);


%ylim([0 1]);
ylabel('Proportion Correct')
ylim([0 1]);
xl = xlim; xlim([xl(1)-0.2, xl(2)+0.4]); % make more space for the legend

% Calculate the medians for each condition
median_AV_Accuracy = median(dataCAvsMLE(:, 1));
median_Average_MLE_Accuracy = median(dataCAvsMLE(:, 2));
median_CA_Accuracy = median(dataCAvsMLE(:, 3));

% Plot the medians as dotted lines
hold on; % Keep the current plot to overlay the lines

% Plot and label the median for the first condition
line([0.7, 1.5], [median_AV_Accuracy, median_AV_Accuracy], 'Color', '#bbbbbb', 'LineStyle', '--', 'LineWidth', 2.5);
text(1.55, median_AV_Accuracy, sprintf('%.2f', median_AV_Accuracy), 'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle', 'FontSize', 22, 'FontWeight', 'bold', 'FontName', 'Times New Roman');

% Plot and label the median for the second condition
line([1.7, 2.5], [median_Average_MLE_Accuracy, median_Average_MLE_Accuracy], 'Color', '#bbbbbb', 'LineStyle', '--', 'LineWidth', 2.5);
text(2.55, median_Average_MLE_Accuracy, sprintf('%.2f', median_Average_MLE_Accuracy), 'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle', 'FontSize', 22, 'FontWeight', 'bold', 'FontName', 'Times New Roman');

% Plot and label the median for the third condition
line([2.7, 3.5], [median_CA_Accuracy, median_CA_Accuracy], 'Color', '#bbbbbb', 'LineStyle', '--', 'LineWidth', 2.5);
text(3.55, median_CA_Accuracy, sprintf('%.2f', median_CA_Accuracy), 'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle', 'FontSize', 22, 'FontWeight', 'bold', 'FontName', 'Times New Roman');

beautifyplot;
unmatlabifyplot;

delta_EMP_MLE = AV_Accuracy - Average_MLE_Accuracy;
delta_EMP_CA = AV_Accuracy - CA_Accuracy;
delta_MLE_CA = Average_MLE_Accuracy - CA_Accuracy;
[p_EMP_MLE] = signrank(delta_EMP_MLE);
[p_EMP_CA] = signrank(delta_EMP_CA);
[p_MLE_CA] = signrank(delta_MLE_CA);

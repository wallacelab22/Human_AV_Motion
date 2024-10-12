%% Analysis Read In and Out Excel Group Data %%%%%%%%%%
clear;
close all;
clc;

%% Load directories
task_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/';
script_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/data_analysis/';
data_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/data/';
figure_file_directory = '/Volumes/WallaceLab/AdamTiesman/individual_figures_IMRF';

addpath('/Volumes/WallaceLab/AdamTiesman/individual_figures_IMRF');
addpath('/Users/a.tiesman/Documents/Research/Human_AV_Motion/data_analysis/RSE-box-master');
addpath('/Users/a.tiesman/Documents/Research/Human_AV_Motion/data_analysis/RSE-box-master/analysis');
addpath('/Users/a.tiesman/Documents/Research/Human_AV_Motion/data_analysis/');
addpath('/Users/a.tiesman/Documents/Research/Human_AV_Motion/data');

%% Load participant predetermined variables from Excel
excelFileName = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/data_analysis/group_perf_data.xlsx';  % Adjust the path accordingly
inputSheet = 'data_in';
outputSheet = 'data_out';
variableSheet = 'variables';

[~, ~, varNamesRaw] = xlsread(excelFileName, variableSheet);
variableNames = varNamesRaw;
variableNames = cellfun(@char, variableNames, 'UniformOutput', false);

[finalTable] = data_read(variableNames, excelFileName, inputSheet, outputSheet, data_file_directory, script_file_directory, figure_file_directory);

% Load variables into workspace
assignTableColumnsToVariables(finalTable)

%% Data analysis
% scatter_plotter(aud_std, vis_std);
% SD_ratio = aud_std./vis_std;
% scatter_plotter(SD_ratio, aud_weight);
% 
% [p_std, observeddifference_std, effectsize_std] = permutationTest(aud_std, vis_std, 500, 'plotresult', 1);
% 
% [p_mu, observeddifference_mu, effectsize_mu] = permutationTest(aud_mu, vis_mu, 500, 'plotresult', 1);

% %% Modeling accuracy data
% A_AV_V_cond = (AO >= AV_perf) & (AV_perf >= VO);
% V_AV_A_cond = (VO >= AV_perf) & (AV_perf >= AO);
% AV_enhance_cond = (AV_perf > AO) & (AV_perf > VO);
% AV_depress_cond = (AV_perf < AO) & (AV_perf < VO);
% 
% accuracies_and_weights = [AO, VO, AV_perf, aud_weight, vis_weight];
% 
% 
% % Define color groups based on aud_weight
% color1 = [1, 0, 0]; % Red for aud_weight > 0.6
% color2 = [0, 1, 0]; % Green for 0.4 < aud_weight < 0.6
% color3 = [0, 0, 1]; % Blue for aud_weight < 0.4
% 
% % Create a figure
% figure;
% hold on;
% 
% % Define the x and y values for the shaded regions
% x = linspace(0, 1, 100);
% y = linspace(0, 1, 100);
% 
% % Calculate boundaries based on aud_weight = vis_std^2 / (aud_std^2 + vis_std^2)
% boundary1_x = x; 
% boundary1_y = sqrt(0.6 * (boundary1_x.^2) ./ (1 - 0.6)); % Upper boundary for red region
% 
% boundary2_low_x = x;
% boundary2_low_y = sqrt(0.4 * (boundary2_low_x.^2) ./ (1 - 0.4)); % Lower boundary for green region
% 
% boundary2_high_x = x;
% boundary2_high_y = sqrt(0.6 * (boundary2_high_x.^2) ./ (1 - 0.6)); % Upper boundary for green region
% 
% boundary3_x = x;
% boundary3_y = sqrt(0.4 * (boundary3_x.^2) ./ (1 - 0.4)); % Upper boundary for blue region
% 
% % Plot shaded areas
% fill([boundary1_x fliplr(boundary1_x)], [boundary1_y fliplr(ones(size(boundary1_x)))], color1, 'FaceAlpha', 0.1, 'EdgeColor', 'none');
% fill([boundary2_low_x fliplr(boundary2_high_x)], [boundary2_low_y fliplr(boundary2_high_y)], color2, 'FaceAlpha', 0.1, 'EdgeColor', 'none');
% fill([boundary3_x fliplr(boundary3_x)], [zeros(size(boundary3_y)) fliplr(boundary3_y)], color3, 'FaceAlpha', 0.1, 'EdgeColor', 'none');
% 
% % Plot data points with different colors based on aud_weight
% for i = 1:height(aud_weight)
%     if aud_weight(i) > 0.6
%         scatter(aud_std(i), vis_std(i), 'MarkerEdgeColor', color1, 'MarkerFaceColor', color1);
%     elseif aud_weight(i) > 0.4 && aud_weight(i) < 0.6
%         scatter(aud_std(i), vis_std(i), 'MarkerEdgeColor', color2, 'MarkerFaceColor', color2);
%     else
%         scatter(aud_std(i), vis_std(i), 'MarkerEdgeColor', color3, 'MarkerFaceColor', color3);
%     end
% end
% 
% % Add labels
% xlabel('Auditory Sensitivity');
% ylabel('Visual Sensitivity');
% 
% % Add legend
% legend({'Group 1 (aud\_weight > 0.6)', 'Group 2 (0.4 < aud\_weight < 0.6)', 'Group 3 (aud\_weight < 0.4)'}, 'Location', 'best');
% 
% % Set axis limits
% xlim([0 1]);
% ylim([0 1]);
% 
% hold off;
% beautifyplot;
% 
% % Define color groups based on aud_weight
% group1 = aud_weight > 0.6;
% group2 = aud_weight > 0.4 & aud_weight < 0.6;
% group3 = aud_weight < 0.4;
% 
% % Define colors
% color1 = [1, 0, 0]; % Red for Group 1
% color2 = [0, 1, 0]; % Green for Group 2
% color3 = [0, 0, 1]; % Blue for Group 3
% 
% % Define number of bins
% numBins = 20;
% 
% % Create histograms for MS_Gain
% edges = linspace(min(MS_Gain), max(MS_Gain), numBins+1);
% counts1 = histcounts(MS_Gain(group1), edges);
% counts2 = histcounts(MS_Gain(group2), edges);
% counts3 = histcounts(MS_Gain(group3), edges);
% 
% figure;
% hold on;
% bar(edges(1:end-1) + diff(edges)/2, [counts1' counts2' counts3'], 'stacked');
% set(gca, 'ColorOrder', [color1; color2; color3], 'NextPlot', 'replacechildren');
% xlabel('MS Gain');
% ylabel('Frequency');
% legend({'Group 1 (aud\_weight > 0.6)', 'Group 2 (0.4 < aud\_weight < 0.6)', 'Group 3 (aud\_weight < 0.4)'}, 'Location', 'best');
% title('MS Gain Distribution by Group');
% hold off;
% beautifyplot;
% 
% % Create histograms for RT_gain
% edges = linspace(min(RT_gain), max(RT_gain), numBins+1);
% counts1 = histcounts(RT_gain(group1), edges);
% counts2 = histcounts(RT_gain(group2), edges);
% counts3 = histcounts(RT_gain(group3), edges);
% 
% figure;
% hold on;
% bar(edges(1:end-1) + diff(edges)/2, [counts1' counts2' counts3'], 'stacked');
% set(gca, 'ColorOrder', [color1; color2; color3], 'NextPlot', 'replacechildren');
% xlabel('RT Gain');
% ylabel('Frequency');
% legend({'Group 1 (aud\_weight > 0.6)', 'Group 2 (0.4 < aud\_weight < 0.6)', 'Group 3 (aud\_weight < 0.4)'}, 'Location', 'best');
% title('RT Gain Distribution by Group');
% hold off;
% beautifyplot;

dataToAnalyze = readtable('group_perf_data.xlsx',  'Sheet', 'data_to_analyze');
dataToAnalyze = dataToAnalyze(2:50, :);

AV_EstimatedSD = table2array(dataToAnalyze(:, 30));
CA_acc = table2array(dataToAnalyze(:, 37));
MLE_Est_Mu = table2array(dataToAnalyze(:, 38));

MLE_acc = zeros(length(CA_acc), 1);

for i = 1:length(MLE_acc)
    MLE_acc(i) = 0.5 * (1 + erf((aud_coh(i) - MLE_Est_Mu(i)) / (AV_EstimatedSD(i) * sqrt(2))));
%     estimated_audthres_lefty = 0.5 * (1 + erf((-aud_coh - estimated_mu) / (estimated_sigma * sqrt(2))));
%     estimated_audthres_righty = 0.5 * (1 + erf((aud_coh - estimated_mu) / (estimated_sigma * sqrt(2))));
end

% MaxA_V = max(AO, VO);
% CA_acc = aV_stim;
% MLE_acc = Av_stim;

% Define color groups based on aud_weight
group1 = aud_weight > 0.6;
group2 = aud_weight > 0.4 & aud_weight < 0.6;
group3 = aud_weight < 0.4;

createParticipantAccPlots(AO, VO, AV_perf, MLE_acc, CA_acc, MaxA_V, aud_weight);
beautifyplot;

sort(aud_weight, 'descend');


% % Define logical conditions for each category
% weight1 = 0.4;
% weight2 = 0.6;
% dataAll_raw = table2array(dataAll);
% conditionEqual = dataAll_raw(:,28) > weight1 & dataAll_raw(:,28) < weight2;
% conditionVis = dataAll_raw(:,28) <= weight1;
% conditionAud = dataAll_raw(:,28) >= weight2;
% 
% % Create separate arrays based on conditions
% EqualReliabilities = dataAll_raw(conditionEqual, :);
% VisCapture = dataAll_raw(conditionVis, :);
% AudCapture = dataAll_raw(conditionAud, :);
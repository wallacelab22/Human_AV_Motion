%% Cued Task Publication Quality Figures
clear; close all; clc;

%% Figure variables to keep uniform throughout
scatter_size = 500;
aud_color = '#d73027'; vis_color = '#4575b4'; both_color = '#009304';


dataAll = readtable('group_cue_data.xlsx',  'Sheet', 'data_final');

AO_Slope = table2array(dataAll(:, 6));
VO_Slope = table2array(dataAll(:, 8));
AV_Aud_Slope = table2array(dataAll(:, 10));
AV_Vis_Slope = table2array(dataAll(:, 12));
AV_AV_Slope = table2array(dataAll(:, 14));
Best_AO_VO_Slope = table2array(dataAll(:, 16));
Best_MSCue_Slope = table2array(dataAll(:, 18));
Incong_AV_Aud_Slope = table2array(dataAll(:, 20));
Incong_AV_Vis_Slope = table2array(dataAll(:, 22));
Aud_Weight = table2array(dataAll(:, 23));
Vis_Weight = table2array(dataAll(:, 24));
AV_EstimatedSlope = table2array(dataAll(:, 26));
MS_Gain_Slope = table2array(dataAll(:, 28));
Worst_Unisensory_Weight = table2array(dataAll(:, 29));

% --- Plot 1: Cue Aud vs AO ---
x_name = 'Auditory Only Slope';
y_name = 'Cued Auditory Slope';

% Scatter Plot
figure;
hold on;
plot([0 20], [0 20], '--', 'Color', '#bbbbbb', 'LineWidth', 2.5, 'DisplayName', 'Equal Sensitivity');
scatter(AO_Slope, AV_Aud_Slope, scatter_size, 'o', 'filled', 'MarkerFaceColor', aud_color, 'HandleVisibility', 'off');
xlim([0 20]);
ylim([0 20]);
xlabel(x_name, 'FontSize', 38);
ylabel(y_name, 'FontSize', 38);
axis square
% Set tick marks 
xticks([0 4 8 12 16 20]);
yticks([0 4 8 12 16 20]);

% Create the legend and adjust its properties
[h, icons] = legend('show', 'Location', 'northwest', 'FontSize', 30, 'FontName', 'Times New Roman');  % Set legend font size
h.ItemTokenSize = [25, 25];  % Match the size of the markers in the legend to the scatter plot

beautifyplot;
unmatlabifyplot;
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 38);

hold off;

delta_histogram_plotter(AO_Slope, AV_Aud_Slope, aud_color, x_name, y_name);

% --- Plot 2: Cue Vis vs VO ---
x_name = 'Visual Only Slope';
y_name = 'Cued Visual Slope';

% Scatter Plot
figure;
hold on;
plot([0 20], [0 20], '--', 'Color', '#bbbbbb', 'LineWidth', 2.5, 'DisplayName', 'Equal Sensitivity');
scatter(VO_Slope, AV_Vis_Slope, scatter_size, '^', 'filled', 'MarkerFaceColor', vis_color, 'HandleVisibility', 'off');
xlim([0 20]);
ylim([0 20]);
xlabel(x_name, 'FontSize', 38);
ylabel(y_name, 'FontSize', 38);
axis square
% Set tick marks 
xticks([0 4 8 12 16 20]);
yticks([0 4 8 12 16 20]);

% Create the legend and adjust its properties
[h, icons] = legend('show', 'Location', 'northwest', 'FontSize', 30, 'FontName', 'Times New Roman');  % Set legend font size
h.ItemTokenSize = [25, 25];  % Match the size of the markers in the legend to the scatter plot

beautifyplot;
unmatlabifyplot;
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 38);

hold off;

delta_histogram_plotter(VO_Slope, AV_Vis_Slope, vis_color, x_name, y_name);

% --- Plot 3: Cue Vis vs VO ---
x_name = 'Auditory Only Slope';
y_name = 'Visual Only Slope';

% Scatter Plot
figure;
hold on;
plot([0 20], [0 20], '--', 'Color', '#bbbbbb', 'LineWidth', 2.5, 'DisplayName', 'Equal Sensitivity');
scatter(AO_Slope, VO_Slope, scatter_size, 's', 'filled', 'MarkerFaceColor', both_color, 'HandleVisibility', 'off');
xlim([0 20]);
ylim([0 20]);
xlabel(x_name, 'FontSize', 38);
ylabel(y_name, 'FontSize', 38);
axis square
% Set tick marks 
xticks([0 4 8 12 16 20]);
yticks([0 4 8 12 16 20]);

% Create the legend and adjust its properties
[h, icons] = legend('show', 'Location', 'northwest', 'FontSize', 30, 'FontName', 'Times New Roman');  % Set legend font size
h.ItemTokenSize = [25, 25];  % Match the size of the markers in the legend to the scatter plot

beautifyplot;
unmatlabifyplot;
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 38);

hold off;

delta_histogram_plotter(AO_Slope, VO_Slope, both_color, x_name, y_name);
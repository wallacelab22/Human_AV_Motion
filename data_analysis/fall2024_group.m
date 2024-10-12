%% Fall 2024 Cued + Incongruent Blocks Task GROUP DATA
clear; close all; clc;

dataAll = readtable('group_cue_data.xlsx',  'Sheet', 'data_to_analyze');

AO_Std = table2array(dataAll(:, 5));
AO_Mu = table2array(dataAll(:, 6));
VO_Std = table2array(dataAll(:, 7));
VO_Mu = table2array(dataAll(:, 8));
AV_Aud_Std = table2array(dataAll(:, 9));
AV_Aud_Mu = table2array(dataAll(:, 10));
AV_Vis_Std = table2array(dataAll(:, 11));
AV_Vis_Mu = table2array(dataAll(:, 12));
AV_AV_Std = table2array(dataAll(:, 13));
AV_AV_Mu = table2array(dataAll(:, 14));
Best_AO_VO_Std = table2array(dataAll(:, 15));
Best_aAV_vAV_Std = table2array(dataAll(:, 16));
Incong_AV_Aud_Std = table2array(dataAll(:, 17));
Incong_AV_Aud_Mu = table2array(dataAll(:, 18));
Incong_AV_Vis_Std = table2array(dataAll(:, 19));
Incong_AV_Vis_Mu = table2array(dataAll(:, 20));
CohOne_MRE_RT = table2array(dataAll(:, 21));
CohTwo_MRE_RT = table2array(dataAll(:, 22));
CohThree_MRE_RT = table2array(dataAll(:, 23));
CohFour_MRE_RT = table2array(dataAll(:, 24));
Aud_Weight = table2array(dataAll(:, 25));
Vis_Weight = table2array(dataAll(:, 26));
AV_EstimatedSD = table2array(dataAll(:, 27));
AUD_R2 = table2array(dataAll(:, 28));
VIS_R2 = table2array(dataAll(:, 29));
AV_R2 = table2array(dataAll(:, 30));


% --- Plot 1: AV Cue vs Best Unisensory Sensitivity ---
% Scatter Plot
figure;
hold on;
scatter_size = 500;  % Define marker size for scatter plot
scatter(Best_AO_VO_Std, AV_AV_Std, scatter_size, 's', 'filled', 'MarkerFaceColor', 'g', 'DisplayName', 'AV Cue');
plot([0 1], [0 1], '--k', 'LineWidth', 2, 'DisplayName', 'Equal Sensitivity');
axis equal;
xlim([0 1]);
ylim([0 1]);
xlabel('Best Unisensory Sensitivity');
ylabel('AV Cue Sensitivity');

% Create the legend and adjust marker size in the legend
lgd = legend('show', 'Location', 'northwest');
lgd.ItemTokenSize = [25, 25];  % Adjust the marker size in the legend

beautifyplot;
set(gca, 'XTickLabelRotation', 45);
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 44);
hold off;

% Histogram (x - y)
delta = Best_AO_VO_Std - AV_AV_Std;
data = delta; 
mu = mean(data);
sigma = std(data);
z_scores = (data - mu) / sigma;
outlier_indices = abs(z_scores) > 3;
cleaned_data = data(~outlier_indices);
delta = cleaned_data;

% Define the edges for the bins, symmetric around 0
binEdges = -1:0.2:1;  % Creates bins centered on 0 with width 0.2

figure;
histogram(delta, 'BinEdges', binEdges, 'FaceColor', 'g');  % Specify the bin edges
xlim([-1 1]);  % Set x-axis range to -1 to 1
ylim([0 8]);   % Set y-axis range to 0 to 8
axis off;      % Remove axis

% Add a vertical dotted line at x = 0
hold on;
plot([0 0], ylim, 'k--', 'LineWidth', 2);  % Dotted line (--) at x = 0 in black ('k')

% Perform Wilcoxon Signed-Rank Test
[p, h] = signrank(delta);  % h is 1 if significant, 0 if not

% Annotate based on p-value, set color to black
hold on;
if p < 0.001
    text(0.5, 0.9, '***', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
elseif p < 0.01
    text(0.5, 0.9, '**', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
elseif p < 0.05
    text(0.5, 0.9, '*', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
else
    text(0.5, 0.9, 'n.s.', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
end
hold off;

% --- Plot 2: Aud Cue vs AO ---
% Scatter Plot
figure;
hold on;
scatter(AO_Std, AV_Aud_Std, scatter_size, 'o', 'filled', 'MarkerFaceColor', 'r', 'DisplayName', 'Aud Cue');
plot([0 1], [0 1], '--k', 'LineWidth', 2, 'DisplayName', 'Equal Sensitivity');
axis equal;
xlim([0 1]);
ylim([0 1]);
xlabel('Aud Only Sensitivity');
ylabel('AV Aud Cue Sensitivity');

% Create the legend and adjust marker size in the legend
lgd = legend('show', 'Location', 'northwest');
lgd.ItemTokenSize = [25, 25];  % Adjust the marker size in the legend

beautifyplot;
set(gca, 'XTickLabelRotation', 45);
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 44);
hold off;

% Histogram (x - y)
delta = AO_Std - AV_Aud_Std;
data = delta; 
mu = mean(data);
sigma = std(data);
z_scores = (data - mu) / sigma;
outlier_indices = abs(z_scores) > 3;
cleaned_data = data(~outlier_indices);
delta = cleaned_data;

% Define the edges for the bins, symmetric around 0
binEdges = -1:0.2:1;  % Creates bins centered on 0 with width 0.2

figure;
histogram(delta, 10, 'FaceColor', 'r');  % 10 bins specified
xlim([-1 1]);  % Set x-axis range to -1 to 1
ylim([0 8]);   % Set y-axis range to 0 to 8
axis off;      % Remove axis

% Add a vertical dotted line at x = 0
hold on;
plot([0 0], ylim, 'k--', 'LineWidth', 2);  % Dotted line (--) at x = 0 in black ('k')

% Perform Wilcoxon Signed-Rank Test
[p, h] = signrank(delta);  % h is 1 if significant, 0 if not

% Annotate based on p-value, set color to black
hold on;
if p < 0.001
    text(0.5, 0.9, '***', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
elseif p < 0.01
    text(0.5, 0.9, '**', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
elseif p < 0.05
    text(0.5, 0.9, '*', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
else
    text(0.5, 0.9, 'n.s.', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
end
hold off;

% --- Plot 3: Vis Cue vs VO ---
% Scatter Plot
figure;
hold on;
scatter(VO_Std, AV_Vis_Std, scatter_size, '^', 'filled', 'MarkerFaceColor', 'b', 'DisplayName', 'Vis Cue');
plot([0 1], [0 1], '--k', 'LineWidth', 2, 'DisplayName', 'Equal Sensitivity');
axis equal;
xlim([0 1]);
ylim([0 1]);
xlabel('Vis Only Sensitivity');
ylabel('AV Vis Cue Sensitivity');

% Create the legend and adjust marker size in the legend
lgd = legend('show', 'Location', 'northwest');
lgd.ItemTokenSize = [25, 25];  % Adjust the marker size in the legend

beautifyplot;
set(gca, 'XTickLabelRotation', 45);
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 44);
hold off;

% Histogram (x - y)
delta = VO_Std - AV_Vis_Std;
data = delta; 
mu = mean(data);
sigma = std(data);
z_scores = (data - mu) / sigma;
outlier_indices = abs(z_scores) > 3;
cleaned_data = data(~outlier_indices);
delta = cleaned_data;

% Define the edges for the bins, symmetric around 0
binEdges = -1:0.2:1;  % Creates bins centered on 0 with width 0.2

figure;
histogram(delta, 'BinEdges', binEdges, 'FaceColor', 'b');  % 10 bins specified
xlim([-1 1]);  % Set x-axis range to -1 to 1
ylim([0 8]);   % Set y-axis range to 0 to 8
axis off;      % Remove axis

% Add a vertical dotted line at x = 0
hold on;
plot([0 0], ylim, 'k--', 'LineWidth', 2);  % Dotted line (--) at x = 0 in black ('k')

% Perform Wilcoxon Signed-Rank Test
[p, h] = signrank(delta);  % h is 1 if significant, 0 if not

% Annotate based on p-value, set color to black
hold on;
if p < 0.001
    text(0.5, 0.9, '***', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
elseif p < 0.01
    text(0.5, 0.9, '**', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
elseif p < 0.05
    text(0.5, 0.9, '*', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
else
    text(0.5, 0.9, 'n.s.', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
end
hold off;

% --- Plot 4a: AV AV Cue vs Multisensory A Cue Sensitivity ---
% Scatter Plot
figure;
hold on;
scatter_size = 500;  % Define marker size for scatter plot
scatter(AV_Aud_Std, AV_AV_Std, scatter_size, '^', 'filled', 'MarkerFaceColor', '#A2142F', 'DisplayName', 'AV Cue');
plot([0 1], [0 1], '--k', 'LineWidth', 2, 'DisplayName', 'Equal Sensitivity');
axis equal;
xlim([0 1]);
ylim([0 1]);
xlabel('Aud Cue Sigma');
ylabel('AV Cue Sigma');

% Create the legend and adjust marker size in the legend
lgd = legend('show', 'Location', 'northwest');
lgd.ItemTokenSize = [25, 25];  % Adjust the marker size in the legend

beautifyplot;
set(gca, 'XTickLabelRotation', 45);
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 44);
hold off;

% Histogram (x - y)
delta = AV_Aud_Std - AV_AV_Std;
data = delta; 
mu = mean(data);
sigma = std(data);
z_scores = (data - mu) / sigma;
outlier_indices = abs(z_scores) > 3;
cleaned_data = data(~outlier_indices);
delta = cleaned_data;

% Define the edges for the bins, symmetric around 0
binEdges = -1:0.2:1;  % Creates bins centered on 0 with width 0.2

figure;
histogram(delta, 'BinEdges', binEdges, 'FaceColor', '#A2142F');  % 10 bins specified
xlim([-1 1]);  % Set x-axis range to -1 to 1
ylim([0 8]);   % Set y-axis range to 0 to 8
axis off;      % Remove axis

% Add a vertical dotted line at x = 0
hold on;
plot([0 0], ylim, 'k--', 'LineWidth', 2);  % Dotted line (--) at x = 0 in black ('k')

% Perform Wilcoxon Signed-Rank Test
[p, h] = signrank(delta);  % h is 1 if significant, 0 if not

% Annotate based on p-value, set color to black
if p < 0.001
    text(0.5, 0.9, '***', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
elseif p < 0.01
    text(0.5, 0.9, '**', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
elseif p < 0.05
    text(0.5, 0.9, '*', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
else
    text(0.5, 0.9, 'n.s.', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
end
hold off;

% --- Plot 4b: AV AV Cue vs Multisensory V Cue Sensitivity ---
% Scatter Plot
figure;
hold on;
scatter_size = 500;  % Define marker size for scatter plot
scatter(AV_Vis_Std, AV_AV_Std, scatter_size, '^', 'filled', 'MarkerFaceColor', '#4DBEEE', 'DisplayName', 'AV Cue');
plot([0 1], [0 1], '--k', 'LineWidth', 2, 'DisplayName', 'Equal Sensitivity');
axis equal;
xlim([0 1]);
ylim([0 1]);
xlabel('Vis Cue Sigma');
ylabel('AV Cue Sigma');

% Create the legend and adjust marker size in the legend
lgd = legend('show', 'Location', 'northwest');
lgd.ItemTokenSize = [25, 25];  % Adjust the marker size in the legend

beautifyplot;
set(gca, 'XTickLabelRotation', 45);
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 44);
hold off;

% Histogram (x - y)
delta = AV_Vis_Std - AV_AV_Std;
data = delta; 
mu = mean(data);
sigma = std(data);
z_scores = (data - mu) / sigma;
outlier_indices = abs(z_scores) > 3;
cleaned_data = data(~outlier_indices);
delta = cleaned_data;

% Define the edges for the bins, symmetric around 0
binEdges = -1:0.2:1;  % Creates bins centered on 0 with width 0.2

figure;
histogram(delta, 'BinEdges', binEdges, 'FaceColor', '#4DBEEE');  % 10 bins specified
xlim([-1 1]);  % Set x-axis range to -1 to 1
ylim([0 8]);   % Set y-axis range to 0 to 8
axis off;      % Remove axis

% Add a vertical dotted line at x = 0
hold on;
plot([0 0], ylim, 'k--', 'LineWidth', 2);  % Dotted line (--) at x = 0 in black ('k')

% Perform Wilcoxon Signed-Rank Test
[p, h] = signrank(delta);  % h is 1 if significant, 0 if not

% Annotate based on p-value, set color to black
if p < 0.001
    text(0.5, 0.9, '***', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
elseif p < 0.01
    text(0.5, 0.9, '**', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
elseif p < 0.05
    text(0.5, 0.9, '*', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
else
    text(0.5, 0.9, 'n.s.', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
end
hold off;

% --- Plot 5: Aud Cue INCONGRUENT vs AO ---
% Scatter Plot
figure;
hold on;
scatter(AO_Std, Incong_AV_Aud_Std, scatter_size, 'o', 'filled', 'MarkerFaceColor', 'r', 'DisplayName', 'Aud Cue');
plot([0 1], [0 1], '--k', 'LineWidth', 2, 'DisplayName', 'Equal Sensitivity');
axis equal;
xlim([0 1]);
ylim([0 1]);
xlabel('Aud Only Sensitivity');
ylabel('Incong AV Aud Cue Sensitivity');

% Create the legend and adjust marker size in the legend
lgd = legend('show', 'Location', 'northwest');
lgd.ItemTokenSize = [25, 25];  % Adjust the marker size in the legend

beautifyplot;
set(gca, 'XTickLabelRotation', 45);
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 44);
hold off;

% Histogram (x - y)
delta = AO_Std - Incong_AV_Aud_Std;
data = delta; 
mu = mean(data);
sigma = std(data);
z_scores = (data - mu) / sigma;
outlier_indices = abs(z_scores) > 3;
cleaned_data = data(~outlier_indices);
delta = cleaned_data;
% manually removing NOT GOOD
delta(18) = []; delta(16) = []; delta(12) = []; delta(10) = []; delta(2) = []; delta(1) = [];

% Define the edges for the bins, symmetric around 0
binEdges = -1:0.2:1;  % Creates bins centered on 0 with width 0.2

figure;
histogram(delta, 'BinEdges', binEdges, 'FaceColor', 'r');  % 10 bins specified
xlim([-1 1]);  % Set x-axis range to -1 to 1
ylim([0 8]);   % Set y-axis range to 0 to 8
axis off;      % Remove axis

% Add a vertical dotted line at x = 0
hold on;
plot([0 0], ylim, 'k--', 'LineWidth', 2);  % Dotted line (--) at x = 0 in black ('k')

% Perform Wilcoxon Signed-Rank Test
[p, h] = signrank(delta);  % h is 1 if significant, 0 if not

% Annotate based on p-value, set color to black
hold on;
if p < 0.001
    text(0.5, 0.9, '***', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
elseif p < 0.01
    text(0.5, 0.9, '**', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
elseif p < 0.05
    text(0.5, 0.9, '*', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
else
    text(0.5, 0.9, 'n.s.', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
end
hold off;

% --- Plot 6: Vis Cue INCONGRUENT vs VO ---
% Scatter Plot
figure;
hold on;
scatter(VO_Std, Incong_AV_Vis_Std, scatter_size, '^', 'filled', 'MarkerFaceColor', 'b', 'DisplayName', 'Vis Cue');
plot([0 1], [0 1], '--k', 'LineWidth', 2, 'DisplayName', 'Equal Sensitivity');
axis equal;
xlim([0 1]);
ylim([0 1]);
xlabel('Vis Only Sensitivity');
ylabel('Incong AV Vis Cue Sensitivity');

% Create the legend and adjust marker size in the legend
lgd = legend('show', 'Location', 'northwest');
lgd.ItemTokenSize = [25, 25];  % Adjust the marker size in the legend

beautifyplot;
set(gca, 'XTickLabelRotation', 45);
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 44);
hold off;

% Histogram (x - y)
delta = VO_Std - Incong_AV_Vis_Std;
data = delta; 
mu = mean(data);
sigma = std(data);
z_scores = (data - mu) / sigma;
outlier_indices = abs(z_scores) > 3;
cleaned_data = data(~outlier_indices);
delta = cleaned_data;
figure;
histogram(delta, 10, 'FaceColor', 'b');  % 10 bins specified
xlim([-1 1]);  % Set x-axis range to -1 to 1
ylim([0 8]);   % Set y-axis range to 0 to 8
axis off;      % Remove axis

% Add a vertical dotted line at x = 0
hold on;
plot([0 0], ylim, 'k--', 'LineWidth', 2);  % Dotted line (--) at x = 0 in black ('k')

% Perform Wilcoxon Signed-Rank Test
[p, h] = signrank(delta);  % h is 1 if significant, 0 if not

% Annotate based on p-value, set color to black
hold on;
if p < 0.001
    text(0.5, 0.9, '***', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
elseif p < 0.01
    text(0.5, 0.9, '**', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
elseif p < 0.05
    text(0.5, 0.9, '*', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
else
    text(0.5, 0.9, 'n.s.', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
end
hold off;

%% RT analysis
data = [CohOne_MRE_RT, CohTwo_MRE_RT, CohThree_MRE_RT, CohFour_MRE_RT];
% Create a figure for box plots
figure;
hold on;

% Define colors for each boxplot
boxColors = ['r', 'g', 'b', 'c'];  % Example colors (red, green, blue, cyan)

% Plot the box-and-whisker plots with filled colors
h = boxplot(data, 'Colors', 'k', 'Symbol', '');  % No outlier symbol, black color for lines

% Customize box plot appearance by filling the boxes with colors
for j = 1:4  % 4 box plots corresponding to each array (Coherence 1-4)
    patch(get(h(5, j), 'XData'), get(h(5, j), 'YData'), boxColors(j), 'FaceAlpha', 0.5);  % Set box color with transparency
end

% Plot each participant's data as connected black lines with black dots
num_participants = length(CohOne_MRE_RT);
x_positions = repmat(1:4, num_participants, 1);  % X-positions for each group (1 to 4)

% Plot lines connecting each participant's data points across arrays
for i = 1:num_participants
    plot(x_positions(i, :), [CohOne_MRE_RT(i), CohTwo_MRE_RT(i), CohThree_MRE_RT(i), CohFour_MRE_RT(i)], '-ok', 'LineWidth', 1.5);
    % '-ok' specifies black lines and black circle markers
end

% Set plot title and labels
title('Reaction Time Enhancment Across Coherence');
xlabel('Coherence');
ylabel('Reaction Time Enhancement (RT)');
set(gca, 'XTick', 1:4, 'XTickLabel', {'Coherence 0.05', 'Coherence 0.1', 'Coherence 0.2', 'Coherence 0.4'});
beautifyplot;

hold off;

figure;

% Define a fixed number of bins (based on x-axis range)
num_bins_top = 40;  % Number of bins for top row (SD plots)
num_bins_bottom = 40;  % Number of bins for bottom row (PSE plots)

% Set fixed x-axis ranges
x_range_top = [0 1];  % X-axis range for the top row
x_range_bottom = [-0.5 0.5];  % X-axis range for the bottom row

% Generate bin edges based on the fixed x-axis ranges
bin_edges_top = linspace(x_range_top(1), x_range_top(2), num_bins_top + 1);
bin_edges_bottom = linspace(x_range_bottom(1), x_range_bottom(2), num_bins_bottom + 1);

% Initialize a variable to track the global maximum frequency (for y-axis limits)
max_y = 0;

% First pass: Calculate the maximum frequency for y-axis scaling
all_data = {AO_Std, VO_Std, AO_Mu, VO_Mu};
bin_edges = {bin_edges_top, bin_edges_top, bin_edges_bottom, bin_edges_bottom};  % Bins for each plot

for i = 1:length(all_data)
    data = all_data{i};
    
    % Remove outliers
    mu = mean(data);
    sigma = std(data);
    z_scores = (data - mu) / sigma;
    outlier_indices = abs(z_scores) > 3;
    cleaned_data = data(~outlier_indices);
    
    % Calculate histogram counts for the cleaned data using the predefined bin edges
    [counts, ~] = histcounts(cleaned_data, bin_edges{i});
    
    % Update the maximum y value if necessary
    max_y = max(max_y, max(counts));
end

% Second pass: Plot the histograms with consistent y-axis limits and specified bin edges

% First subplot: Auditory Only SD
subplot(2, 2, 1);
data = AO_Std; 
mu = mean(data);
sigma = std(data);
z_scores = (data - mu) / sigma;
outlier_indices = abs(z_scores) > 3;
cleaned_data = data(~outlier_indices);
histogram(cleaned_data, bin_edges_top, 'FaceColor', 'r');  % Red color for Auditory Only SD
xlim(x_range_top);  % Set x-axis range to [0, 1]
ylim([0 max_y]);  % Set y-axis limits to the global maximum
xlabel('Auditory Only SD');
ylabel('Frequency');
hold on;
median_AO_Std = median(cleaned_data);
xline(median_AO_Std, 'k--', 'LineWidth', 1.5);  % Add median line
beautifyplot;
hold off;

% Second subplot: Visual Only SD
subplot(2, 2, 2);
data = VO_Std; 
mu = mean(data);
sigma = std(data);
z_scores = (data - mu) / sigma;
outlier_indices = abs(z_scores) > 3;
cleaned_data = data(~outlier_indices);
histogram(cleaned_data, bin_edges_top, 'FaceColor', 'b');  % Blue color for Visual Only SD
xlim(x_range_top);  % Set x-axis range to [0, 1]
ylim([0 max_y]);  % Set y-axis limits to the global maximum
xlabel('Visual Only SD');
ylabel('Frequency');
hold on;
median_VO_Std = median(cleaned_data);
xline(median_VO_Std, 'k--', 'LineWidth', 1.5);  % Add median line
beautifyplot;
hold off;

% Third subplot: Auditory Only PSE
subplot(2, 2, 3);
data = AO_Mu; 
mu = mean(data);
sigma = std(data);
z_scores = (data - mu) / sigma;
outlier_indices = abs(z_scores) > 3;
cleaned_data = data(~outlier_indices);
histogram(cleaned_data, bin_edges_bottom, 'FaceColor', 'r');  % Red color for Auditory Only PSE
xlim(x_range_bottom);  % Set x-axis range to [-0.5, 0.5]
ylim([0 max_y]);  % Set y-axis limits to the global maximum
xlabel('Auditory Only PSE');
ylabel('Frequency');
hold on;
median_AO_Mu = median(cleaned_data);
xline(median_AO_Mu, 'k--', 'LineWidth', 1.5);  % Add median line
beautifyplot;
hold off;

% Fourth subplot: Visual Only PSE
subplot(2, 2, 4);
data = VO_Mu; 
mu = mean(data);
sigma = std(data);
z_scores = (data - mu) / sigma;
outlier_indices = abs(z_scores) > 3;
cleaned_data = data(~outlier_indices);
histogram(cleaned_data, bin_edges_bottom, 'FaceColor', 'b');  % Blue color for Visual Only PSE
xlim(x_range_bottom);  % Set x-axis range to [-0.5, 0.5]
ylim([0 max_y]);  % Set y-axis limits to the global maximum
xlabel('Visual Only PSE');
ylabel('Frequency');
hold on;
median_VO_Mu = median(cleaned_data);
xline(median_VO_Mu, 'k--', 'LineWidth', 1.5);  % Add median line
beautifyplot;
hold off;

%% Mu (Point of Subjective Equality) %%%%%%
% Assume AO_Mu, VO_Mu, AV_Aud_Mu, and AV_Vis_Mu are your data arrays (one value per participant)
num_participants = length(AO_Mu);  % Number of participants

% Create a new figure
figure;

%% First subplot: Auditory comparison (AO_Mu to AV_Aud_Mu)
subplot(1, 2, 1);  % 1 row, 2 columns, position 1
hold on;

% Plot AO to AV_Aud (Auditory Only to Auditory Multisensory)
for i = 1:num_participants
    % Plot a line connecting AO_Mu and AV_Aud_Mu for each participant
    plot([1, 2], [AO_Mu(i), AV_Aud_Mu(i)], '-o', 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 1.5);
end

% Add horizontal zero line for reference
yline(0, 'k--', 'LineWidth', 1.5);  % Dashed line at y = 0

% Set the x-axis labels for auditory comparison
xticks([1 2]);
xticklabels({'AO', 'AV Auditory'});

% Label the axes
xlabel('Condition');
ylabel('PSE (Mu)');

% Add a title for the auditory comparison
title('Auditory Comparison (AO to AV Auditory)');

% Set y-axis limits (optional, adjust based on your data range)
ylim([-0.5, 0.5]);  % Adjust the y-axis range if necessary

% Add grid for clarity
grid on;
% Auditory comparison: AO_Mu vs. AV_Aud_Mu
[p_Aud, h_Aud] = signrank(abs(AO_Mu), abs(AV_Aud_Mu));
hold on;
if p_Aud < 0.001
    text(0.5, 0.9, '***', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
elseif p_Aud < 0.01
    text(0.5, 0.9, '**', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
elseif p_Aud < 0.05
    text(0.5, 0.9, '*', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
else
    text(0.5, 0.9, 'n.s.', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
end
hold off;
beautifyplot;
hold off;

%% Second subplot: Visual comparison (VO_Mu to AV_Vis_Mu)
subplot(1, 2, 2);  % 1 row, 2 columns, position 2
hold on;

% Plot VO to AV_Vis (Visual Only to Visual Multisensory)
for i = 1:num_participants
    % Plot a line connecting VO_Mu and AV_Vis_Mu for each participant
    plot([1, 2], [VO_Mu(i), AV_Vis_Mu(i)], '-o', 'Color', [0, 0.4470, 0.7410], 'LineWidth', 1.5);
end

% Add horizontal zero line for reference
yline(0, 'k--', 'LineWidth', 1.5);  % Dashed line at y = 0

% Set the x-axis labels for visual comparison
xticks([1 2]);
xticklabels({'VO', 'AV Visual'});

% Label the axes
xlabel('Condition');
ylabel('PSE (Mu)');

% Add a title for the visual comparison
title('Visual Comparison (VO to AV Visual)');

% Set y-axis limits (optional, adjust based on your data range)
ylim([-0.5, 0.5]);  % Adjust the y-axis range if necessary

% Add grid for clarity
grid on;
% Auditory comparison: AO_Mu vs. AV_Aud_Mu
[p_Vis, h_Vis] = signrank(abs(VO_Mu), abs(AV_Vis_Mu));
hold on;
if p_Vis < 0.001
    text(0.5, 0.9, '***', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
elseif p_Vis < 0.01
    text(0.5, 0.9, '**', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
elseif p_Vis < 0.05
    text(0.5, 0.9, '*', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
else
    text(0.5, 0.9, 'n.s.', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
end
beautifyplot;
hold off;

% Assume AO_Mu, VO_Mu, AV_Aud_Mu, and AV_Vis_Mu are your data arrays (one value per participant)
num_participants = length(AO_Mu);  % Number of participants

% Create a new figure
figure;

%% First subplot: Auditory comparison (AO_Mu to Incong_AV_Aud_Mu)
subplot(1, 2, 1);  % 1 row, 2 columns, position 1
hold on;

% Plot AO to AV_Aud (Auditory Only to Auditory Multisensory)
for i = 1:num_participants
    % Plot a line connecting AO_Mu and AV_Aud_Mu for each participant
    plot([1, 2], [AO_Mu(i), Incong_AV_Aud_Mu(i)], '-o', 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 1.5);
end

% Add horizontal zero line for reference
yline(0, 'k--', 'LineWidth', 1.5);  % Dashed line at y = 0

% Set the x-axis labels for auditory comparison
xticks([1 2]);
xticklabels({'AO', 'Incong AV Auditory'});

% Label the axes
xlabel('Condition');
ylabel('PSE (Mu)');

% Add a title for the auditory comparison
title('Auditory Comparison (AO to Incong AV Auditory)');

% Set y-axis limits (optional, adjust based on your data range)
ylim([-0.5, 0.5]);  % Adjust the y-axis range if necessary

% Add grid for clarity
grid on;
% Auditory comparison: AO_Mu vs. AV_Aud_Mu
[p_Aud, h_Aud] = signrank(abs(AO_Mu), abs(Incong_AV_Aud_Mu));
hold on;
if p_Aud < 0.001
    text(0.5, 0.9, '***', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
elseif p_Aud < 0.01
    text(0.5, 0.9, '**', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
elseif p_Aud < 0.05
    text(0.5, 0.9, '*', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
else
    text(0.5, 0.9, 'n.s.', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
end
hold off;
beautifyplot;
hold off;

%% Second subplot: Visual comparison (VO_Mu to Incong_AV_Vis_Mu)
subplot(1, 2, 2);  % 1 row, 2 columns, position 2
hold on;

% Plot VO to AV_Vis (Visual Only to Visual Multisensory)
for i = 1:num_participants
    % Plot a line connecting VO_Mu and AV_Vis_Mu for each participant
    plot([1, 2], [VO_Mu(i), Incong_AV_Vis_Mu(i)], '-o', 'Color', [0, 0.4470, 0.7410], 'LineWidth', 1.5);
end

% Add horizontal zero line for reference
yline(0, 'k--', 'LineWidth', 1.5);  % Dashed line at y = 0

% Set the x-axis labels for visual comparison
xticks([1 2]);
xticklabels({'VO', 'Incong AV Visual'});

% Label the axes
xlabel('Condition');
ylabel('PSE (Mu)');

% Add a title for the visual comparison
title('Visual Comparison (VO to Incong AV Visual)');

% Set y-axis limits (optional, adjust based on your data range)
ylim([-0.5, 0.5]);  % Adjust the y-axis range if necessary

% Add grid for clarity
grid on;
% Auditory comparison: AO_Mu vs. AV_Aud_Mu
[p_Vis, h_Vis] = signrank(abs(VO_Mu), abs(Incong_AV_Vis_Mu));
hold on;
if p_Vis < 0.001
    text(0.5, 0.9, '***', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
elseif p_Vis < 0.01
    text(0.5, 0.9, '**', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
elseif p_Vis < 0.05
    text(0.5, 0.9, '*', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
else
    text(0.5, 0.9, 'n.s.', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
end
beautifyplot;
hold off;

%% MLE
% Scatter Plot
figure;
hold on;
scatter_size = 500;  % Define marker size for scatter plot
scatter(AV_AV_Std, AV_EstimatedSD, scatter_size, 's', 'filled', 'MarkerFaceColor', 'g', 'DisplayName', 'AV Std');
plot([0 1], [0 1], '--k', 'LineWidth', 2, 'DisplayName', 'Predicted MLE');
axis equal;
xlim([0 1]);
ylim([0 1]);
xlabel('Cue AV Std');
ylabel('MLE Predicted Std');

% Create the legend and adjust marker size in the legend
lgd = legend('show', 'Location', 'northwest');
lgd.ItemTokenSize = [25, 25];  % Adjust the marker size in the legend

beautifyplot;
set(gca, 'XTickLabelRotation', 45);
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 44);
hold off;

% Histogram (x - y)
delta = AV_AV_Std - AV_EstimatedSD;
% data = delta; 
% mu = mean(data);
% sigma = std(data);
% z_scores = (data - mu) / sigma;
% outlier_indices = abs(z_scores) > 3;
% cleaned_data = data(~outlier_indices);
% delta = cleaned_data;
%delta(15) = [];
figure;
histogram(delta, 10, 'FaceColor', 'g');  % 10 bins specified
xlim([-1 1]);  % Set x-axis range to -1 to 1
ylim([0 8]);   % Set y-axis range to 0 to 8
axis off;      % Remove axis

% Add a vertical dotted line at x = 0
hold on;
plot([0 0], ylim, 'k--', 'LineWidth', 2);  % Dotted line (--) at x = 0 in black ('k')

% Perform Wilcoxon Signed-Rank Test
[p, h] = signrank(delta);  % h is 1 if significant, 0 if not

% Annotate based on p-value, set color to black
hold on;
if p < 0.001
    text(0.5, 0.9, '***', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
elseif p < 0.01
    text(0.5, 0.9, '**', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
elseif p < 0.05
    text(0.5, 0.9, '*', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
else
    text(0.5, 0.9, 'n.s.', 'FontSize', 40, 'Units', 'normalized', 'Color', 'k');
end
hold off;

MS_Gain = Best_AO_VO_Std - AV_AV_Std;
data = MS_Gain; 
mu = mean(data);
sigma = std(data);
z_scores = (data - mu) / sigma;
outlier_indices = abs(z_scores) > 3;
cleaned_data = data(~outlier_indices);
Aud_Weight = Aud_Weight(~outlier_indices);
figure;
hold on;
scatter_size = 500;  % Define marker size for scatter plot
scatter(Aud_Weight, cleaned_data, scatter_size, '^', 'filled', 'MarkerFaceColor', '#7E2F8E', 'DisplayName', 'MS Gain');
xlabel('Aud Weight');
ylabel('MS Gain');
beautifyplot;
grid on;

AV_Aud_Std = AV_Aud_Std(~outlier_indices);
AV_Vis_Std = AV_Vis_Std(~outlier_indices);
AV_AV_Std = AV_AV_Std(~outlier_indices);

figure;
hold on;
scatter_size = 500;  % Define marker size for scatter plot
scatter(Aud_Weight, AV_Aud_Std, scatter_size, 'o', 'filled', 'MarkerFaceColor', '#D95319', 'DisplayName', 'Cue Aud');
hold on;
scatter(Aud_Weight, AV_Vis_Std, scatter_size, '^', 'filled', 'MarkerFaceColor', '#0072BD', 'DisplayName', 'Cue Vis');
hold on;
scatter(Aud_Weight, AV_AV_Std, scatter_size, 's', 'filled', 'MarkerFaceColor', '#77AC30', 'DisplayName', 'Cue AV');
xlabel('Aud Weight');
ylabel('AV Std');
lgd = legend('show', 'Location', 'northwest');
beautifyplot;
grid on;
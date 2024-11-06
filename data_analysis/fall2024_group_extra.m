% % --- Plot 2: Aud Cue vs AO ---
% figure;
% hold on;
% 
% % Indexing based on Aud_Weight
% below_threshold = Aud_Weight <= 0.5;  % Logical index for Aud_Weight <= 0.5
% above_threshold = Aud_Weight > 0.5;   % Logical index for Aud_Weight > 0.5
% 
% % Plot blue squares for Aud_Weight <= 0.5
% scatter(AO_Std(below_threshold), AV_Aud_Std(below_threshold), ...
%     scatter_size, 's', 'filled', 'MarkerFaceColor', 'b', 'DisplayName', 'Aud Weight <= 0.5');
% 
% % Plot maroon triangles for Aud_Weight > 0.5
% scatter(AO_Std(above_threshold), AV_Aud_Std(above_threshold), ...
%     scatter_size, '^', 'filled', 'MarkerFaceColor', '#A2142F', 'DisplayName', 'Aud Weight > 0.5');
% 
% % Add a reference line
% plot([0 1], [0 1], '--k', 'LineWidth', 2, 'DisplayName', 'Equal Sensitivity');
% 
% % Set axis properties
% axis equal;
% xlim([0 1]);
% ylim([0 1]);
% xlabel('Aud Only Std. Dev.');
% ylabel('AV Aud Cue Std. Dev.');
% 
% % Create the legend and adjust marker size in the legend
% lgd = legend('show', 'Location', 'northwest');
% lgd.ItemTokenSize = [25, 25];  % Adjust the marker size in the legend
% 
% % Apply additional formatting
% beautifyplot;
% set(gca, 'XTickLabelRotation', 45);
% set(findall(gcf, '-property', 'FontSize'), 'FontSize', 44);
% hold off;
% 
% % --- Plot 3: Vis Cue vs VO ---
% figure;
% hold on;
% 
% % Indexing based on Aud_Weight
% below_threshold = Aud_Weight <= 0.5;  % Logical index for Aud_Weight <= 0.5
% above_threshold = Aud_Weight > 0.5;   % Logical index for Aud_Weight > 0.5
% 
% % Plot blue squares for Aud_Weight <= 0.5
% scatter(VO_Std(below_threshold), AV_Vis_Std(below_threshold), ...
%     scatter_size, 's', 'filled', 'MarkerFaceColor', 'b', 'DisplayName', 'Aud Weight <= 0.5');
% 
% % Plot maroon triangles for Aud_Weight > 0.5
% scatter(VO_Std(above_threshold), AV_Vis_Std(above_threshold), ...
%     scatter_size, '^', 'filled', 'MarkerFaceColor', '#A2142F', 'DisplayName', 'Aud Weight > 0.5');
% 
% % Add a reference line
% plot([0 1], [0 1], '--k', 'LineWidth', 2, 'DisplayName', 'Equal Sensitivity');
% 
% % Set axis properties
% axis equal;
% xlim([0 1]);
% ylim([0 1]);
% xlabel('Vis Only Std. Dev.');
% ylabel('AV Vis Cue Std. Dev.');
% 
% % Create the legend and adjust marker size in the legend
% lgd = legend('show', 'Location', 'northwest');
% lgd.ItemTokenSize = [25, 25];  % Adjust the marker size in the legend
% 
% % Apply additional formatting
% beautifyplot;
% set(gca, 'XTickLabelRotation', 45);
% set(findall(gcf, '-property', 'FontSize'), 'FontSize', 44);
% hold off;
% 
% Incong_AV_Vis_Std(10) = [];

% --- Plot 3: Vis Cue Cong vs Incong ---
figure;
hold on;

% Indexing based on Aud_Weight
below_threshold = Aud_Weight < 0.4;  % Logical index for Aud_Weight <= 0.5
above_threshold = Aud_Weight > 0.6; % Logical index for Aud_Weight > 0.5
at_threshold = Aud_Weight >= 0.4 & Aud_Weight <= 0.6;


% Plot maroon triangles for Aud_Weight > 0.5
scatter(AV_Vis_Std(above_threshold), Incong_AV_Vis_Std(above_threshold), ...
    scatter_size, '^', 'filled', 'MarkerFaceColor', '#e0f3f8', 'DisplayName', 'Auditory Bias');

% Plot maroon triangles for Aud_Weight > 0.5
scatter(AV_Vis_Std(at_threshold), Incong_AV_Vis_Std(at_threshold), ...
    scatter_size, '^', 'filled', 'MarkerFaceColor', '#91bfdb', 'DisplayName', 'Equal Reliabilities');

% Plot blue squares for Aud_Weight <= 0.5
scatter(AV_Vis_Std(below_threshold), Incong_AV_Vis_Std(below_threshold), ...
    scatter_size, '^', 'filled', 'MarkerFaceColor', '#4575b4', 'DisplayName', 'Visual Bias');

% Add a reference line
plot([0 1], [0 1], '--k', 'LineWidth', 2, 'DisplayName', 'Equal Sensitivity');

% Set axis properties
axis equal;
xlim([0 1]);
ylim([0 1]);
xlabel('Cong Vis Cue Std. Dev.');
ylabel('Incong Vis Cue Std. Dev.');

% Create the legend and adjust marker size in the legend
[h, icons] = legend('show', 'Location', 'northwest', 'FontSize', 30);
h.ItemTokenSize = [25, 25];  % Adjust the marker size in the legend

icons = findobj(icons,'Type','patch');
icons = findobj(icons,'Marker','none','-xor');
set(icons(1),'MarkerSize',20); 
set(icons(2),'MarkerSize',20); 
set(icons(3),'MarkerSize',20);

% Set tick marks 
xticks([0 0.2 0.4 0.6 0.8 1]);
yticks([0 0.2 0.4 0.6 0.8 1]);

% Apply additional formatting
beautifyplot;
set(gca, 'XTickLabelRotation', 45);
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 38);
hold off;

% Histogram (x - y)
delta = AV_Vis_Std - Incong_AV_Vis_Std;
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
histogram(delta, 'BinEdges', binEdges, 'FaceColor', '#b17cbf');  % 10 bins specified
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

% --- Plot 3: Aud Cue Cong vs Incong ---
figure;
hold on;

% Indexing based on Aud_Weight
below_threshold = Aud_Weight < 0.4;  % Logical index for Aud_Weight <= 0.5
above_threshold = Aud_Weight > 0.6; % Logical index for Aud_Weight > 0.5
at_threshold = Aud_Weight >= 0.4 & Aud_Weight <= 0.6;


% Plot maroon triangles for Aud_Weight > 0.5
scatter(AV_Aud_Std(above_threshold), Incong_AV_Aud_Std(above_threshold), ...
    scatter_size, '^', 'filled', 'MarkerFaceColor', 'r', 'DisplayName', 'Auditory Capture');

% Plot maroon triangles for Aud_Weight > 0.5
scatter(AV_Aud_Std(at_threshold), Incong_AV_Aud_Std(at_threshold), ...
    scatter_size, '^', 'filled', 'MarkerFaceColor', '#068500', 'DisplayName', 'Equal Reliabilities');

% Plot blue squares for Aud_Weight <= 0.5
scatter(AV_Aud_Std(below_threshold), Incong_AV_Aud_Std(below_threshold), ...
    scatter_size, '^', 'filled', 'MarkerFaceColor', 'b', 'DisplayName', 'Visual Capture');

% Add a reference line
plot([0 1], [0 1], '--k', 'LineWidth', 2, 'DisplayName', 'Equal Sensitivity');

% Set axis properties
axis equal;
xlim([0 1]);
ylim([0 1]);
xlabel('Cong Aud Cue Std. Dev.');
ylabel('Incong Aud Cue Std. Dev.');

% Create the legend and adjust marker size in the legend
lgd = legend('show', 'Location', 'northwest');
lgd.ItemTokenSize = [25, 25];  % Adjust the marker size in the legend

% Create the legend and adjust marker size in the legend
[h, icons] = legend('show', 'Location', 'northwest', 'FontSize', 30);
h.ItemTokenSize = [25, 25];  % Adjust the marker size in the legend

icons = findobj(icons,'Type','patch');
icons = findobj(icons,'Marker','none','-xor');
set(icons(1),'MarkerSize',20); 
set(icons(2),'MarkerSize',20); 
set(icons(3),'MarkerSize',20);

% Set tick marks 
xticks([0 0.2 0.4 0.6 0.8 1]);
yticks([0 0.2 0.4]);

% Apply additional formatting
beautifyplot;
set(gca, 'XTickLabelRotation', 45);
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 38);
hold off;


%% W
figure;
hold on;

% Plot maroon triangles for Aud_Weight > 0.5
scatter(Aud_Weight, AV_AV_Std, scatter_size, 's', 'filled', 'MarkerFaceColor', '#009304', 'HandleVisibility', 'off');

% Fit the linear model
tbl = table(Aud_Weight, AV_AV_Std);
mdl = fitlm(tbl, 'AV_AV_Std ~ Aud_Weight');

% Plot the model with customizations
hModelPlot = plot(mdl);  % Capture the model plot handle

% Customize model line properties
set(hModelPlot(1), 'LineWidth', 3, 'Color', 'k');  % Main regression line
set(hModelPlot(2), 'LineWidth', 3, 'LineStyle', '--', 'Color', 'k');  % Confidence interval upper bound
set(hModelPlot(3), 'LineWidth', 3, 'LineStyle', '--', 'Color', 'k');  % Confidence interval lower bound
set(hModelPlot(4), 'LineWidth', 3, 'LineStyle', '--', 'Color', 'k');  % Confidence interval lower bound


xlim([0 1]);
ylim([0 0.4]);
xlabel('Auditory Weight (1 - Visual Weight)');
ylabel('AV Cue Std. Dev.');

% Set tick marks 
xticks([0 0.2 0.4 0.6 0.8 1]);
yticks([0 0.2 0.4]);

% Create the legend and adjust marker size in the legend
[h, icons] = legend('show', 'Location', 'northwest', 'FontSize', 30);
h.ItemTokenSize = [25, 25];  % Adjust the marker size in the legend

icons = findobj(icons, 'Type', 'patch');
icons = findobj(icons, 'Marker', 'none', '-xor');
% Adjust legend markers if needed
% set(icons(1), 'MarkerSize', 20); 
% set(icons(2), 'MarkerSize', 20); 
% set(icons(3), 'MarkerSize', 20);

legend('off');

beautifyplot;
set(gca, 'XTickLabelRotation', 45);
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 38);
hold off;


%% W
figure;
hold on;

% Plot maroon triangles for Aud_Weight > 0.5
scatter(Worst_Unisensory_Weight, MS_Gain, scatter_size, 's', 'filled', 'MarkerFaceColor', '#009304', 'HandleVisibility', 'off');

% Fit the linear model
tbl = table(Worst_Unisensory_Weight, MS_Gain);
mdl = fitlm(tbl, 'MS_Gain ~ Worst_Unisensory_Weight');

% Plot the model with customizations
hModelPlot = plot(mdl);  % Capture the model plot handle

% Customize model line properties
set(hModelPlot(1), 'LineWidth', 3, 'Color', 'k');  % Main regression line
set(hModelPlot(2), 'LineWidth', 3, 'LineStyle', '--', 'Color', 'k');  % Confidence interval upper bound
set(hModelPlot(3), 'LineWidth', 3, 'LineStyle', '--', 'Color', 'k');  % Confidence interval lower bound
set(hModelPlot(4), 'LineWidth', 3, 'LineStyle', '--', 'Color', 'k');  % Confidence interval lower bound


xlim([0 0.5]);
ylim([-0.2 0.2]);
xlabel('Worst Unisensory Weight');
ylabel('Multisensory Gain (Std. Dev.)');

% Set tick marks 
xticks([0 0.1 0.2 0.3 0.4 0.5]);
yticks([-0.2 0 0.2]);

% Create the legend and adjust marker size in the legend
[h, icons] = legend('show', 'Location', 'northwest', 'FontSize', 30);
h.ItemTokenSize = [25, 25];  % Adjust the marker size in the legend

icons = findobj(icons, 'Type', 'patch');
icons = findobj(icons, 'Marker', 'none', '-xor');
% Adjust legend markers if needed
% set(icons(1), 'MarkerSize', 20); 
% set(icons(2), 'MarkerSize', 20); 
% set(icons(3), 'MarkerSize', 20);

legend('off');

beautifyplot;
set(gca, 'XTickLabelRotation', 45);
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 38);
hold off;



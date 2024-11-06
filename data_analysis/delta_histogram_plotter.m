function delta_histogram_plotter(x, y, color, figure_font_size, x_name, y_name)
% Calculate the delta and remove outliers based on z-scores
delta = x - y;
data = delta; 
mu = mean(data);
sigma = std(data);
z_scores = (data - mu) / sigma;
outlier_indices = abs(z_scores) > 3;
cleaned_data = data(~outlier_indices);
delta = cleaned_data;

% Define the edges for bins symmetric around 0
binWidth = 1;  % Adjust the bin width as desired
maxEdge = ceil(max(abs(delta)) / binWidth) * binWidth;  % Ensure bins cover data
binEdges = -maxEdge-binWidth/10 : binWidth : maxEdge+binWidth/10;  % Centered on 0

figure;
histogram(delta, 'BinEdges', binEdges, 'FaceColor', color, 'FaceAlpha', 1, 'EdgeColor', 'k', 'LineWidth', 2.5);
xlim([-maxEdge maxEdge]);  % Symmetric x-axis range based on data

% Remove axis and add vertical dotted line at x = 0
xlim([-20 20])
xlabel_name = sprintf('%s - %s', x_name, y_name);
xlabel(xlabel_name, 'FontSize', 38);
ax = gca;               % Get the current axes
ax.YAxis.Visible = 'off'; % Turn off the y-axis completely
hold on;
plot([0 0], ylim, '--', 'Color', '#bbbbbb', 'LineWidth', 2.5);
delta_median = median(delta); 
%plot([delta_median delta_median], ylim, '-', 'Color', 'k', 'LineWidth', 2.5);  % Vertical line at delta_median


% Perform Wilcoxon Signed-Rank Test
[p, h] = signrank(delta);  % h is 1 if significant, 0 if not

% Apply styling functions
beautifyplot;
unmatlabifyplot;

set(findall(gcf, '-property', 'FontSize'), 'FontSize', figure_font_size);

y_limits = ylim;  % Get current y-axis limits
p_rounded = round(p, 4);
median_rounded = round(delta_median, 2);

% Display median and p-value on the plot
text_location_x = 10;
text_location_y = y_limits(2) - 1;
text_str = sprintf('median = %.3f\np = %.3f', median_rounded, p_rounded);
text(text_location_x, text_location_y, text_str, 'FontSize', 36, 'FontWeight', 'bold', 'FontName', 'Times New Roman');

% text(10, y_limits(2) - 1, "median = " + num2str(median_rounded), 'FontName', 'Times New Roman', 'FontSize', 36);
% text(10, y_limits(2) - 1.3, "p = " + num2str(p_rounded), 'FontName', 'Times New Roman', 'FontSize', 36);

hold off;
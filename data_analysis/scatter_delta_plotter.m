function [delta, p] = scatter_delta_plotter(x_var, y_var, plot_color, x_var_name, y_var_name)
% Scatter Plot
figure;
hold on;
scatter(x_var, y_var, 500, 'o', 'filled', 'MarkerFaceColor', plot_color);
plot([0 1], [0 1], '--k', 'LineWidth', 2, 'DisplayName', 'Equal Sensitivity');
axis equal;
xlim([0 1]);
ylim([0 1]);
xlabel(x_var_name);
ylabel(y_var_name);

% Create the legend and adjust marker size in the legend
lgd = legend('show', 'Location', 'northwest');
lgd.ItemTokenSize = [25, 25];  % Adjust the marker size in the legend

beautifyplot;
set(gca, 'XTickLabelRotation', 45);
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 44);
hold off;

% Histogram
delta = x_var - y_var;
data = delta; 
mu = mean(data);
sigma = std(data);
z_scores = (data - mu) / sigma;
outlier_indices = abs(z_scores) > 3;
cleaned_data = data(~outlier_indices);
delta = cleaned_data;
figure;
histogram(delta, 10, 'FaceColor', 'r');  % 10 bins specified
xlim([-1 1]);
ylim([0 8]);
axis off;

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
end
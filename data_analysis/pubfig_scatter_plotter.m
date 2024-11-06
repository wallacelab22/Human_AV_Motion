function pubfig_scatter_plotter(x_values, y_values, scatter_icon, scatter_color, figure_font_size, scatter_size, x_name, y_name)
% Scatter Plot
figure;
hold on;
plot([0 20], [0 20], '--', 'Color', '#bbbbbb', 'LineWidth', 2.5, 'DisplayName', 'Equal Sensitivity', 'HandleVisibility', 'off');
scatter(x_values, y_values, scatter_size, scatter_icon, 'filled', 'MarkerFaceColor', scatter_color, 'HandleVisibility', 'off');
xlim([0 20]);
ylim([0 20]);
xlabel(x_name, 'FontSize', figure_font_size);
ylabel(y_name, 'FontSize', figure_font_size);
axis square
% Set tick marks 
xticks([0 4 8 12 16 20]);
yticks([0 4 8 12 16 20]);

% Create the legend and adjust its properties
%[h, icons] = legend('show', 'Location', 'northwest', 'FontSize', 30, 'FontName', 'Times New Roman');  % Set legend font size
%h.ItemTokenSize = [25, 25];  % Match the size of the markers in the legend to the scatter plot

beautifyplot;
unmatlabifyplot;
set(findall(gcf, '-property', 'FontSize'), 'FontSize', figure_font_size);

hold off;

end
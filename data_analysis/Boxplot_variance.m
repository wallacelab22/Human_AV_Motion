% Example data for AUD and VIS Weights
AUD_W = [0.446, 0.4529, 0.4807, 0.0147, 0.7829, 0.1546, 0.1928, 0.2, 0.7954];
VIS_W = [0.554, 0.5471, 0.5193, 0.9853, 0.2171, 0.8454, 0.8072, 0.8, 0.2046];

% Combine the data into a matrix for boxplot
data = [AUD_W', VIS_W'];

% Create box plots
figure;
h = boxplot(data, 'Labels', {'AUD Weights', 'VIS Weights'});
title('Grouped Box Plots for Auditory and Visual Weights');
ylabel('Weight');

% Customize colors for the box plots
set(h, {'linew'}, {2});
boxColors = {'r', 'b'}; % Red for AUD, Blue for VIS
h = findobj(gca, 'Tag', 'Box');
% Reverse the handle array to match the order of boxColors
h = flipud(h);

for j = 1:length(h)
    patch(get(h(j), 'XData'), get(h(j), 'YData'), boxColors{j}, 'FaceAlpha', 0.5);
end

% Add individual data points
hold on;
scatter(ones(size(AUD_W)), AUD_W, 'r', 'filled', 'SizeData', 70); % Auditory data in red
scatter(2 * ones(size(VIS_W)), VIS_W, 'b', 'filled', 'SizeData', 70); % Visual data in blue

% Connect corresponding column values with a line
for i = 1:length(AUD_W)
    plot([1, 2], [AUD_W(i), VIS_W(i)], 'k-', 'LineWidth', 1.5); % Thicker black line
end

% Customize labels and appearance
set(gca, 'XTickLabelRotation', 45); % Rotate x-axis labels for better readability
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
grid on;

% Turn off hold
hold off;

function plotconsecutiveValues(data, style)
% Plot in bar graphs ascending values of a given value
data = [0.27512
0.4372
0.26784
0.47078
0.22731
0.27953
0.21355
0.33879
0.57529
0.26563
0.46107
0.32507
0.25191
0.45722
0.20148
0.30142
0.22456
0.29466
0.22489
0.33886
0.21723
0.32151
0.27523
0.51113
0.28749
0.39283
2.8863
0.2895
0.45235
0.76224
0.50088
1.2892
0.33999
0.23975
0.17116
0.71536
0.31519
0.27249
0.20094
0.24053
0.51857
0.23592
0.36451
0.37707
0.21661
0.24194
0.19279
0.25675
0.33048
0.45715];

style = 'descend';
data = sort(data, style);
mediandata = median(data);

data = data(3:end);

figure;
set(gcf, 'Units', 'inches', 'Position', [0, 0, 8, 4]);

b = bar(data);

% Apply the winter colormap
colormap(winter);

% Get the current colormap
cmap = colormap;

% Set colors for each bar using the colormap
num_bars = length(data);
color_indices = round(linspace(1, size(cmap, 1), num_bars));
colors = cmap(color_indices, :);

for k = 1:num_bars
    b.FaceColor = 'flat';
    b.CData(k, :) = colors(k, :);
end

% Add y-axis dotted line for median
hold on;
hLine = line([0, length(data) + 1], [mediandata, mediandata], 'Color', 'k', 'LineStyle', '--');

% Label the y-axis and x-axis
ylabel('JND', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('Participant', 'FontSize', 14, 'FontWeight', 'bold');

% Adjust y-axis limits
ylim([0 max(data) + 0.2]);

% Add grid lines
grid on;
ax = gca;
ax.GridLineStyle = '--';

% Create the legend
legend(hLine, 'Median', 'FontSize', 12, 'Location', 'best');

hold off;

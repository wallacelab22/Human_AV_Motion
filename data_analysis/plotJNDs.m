function plotJNDs(aJND,vJND, avJND, avMLE)
% Plots a histogram of JNDs (or variance) for unisensory (A and V) and
% multisensory as well as a dotted line for MLE optimal JND (variance)

aJND = 0.3; 
vJND = 0.2; 
avJND = 0.13; 
avMLE = 0.167;

bardata = [aJND, vJND, avJND];
colors = [224,243,219; 168,221,181; 67,162,202] / 255;  % Convert to color palette

% Create figure and set size
figure;
set(gcf, 'Units', 'inches', 'Position', [0, 0, 3, 6]); 

% Create bar plot
b = bar(bardata);

% Apply colors to each bar
for k = 1:length(bardata)
    b.FaceColor = 'flat';
    b.CData(k, :) = colors(k, :);
end

% Add y-axis dotted line for avMLE
hold on;
hLine = line([0, length(bardata) + 1], [avMLE, avMLE], 'Color', 'k', 'LineStyle', '--');

% Add a dummy plot for the legend
hLegend = plot(nan, nan, 'k--');

% Label the y-axis and x-axis
ylabel('JND', 'FontSize', 14, 'FontWeight', 'bold');
set(gca, 'XTickLabel', {'Auditory', 'Visual', 'Audiovisual'}, 'FontSize', 14, 'FontWeight', 'bold');

% Adjust y-axis limits
ylim([0 max(bardata) + 0.2]);

% Add grid lines
grid on;
ax = gca;
ax.GridLineStyle = '--';

% Create the legend
legend(hLine, 'MLE predicted', 'FontSize', 14, 'Location', 'best');

% Save the figure
print('bar_plot', '-dpdf', '-r300');

hold off;



end
% Data for SD
BEST_SD = [0.1345 0.2081 0.3401 0.1688 0.187 0.2579 0.2669 0.1343 0.1553];
AV_SD = [0.1302	0.1937	0.6573	0.1423	0.3326	0.2212	0.25	0.1084	0.0913];

% Combine into a single matrix
sd_data = [BEST_SD', AV_SD'];

% Create box plots for SD data
figure;
h = boxplot(sd_data, 'Labels', {'MIN A,V SD', 'AV SD'});
title('Min. Unisensory and AV SD');
ylabel('SD Values');

% Color the boxes
set(h, {'linew'}, {2});
colors = {'m', 'g'}; % Red for AUD, Blue for VIS
h = findobj(gca, 'Tag', 'Box');
for j = 1:length(h)
   patch(get(h(j), 'XData'), get(h(j), 'YData'), colors{j}, 'FaceAlpha', 0.5);
end

% Add individual data points for SD
hold on;
scatter(ones(size(BEST_SD)), BEST_SD, 'g', 'filled', 'SizeData', 70);
scatter(2 * ones(size(AV_SD)), AV_SD, 'm', 'filled', 'SizeData', 70);

% Connect corresponding column values with a line for SD
for i = 1:length(BEST_SD)
    plot([1, 2], [BEST_SD(i), AV_SD(i)], 'k-', 'LineWidth', 1.5); % Thicker black line
end

hold off;
grid on;
set(gca, 'XTickLabelRotation', 45);
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)


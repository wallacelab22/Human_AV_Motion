% Data for SD
AUD_SD = [0.1499 0.2288 0.3535 1.3816 0.187 0.6031 0.5462 0.2686 0.1553];
VIS_SD = [0.1345 0.2081 0.3401 0.1688 0.3551 0.2579 0.2669 0.1343 0.3062];

% Combine into a single matrix
sd_data = [AUD_SD', VIS_SD'];

% Create box plots for SD data
figure;
h = boxplot(sd_data, 'Labels', {'AUD SD', 'VIS SD'});
title('Box Plots for Auditory and Visual SD');
ylabel('SD Values');

% Color the boxes
set(h, {'linew'}, {2});
colors = {'b', 'r'}; % Red for AUD, Blue for VIS
h = findobj(gca, 'Tag', 'Box');
for j = 1:length(h)
   patch(get(h(j), 'XData'), get(h(j), 'YData'), colors{j}, 'FaceAlpha', 0.5);
end

% Add individual data points for SD
hold on;
scatter(ones(size(AUD_SD)), AUD_SD, 'r', 'filled', 'SizeData', 70);
scatter(2 * ones(size(VIS_SD)), VIS_SD, 'b', 'filled', 'SizeData', 70);

% Connect corresponding column values with a line for SD
for i = 1:length(AUD_SD)
    plot([1, 2], [AUD_SD(i), VIS_SD(i)], 'k-', 'LineWidth', 1.5); % Thicker black line
end

hold off;
grid on;
set(gca, 'XTickLabelRotation', 45);
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)


function acc_boxplotter(maxA_V, AV_perf, group_type)
acc_data = [maxA_V, AV_perf];

% Create box plots for SD data
figure;
h = boxplot(acc_data, 'Labels', {'Unisensory', 'Audiovisual'});
title(sprintf('%s Accuracy', group_type));
ylabel('Accuracy');
ylim([0.3 1]);

% Color the boxes
set(h, {'linew'}, {2});
colors = {'m', 'g'}; % Red for AUD, Blue for VIS
h = findobj(gca, 'Tag', 'Box');
for j = 1:length(h)
   patch(get(h(j), 'XData'), get(h(j), 'YData'), colors{j}, 'FaceAlpha', 0.5);
end

% Add individual data points for SD
hold on;
scatter(ones(size(maxA_V)), maxA_V, 'g', 'filled', 'SizeData', 70);
scatter(2 * ones(size(AV_perf)), AV_perf, 'm', 'filled', 'SizeData', 70);

% Connect corresponding column values with a line for SD
for i = 1:length(maxA_V)
    plot([1, 2], [maxA_V(i), AV_perf(i)], 'k-', 'LineWidth', 1.5); % Thicker black line
end

hold off;
grid on;
set(gca, 'XTickLabelRotation', 45);
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)

% Run a paired ttest on data to test for significant difference
[h, p] = ttest(maxA_V, AV_perf);
fprintf('Paired t-test = %d\n', h);
fprintf('Max A,V and AV - p-value: %f\n', p);

% Add significance indicator if significant
if h == 1  % If test indicates significance
    ylims = get(gca, 'YLim');
    text(1.5, ylims(2)-0.7, '*', 'FontSize', 44, 'HorizontalAlignment', 'center'); % Place asterisk
    % Draw line
    %line([1,2], [ylims(2)-0.5, ylims(2)-0.5], 'Color', 'k'); % Adjust line position as needed
end
end
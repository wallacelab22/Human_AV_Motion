clear;
close all;
clc;

% Data for SD
AUD_SD = [0.27512
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
0.17707
0.2895
0.45235
0.18036
0.76224
0.50088
1.2892
0.33999
0.23055
0.30304
0.22643];

VIS_SD = [0.12911
1.2164
1.1077
0.31181
0.38456
0.8688
0.25127
0.13106
0.82861
0.35632
0.43908
0.21289
0.39296
2.2038
0.1602
0.45691
0.29228
2.0834
0.66047
0.17655
0.3873
0.32601
0.47192
0.33141
0.33894
0.26337
0.65264
0.2919
0.14771
0.725
0.63371
0.52504
1.8038
0.47833];

meanAUD = mean(AUD_SD); medianAUD = median(AUD_SD);
meanVIS = mean(VIS_SD); medianVIS = median(VIS_SD);

% Combine into a single matrix
sd_data = [AUD_SD, VIS_SD];

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

% Compute the differences in individual's SD
sd_diff = sd_data(:,1) - sd_data(:,2);
same_slope = [];
for i = 1:length(sd_diff)
    if -0.1 <= sd_diff(i) && sd_diff(i) <= 0.1
        same_slope = [same_slope sd_diff(i)]; 
    end
end

for i = 1:length(same_slope)
    same_indices = find(sd_diff == same_slope(i));
end

% Run a paired ttest on data to test for significant difference
[h_std, p_std] = ttest(AUD_SD, VIS_SD);
fprintf('Paired t-test = %d\n', h_std);
fprintf('Sensitivity Comparison - p-value: %f\n', p_std);

% Add significance indicator if significant
if h_std == 1  % If test indicates significance
    ylims = get(gca, 'YLim');
    text(1.5, ylims(2)-0.3, '*', 'FontSize', 44, 'HorizontalAlignment', 'center'); % Place asterisk
    % Draw line
    %line([1,2], [ylims(2)-0.5, ylims(2)-0.5], 'Color', 'k'); % Adjust line position as needed
end

maxA_V = [0.875
0.825
0.95
0.825
0.425
0.675
0.65
0.45
1
0.825
0.875];

AV_perf = [0.908333
0.775
0.825
0.825
0.525
0.55
0.65
0.6
0.9
0.8
0.775];

acc_data = [maxA_V, AV_perf];

% Create box plots for SD data
figure;
h = boxplot(acc_data, 'Labels', {'MAX A,V', 'AV'});
title('Box Plots for Best Unisensory and AV ACC');
ylabel('Accuracy Values');

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
fprintf('Sensitivity Comparison - p-value: %f\n', p);

maxA_V = [1
0.975
0.8
0.65
0.525
0.575
0.95
0.7
0.575
0.5
0.6
0.925
0.925
0.575];

AV_perf = [1
0.975
0.691666667
0.425
0.6
0.525
0.775
0.675
0.55
0.625
0.575
0.65
0.8
0.35];

acc_data = [maxA_V, AV_perf];

% Create box plots for SD data
figure;
h = boxplot(acc_data, 'Labels', {'MAX A,V', 'AV'});
title('Box Plots for Best Unisensory and AV ACC');
ylabel('Accuracy Values');

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
fprintf('Sensitivity Comparison - p-value: %f\n', p);

% Add significance indicator if significant
if h == 1  % If test indicates significance
    ylims = get(gca, 'YLim');
    text(1.5, ylims(2)-0.7, '*', 'FontSize', 44, 'HorizontalAlignment', 'center'); % Place asterisk
    % Draw line
    %line([1,2], [ylims(2)-0.5, ylims(2)-0.5], 'Color', 'k'); % Adjust line position as needed
end
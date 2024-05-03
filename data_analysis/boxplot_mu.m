clear;
close all;
clc;

% Data for Mu
AUD_Mu = [-0.059071
-0.020995
-0.049343
0.094183
-0.015137
0.041355
-0.032411
-0.056358
0.13552
0.024868
0.077716
-0.0044432
-0.077071
-0.06862
0.12534
0.11273
0.15039
-0.0029127
0.010428
0.12007
-0.02273
-0.025283
0.067933
0.035544
0.017471
-0.023554
-0.041634
-0.31807
0.006293
-0.26239
0.087785
-0.021117
0.01799
0.052081];
VIS_Mu = [-0.030555
0.093494
0.057849
-0.11091
-0.065507
-0.41443
0.019286
-0.07493
0.12361
-0.42472
-0.059854
-0.037207
-0.070533
-0.3596
-0.011491
0.039617
-0.00069259
-0.85377
-0.010512
0.016491
-0.085804
-0.014681
-0.35751
-0.037279
0.075679
0.038463
-0.044429
-0.028354
0.021066
-0.37613
0.22833
0.13465
0.36179
-0.16985];

meanAUD_Mu = mean(AUD_Mu); medianAUD_Mu = median(AUD_Mu);
meanVIS_Mu = mean(VIS_Mu); medianVIS_Mu = median(VIS_Mu);

% Combine into a single matrix
mu_data = [AUD_Mu, VIS_Mu];

% Create box plots for Mu data
figure;
h = boxplot(mu_data, 'Labels', {'AUD Mu', 'VIS Mu'});
title('Box Plots for Auditory and Visual Mu');
ylabel('Mu Values');

% Color the boxes
set(h, {'linew'}, {2});
colors = {'b', 'r'}; % Red for AUD, Blue for VIS
h = findobj(gca, 'Tag', 'Box');
for j = 1:length(h)
   patch(get(h(j), 'XData'), get(h(j), 'YData'), colors{j}, 'FaceAlpha', 0.5);
end

% Add individual data points for Mu
hold on;
scatter(ones(size(AUD_Mu)), AUD_Mu, 'r', 'filled', 'SizeData', 70);
scatter(2 * ones(size(VIS_Mu)), VIS_Mu, 'b', 'filled', 'SizeData', 70);

% Connect corresponding column values with a line for Mu
for i = 1:length(AUD_Mu)
    plot([1, 2], [AUD_Mu(i), VIS_Mu(i)], 'k-', 'LineWidth', 1.5); % Thicker black line
end

hold off;
grid on;
set(gca, 'XTickLabelRotation', 45);
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)

% Run a paired ttest on data to test for significant difference
[h_mu, p_mu] = ttest(AUD_Mu, VIS_Mu);
fprintf('Paired t-test = %d\n', h_mu);
fprintf('Sensitivity Comparison - p-value: %f\n', p_mu);

% Add significance indicator if significant
if h_mu == 1  % If test indicates significance
    ylims = get(gca, 'YLim');
    text(1.5, ylims(2)-0.3, '*', 'FontSize', 44, 'HorizontalAlignment', 'center'); % Place asterisk
    % Draw line
    %line([1,2], [ylims(2)-0.5, ylims(2)-0.5], 'Color', 'k'); % Adjust line position as needed
end

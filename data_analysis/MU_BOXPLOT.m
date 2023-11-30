% Data for Mu
AUD_Mu = [0.0078 -0.0185 0.0685 0.188 -0.0583 -0.102 0.2441 -0.1129 -0.1089];
VIS_Mu = [-0.0437 -0.0129 -0.001 -0.0795 -0.0138 0.1055 -0.0742 0.028 -0.029];

% Combine into a single matrix
mu_data = [AUD_Mu', VIS_Mu'];

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

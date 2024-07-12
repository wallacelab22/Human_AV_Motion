function distribution_plotter(x)

xVar = inputname(1);

figure; % Create a new figure window
histogram(x, 50, 'FaceColor', 'g'); 
titleName = sprintf('Distribution of %s', xVar);
title(titleName);
xlabel(xVar);
xlim([min(x) max(x)]);
ylim([0 12]);
ylabel('Frequency');
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
grid on;
set(gca, 'XTickLabelRotation', 45);
end
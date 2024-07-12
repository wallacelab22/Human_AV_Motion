function scatter_plotter(x, y)

xVar = inputname(1);
yVar = inputname(2);

figure; hold on;
scatter(x, y, 'k', 'filled', 'SizeData', 70);
xlabel(xVar);
ylabel(yVar);
titleName = sprintf('Scatter between %s & %s', xVar, yVar);
title(titleName);
beautifyplot;

end
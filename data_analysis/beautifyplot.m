function beautifyplot
% I used this over and over, so now in a single function.

set(gca, 'xcolor', 'k');
set(gca, 'ycolor', 'k');
set(gca, 'LineWidth', 1.5);
set(gca, 'FontName','Helvetica')
set(gca, 'FontSize', 14);
set(gca, 'TickDir', 'in');
box off;
set(gca ,'Layer', 'Top')

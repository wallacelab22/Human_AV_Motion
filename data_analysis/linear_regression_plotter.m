function linear_regression_plotter(x_values, y_values, scatter_icon, scatter_color, figure_font_size, scatter_size, x_name, y_name, x_lim, x_ticks, y_lim, y_ticks)

    % Create table for linear regression
    tbl = table(x_values, y_values);
    mdl = fitlm(tbl);  % No outlier removal or robust options

    % Plot the scatter plot
    figure;
    hold on;
    scatter(x_values, y_values, scatter_size, scatter_icon, 'filled', 'MarkerFaceColor', scatter_color, 'HandleVisibility', 'off');

    % Plot the fitted linear model
    hModelPlot = plot(mdl);  % Capture the model plot handle

    % Customize model line and confidence intervals, show only regression
    set(hModelPlot(1), 'Visible', 'off');
    set(hModelPlot(2), 'LineStyle', '--', 'LineWidth', 3, 'Color', 'k');                   
    set(hModelPlot(3), 'Visible', 'off');                  
    set(hModelPlot(4), 'Visible', 'off');   

    % Label axes
    xlabel(x_name);
    ylabel(y_name);

    xlim(x_lim);
    ylim(y_lim);

    % Set tick marks 
    xticks(x_ticks);
    yticks(y_ticks);

    % Retrieve R^2 and p-value from the model
    R2 = mdl.Rsquared.Ordinary;
    p_value = mdl.Coefficients.pValue(2);  % p-value for the slope coefficient

    % Display R^2 and p-value on the plot
    text_location_x = min(x_values) + 0.1 * range(x_values);
    text_location_y = max(y_values) - 0.1 * range(y_values);
    text_str = sprintf('R^2 = %.3f\np = %.3f', R2, p_value);
    text(text_location_x, text_location_y, text_str, 'FontSize', 14, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
    
    legend('off');
    title('');

    % Beautify plot
    beautifyplot;
    unmatlabifyplot;
    set(findall(gcf, '-property', 'FontSize'), 'FontSize', figure_font_size);
    hold off;
end

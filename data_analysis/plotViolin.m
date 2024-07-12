function plotViolin(dataMatrix, connectPoints)

connectPoints = false;
% dataMatrix = [];
dataMatrix = [0.825	0.7	0.775	0.95	0.75
0.95	0.725	0.825	0.875	0.775
0.825	0.725	0.825	0.9	0.9
0.425	0.4	0.525	0.6	0.65
0.575	0.675	0.55	0.425	0.65
0.625	0.65	0.65	0.575	0.925
0.45	0.4	0.6	0.625	0.6
0.675	0.825	0.8	1	0.75
0.725	0.875	0.775	0.725	0.65
0.625	0.45	0.55	0.5	0.55
0.9	0.5	0.625	1	0.425
0.9	0.575	0.475	0.925	0.475
0.925	0.6	0.8	0.9	0.55
0.675	0.8	0.85	0.55	0.85
0.55	0.775	0.675	0.675	0.625
0.875	0.775	0.658333333	0.658333333	0.658333333
0.5	0.925	0.9	0.5	0.85
0.775	0.95	0.95	0.675	1
0.325	1	1	0.475	1
0.975	0.875	0.975	1	0.85
0.8	0.55	0.691666667	0.691666667	0.691666667
0.65	0.45	0.425	0.45	0.7
0.5	0.525	0.6	0.6	0.775
0.6	0.65	0.675	0.525	0.6
0.85	0.45	0.75	0.825	0.55
0.775	0.475	0.566666667	0.566666667	0.566666667
0.525	0.5	0.675	0.525	0.475
0.95	0.6	0.775	0.9	0.625
0.7	0.65	0.675	0.9	0.75
0.5	0.425	0.625	0.95	0.6
0.925	0.625	0.65	1	0.525
0.925	0.55	0.8	0.75	0.725
0.575	0.325	0.35	0.425	0.4
0.5	0.775	0.775	0.775	0.775
0.625	0.775	0.675	0.725	0.825
0.55	0.75	0.8	0.925	0.825
0.5	0.475	0.55	0.55	0.55
0.55	0.55	0.55	0.45	0.675
0.475	0.7	0.675	0.7	0.825
0.625	0.525	0.6	0.65	0.675
0.5	0.725	0.766666667	0.766666667	0.766666667
0.6	0.275	0.625	0.6	0.55
0.75	0.7	0.575	0.95	0.7
0.55	0.525	0.5	0.65	0.45
0.525	0.8	0.7	0.975	0.75
0.575	0.75	0.75	0.65	0.825
0.475	0.5	0.55	0.65	0.55
0.675	0.8	0.725	0.8	0.85
0.625	0.375	0.45	0.4	0.55
0.6	0.475	0.775	0.9	0.475];

    % Validate connectPoints parameter
    if ~islogical(connectPoints) || numel(connectPoints) ~= 1
        error('connectPoints should be a single boolean value.');
    end

    % Get the number of columns
    [x, n] = size(dataMatrix);

    % Create the violin plot
    figure;
    hold on;
    colors = winter(n); % Use the winter colormap

    for i = 1:n
        % Get data for the i-th column
        data = dataMatrix(:, i);

        % Create a kernel density estimate
        [f, xi] = ksdensity(data);
        f = f / max(f) * 0.4; % Normalize and scale for plotting

        % Plot the violin
        patch([i - f, fliplr(i + f)], [xi, fliplr(xi)], colors(i, :), ...
             'FaceAlpha', 0.3, 'EdgeColor', 'none');
        
        % Plot the median line
        medianValue = median(data);
        plot([i - 0.4, i + 0.4], [medianValue, medianValue], 'k--', 'LineWidth', 2);

        % Add median value text if connectPoints is false
        if ~connectPoints
            text(i, medianValue + 0.02, num2str(medianValue, '%.2f'), 'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'FontSize', 18);
        end
    end

    % Connect individual data points in rows if connectPoints is true
    if connectPoints
        for i = 1:x
            plot(1:n, dataMatrix(i, :), '-o', 'Color', [0.5, 0.5, 0.5, 0.5], 'LineWidth', 1.5);
        end
    end

    % Run permutation tests and annotate significant differences
    permutations = 500;
    for i = 1:n-1
        for j = i+1:n
            [p, ~, ~] = permutationTest(dataMatrix(:, i), dataMatrix(:, j), permutations);
            if p < 0.05
                % Plot significance line and asterisk
                yMax = max([max(dataMatrix(:, i)), max(dataMatrix(:, j))]);
                line([i, j], [yMax + 0.05, yMax + 0.05], 'Color', 'k', 'LineWidth', 2);
                line([i, i], [yMax + 0.04, yMax + 0.06], 'Color', 'k', 'LineWidth', 2);
                line([j, j], [yMax + 0.04, yMax + 0.06], 'Color', 'k', 'LineWidth', 2);
                text((i + j) / 2, yMax + 0.07, '*', 'HorizontalAlignment', 'center', 'FontSize', 14, 'FontWeight', 'bold', 'FontSize', 18);
            end
        end
    end

    % Set the x-axis labels and format the plot
    set(gca, 'XTick', 1:n, 'XTickLabel', 1:n, 'FontWeight', 'bold', 'LineWidth', 2);
    xlabel('Columns', 'FontWeight', 'bold');
    ylabel('Values', 'FontWeight', 'bold');
    set(gca, 'FontSize', 24);
    ylim([0 1.4]);
    title('Violin Plot with Data Points Connection', 'FontWeight', 'bold');
    grid on;
    hold off;
end

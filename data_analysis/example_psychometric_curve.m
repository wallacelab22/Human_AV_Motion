% Create a figure
figure;

% Define x values from -1 to 1
x = linspace(-1, 1, 1000);

% Define the sigmoid function as the psychometric function
% Using a shallower steepness coefficient
y = 1 ./ (1 + exp(-5 * x));

% Plot the psychometric curve and get a handle for it
hBehavioral = plot(x, y, 'g', 'LineWidth', 2); % 'g' for green color
hold on; % Keep the plot to add more features

% Plot a vertical dotted line at x = 0 from y = 0 to y = 0.5 and get a handle
hPSEVertical = plot([0, 0], [0, 0.5], 'k:', 'LineWidth', 2); % 'k' for black color and ':' for dotted line

% Plot a horizontal dotted line from x = -1 to x = 0 at y = 0.5 and get a handle
hPSEHorizontal = plot([-1, 0], [0.5, 0.5], 'k:', 'LineWidth', 2);

% Set the x and y axis limits
xlim([-1, 1]);
ylim([0, 1]);

% Label the axes
xlabel('Coherence (- Leftward, + Rightward)');
ylabel('% Rightward Response');

% Add a title
title('Psychometric Curve');

% Add grid for better visibility
grid on;

% Add a legend
legend([hBehavioral, hPSEVertical], 'Behavioral Data', 'PSE', 'Location', 'best');

% Turn off hold
hold off;


plotEstimatedAV(0.2289, [-0.0253 -0.0147], [0.5069 0.4931])

function plotEstimatedAV(estimated_sigma, mus, weights)
    mu_aud = mus(1); mu_vis = mus(2);
    weight_aud = weights(1); weight_vis = weights(2);
    
    estimated_mu = (mu_aud*weight_aud) + (mu_vis*weight_vis);

    % Define the range of x values
    x = linspace(-1, 1, 1000);

    % Define the psychometric function using the logistic equation
    y = 1 ./ (1 + exp(-(x - estimated_mu)/estimated_sigma));

    % Plot the psychometric curve
    plot(x, y, 'g', 'LineWidth', 2);
    hold on;

    % Formatting the plot
    title('Psychometric Curve with Given Variance');
    xlabel('Stimulus Intensity');
    ylabel('Response Probability');
    xlim([-1, 1]);
    ylim([0, 1]);
    grid on;

%     % Plot reference lines for PSE at the mean
%     plot([0, 0], [0, 0.5], 'k:', 'LineWidth', 2);
%     plot([-1, 0], [0.5, 0.5], 'k:', 'LineWidth', 2);

    % Add a legend
    legend('Behavioral Data', 'PSE', 'Location', 'best');

    % Release the hold
    hold off;
end


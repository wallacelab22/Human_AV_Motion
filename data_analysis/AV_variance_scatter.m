% Data matrix
data = [0.01 0.017
        0.0237 0.0375
        0.0601 0.432
        0.0281 0.0203
        0.0274 0.1106
        0.0562 0.0489
        0.0575 0.0625
        0.0144 0.0118]

% Create a figure
figure;

% Get 'cool' colormap for the number of participants
numParticipants = size(data, 1);
colors = turbo(numParticipants);

% Hold the plot for multiple scatter plots
hold on;

% Plot each row of the matrix as a dot, each with a different color
for i = 1:numParticipants
    scatter(data(i, 1), data(i, 2), 100, colors(i, :), 'filled', 'LineWidth', 1.5);
end

% Plot the dotted line y = x
x = min(data(:)):0.01:max(data(:)); % Define the x values for the line
plot(x, x, '--k', 'LineWidth', 2); % '--k' specifies a black dotted line and increases the line width

% Add labels and title
ylabel('AV empirical variance');
xlabel('MLE AV estimated variance');
title('AV-AV variance');
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
grid on

% Turn off the 'hold'
hold off;

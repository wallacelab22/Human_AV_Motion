% Assuming your data is stored in d_prime_matrix (10x3)
d_prime_matrix = rand(10, 5);  % Example data, replace with your actual matrix

% Create a heatmap
figure;  % Create a new figure
imagesc(d_prime_matrix);  % Create the heatmap
colormap('cool');  % Choose a colormap, e.g., 'hot', 'jet', etc.
colorbar;  % Add a colorbar to show the mapping of data values to colors

% Add labels and titles
xlabel('Condition');
ylabel('Participant');
title('D Prime Scores Heatmap');
set(gca, 'XTick', 1:6, 'XTickLabel', {'Auditory', 'Visual', 'Audiovisual'});
set(gca, 'YTick', 1:10, 'YTickLabel', arrayfun(@num2str, 1:10, 'UniformOutput', false));

% Optionally, adjust the aspect ratio
pbaspect([1 1.5 1]);  % Adjust aspect ratio as needed

% Display the values on the heatmap
[numParticipants, numConditions] = size(d_prime_matrix);
for i = 1:numParticipants
    for j = 1:numConditions
        text(j, i, num2str(d_prime_matrix(i, j), '%0.2f'), ...
             'HorizontalAlignment', 'center', ...
             'Color', 'white');
    end
end


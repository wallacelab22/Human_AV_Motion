function [millersBound, figure] = calculateMillersBound(auditoryData, visualData, audiovisualData)
% Extract reaction times from the datasets
rtAuditory = auditoryData(:, 4); % Assuming RTs are in the 4th column
rtVisual = visualData(:, 4);
rtAudiovisual = audiovisualData(:, 6);

% Compute CDFs for auditory and visual data
[cdfAuditory, rtValues] = ecdf(rtAuditory);
[cdfVisual, ~] = ecdf(rtVisual);


% Initialize Miller's Bound array
millersBound = zeros(size(rtValues));

% Calculate Miller's Bound
for i = 1:length(rtValues)
    % Compute the bound at each RT value
    millersBound(i) = max(0, cdfAuditory(i) + cdfVisual(i) - 1);
end

% Plot the results for comparison (optional)
figure;
plot(rtValues, cdfAuditory, 'r-', 'DisplayName', 'Auditory CDF');
hold on;
plot(rtValues, cdfVisual, 'b-', 'DisplayName', 'Visual CDF');
plot(rtValues, ecdf(rtAudiovisual), 'm-', 'DisplayName', 'Audiovisual CDF');
plot(rtValues, millersBound, 'k--', 'DisplayName', 'Miller''s Bound');
hold off;
legend;
xlabel('Reaction Time');
ylabel('Cumulative Probability');
title('CDFs and Miller''s Bound');
end

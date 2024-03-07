function [] = PERFvsSTIM_accuracy_plotter(data_output, subjnum_s, group_s)
% Assume 'data_output' is your matrix with trial information
% Column 1: Auditory direction (1=left, 2=right)
% Column 2: Auditory coherence (0-1)
% Column 3: Visual direction (1=left, 2=right)
% Column 4: Visual coherence (0-1)
% Column 5: Participant's response (1=left, 2=right)

% Find unique coherence values (excluding zeros which represent no stimulus)
uniqueCoherences = unique(data_output(data_output(:,2) > 0, 2));
if length(uniqueCoherences) > 2
    error('More than two unique coherence levels found.');
end

% Auditory perf coherence
coherence1 = mode(data_output(:,2));
% Visual perf coherence
coherence2 = mode(data_output(:,4));

% Initialize accuracy storage
accuracies = zeros(1, 7);

% For each trial type, calculate accuracy
for trialType = 1:7
    switch trialType
        case 1 % Auditory only, coherence 1
            idx = data_output(:,2) == coherence1 & isnan(data_output(:,4));
            correctResponses = data_output(idx, 1) == data_output(idx, 5);
        case 2 % Visual only, coherence 2
            idx = data_output(:,4) == coherence2 & isnan(data_output(:,2));
            correctResponses = data_output(idx, 3) == data_output(idx, 5);
        case 3 % Audiovisual, coherence 1 for auditory, coherence 2 for visual
            idx = data_output(:,2) == coherence1 & data_output(:,4) == coherence2;
            correctResponses = ((data_output(idx, 1) == data_output(idx, 5)) | (data_output(idx, 3) == data_output(idx, 5)));
        case 4 % Audiovisual, coherence 1 for both
            idx = data_output(:,2) == coherence1 & data_output(:,4) == coherence1;
            correctResponses = ((data_output(idx, 1) == data_output(idx, 5)) | (data_output(idx, 3) == data_output(idx, 5)));
        case 5 % Audiovisual, coherence 2 for both
            idx = data_output(:,2) == coherence2 & data_output(:,4) == coherence2;
            correctResponses = ((data_output(idx, 1) == data_output(idx, 5)) | (data_output(idx, 3) == data_output(idx, 5)));
        case 6 % Auditory coherence with visual noise (visual coherence = 0)
            idx = data_output(:,2) > 0 & data_output(:,4) == 0; % Auditory coherence present, visual coherence is 0
            correctResponses = data_output(idx, 1) == data_output(idx, 5);
        case 7 % Visual coherence with auditory noise (auditory coherence = 0)
            idx = data_output(:,4) > 0 & data_output(:,2) == 0; % Visual coherence present, auditory coherence is 0
            correctResponses = data_output(idx, 3) == data_output(idx, 5);
    end
    accuracies(trialType) = sum(correctResponses) / length(correctResponses);
end

coherence1 = round(coherence1, 3, "decimals");
coherence2 = round(coherence2, 3, "decimals");

% Plot the accuracies
bar(1:7, accuracies)
xlabel('Trial Type')
ylabel('Accuracy')
xticks(1:7)
ylim([0 1])
xticklabels({'Auditory Only', 'Visual Only', 'AV Performance Matched', 'AV Auditory Matched', 'AV Visual Matched', 'Auditory with Visual Noise', 'Visual with Auditory Noise'})
title(sprintf('Accuracy by Trial Type for %s %s', subjnum_s, group_s))
%legend(['Auditory Coherence = ', num2str(coherence1)], ['Visual Coherence = ', num2str(coherence2)], 'Location', 'best')
text(1, 0.97, ['Auditory Coherence = ', num2str(coherence1)], 'FontSize', 14)
text(1, 0.92, ['Visual Coherence = ', num2str(coherence2)], 'FontSize', 14)


beautifyplot;

end

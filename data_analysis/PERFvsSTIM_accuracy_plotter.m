function [accuracies, violation, gain, coherence1, coherence2, AV_accuracy_CDF_points] = PERFvsSTIM_accuracy_plotter(data_output, subjnum_s, group_s, figure_file_directory, save_fig)
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
            dataAud = data_output(idx, :);
        case 2 % Visual only, coherence 2
            idx = data_output(:,4) == coherence2 & isnan(data_output(:,2));
            correctResponses = data_output(idx, 3) == data_output(idx, 5);
            dataVis = data_output(idx, :);
        case 3 % Audiovisual, coherence 1 for auditory, coherence 2 for visual
            idx = data_output(:,2) == coherence1 & data_output(:,4) == coherence2;
            correctResponses = ((data_output(idx, 1) == data_output(idx, 5)) | (data_output(idx, 3) == data_output(idx, 5)));
            dataAV = data_output(idx, :);
        case 4 % Audiovisual, coherence 1 for both
            idx = data_output(:,2) == coherence1 & data_output(:,4) == coherence1;
            correctResponses = ((data_output(idx, 1) == data_output(idx, 5)) | (data_output(idx, 3) == data_output(idx, 5)));
            right_or_left = data_output(idx, 1);
            % Splitting data based on direction
            right_vs_left = splitapply(@(x){x}, data_output(idx, :), right_or_left);
        
            % Correct responses for RIGHT and LEFT groups
            % Note: Do not reuse 'idx' here; '1' and '2' are the group indices
            correctResponses_RIGHT = ((right_vs_left{1}(:, 1) == right_vs_left{1}(:, 5)) | (right_vs_left{1}(:, 3) == right_vs_left{1}(:, 5)));
            correctResponses_LEFT = ((right_vs_left{2}(:, 1) == right_vs_left{2}(:, 5)) | (right_vs_left{2}(:, 3) == right_vs_left{2}(:, 5)));
        
            % Calculating accuracies for RIGHT and LEFT
            accuracies_Av_RIGHT = sum(correctResponses_RIGHT) / length(correctResponses_RIGHT);
            accuracies_Av_LEFT = sum(correctResponses_LEFT) / length(correctResponses_LEFT);
        case 5 % Audiovisual, coherence 2 for both
            idx = data_output(:,2) == coherence2 & data_output(:,4) == coherence2;
            correctResponses = ((data_output(idx, 1) == data_output(idx, 5)) | (data_output(idx, 3) == data_output(idx, 5)));
            right_or_left = data_output(idx, 1);
            % Splitting data based on direction
            right_vs_left = splitapply(@(x){x}, data_output(idx, :), right_or_left);
        
            % Correct responses for RIGHT and LEFT groups
            % Note: Do not reuse 'idx' here; '1' and '2' are the group indices
            correctResponses_RIGHT = ((right_vs_left{1}(:, 1) == right_vs_left{1}(:, 5)) | (right_vs_left{1}(:, 3) == right_vs_left{1}(:, 5)));
            correctResponses_LEFT = ((right_vs_left{2}(:, 1) == right_vs_left{2}(:, 5)) | (right_vs_left{2}(:, 3) == right_vs_left{2}(:, 5)));
        
            % Calculating accuracies for RIGHT and LEFT
            accuracies_aV_RIGHT = sum(correctResponses_RIGHT) / length(correctResponses_RIGHT);
            accuracies_aV_LEFT = sum(correctResponses_LEFT) / length(correctResponses_LEFT);
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

set(gcf, 'Units', 'normalized', 'OuterPosition', [0 0 1 1]);
acc = gcf;
fig_type = 'acc';
filename = fullfile(figure_file_directory, [subjnum_s '_' group_s '_' fig_type '.jpg']);
if save_fig
    saveas(acc, filename, 'jpeg');
end

% Filter data for the current coherence level
% Convert seconds to ms, sort RT in ascending order
rtAuditory = dataAud(:, 6);
rtAuditory = rtAuditory*1000;
rtAuditory = sort(rtAuditory, 'ascend');
rtAuditory = rtAuditory(~isnan(rtAuditory));
rtVisual = dataVis(:, 6);
rtVisual = rtVisual*1000;
rtVisual = sort(rtVisual, 'ascend');
rtVisual = rtVisual(~isnan(rtVisual));
rtAudiovisual = dataAV(:, 6);
rtAudiovisual = rtAudiovisual*1000;
rtAudiovisual = sort(rtAudiovisual, 'ascend');
rtAudiovisual = rtAudiovisual(~isnan(rtAudiovisual));
coherence1 = num2str(round(coherence1, 3));
coherence2 = num2str(round(coherence2, 3));
coh = sprintf("%s, %s", coherence1, coherence2);
if length(rtAuditory) > length(rtVisual)
    rtAUD_oldsize = length(rtAuditory);
    rtAuditory = rtAuditory(1:length(rtVisual));
    rtAUD_newsize = length(rtAuditory);
    rtAUD_missingdata = rtAUD_oldsize - rtAUD_newsize; 
elseif length(rtAuditory) < length(rtVisual)
    rtVIS_oldsize = length(rtVisual);
    rtVisual = rtVisual(1:length(rtAuditory));
    rtVIS_newsize = length(rtVisual);
    rtVIS_missingdata = rtVIS_oldsize - rtVIS_newsize;
end
if length(rtAuditory) < length(rtAudiovisual)
    rtAV_oldsize = length(rtAudiovisual);
    rtAudiovisual = rtAudiovisual(1:length(rtAuditory));
    rtAV_newsize = length(rtAudiovisual);
    rtAV_missingdata = rtAV_oldsize - rtAV_newsize;
elseif length(rtAuditory) > length(rtAudiovisual)
    rtAuditory = rtAuditory(1:length(rtAudiovisual));
    rtVisual = rtVisual(1:length(rtAudiovisual));
end
showplot = 1;
part_ID = sprintf('%s, %s', subjnum_s, group_s);
[violation, gain] = RMI_violation(rtAuditory, rtVisual, rtAudiovisual, showplot, part_ID, coh, subjnum_s, group_s, figure_file_directory, save_fig);

coherence1 = str2double(coherence1);
coherence2 = str2double(coherence2);

AV_accuracy_CDF_points = [accuracies_Av_RIGHT accuracies_Av_LEFT accuracies_aV_RIGHT accuracies_aV_LEFT];

end

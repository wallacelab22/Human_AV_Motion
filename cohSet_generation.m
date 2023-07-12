function [stimInfo] = cohSet_generation(stimInfo, nlog_coh_steps, nlog_division)
%Generates the coherences to be used in the coherence set for the stimulus
%staircase (either auditory or visual)

% Initialize cohSet variable
stimInfo.cohSet = zeros(1, nlog_coh_steps);

% Loop through every place in cohSet, lowering coherence by dividing
% previous value by nlog_division.
for i = 1:length(stimInfo.cohSet)
    stimInfo.cohSet(i) = stimInfo.cohStart/(nlog_division^(i-1));
end

end
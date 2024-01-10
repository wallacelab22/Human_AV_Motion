function [stimInfo] = cohSet_generation(stimInfo, block)
%Generates the coherences to be used in the coherence set for the stimulus
%staircase (either auditory or visual)
if contains(block, 'Vis') || contains(block, 'Aud') || contains(block, 'AV')
    % Initialize cohSet variable
    stimInfo.cohSet = zeros(1, stimInfo.nlog_coh_steps);
    
    % Loop through every place in cohSet, lowering coherence by dividing
    % previous value by nlog_division.
    for i = 1:length(stimInfo.cohSet)
        stimInfo.cohSet(i) = stimInfo.cohStart/(stimInfo.nlog_division^(i-1));
    end
end

end
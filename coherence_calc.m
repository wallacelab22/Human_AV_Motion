function [stimInfo] = coherence_calc(data_output, freq_decimal, nlog_division)
% Finds the coherence in the staircase task that the participant asympototed
% out to. It then extrapolates down four log values and up two log values
% given a certain step value (nlog_division). This coherence set is given
% to the task code to individualize coherences.

trial_coh = data_output(:, 2);

[unique_cohs, ~, idx] = unique(trial_coh);
counts = accumarray(idx(:), 1, [], @sum);

min_coh = min(unique_cohs(counts >= (freq_decimal * numel(trial_coh))));

stimInfo.cohSet = [nlog_division*min_coh];
stimInfo.cohSet = [nlog_division*stimInfo.cohSet nlog_division*min_coh];

for i = 1:4
    if i == 1
        nlog_value = min_coh;
        stimInfo.cohSet=[stimInfo.cohSet nlog_value];
    end
    nlog_value = nlog_value/nlog_division;
    stimInfo.cohSet = [stimInfo.cohSet nlog_value];
end

end
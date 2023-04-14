function [stimInfo] = coherence_calc(data_output, freq_decimal, nlog_division)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
freq_decimal = 0.2;
load('RDKHoop_stairAud_05_01_01_28.mat')
nlog_division = 1.4;

trial_coh = data_output(:, 2);

[unique_cohs, ~, idx] = unique(trial_coh);
counts = accumarray(idx(:), 1, [], @sum);

min_coh = min(unique_cohs(counts >= (freq_decimal * numel(trial_coh))));

stimInfo.cohSet = [nlog_division*min_coh];
stimInfo.cohSet = [nlog_division*stimInfo.cohSet stimInfo.cohSet];

for i = 1:4
    if i == 1
        nlog_value = min_coh;
    end
    nlog_value = nlog_value/nlog_division;
    stimInfo.cohSet = [stimInfo.cohSet nlog_value];
end

end
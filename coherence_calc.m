function [stimInfo] = coherence_calc(data_output, freq_decimal, nlog_division)
% Finds the coherence in the staircase task that the participant asympototed
% out to. It then extrapolates down lower_lim log values and up upper_lim log values
% given a certain step value (nlog_division). This coherence set is given
% to the task code to individualize coherences.

load('RDKHoop_stairAud_01_01_02_24-3.mat')
freq_decimal = 0.2;
nlog_division = 1.4;

upper_lim = 3;
lower_lim = 3;

trial_coh = data_output(:, 2);

[unique_cohs, ~, idx] = unique(trial_coh);
counts = accumarray(idx(:), 1, [], @sum);

min_coh = min(unique_cohs(counts >= (freq_decimal * numel(trial_coh))));
disp(min_coh)
stimInfo.cohSet = [min_coh];

for ii = 1:upper_lim
    if ii == 1
        nlog_value = min_coh*nlog_division;
        stimInfo.cohSet = [stimInfo.cohSet nlog_value];
    else
        nlog_value = nlog_value*nlog_division;
        stimInfo.cohSet = [stimInfo.cohSet nlog_value];
    end
end
   

for i = 1:lower_lim
    if i == 1
        nlog_value = min_coh/nlog_division;
        stimInfo.cohSet=[stimInfo.cohSet nlog_value];
    else
        nlog_value = nlog_value/nlog_division;
        stimInfo.cohSet = [stimInfo.cohSet nlog_value];
    end
end

stimInfo.cohSet = sort(stimInfo.cohSet, 'descend');

end
function [stimInfo] = coherence_calc(data_output, extrapolateCoh, stimInfo, coh_step)
% written 04/24/23 - Adam Tiesman
% Finds the coherence in the staircase task that the participant asympototed
% out to. It then extrapolates down lower_lim log values and up upper_lim log values
% given a certain step value (nlog_division). This coherence set is given
% to the task code to individualize coherences.
%
% nlog_division, upper_lim, lower_lim, num_reversals, and coh_step can all 
% be manipulated to change how to generate the coherence set.
%
% nlog_division.................value used to extrapolate down and up from a
%                               threshold calculated in via the staircase
% upper_lim.....................value used to determine how far to extrapolate 
%                               UP from a threshold
% lower_lim.....................value used to determine how far to extrapolate 
%                               DOWN from a threshold
% num_reversals.................the number of reversals at the end in the stairstep 
%                               function to be considered in calulating the 
%                               average coherence level in the staircase
% coh_step......................the number of coherence steps up from the 
%                               average coherence level in the coherence levels 
%                               from the staircase that you want to extrapolate 
%                               down and up from. the coherence value from the
%                               number of steps up (coh_step) will be the
%                               threshold

% Define malleable variables
nlog_division = sqrt(2);
upper_lim = 3;
lower_lim = 3;
num_reversals = 10;

% Find the direction of each trial (positive or negative)
directions = sign(diff(data_output(:,2)));

% Find the indices of the reversal points
reversal_indices = find(diff(directions) ~= 0);

% Find the last num_reversals reversal points
if length(reversal_indices) >= num_reversals
    last_reversal_indices = reversal_indices(end-num_reversals+1:end);
else
    error('There are less than %d reversals in the data', num_reversals);
end

% Compute the average coherence level of the last num_reversals reversals
avg_coherence_level = mean(data_output(last_reversal_indices,2));

% Find the index of the closest coherence level to the avg_coherence_level
% given the list of coherenece_levels
coherence_levels = sort(unique(data_output(:,2)), 'descend');
[~, idx] = min(abs(coherence_levels - avg_coherence_level));
closest_coh = coherence_levels(idx);

% Find the coherence levels coh_step levels up from the closest coherence level
threshold = coherence_levels(idx - coh_step);
stimInfo.cohSet = [threshold];

if extrapolateCoh
    % Extrapolate up upper_lim amount of times from the given threshold
    for ii = 1:upper_lim
        if ii == 1
            nlog_value = threshold*nlog_division;
            stimInfo.cohSet = [stimInfo.cohSet nlog_value];
        else
            nlog_value = nlog_value*nlog_division;
            stimInfo.cohSet = [stimInfo.cohSet nlog_value];
        end
    end
       
    % Extrapolate down lower_lim amount of times from the given threshold
    for i = 1:lower_lim
        if i == 1
            nlog_value = threshold/nlog_division;
            stimInfo.cohSet=[stimInfo.cohSet nlog_value];
        else
            nlog_value = nlog_value/nlog_division;
            stimInfo.cohSet = [stimInfo.cohSet nlog_value];
        end
    end
    
    % Generate coherence set in descending order to be fed to the AV task code
    stimInfo.cohSet = sort(stimInfo.cohSet, 'descend');
end

end
function [trial_status, data_output] = record_data(data_output, right_var, left_var, right_keypress, left_keypress, stimInfo, resp, rt, ii, vel_stair)
%% Save data to the initialized data_output matrix
% Each row is a trial
%
% Column 1 = direction of trial, 1 = right, 2 = left
% Column 2 = coherence of trial,0 = 0% coherence, 0.5 = 50% coherence, etc.
% Column 3 = subject reported direction of trial, 1 = right, 2 = left
% Column 4 = subject reaction time of trial, reported in seconds
% Column 5 = subject character press, number denotes key pressed
% Column 6 = whether subject was correct (1) or incorrect (0) for trial

data_output(ii, 1) = stimInfo.dir;
data_output(ii, 2) = stimInfo.coh;
if ismember(resp, right_keypress)
    data_output(ii, 3) = right_var;
elseif ismember(resp, left_keypress)
    data_output(ii, 3) = left_var;
else
    data_output(ii, 3) = nan;
end
data_output(ii, 4) = rt;
data_output(ii,5) = char(resp);
% For the table, column 6 denotes accuracy (used for
% staircase_procedure). 0 = incorrect, 1 = correct, it checks if the 
% stimulus direction is equal to the recorded response. If so, then
% trial is correct.
if data_output(ii, 3) == data_output(ii, 1)
    trial_status = 1;
    data_output(ii, 6) = trial_status;
else 
    trial_status = 0;
    data_output(ii, 6) = trial_status;
end
if vel_stair == 1
    data_output(ii, 7) = stimInfo.vel;
end

end
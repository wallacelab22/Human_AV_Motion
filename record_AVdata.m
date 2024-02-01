function [trial_status, data_output] = record_AVdata(data_output, right_var, left_var, right_keypress, left_keypress, audInfo, visInfo, resp, rt, ii, vel_stair, interleave_nature, sliderResp)
%% Save data to the initialized data_output matrix
% Each row is a trial
%
% Column 1 = direction of trial, 1 = right, 2 = left
% Column 2 = coherence of trial, 0 = 0% coherence, 0.5 = 50% coherence, etc.
% Column 3 = subject reported direction of trial, 1 = right, 2 = left
% Column 4 = subject reaction time of trial, reported in seconds
% Column 5 = subject character press, number denotes key pressed
% Column 6 = whether subject was correct (1) or incorrect (0) for trial
% Column 7 = velocity of trial (in deg/sec)

data_output(ii, 1) = audInfo.dir;
data_output(ii, 2) = audInfo.coh;
data_output(ii, 3) = visInfo.dir;
data_output(ii, 4) = visInfo.coh;
if ismember(resp, right_keypress)
    data_output(ii, 5) = right_var;
elseif ismember(resp, left_keypress)
    data_output(ii, 5) = left_var;
else
    data_output(ii, 5) = nan;
end
data_output(ii, 6) = rt;
data_output(ii,7) = char(resp);
% For the table, column 6 denotes accuracy (used for
% staircase_procedure). 0 = incorrect, 1 = correct, it checks if the 
% stimulus direction is equal to the recorded response. If so, then
% trial is correct.
if interleave_nature == 1
    if (data_output(ii, 1) == data_output(ii, 3)) && (data_output(ii, 3) == data_output(ii, 5)) && (data_output(ii, 5) ~= 0)
        trial_status = 1;
        data_output(ii, 8) = trial_status;
    elseif (data_output(ii, 1) == data_output(ii, 5) && isnan(data_output(ii, 3))) || (data_output(ii, 3) == data_output(ii,5) && isnan(data_output(ii,1)))
        trial_status = 1;
        data_output(ii, 8) = trial_status;
    elseif (data_output(ii, 1) == data_output(ii, 3)) && (data_output(ii, 3) == 0)
        trial_status = NaN;
        data_output(ii, 8) = trial_status;
    else 
        trial_status = 0;
        data_output(ii, 8) = trial_status;
    end
else
    if data_output(ii, 3) == data_output(ii, 1) && data_output(ii, 3) == data_output(ii,5)
        trial_status = 1;
        data_output(ii, 8) = trial_status;
    elseif (data_output(ii, 1) == data_output(ii, 3)) && (data_output(ii, 3) == 0)
        trial_status = NaN;
        data_output(ii, 6) = trial_status;
    else 
        trial_status = 0;
        data_output(ii, 8) = trial_status;
    end
end
data_output(ii, 9) = sliderResp;
if vel_stair == 1
    data_output(ii, 10) = audInfo.vel;
    data_output(ii,11) = visInfo.vel;
end

end
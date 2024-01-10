function [stimInfo, staircase_index, vel_index] = staircase_procedure(trial_status, stimInfo, staircase_index, vel_stair, vel_index)
%% Staircase Procedure
% Staircase_procedure function checks last trial for accuracy. Then, using
% preset probabilities, decides whether to LOWER coherence/change direction
% for correct trials and RAISE coherence/change direction for incorrect
% trials. The coherence and direction for the next trial's stimulus are
% thus generated via performance.
    if trial_status == 1
        x_rand = rand(1); %random num between 0-1 
        if x_rand <= stimInfo.probs(1) %Prob of Coherence lowering 
            if staircase_index < length(stimInfo.cohSet) %Check to make sure we don't go lower than the lowest value possible
                staircase_index = staircase_index + 1; %Decrease the coherence
                stimInfo.coh = (stimInfo.cohSet(staircase_index)); 
            end
        end
        if x_rand <= stimInfo.probs(2) %Prob of direction change, after Correct 
            %Change Direction of the stimulus
            if stimInfo.dir == 1 
                stimInfo.dir = 2; 
            elseif stimInfo.dir == 2 
                stimInfo.dir = 1;
            end
        end
        if vel_stair == 1
            p_rand = rand(1);
            if p_rand <= stimInfo.probs(5)
                if vel_index < length(stimInfo.velSet)
                    vel_index = vel_index + 1;
                    stimInfo.vel = (stimInfo.velSet(vel_index));
                end
            end
        end
    elseif trial_status == 0
        y_rand = rand(1); %random num between 0-1 
        if y_rand <= stimInfo.probs(3) %Prob of Coherence Increasing 
            if staircase_index > 1 %Check to make sure we don't go higher than highest value possible
                staircase_index = staircase_index - 1; %Increase the coherence
                stimInfo.coh = (stimInfo.cohSet(staircase_index)); 
            end
        end
        if y_rand <= stimInfo.probs(4) % Prob of direction change, after Incorrect
            % Change Direction of the stimulus
            if stimInfo.dir == 1 
                stimInfo.dir = 2; 
            elseif stimInfo.dir == 2 
                stimInfo.dir = 1;
            end
        end
        if vel_stair == 1
            q_rand = rand(1);
            if q_rand <= stimInfo.probs(6)
                if vel_index > 1
                    vel_index = vel_index - 1;
                    stimInfo.vel = (stimInfo.velSet(vel_index));
                end
            end
        end
    end
    
    
end
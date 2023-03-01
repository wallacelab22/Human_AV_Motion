function [audInfo, staircase_index] = staircase_procedure(trial_status, audInfo, staircase_index)
    %We need info from the last trial on weahter he got the trial correct
    if trial_status == 1
        x_rand = rand(1); %random num between 0-1 
        if x_rand <= audInfo.probs(1) %Prob of Coherence lowering 
            if staircase_index < length(audInfo.cohSet) %Check to make sure we don't go lower than the lowest value possible
                staircase_index = staircase_index + 1; %Decrease the coherence
                audInfo.coh = (audInfo.cohSet(staircase_index)); 
            end
        end

        if x_rand <= audInfo.probs(2) %Prob of direction change, after Correct 
            %Change Direction of the stimulus
            if audInfo.dir == 1 
                audInfo.dir = 2; 
            elseif audInfo.dir == 2 
                audInfo.dir = 1;
            end
        end
    elseif trial_status == 0
        y_rand = rand(1); %random num between 0-1 
        if y_rand <= audInfo.probs(3) %Prob of Coherence Increasing 
            if staircase_index > 1 %Check to make sure we don't go higher than highest value possible
                staircase_index = staircase_index - 1; %Increase the coherence
                audInfo.coh = (audInfo.cohSet(staircase_index)); 
            end
        end

        if y_rand <= audInfo.probs(4) %Prob of direction change, after Incorrect
            %Change Direction of the stimulus
            if audInfo.dir == 1 
                audInfo.dir = 2; 
            elseif audInfo.dir == 2 
                audInfo.dir = 1;
            end
        end
    end
    
    
end
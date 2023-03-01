function [visInfo, staircase_index] = staircase_procedure(trial_status, visInfo, staircase_index)
    %We need info from the last trial on weahter he got the trial correct
    if trial_status == 1
        x_rand = rand(1); %random num between 0-1 
        if x_rand <= visInfo.probs(1) %Prob of Coherence lowering 
            if staircase_index < length(visInfo.cohSet) %Check to make sure we don't go lower than the lowest value possible
                staircase_index = staircase_index + 1; %Decrease the coherence
                visInfo.coh = (visInfo.cohSet(staircase_index)); 
            end
        end

        if x_rand <= visInfo.probs(2) %Prob of direction change, after Correct 
            %Change Direction of the stimulus
            if visInfo.dir == 1 
                visInfo.dir = 2; 
            elseif visInfo.dir == 2 
                visInfo.dir = 1;
            end
        end
    elseif trial_status == 0
        y_rand = rand(1); %random num between 0-1 
        if y_rand <= visInfo.probs(3) %Prob of Coherence Increasing 
            if staircase_index > 1 %Check to make sure we don't go higher than highest value possible
                staircase_index = staircase_index - 1; %Increase the coherence
                visInfo.coh = (visInfo.cohSet(staircase_index)); 
            end
        end

        if y_rand <= visInfo.probs(4) %Prob of direction change, after Incorrect
            %Change Direction of the stimulus
            if visInfo.dir == 1 
                visInfo.dir = 2; 
            elseif visInfo.dir == 2 
                visInfo.dir = 1;
            end
        end
    end
    
    
end
function [resp, rt, start_time] = at_generateAud(continue_show, responded, resp, rt, curWindow, fix, frames, pahandle, wavedata)
% % Generates auditory stimulus and waits for key response for the
% stimulus duration

while continue_show
    %DS look for key down if no response yet
    if ~responded %if no response
        [key,secs,keycode] = KbCheck; %look for a key
        WaitSecs(0.0002); %tiny wait
        if key %if there was a key
            resp = find(keycode,1,'last');
            rt = GetSecs - start_time; %calculate rt from start time earlier
            responded = 1; %note that there was a response
        end
    end
    
    % Now do next drawing commands
    Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], fix, 1);
    % After all computations, flip
    Screen('Flip', curWindow,0);
    frames = frames + 1;
    
    %% get RTs
    if frames == 1
        start_time = GetSecs;
        PsychPortAudio('FillBuffer', pahandle, wavedata');
        PsychPortAudio('Start', pahandle, 1);
    end
    
    % Check for end of loop
    continue_show = continue_show - 1;
end
end
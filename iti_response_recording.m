function [resp, rt] = iti_response_recording(typeInt, minNum, maxNum, meanNum, dur, start_time, keyisdown, responded, resp, rt)
%%  ITI & response recording
interval=makeInterval(typeInt,minNum,maxNum,meanNum);
interval=interval+dur;
%DS loop until interval is over
%while KbCheck; end %hold if key is held down
while ~keyisdown %while no key is down
    [keyisdown,secs,keycode] = KbCheck; %look for a key
    if GetSecs - start_time >= interval %if elapsed time since stim onset is > ISI
        break %break loop
    elseif keyisdown && ~responded %if a key is down
        if length(find(keycode,1)) == 1 %block multikey, if 1 key down
            responded = 1; %mark that they responded
            resp = find(keycode,1,'last');
            rt = GetSecs - start_time; %record rt
            while GetSecs - start_time < interval %wait for rest of ISI
                WaitSecs(0.0002);
            end
            break; % and break
        else
            keyisdown = 0; %reset to no key down and retry
        end
    end
end
while GetSecs - start_time < interval
    WaitSecs(0.0002);
end
while KbCheck; end %hold if key is held down

end
function [resp, rt, start_time] = at_presentDot(visInfo, dotInfo, center, dotSize, ...
    d_ppd, ndots, dxdy, ss, Ls, continue_show, curWindow, fix, responded, ...
    resp, rt, EEG_nature, outlet, markers)

% THE MAIN LOOP
frames = 0;
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
    
    % Get ss & xs from the big matrices. xs and ss are matrices that have
    % stuff for dots from the last 2 positions + current.
    % Ls picks out the previous set (1:5, 6:10, or 11:15)
    %Lthis  = Ls(:,loopi); % Lthis picks out the loop from 3 times ago, which
    % is what is then moved in the current loop
    this_s = ss(Ls,:);  % this is a matrix of random #s - starting positions
    
    % Compute new locations
    % L are the dots that will be moved
    L = rand(ndots,1) < visInfo.coh;
    this_s(L,:) = this_s(L,:) + dxdy(L,:);    % Offset the selected dots
    
    if sum(~L) > 0  % if not 100% coherence
        this_s(~L,:) = rand(sum(~L),2);    % get new random locations for the rest
    end
    
    % Wrap around - check to see if any positions are greater than one or
    % less than zero which is out of the aperture, and then replace with a
    % dot along one of the edges opposite from direction of motion.
    
    N = sum((this_s > 1 | this_s < 0)')' ~= 0;


    % NEW code for dot wrapping, Greg DeAngelis, 6/23/23
    if sum(N) > 0
        dots_outside = this_s(find(N==1),:);
        dots_outside(dots_outside(:,1) > 1,1) = dots_outside(dots_outside(:,1) > 1,1) - 1;
        dots_outside(dots_outside(:,1) < 0,1) = dots_outside(dots_outside(:,1) < 0,1) + 1;
        dots_outside(dots_outside(:,2) > 1,2) = dots_outside(dots_outside(:,2) > 1,2) - 1;
        dots_outside(dots_outside(:,2) < 0,2) = dots_outside(dots_outside(:,2) < 0,2) + 1;
        this_s(find(N==1),:) = dots_outside;
    end
    
    % Convert to stuff we can actually plot
    this_x(:,1:2) = floor(d_ppd(1) * this_s); % pix/ApUnit
    
    % This assumes that zero is at the top left, but we want it to be in the
    % center, so shift the dots up and left, which just means adding half of
    % the aperture size to both the x and y direction.
    dot_show = (this_x(:,1:2) - d_ppd/2)';
    
    % After all computations, flip
    Screen('Flip', curWindow,0);
    % Now do next drawing commands
    Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], fix, 1);
    Screen('DrawDots', curWindow, dot_show, dotSize, dotInfo.dotColor, center);
    % Presentation
    Screen('DrawingFinished',curWindow);
    frames = frames + 1;
    
    %% get RTs
    if frames == 1
        start_time = GetSecs;
        % Push trigger through LSL to EEG machine to record stimulus start
        if EEG_nature == 1
            outlet.push_sample({markers});
        end
    end
    % Update the arrays so xor works next time
    xs(Ls, :) = this_x;
    ss = this_s;
    
    % Check for end of loop
    continue_show = continue_show - 1;
end
% Present last dots
if ~responded %if no response
    [key,secs,keycode] = KbCheck; %look for a key
    WaitSecs(0.0002); %tiny wait
    if key %if there was a key
        resp = find(keycode,1,'last');
        rt = GetSecs - start_time; %calculate rt from start time earlier
        responded = 1; %note that there was a response
    end
end

Screen('Flip', curWindow,0);

if ~responded %if no response
    [key,secs,keycode] = KbCheck; %look for a key
    WaitSecs(0.0002); %tiny wait
    if key %if there was a key
        resp = find(keycode,1,'last');
        rt = GetSecs - start_time; %calculate rt from start time earlier
        responded = 1; %note that there was a response
    end
end

end
function [resp,rt,start_time] = at_generateDot(visInfo, dotInfo, screenInfo, ...
    screenRect, monWidth, viewDist, maxdotsframe, dur, curWindow, fix, ...
    responded, resp, rt)

spf = screenInfo.frameDur; % second per frame
center= screenInfo.center; % center of the screen
ppd = screenInfo.ppd; % pixels per degree of visual angle; right now set to 10 deg/sec
speed = dotInfo.speed; % speed of dots in deg/sec
dotSize = dotInfo.dotSize; % dot size in pixels
apD = dotInfo.apXYD(3); % aperture of stimulus in deg of visual angle*10; right now set to 5 deg

%% at_dotgen content
Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], fix, 1);
Screen('Flip',curWindow,0);
monRefresh = 1/spf; % frames per second

% Everything is initially in coordinates of visual degrees, convert to pixels
% (pix/screen) * (screen/rad) * rad/deg
ppd = pi * screenRect(3) / atan(monWidth/viewDist/2)  / 360;
d_ppd = floor(apD/10 * ppd);

% ndots is the number of dots shown per video frame. Dots are placed in a
% square of the size of the aperture.
%   Size of aperture = Apd*Apd/100  sq deg
%   Number of dots per video frame = 16.7 dots per sq.deg/sec, but
%   since we are updating every frame instead of every 3 frames, we can
%   multiply this number by 3, giving us 50
% When rounding up, do not exceed the number of dots that can be plotted in
% a video frame.
ndots = min(maxdotsframe, ceil(50 * apD .* apD * 0.01 / monRefresh));

% dxdy is an N x 2 matrix that gives jumpsize in units on 0..1
%   deg/sec * Ap-unit/deg * sec/jump = unit/jumC
dxdy = repmat(speed * 10/apD * (1/monRefresh) ...
    * [cos(pi*visInfo.dir/180.0) -sin(pi*visInfo.dir/180.0)], ndots,1);
% dxdy gives a unit amount for each jump for a given signal dot.
% Currently, this jump occurs every 3 frames. What is the unit for
% this? Is it the aperture unit? What do we use to calculate aperture?


% ARRAYS, INDICES for loop
ss = rand(ndots*3, 2); % array of dot positions raw [xposition, yposition]

% Divide dots into three sets
% Originally, the dots were divided into three groups in order to not skip frames
% Code was optimized for older machines that couldn't plot dots fast
% enough. Look into moving towards the dots being all one group instead
% of dividing them into three groups, will make for smoother motion
% perception (i.e. dot X moves to point a, b, c, and d instead of dot X just
% moving from point a to d in same time).
% Ls = cumsum(ones(ndots,3)) + repmat([0 ndots ndots*2], ndots, 1);
Ls = cumsum(ones(ndots,1));

% If we want to make the dots into one group, we can comment out all of
% the code relating to loopi, which tracks the sets of dots
% loopi = 1; % Loops through the three sets of dots

% Show for how many frames
continue_show = round(dur*monRefresh);

priorityLevel = MaxPriority(curWindow,'KbCheck'); %make sure Window commands are correct
Priority(priorityLevel);

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
    
    % 1 group of dots are shown in the first frame, a second group are shown
    % in the second frame, a third group shown in the third frame. Then in
    % the next frame, some percentage of the dots from the first frame are
    % replotted according to the speed/direction and coherence, the next
    % frame the same is done for the second group, etc.
    % Update the loop pointer
%         loopi = loopi+1;
%         
%         if loopi == 4
%             loopi = 1;
%         end
    
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

    % OLD code for dot wrapping, did NOT work. It creates vertical
    % stripes of dots and also does not work for oblique directions,
    % Greg DeAngelis, 6/23/23
%         if sum(N) > 0
%             xdir = sin(pi*visInfo.dir/180.0);
%             ydir = cos(pi*visInfo.dir/180.0);
%             % Flip a weighted coin to see which edge to put the replaced dots
%             if rand < abs(xdir)/(abs(xdir) + abs(ydir))
%                 this_s(find(N==1),:) = [rand(sum(N),1) (xdir > 0)*ones(sum(N),1)];
%             else
%                 this_s(find(N==1),:) = [(ydir < 0)*ones(sum(N),1) rand(sum(N),1)];
%             end
%         end

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
    Screen('DrawDots', curWindow, dot_show, dotSize, [255 255 255], center);
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
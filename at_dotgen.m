function at_dotgen(curWindow, monWidth, viewDist, currviscoh, speed, currvisdir, dotSize, maxdotsframe, dur, spf, apD, center, ppd, screenRect)
% drawDotsTest

% Example of showing how dots look without mask, using DrawDots (not using
% CLUT). This code is completely independent of other dots code and only need
% psychtoolbox to run it.

Screen('Flip',curWindow,0);

monRefresh = 1/spf; % frames per second

% Everything is initially in coordinates of visual degrees, convert to pixels
% (pix/screen) * (screen/rad) * rad/deg
ppd = pi * screenRect(3) / atan(monWidth/viewDist/2)  / 360;

d_ppd = floor(apD/10 * ppd);

% ndots is the number of dots shown per video frame. Dots are placed in a
% square of the size of the aperture.
%   Size of aperture = Apd*Apd/100  sq deg
%   Number of dots per video frame = 16.7 dots per sq.deg/sec,
% When rounding up, do not exceed the number of dots that can be plotted in
% a video frame.
ndots = min(maxdotsframe, ceil(16.7 * apD .* apD * 0.01 / monRefresh));

% dxdy is an N x 2 matrix that gives jumpsize in units on 0..1
%   deg/sec * Ap-unit/deg * sec/jump = unit/jump
dxdy = repmat(speed * 10/apD * (3/monRefresh) ...
    * [cos(pi*currvisdir/180.0) -sin(pi*currvisdir/180.0)], ndots,1);

% ARRAYS, INDICES for loop
ss = rand(ndots*3, 2); % array of dot positions raw [xposition, yposition]

% Divide dots into three sets
Ls = cumsum(ones(ndots,3)) + repmat([0 ndots ndots*2], ndots, 1);
loopi = 1; % Loops through the three sets of dots

% Show for how many frames
continue_show = round(dur*monRefresh);

priorityLevel = MaxPriority(curWindow,'KbCheck'); %make sure Window commands are correct
Priority(priorityLevel);

% THE MAIN LOOP
frames = 0;

while continue_show
    % Get ss & xs from the big matrices. xs and ss are matrices that have
    % stuff for dots from the last 2 positions + current.
    % Ls picks out the previous set (1:5, 6:10, or 11:15)
    Lthis  = Ls(:,loopi); % Lthis picks out the loop from 3 times ago, which
    % is what is then moved in the current loop
    this_s = ss(Lthis,:);  % this is a matrix of random #s - starting positions
    
    % 1 group of dots are shown in the first frame, a second group are shown
    % in the second frame, a third group shown in the third frame. Then in
    % the next frame, some percentage of the dots from the first frame are
    % replotted according to the speed/direction and coherence, the next
    % frame the same is done for the second group, etc.
    
    % Update the loop pointer
    loopi = loopi+1;
    
    if loopi == 4
        loopi = 1;
    end
    
    % Compute new locations
    % L are the dots that will be moved
    L = rand(ndots,1) < currviscoh;
    this_s(L,:) = this_s(L,:) + dxdy(L,:);	% Offset the selected dots
    
    if sum(~L) > 0  % if not 100% coherence
        this_s(~L,:) = rand(sum(~L),2);	% get new random locations for the rest
    end
    
    % Wrap around - check to see if any positions are greater than one or
    % less than zero which is out of the aperture, and then replace with a
    % dot along one of the edges opposite from direction of motion.
    
    N = sum((this_s > 1 | this_s < 0)')' ~= 0;
    if sum(N) > 0
        xdir = sin(pi*currvisdir/180.0);
        ydir = cos(pi*currvisdir/180.0);
        % Flip a weighted coin to see which edge to put the replaced dots
        if rand < abs(xdir)/(abs(xdir) + abs(ydir))
            this_s(find(N==1),:) = [rand(sum(N),1) (xdir > 0)*ones(sum(N),1)];
        else
            this_s(find(N==1),:) = [(ydir < 0)*ones(sum(N),1) rand(sum(N),1)];
        end
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
    fix=[800,300];
    Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], fix, 1);
    Screen('DrawDots', curWindow, dot_show, dotSize, [255 255 255], center);
   
    % Presentation
    Screen('DrawingFinished',curWindow);

    frames = frames + 1;
    
    if frames == 1
        start_time = GetSecs;
    end
    
    % Update the arrays so xor works next time
    xs(Lthis, :) = this_x;
    ss(Lthis, :) = this_s;
    
    % Check for end of loop
    continue_show = continue_show - 1;
    
end

% Present last dots
Screen('Flip', curWindow,0);

% Erase last dots
Screen('DrawingFinished',curWindow);
Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], fix, 1);
Screen('Flip', curWindow,0);


% %     StartUpdateProcess;
end


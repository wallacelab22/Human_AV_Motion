function [center, dotSize, d_ppd, ndots, dxdy, ss, Ls, continue_show] = ...
    at_generateDot(visInfo, dotInfo, screenInfo, screenRect, monWidth, ...
    viewDist, maxdotsframe, dur, curWindow, fix)

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


end
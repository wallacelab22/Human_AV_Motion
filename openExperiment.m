function [screenInfo, xCenter, yCenter] = openExperiment(monWidth, viewDist, curScreen)
% OPENEXPERIMENT initialize screen settings for new experiment
%
% screenInfo = openExperiment(monWidth, viewDist, curScreen)
%
% This function opens new screen, sets the random number generator, gets the
% refresh rate, determines the center and ppd, and stops the update process. This
% function is used by both dot code and touch code.
%
% where
%   monWidth is viewing width of monitor (cm),
%	viewDist is the distance from the center of the subject's eyes to the monitor(cm)
%   and
%   curScreen is the screen number for experiment, by default 0.
%

% Copyright 2006 MKMK
% Copyright 2013 Jian Wang

if nargin < 3
    curScreen = 0;
end

AssertOpenGL;

rseed = sum(100*clock); % Seed random number generator
rng(rseed,'v5uniform'); % v5 random generator
%rng(rseed,'twister'); % new default generator
screenInfo = struct('rseed',rseed);
white = WhiteIndex(curScreen);
black = BlackIndex(curScreen);
gray = GrayIndex(curScreen, 0.5);
% Open screen, make stuff behave itself in OS X with multiple monitors
%Screen('Preference', 'VisualDebugLevel',0);

% Set the background color to the default background value - black
%screenInfo.bckgnd = gray;
screenInfo.bckgnd = black;
%screenInfo.bckgnd = 0;

[screenXpixels, screenYpixels] = Screen('WindowSize', curScreen);
[xCenter, yCenter] = RectCenter([0 0 screenXpixels screenYpixels]);
%[screenInfo.curWindow, screenInfo.screenRect] = PsychImaging('OpenWindow', curScreen, gray);
[screenInfo.curWindow, screenInfo.screenRect] = PsychImaging('OpenWindow', curScreen, black);


% [screenInfo.curWindow, screenInfo.screenRect] = Screen('OpenWindow',curScreen,...
%      screenInfo.bckgnd, [],32,2);
% [screenInfo.curWindow, screenInfo.screenRect] = Screen('OpenWindow',curScreen,...
%      screenInfo.bckgnd, [],[],2);

% 0 for clear drawing, 1 for incremental drawing (does not clear buffer after flip)
screenInfo.dontclear = 0;

% Get the refresh rate of the screen
screenInfo.frameDur = Screen('GetFlipInterval',screenInfo.curWindow);
screenInfo.monRefresh = 1 / screenInfo.frameDur;


% Get screen center coordinates (pixels)
screenInfo.center = [screenInfo.screenRect(3), screenInfo.screenRect(4)]/2;   	

% Determine pixels per degree (ppd), which unit is derived as
% (pix/screen) * (screen/rad) * (rad/deg) = (pixels per degree)
screenInfo.ppd = pi * screenInfo.screenRect(3) / atan(monWidth/viewDist/2) / 360;    

HideCursor;

% If reward system is hooked up, rewardOn = 1, otherwise rewardOn = 0;
screenInfo.rewardOn = 0;
%screenInfo.rewardOn = 1;

% Get reward system ready
screenInfo.daq = DaqDeviceIndex;




function [screenInfo, curWindow, screenRect] = initialize_exp(monWidth,viewDist,curScreen)
%Initialize experiment via psychtoolbox functions. 0 for SkipSyncTests
%tells psychtoolbox to check for sync issues. Important not to skip if
%timing of stimulus presentation is important. viewDist is manually set by
%you and will be. 

Screen('Preference', 'SkipSyncTests', 0);
screenInfo = openExperiment(monWidth, viewDist, curScreen);
curWindow= screenInfo.curWindow;
screenRect= screenInfo.screenRect;
% Enable alpha blending with proper blend-function. We need it for drawing
% of smoothed points.
Screen('BlendFunction', curWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
end
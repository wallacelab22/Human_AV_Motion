function [dot_info, frames, rseed, start_time, end_time, response, response_time] = ...
RDK_draw(inputtype, visInfo.coh, visInfo.dir, typeInt, minNum, maxNum, meanNum, ...
maxdotsframe, dur, block_dot_speed, screenInfo)
% This function initializes the RDK on a trial by trial basis

dotInfo = createDotInfo(inputtype, visInfo.coh, visInfo.dir, typeInt, minNum, maxNum, meanNum, maxdotsframe, dur, block_dot_speed);
dot_info = createDotInfo(1);
Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], fix, 1);
Screen('Flip',curWindow,0);
[frames, rseed, start_time, end_time, response, response_time] = dotsX(screenInfo, dotInfo);    

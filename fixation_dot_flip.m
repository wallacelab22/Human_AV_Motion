function [fix] = fixation_dot_flip(screenRect,curWindow)
%Flip the fixation dot on screen
fix=[screenRect(3)/2,screenRect(4)/2]; %define fix position of fix dot
Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], fix, 1);
Screen('Flip', curWindow,0);
WaitSecs(2); %wait for 2s

end
function instructionsInitTrial(curWindow, cWhite0, fix)
% Waits for participant keypress to move to next trial
Screen('DrawText', curWindow, 'Press any key to move to next trial...',300,250,cWhite0);
Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], fix, 1);
Screen('Flip',curWindow);
keytest_unbound;
end
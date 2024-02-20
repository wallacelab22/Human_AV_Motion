function instructions_InitTrialAV(curWindow, cWhite0, fix, data_output)
% Waits for participant keypress to move to next trial and displays counter

correctCounter = sum(data_output(:,8));
counterText = sprintf('Trials Correct: %d', correctCounter);

Screen('DrawText', curWindow, 'Press any key to move to next trial...',300,250,cWhite0);
Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], fix, 1);
DrawFormattedText(curWindow, counterText, 'center', 20, cWhite0);
Screen('Flip',curWindow);
keytest_unbound;
end
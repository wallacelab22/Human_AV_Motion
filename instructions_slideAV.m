function instructions_slideAV(curWindow, cWhite0, typeSlide)

% Instructions 2
Screen('DrawText', curWindow, 'Additionally, after you report',500,300,cWhite0);
Screen('DrawText', curWindow, 'the direction of motion, you will be asked',300,400,cWhite0);
Screen('DrawText', curWindow, 'to move a slider along a bar.',300,500,cWhite0);
Screen('DrawText', curWindow, 'Press any key to continue...',300,650,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;

if typeSlide == 1
    % Instructions 4
    Screen('DrawText', curWindow, 'Move the bar according to how confident your response is.',300,300,cWhite0);
    Screen('DrawText', curWindow, 'The LEFT end of the bar will refer to 0% confidence in your response while',300,400,cWhite0);
    Screen('DrawText', curWindow, 'the RIGHT end of the bar will refer to 100% confidence in your response',300,500,cWhite0);
    Screen('DrawText', curWindow, 'Press any key to continue...',300,650,cWhite0);
    Screen('Flip',curWindow);
    keytest_unbound;
elseif typeSlide == 2
    % Instructions 3
    Screen('DrawText', curWindow, 'Move the bar according to how strongly you perceived the motion.',300,300,cWhite0);
    Screen('DrawText', curWindow, 'The LEFT end of the bar will refer to no motion while',300,400,cWhite0);
    Screen('DrawText', curWindow, 'the RIGHT end of the bar will refer to strongest motion',300,500,cWhite0);
    Screen('DrawText', curWindow, 'Press any key to continue...',300,650,cWhite0);
    Screen('Flip',curWindow);
    keytest_unbound;
end
                
% Instructions 4
Screen('DrawText', curWindow, 'Use the 0 on the box to move the slider left',300,300,cWhite0);
Screen('DrawText', curWindow, 'and the 1 on the box to move the slider right',300,400,cWhite0);
Screen('DrawText', curWindow, 'Press 2 on the box to confirm your slider position',300,500,cWhite0);
Screen('DrawText', curWindow, 'Press any key to continue...',300,650,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;

% Instructions 4
Screen('DrawText', curWindow, 'To repeat the instructions, report the direction',300,300,cWhite0);
Screen('DrawText', curWindow, 'of motion either 0 (left) or 1 (right)',300,400,cWhite0);
Screen('DrawText', curWindow, 'Then, move the slider to how strongly you perceived the motion',300,500,cWhite0);
Screen('DrawText', curWindow, 'Press any key to continue...',300,650,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;

% Instructions 5
Screen('DrawText', curWindow, 'If the motion stimulus is ambiguous, make a decision as best as you can.',300,300,cWhite0);
Screen('DrawText', curWindow, 'Please try to respond as QUICKLY as possible on EACH TRIAL',300,400,cWhite0);
Screen('DrawText', curWindow, '...WE WILL START NOW!...',500,500,cWhite0);
Screen('DrawText', curWindow, 'WHEN YOU ARE READY: PRESS ANY KEY TO START THE EXPERIMENT.',300,650,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;

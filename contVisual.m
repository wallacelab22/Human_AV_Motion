function contVisual(curWindow, cWhite0)

% Instructions 2
Screen('DrawText', curWindow, '!!!You are finished with this part of the experiment!!!',400,300,cWhite0);
Screen('DrawText', curWindow, '...THANK YOU FOR PARTICIPATING...',400,350,cWhite0);
Screen('DrawText', curWindow, 'Press any key to continue.',400,500,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;

function welcome(curWindow, cWhite0)


% Instructions 1
Screen('DrawText', curWindow, '...Welcome to this experiment...!',400,200,cWhite0);
Screen('DrawText', curWindow, 'You will be asked to detect',200,300,cWhite0);
Screen('DrawText', curWindow, '1. The presence of a moving SOUND embedded in the noise on each trial, and',200,400,cWhite0);
Screen('DrawText', curWindow, '2. To indicate in which direction the SOUND is moving.',200,500,cWhite0);
Screen('DrawText', curWindow, 'Press any key to continue.',200,650,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;
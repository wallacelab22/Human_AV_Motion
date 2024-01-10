function instructionsVisual(curWindow, cWhite0)

% Instructions 2
Screen('DrawText', curWindow, '...Welcome to this experiment...',400,300,cWhite0);
Screen('DrawText', curWindow, 'This is a VISUAL motion discrimination task.',200,400,cWhite0);
Screen('DrawText', curWindow, 'Your task is to report the direction (LEFT or RIGHT) on each trial.',200,500,cWhite0);
Screen('DrawText', curWindow, 'Press any key to continue...',200,650,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;

% Instructions 3
Screen('DrawText', curWindow, 'On each trial we will present both, auditory AND visual stimuli.',200,300,cWhite0);
Screen('DrawText', curWindow, 'Your task is to indicate only the direction of the VISUAL motion by',200,400,cWhite0);
Screen('DrawText', curWindow, 'pressing LEFTARROW for leftward motion or RIGHTARROW for rightward motion',200,500,cWhite0);
Screen('DrawText', curWindow, 'Press any key to continue...',200,650,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;

% Instructions 4
Screen('DrawText', curWindow, 'During a trial, a red dot will appear on',200,300,cWhite0);
Screen('DrawText', curWindow, 'the screen. Please FIXATE the red dot,',200,400,cWhite0);
Screen('DrawText', curWindow, 'throughout the trial.',200,500,cWhite0);
Screen('DrawText', curWindow, 'Press any key to continue...',200,650,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;

% Instructions 5
Screen('DrawText', curWindow, 'If the VISUAL stimulus is ambiguous, make a decision as best as you can.',200,300,cWhite0);
Screen('DrawText', curWindow, '!!!Please try to respond as ACCURATELY and QUICKLY as possible!!!',200,400,cWhite0);
Screen('DrawText', curWindow, '...WE WIL START NOW!...',400,500,cWhite0);
Screen('DrawText', curWindow, 'WHEN YOU ARE READY: PRESS ANY KEY TO START THE EXPERIMENT.',200,650,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;

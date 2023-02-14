function instructions_psyAVexample(curWindow, cWhite0)

% Instructions 2
Screen('DrawText', curWindow, 'We will start with a short example of the task',500,300,cWhite0);
Screen('DrawText', curWindow, 'Your task is to look and listen to the stimuli.',300,400,cWhite0);
Screen('DrawText', curWindow, 'Press any key to continue...',300,650,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;

Screen('DrawText', curWindow, 'During each trial, a red dot will appear on the center of',300,300,cWhite0);
Screen('DrawText', curWindow, 'the screen. Please FIXATE the red dot,',300,400,cWhite0);
Screen('DrawText', curWindow, 'throughout the trial.',300,500,cWhite0);
Screen('DrawText', curWindow, 'Press any key to continue...',300,650,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;


% Instructions 3
Screen('DrawText', curWindow, 'On each trial we will present a patch of visual dots and burst of auditory noise.',300,300,cWhite0);
Screen('DrawText', curWindow, 'On the first 2 trials, we will present VISUAL MOTION embedded in auditory noise.',300,400,cWhite0);
Screen('DrawText', curWindow, 'On the 3rd & 4th trials, we will present AUDITORY MOTION embedded in visual noise.',300,500,cWhite0);
Screen('DrawText', curWindow, 'On the last 4 trials, we will present both VISUAL AND AUDITORY MOTION.',300,600,cWhite0);
Screen('DrawText', curWindow, 'Press any key to continue...',300,650,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;

% Instructions 4

% Instructions 5
Screen('DrawText', curWindow, 'Remember the stimuli that you have just seen....',300,300,cWhite0);
Screen('DrawText', curWindow, 'Can you still discriminate the motion even when they are presented together?',300,400,cWhite0);
Screen('DrawText', curWindow, 'WHEN YOU ARE READY: PRESS ANY KEY TO START THE EXPERIMENT.',300,650,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;

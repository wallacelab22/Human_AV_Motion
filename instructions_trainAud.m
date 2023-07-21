function instructions_trainAud(curWindow, cWhite0, pahandle, corr_soundout, incorr_soundout)

% Instructions 2
Screen('DrawText', curWindow, '...Welcome to this experiment...',500,300,cWhite0);
Screen('DrawText', curWindow, 'This is a motion discrimination task.',200,400,cWhite0);
Screen('DrawText', curWindow, 'Your task is to report the direction (LEFT or RIGHT) of the stimulus.',300,500,cWhite0);
Screen('DrawText', curWindow, 'Press any key to continue...',200,650,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;

% Instructions 3
Screen('DrawText', curWindow, 'On each trial we will present a burst of auditory noise.',300,300,cWhite0);
Screen('DrawText', curWindow, 'Your task is to indicate whether there was motion on EACH TRIAL by',300,400,cWhite0);
Screen('DrawText', curWindow, 'pressing LEFTARROW for leftward motion or RIGHTARROW for rightward motion',300,500,cWhite0);
Screen('DrawText', curWindow, 'Press any key to continue...',300,650,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;

% Instructions 4
Screen('DrawText', curWindow, 'During a trial, a red dot will appear on the center of',300,300,cWhite0);
Screen('DrawText', curWindow, 'the screen. Please FIXATE the red dot,',300,400,cWhite0);
Screen('DrawText', curWindow, 'throughout the trial.',300,500,cWhite0);
Screen('DrawText', curWindow, 'Press any key to continue...',300,650,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;

% Instructions 5
Screen('DrawText', curWindow, 'After every trial you will be informed if you were correct or incorrect.',300,300,cWhite0);
Screen('DrawText', curWindow, 'The following HIGH pitched tone will be played if you are CORRECT.',300,400,cWhite0);
Screen('DrawText', curWindow, 'Press any key to continue after tone is played...',300,650,cWhite0);
Screen('Flip',curWindow);
WaitSecs(3)
PsychPortAudio('FillBuffer', pahandle, corr_soundout')
PsychPortAudio('Start', pahandle)
keytest_unbound


% Instructions 6
Screen('DrawText', curWindow, 'The CORRECT tone will be played again...',300,400,cWhite0);
Screen('DrawText', curWindow, 'Press any key to continue after tone is played...',300,650,cWhite0);
Screen('Flip',curWindow);
WaitSecs(1)
PsychPortAudio('FillBuffer', pahandle, corr_soundout')
PsychPortAudio('Start', pahandle)
keytest_unbound

% Instructions 7
Screen('DrawText', curWindow, 'After every trial you will be informed if you were correct or incorrect.',300,300,cWhite0);
Screen('DrawText', curWindow, 'The following LOW pitched tone will be played if you are INCORRECT.',300,400,cWhite0);
Screen('DrawText', curWindow, 'Press any key to continue after tone is played...',300,650,cWhite0);
Screen('Flip',curWindow);
WaitSecs(3)
PsychPortAudio('FillBuffer', pahandle, incorr_soundout')
PsychPortAudio('Start', pahandle)
keytest_unbound

% Instructions 8
Screen('DrawText', curWindow, 'The INCORRECT tone will be played again...',300,400,cWhite0);
Screen('DrawText', curWindow, 'Press any key to continue after tone is played...',300,650,cWhite0);
Screen('Flip',curWindow);
WaitSecs(1)
PsychPortAudio('FillBuffer', pahandle, incorr_soundout')
PsychPortAudio('Start', pahandle)
keytest_unbound

% Instructions 9
Screen('DrawText', curWindow, 'If the motion stimulus is ambiguous, make a decision as best as you can.',300,300,cWhite0);
Screen('DrawText', curWindow, 'Please try to respond as QUICKLY as possible on EACH TRIAL',300,400,cWhite0);
Screen('DrawText', curWindow, '...WE WILL START NOW!...',500,500,cWhite0);
Screen('DrawText', curWindow, 'WHEN YOU ARE READY: PRESS ANY KEY TO START THE EXPERIMENT.',300,650,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;

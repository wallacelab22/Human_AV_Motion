function instructions_psyAV_cued(curWindow, cWhite0, sliderResp_nature)

% Instructions 2
Screen('DrawText', curWindow, '...Welcome to this experiment...',500,300,cWhite0);
Screen('DrawText', curWindow, 'This is a motion discrimination task.',300,400,cWhite0);
Screen('DrawText', curWindow, 'Your task is to report the direction (LEFT or RIGHT) of a stimulus.',300,500,cWhite0);
Screen('DrawText', curWindow, 'Press any key to continue...',300,650,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;

% Instructions 3
Screen('DrawText', curWindow, 'Before some of the trials, you will see a possibility of 3 different instructions:',500,300,cWhite0);
Screen('DrawText', curWindow, '1- AUDITORY, 2- VISUAL, 3- AUDITORY & VISUAL',300,400,cWhite0);
Screen('DrawText', curWindow, 'These instructions will inform you which stimulus to PAY ATTENTION TO.',300,500,cWhite0);
Screen('DrawText', curWindow, 'Press any key to continue...',300,650,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;

% Instructions 4
Screen('DrawText', curWindow, 'For every trial we will present a patch of visual dots, burst of auditory noise, or both.',300,300,cWhite0);
Screen('DrawText', curWindow, 'Your task is to indicate the direction of motion ON EACH TRIAL by',300,400,cWhite0);
Screen('DrawText', curWindow, 'pressing 0 on the box for leftward motion or 1 on the box for rightward motion',300,500,cWhite0);
Screen('DrawText', curWindow, 'Press any key to continue...',300,650,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;

% Instructions 5
Screen('DrawText', curWindow, 'Please FIXATE the red fixation dot throughout every trial.',300,300,cWhite0);
Screen('DrawText', curWindow, 'Be sure to attend to the sense you were instructed if you were',300,400,cWhite0);
Screen('DrawText', curWindow, 'informed to do so for that trial.',300,500,cWhite0);
Screen('DrawText', curWindow, 'Press any key to continue...',300,650,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;

if ~sliderResp_nature
    % Instructions 6
    Screen('DrawText', curWindow, 'If the motion stimulus is ambiguous, make a decision as best as you can.',300,300,cWhite0);
    Screen('DrawText', curWindow, 'Please try to respond as QUICKLY as possible on EACH TRIAL',300,400,cWhite0);
    Screen('DrawText', curWindow, '...WE WILL START NOW!...',500,500,cWhite0);
    Screen('DrawText', curWindow, 'WHEN YOU ARE READY: PRESS ANY KEY TO START THE EXPERIMENT.',300,650,cWhite0);
    Screen('Flip',curWindow);
    keytest_unbound;
end

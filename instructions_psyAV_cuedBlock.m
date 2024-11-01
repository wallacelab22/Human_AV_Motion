
function instructions_psyAV_cuedBlock(curWindow, cWhite0, sliderResp_nature, cued_modality_nature)

switch cued_modality_nature
    case 1
        cued_modality = 'AUDITORY';
    case 2
        cued_modality = 'VISUAL';
    case 3
        cued_modality = 'AUDITORY & VISUAL';
end

% Instructions 2
Screen('DrawText', curWindow, '...Welcome to this experiment...',500,300,cWhite0);
Screen('DrawText', curWindow, 'This is a motion discrimination task.',300,400,cWhite0);
Screen('DrawText', curWindow, 'Your task is to report the direction (LEFT or RIGHT) of a stimulus.',300,500,cWhite0);
Screen('DrawText', curWindow, 'Press any key to continue...',300,650,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;

% Instructions 4
Screen('DrawText', curWindow, 'For every trial we will present a patch of visual dots and burst of auditory noise.',300,300,cWhite0);
Screen('DrawText', curWindow, 'Your task is to indicate the direction of motion ON EACH TRIAL by',300,400,cWhite0);
Screen('DrawText', curWindow, 'pressing 0 on the box for leftward motion or 1 on the box for rightward motion',300,500,cWhite0);
Screen('DrawText', curWindow, 'Press any key to continue...',300,650,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;


% Instructions 3
Screen('DrawText', curWindow, 'For this block, you will be asked to PAY ATTENTION to the:',500,300,cWhite0);
cueBlock_prompt = sprintf('%s stimulus ONLY', cued_modality);
Screen('DrawText', curWindow, cueBlock_prompt,300,400,cWhite0);
Screen('DrawText', curWindow, 'Please report that modality''s specific direction',300,500,cWhite0);
Screen('DrawText', curWindow, 'Press any key to continue...',300,650,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;

% Instructions 5
Screen('DrawText', curWindow, 'Please FIXATE the red fixation dot throughout every trial.',300,300,cWhite0);
cueBlock_reminderprompt = sprintf('Please be sure to attend to %s for this block.', cued_modality);
Screen('DrawText', curWindow, cueBlock_reminderprompt,300,400,cWhite0);
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

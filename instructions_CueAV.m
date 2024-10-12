function instructions_CueAV(curWindow, cWhite0, fix, data_output, correctCounter_nature, cued_modality)
% Waits for participant keypress to move to next trial and displays the CUE

if correctCounter_nature
    correctCounter = sum(data_output(:,8), 'omitnan');
    counterText = sprintf('Trials Correct: %d', correctCounter);
end

switch cued_modality    
    case 1
        cue_prompt = 'AUDITORY';
    case 2    
        cue_prompt = 'VISUAL';
    case 3    
        cue_prompt = 'AUDITORY & VISUAL';
    otherwise
        cue_prompt = '';
end

Screen('TextSize', curWindow, 40);
Screen('DrawText', curWindow, cue_prompt, 300, 250, cWhite0);
Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], fix, 1);
if correctCounter_nature
    DrawFormattedText(curWindow, counterText, 'center', 20, cWhite0);
end
Screen('Flip',curWindow);
keytest_unbound;
end
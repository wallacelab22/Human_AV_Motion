function instructions_CueAV(curWindow, cWhite0, fix, data_output, correctCounter_nature, cued_modality, xCenter)
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
        cue_prompt = '---';
end


Screen('TextSize', curWindow, 128);
% Get the screen resolution
[screenXpixels, screenYpixels] = Screen('WindowSize', curWindow);

% Calculate the position for the text to be centered horizontally and slightly above the vertical center
textXpos = screenXpixels * 0.5;
textYpos = screenYpixels * 0.4; % Adjust this value to position the text above the vertical center

% Measure the text width and height to center it correctly
[normBoundsRect, ~] = Screen('TextBounds', curWindow, cue_prompt);
textWidth = normBoundsRect(3);
textHeight = normBoundsRect(4);

% Adjust textXpos to center the text (considering the measured width)
textXpos = textXpos - textWidth / 2;
% Adjust textYpos to center the text (considering the measured height)
textYpos = textYpos - textHeight / 2;

% Draw the text at the new position
Screen('DrawText', curWindow, cue_prompt, textXpos, textYpos, cWhite0);
Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], fix, 1);
if correctCounter_nature
    DrawFormattedText(curWindow, counterText, 'center', 20, cWhite0);
end
Screen('Flip',curWindow);
keytest_unbound;
end
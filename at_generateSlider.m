function [stimInfo, StopPixel_M, currentRating] = at_generateSlider(stimInfo, right_keypress, left_keypress, space_keypress, curWindow, cWhite0, xCenter, yCenter)

% Parameters for your scale and text that you want
question = 'USE THE SLIDER TO MATCH THE VISUAL NOISINESS TO THE AUDITORY NOISINESS.';
lowerText = 'Less Noisy';
upperText = 'More Noisy';
pixelsPerPress = 2;
waitframes = 1;
lineLength = 500; % in pixels
halfLength = lineLength/2;
divider = lineLength/10; % for a rating of 1:10

baseRect = [0 0 10 30]; % size of slider
LineX = xCenter;
LineY = yCenter;

rectColor = cWhite0;
lineColor = cWhite0;
textColor = cWhite0;

while KbCheck; end
while true
    [keyisDown, secs, keyCode] = KbCheck;
    pressedKeys = find(keyCode);
    if ismember(pressedKeys, right_keypress)
        LineX = LineX + pixelsPerPress;
    elseif ismember(pressedKeys, left_keypress)
        LineX = LineX - pixelsPerPress;
    elseif ismember(pressedKeys, space_press)
        StopPixel_M = ((LineX - xCenter) + halfLength)/divider; % for a rating of between 0 and 10. Tweak this as necessary
        break
    end
    if LineX < (xCenter - halfLength)
        LineX = xCenter - halfLength;
    elseif LineX > (xCenter + halfLength)
        LineX = xCenter + halfLength;
    end
    if LineY < 0
        LineY = 0;
    elseif LineY > (yCenter + 10)
        LineY = yCenter + 10;
    end

    centeredRect = CenterRectOnPointd(baseRect, LineX, LineY);

    currentRating = ((LineX - xCenter) + halfLength)/divider;
    ratingText = num2str(currentRating); % to make this display whole numbers, use "round(currentRating)"

    DrawFormattedText(curWindow, ratingText ,'center', (yCenter-200), textColor, [],[],[],5); % display current rating 
    DrawFormattedText(curWindow, question ,'center', (yCenter-100), textColor, [],[],[],5);
    
    Screen('DrawLine', curWindow,  lineColor, (xCenter+halfLength), (yCenter),(xCenter-halfLength), (yCenter), 1);
    Screen('DrawLine', curWindow,  lineColor, (xCenter+halfLength), (yCenter+10), (xCenter+halfLength), (yCenter-10), 1);
    Screen('DrawLine', curWindow,  lineColor, (xCenter-halfLength), (yCenter+10), (xCenter-halfLength), (yCenter-10), 1);
    
    Screen('DrawText', curWindow, lowerText, (xCenter-halfLength), (yCenter+25),  textColor);
    Screen('DrawText', curWindow, upperText , (xCenter+halfLength) , (yCenter+25), textColor);
    Screen('FillRect', curWindow, rectColor, centeredRect);
    vbl = Screen('Flip', curWindow, vbl + (waitframes - 0.5) *  slack);
end

%% Close everything and display the rating. If you're doing this during a script, just put in a flip and save the rating somewhere. 

disp('Rating: ') ;
disp(StopPixel_M);
sca;
Screen('CloseAll');

end
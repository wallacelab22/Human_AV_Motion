function [audInfo, StopPixel_M] = at_generate_audSlider(audInfo, right_keypress, left_keypress, space_keypress, screenInfo, screenRect, curWindow, cWhite0, xCenter, yCenter, silence, Fs, noise_reduction_scalar, pahandle)

% Needed to present stimuli
EEG_nature = 0;
outlet = NaN;
markers = NaN;

% Variables for nonchanging visual stimulus
inputtype = 1; typeInt = 1; minNum = 1.5; maxNum = 2.5; meanNum = 2; maxdotsframe = 150;
block_dot_speed = 15; vel_stair = 0; visInfo.vel = 58.8; dur = 0.5;
monWidth = 50.8; viewDist = 120;

slack = Screen('GetFlipInterval', curWindow);
vbl = Screen('Flip', curWindow);

% Parameters for your scale and text that you want
question = 'USE THE SLIDER TO MATCH THE VISUAL NOISINESS TO THE AUDITORY NOISINESS.';
lowerText = 'Most Noisy';
upperText = 'Least Noisy';
pixelsPerPress = 2;
waitframes = 1;
lineLength = 500; % in pixels
halfLength = lineLength/2;
divider = lineLength/100; % for a rating of 1:10

baseRect = [0 0 10 30]; % size of slider
LineX = xCenter;
LineY = yCenter;

rectColor = cWhite0;
lineColor = cWhite0;
textColor = cWhite0;

while KbCheck; end
while true
    %% Flip up fixation dot
    [fix, s] = fixation_dot_flip(screenRect, curWindow);

    %% Create slider
    [keyisDown, secs, keyCode] = KbCheck;
    pressedKeys = find(keyCode);
    if ismember(pressedKeys, right_keypress)
        LineX = LineX + pixelsPerPress;
    elseif ismember(pressedKeys, left_keypress)
        LineX = LineX - pixelsPerPress;
    elseif ismember(pressedKeys, space_keypress)
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
    ratingText = sprintf(ratingText, '%');

    DrawFormattedText(curWindow, ratingText,'center', (yCenter-200), textColor, [],[],[],5); % display current rating 
    DrawFormattedText(curWindow, question ,'center', (yCenter-100), textColor, [],[],[],5);
    
    Screen('DrawLine', curWindow,  lineColor, (xCenter+halfLength), (yCenter),(xCenter-halfLength), (yCenter), 1);
    Screen('DrawLine', curWindow,  lineColor, (xCenter+halfLength), (yCenter+10), (xCenter+halfLength), (yCenter-10), 1);
    Screen('DrawLine', curWindow,  lineColor, (xCenter-halfLength), (yCenter+10), (xCenter-halfLength), (yCenter-10), 1);
    
    Screen('DrawText', curWindow, lowerText, (xCenter-halfLength), (yCenter+25),  textColor);
    Screen('DrawText', curWindow, upperText , (xCenter+halfLength) , (yCenter+25), textColor);
    Screen('FillRect', curWindow, rectColor, centeredRect);
    vbl = Screen('Flip', curWindow, vbl + (waitframes - 0.5) *  slack);

    % Present visual stimulus at a given coherence
    visInfo.coh = givenCoh;
    visInfo.dir = randi([1,2]);
    
    % Necessary variable changing for RDK code. 1 = RIGHT, which is 0 
    % degrees on unit circle, 2 = LEFT, which is 180 degrees on unit circle
    visInfo = direction_conversion(visInfo);

    %% Create info matrix for Visual Stim. 
    % This dotInfo  output informs at_dotGenerate how to generate the RDK. 
    dotInfo = at_createDotInfo(inputtype, visInfo.coh, visInfo.dir, typeInt, ...
        minNum, maxNum, meanNum, maxdotsframe, dur, block_dot_speed, vel_stair, visInfo.vel);
    
    %% Dot Generation.
    % This function generates the dots that will be presented to
    % participant in accordance with their coherence, direction, and other dotInfo.
    [center, dotSize, d_ppd, ndots, dxdy, ss, Ls, continue_show] = at_generateDot(visInfo, dotInfo, screenInfo, screenRect, monWidth, viewDist, maxdotsframe, dur, curWindow, fix);
    
     if keyisDown
        % Update auditory stimulus in accordance to currentRating
        audInfo.coh = currentRating/100;
        audInfo.dir = visInfo.dir;
        %% Generate and present the auditory stimulus
        % Generates auditory stimulus
        frames = 0;
        % makeCAM and makeCAM_PILOT create an array voltages to be presented
        % via speakers that creates perceptual auditory motion from one speaker
        % to another
        CAM = makeCAM_PILOT(audInfo.coh, audInfo.dir, audInfo.durRaw, silence, Fs, noise_reduction_scalar);
        wavedata = CAM;
        nrchannels = size(wavedata,1); % Number of rows = number of channels.
     end

    %% Dot Presentation
    % This function uses psychtoolbox to present dots to participant.
    responded = 0; %DS mark as no response yet
    resp = nan; %default response is nan
    rt = nan; %default rt in case no response is recorded

    [resp, rt, start_time] = at_presentDot(visInfo, center, dotSize, d_ppd, ndots, dxdy, ss, Ls, continue_show, curWindow, fix, responded, resp, rt, EEG_nature, outlet, markers);
    
    if keyisDown
        % Presents auditory stimulus and gets reaction time. Presents stimulus 
        % for duration specified in dur, which is the length of CAM (wavedata)
        [resp, rt, start_time] = at_presentAud(continue_show, responded, resp, rt, curWindow, fix, frames, pahandle, wavedata, EEG_nature, outlet, markers);
    end

    %% Erase last dots & go back to only plotting fixation
    Screen('DrawingFinished',curWindow);
    Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], fix, 1);
    Screen('Flip', curWindow,0);
end

%% Close everything and display the rating. If you're doing this during a script, just put in a flip and save the rating somewhere. 

disp('Rating: ') ;
disp(StopPixel_M);
sca;
Screen('CloseAll');

end
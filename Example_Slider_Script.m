%% Example Slider Script - 01/05/24

% Initialize variables
KbName('UnifyKeyNames')
try
    right_keypress = KbName('RightArrow');
    left_keypress = KbName('LeftArrow');
    space_keypress = KbName('Space');
catch
    right_keypress = [115 13];
    left_keypress = [114 12];
    space_keypress = [66 14];
end
cWhite0 = 255;
% fixation_color = [255 0 0];
viewDist = 120;
curScreen = 0;
aperture_size = 50;
visInfo.displaceSet = aperture_size;

% Prompt for monitor width
monWidth = input('Monitor Width (in cm)?  : ');

% Opens psychtoolbox and initializes experiment
Screen('Preference', 'SkipSyncTests', 1);
[screenInfo, xCenter, yCenter] = openExperiment(monWidth, viewDist, curScreen);
curWindow= screenInfo.curWindow;
screenRect= screenInfo.screenRect;
% Enable alpha blending with proper blend-function. We need it for drawing
% of smoothed points.
Screen('BlendFunction', curWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
monRefresh = 1/screenInfo.frameDur;


slack = Screen('GetFlipInterval', curWindow);
vbl = Screen('Flip', curWindow);

% Needed to present stimuli
EEG_nature = 0;
outlet = NaN;
markers = NaN;

% Variables for nonchanging visual stimulus
inputtype = 1; typeInt = 1; minNum = 1.5; maxNum = 2.5; meanNum = 2; maxdotsframe = 150;
block_dot_speed = 15; vel_stair = 0; visInfo.vel = 58.8; dur = 0.5;
monWidth = 50.8; viewDist = 120; givenCoh = 0.5;


% Parameters for your scale and text that you want
question = 'USE THE SLIDER TO MATCH THE VISUAL NOISINESS TO THE AUDITORY NOISINESS.';
lowerText = 'Most Noisy';
upperText = 'Least Noisy';
pixelsPerPress = 2;
waitframes = 1;
lineLength = 500; % in pixels
halfLength = lineLength/2;
divider = lineLength/100; % for a rating of 1:10
currentRating = NaN;

baseRect = [0 0 10 30]; % size of slider
LineX = xCenter;
LineY = yCenter;

rectColor = cWhite0;
lineColor = cWhite0;
textColor = cWhite0;

while KbCheck; end
while true

    %% Create slider
    [keyisDown, secs, keyCode] = KbCheck;
    pressedKeys = find(keyCode);
    disp(KbName)
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
    WaitSecs(4)
    
end

%% Close everything and display the rating. If you're doing this during a script, just put in a flip and save the rating somewhere. 

disp('Rating: ') ;
disp(StopPixel_M);
sca;
Screen('CloseAll');

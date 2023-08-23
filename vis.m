%% HUMAN VISUAL MOTION DISCRIMINATION TASK CODE %%%%%%%%%%%%%
% Wallace Multisensory Lab - Vanderbilt University
% written by Adam Tiesman - adam.j.tiesman@vanderbilt.edu
% Initial commit on 2/27/2023
clear;
close all;
clc;

%% FOR RESPONSE CODING: 1 = RIGHTWARD MOTION; 2 = LEFTWARD MOTION
right_var = 1; left_var = 2; catch_var = 0; EEG_nature = 0; outlet= NaN; markers = NaN; vel_stair = 0;

%% General variables to smoothly run PTB
% Necessary for psychtoolbox to read keyboard inputs. UnifyKeyNames allows
% for portability of script. 
KbName('UnifyKeyNames');
AssertOpenGL;
% Assigned keyboard variables in Linux for left and right arrow keys and extended
% keyboard device. Change depending on what you are using to have
% participants report direction.
right_keypress = [115 13];
left_keypress = [114 12];
space_keypress = [66 14];

%% Define general values how long recording iTis for, might have been poisson distribution
% inputtype, typeInt, minNum, maxNum, and meanNum all deal with the intertrial interval, which
% is generated in the function iti_response_recording. menaNum is the mean
% time in sec that the iti will be. mMn and max time for iti defined by minNum
% and maxNum respectively.
inputtype = 1; typeInt = 1; minNum = 1.5; maxNum = 2.5; meanNum = 2;

%% General stimulus variables
% dur is stimulus duration, triallength is total length of 1 trial (this is
% currently unused in code), Fs is sampling rate, nbblocks is used to divide up num_trials 
% into equal parts to give subject breaks if there are many trials. 
% Set to 0 if num_trials is shor  t   a nd subject does not need break(s).
dur = 2; Fs = 44100; triallength = 2; nbblocks = 0; 

% Define buffersize in  order to make CAM (auditory stimulus)
silence = 0.03; buffersize = (dur+silence)*Fs;

% All variables that define stimulus repetitions; num_trials defines total
% number of staircase trials, stimtrials defines number of stimulus trials
% per condition for MCS, catchtrials defines total number of catch trials
% for MCS.
num_trials = 100; stimtrials = 12; catchtrials = 25;

% Visual stimulus properties relating to monitor (measure yourself),
% maxdotsframe is for RDK and is a limitation of your graphics card. The
% only way you can know its limit is by trial and error. Variables monWidth
% and viewDist are measured in centimeters. Speaker distance in degrees,
% measured from center of one speaker to center of the other. Because
% speakerDistance = 29.4 and dur = 0.5, auditory velocity if not otherwise 
% specified is 58.8 deg/s. maxVel is maximum velocity that can be presented
% as an auditory stimulus with a 0.5 sec dur.
maxdotsframe = 150; monWidth = 50.8; viewDist = 120; audInfo.speakerDistance = 29.4;
audInfo.maxVel = audInfo.speakerDistance/dur;

% General drawing color used for RDK, instructions, etc.
cWhite0 = 255; fixation_color = [255 0 0];

%% Create data matrix to store data
data_output = zeros(num_trials, 7);

%% Initialize
% curScreen = 0 if there is only one monitor. If more than one monitor, 
% check display settings on PC. curScreen will probably equal 1 or 2 
% (e.g. monitor for stimulus presentation and monitor to run MATLAB code).
curScreen = 0;

% Opens psychtoolbox and initializes experiment
[screenInfo, curWindow, screenRect, xCenter, yCenter] = initialize_exp(monWidth, viewDist, curScreen);

%% Initialize Audio
[pahandle] = initialize_aud(curWindow, Fs);

%% SLIDER INFORMATION
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


%% Welcome and Instrctions for the Suject
% Opens psychtoolbox instructions for participant for the specific task 
% (psyVis for all visual tasks, psyAud for all auditory only tasks, psyAV 
% for all audiovisual tasks). trainAud and trainVis have separate instructions.
%instructions_psyVis(curWindow, cWhit e0);

%% Flip up fixation dot
[fix, s] = at_presentFix(screenRect, curWindow);

givenCoh = 0.5;
%% Experiment Loop
% Loop through every trial.6
for ii = 1:length(data_output)

    visInfo.dir = data_output(ii,3);
    audInfo.dir = data_output(ii,1);
    audInfo.coh = data_output(ii,2);
    givenCoh = data_output(ii,4);
    while true
        visInfo.coh = givenCoh;
        visInfo.vel = 20;
        audInfo.vel = visInfo.vel;
        visInfo.displaceSet = 50;
    
        % Necessary variable changing for RDK code. 1 = RIGHT, which is 0 
        % degrees on unit circle, 2 = LEFT, which is 180 degrees on unit circle
        visInfo = direction_conversion(visInfo);
    
        %% Create info matrix for Visual Stim. 
        % This dotInfo  output informs at_dotGenerate how to generate the RDK. 
        dotInfo = at_createDotInfo(inputtype, visInfo.coh, visInfo.dir, typeInt, ...
            minNum, maxNum, meanNum, maxdotsframe, dur, visInfo.vel, visInfo.displaceSet);
        
        %% Keypress input initialize variables, define frames for presentation
        while KbCheck; end
        keycorrect = 0;
        keyisdown = 0;
        responded = 0; %DS mark as no response yet
        resp = nan; %default response is nan
        rt = nan; %default rt in case no response is recorded
    
        % Create marker for EEG
        [markers] = at_generateMarkers(data_output, ii, EEG_nature);
    
        while true
            %% Dot Generation.
            % This function generates the dots that will be presented to
            % participant in accordance with their coherence, direction, and other dotInfo.
            [center, dotSize, d_ppd, ndots, dxdy, ss, Ls, continue_show] = at_generateDot(visInfo, dotInfo, screenInfo, screenRect, monWidth, viewDist, maxdotsframe, dur, curWindow, fix);
            
            %% Dot Presentation
            % This function uses psychtoolbox to present dots to participant.
            [resp, rt, start_time] = at_presentDot(visInfo, dotInfo, center, dotSize, d_ppd, ndots, dxdy, ss, Ls, continue_show, curWindow, fix, responded, resp, rt, EEG_nature, outlet, markers);
        
            %% Erase last dots & go back to only plotting fixation
            Screen('DrawingFinished',curWindow);
            Screen('DrawDots', curWindow, [0; 0], 10, fixation_color, fix, 1);
            Screen('Flip', curWindow, 0);
            
            %% ITI & response recording
            [resp, rt] = iti_response_recording(typeInt, minNum, maxNum, meanNum, dur, start_time, keyisdown, responded, resp, rt);
            
            %% 2 Direction conversion
            visInfo = direction_conversion(visInfo);
        
            %% Save data into data_output on a trial by trial basis
            [trial_status, data_output] = record_data(data_output, right_var, left_var, right_keypress, left_keypress, visInfo, resp, rt, ii, vel_stair);
        
            WaitSecs(0.5)
        
            while true
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
            end
            Screen('DrawText', curWindow, 'Do you think you have matched the visual noisiness to the auditory noisiness?',300,300,cWhite0);
            Screen('DrawText', curWindow, 'If you think you are complete with this trial, press 1',300,400,cWhite0);
            Screen('DrawText', curWindow, 'If you want to see/hear your adjustments, press 2',300,500,cWhite0);
            Screen('Flip',curWindow);
            [keyisDown, secs, keyCode] = KbCheck;
            pressedKeys = find(keyCode);
            if ismember(pressedKeys, right_keypress)
                break;
            elseif ismember(pressedKeys, left_keypress)
                continue;
            else
                WaitSecs(3)
            end
        end
    end
    WaitSecs(0.5)
    
    givenCoh = StopPixel_M/100;

 end

%% Goodbye
cont(curWindow, cWhite0);

%% Finalize 
% Close psychtoolbox window
closeExperiment;
close all
Screen('CloseAll')
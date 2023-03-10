%% AUDITORY STAIRCASE TRAINING %%%%%%%%%%
% written by Adam Tiesman 2/27/2023
clear;
close all;
clc;
%% FOR RESPONSE CODING: 1= RIGHTWARD MOTION ; 2=LEFTWARD MOTION
% %% define general variables
% % directories used throughout the experment
scriptdirectory = 'C:\Users\Wallace Lab\Documents\MATLAB\Human_AV_Motion';
localdirectory = 'C:\Users\Wallace Lab\Documents\MATLAB\Human_AV_Motion';
serverdirectory = 'C:\Users\Wallace Lab\Documents\MATLAB\Human_AV_Motion';
data_directory = 'C:\Users\Wallace Lab\Documents\MATLAB\Human_AV_Motion\data\';
cd(scriptdirectory)

% % general variables to smoothly run PTB
 KbName('UnifyKeyNames');

%% define general values how long recording iTis for, might have been poisson distribution
inputtype=1; typeInt=1; minNum=1.5; maxNum=2.5; meanNum=2;

%% general stimlus variables duration of trial, trial length to keep it open for rt reasons, 
dur=.5; Fs=44100; triallength=2; nbblocks=2; silence=0.03; audtrials=20;
buffersize=(dur+silence)*Fs; s.Rate=44100; num_trials = 100;

% visual stimulus properties number of dots, viewing distance from monitor
maxdotsframe=150; monWidth=42.5; viewDist =120; cWhite0=255;

%% collect subjectinformation
subjnum = input('Enter the subject''s number: ');
subjnum_s = num2str(subjnum);
if length(subjnum_s) < 2
    subjnum_s = strcat(['0' subjnum_s]);
end
group = input('Enter the test group: ');
group_s = num2str(group);
if length(group_s) < 2
    group_s = strcat(['0' group_s]);
end
sex = input('Enter the subject''s sex (1 = female; 2 = male): ');
sex_s=num2str(sex);
if length(sex_s) < 2
    sex_s = strcat(['0' sex_s]);
end
age = input('Enter the subject''s age: ');
age_s=num2str(age);
if length(age_s) < 2
    age_s = strcat(['0' age_s]);
end

underscore = '_';
filename = strcat('RDKHoop_stairAud',underscore,subjnum_s,underscore,group_s, underscore, sex_s, underscore, age_s);

cd(localdirectory)
save(filename,'filename')
cd(scriptdirectory)

%% Initialize
curScreen=2;
Screen('Preference', 'SkipSyncTests', 1);
screenInfo = openExperiment(monWidth, viewDist, curScreen);
curWindow= screenInfo.curWindow;
screenRect= screenInfo.screenRect;
% Enable alpha blending with proper blend-function. We need it for drawing
% of smoothed points.

%% Initialize Audio
Screen('BlendFunction', curWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
InitializePsychSound;
pahandle = PsychPortAudio('Open', 4, [], 0, Fs, 2);

%% Welcome and Instrctions for the Suject
instructions_psyAud(curWindow, cWhite0);

%% Flip up fixation dot
fix=[screenRect(3)/2,screenRect(4)/2]; %define fix position of fix dot
Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], fix, 1);
Screen('Flip', curWindow,0);
s.NotifyWhenScansQueuedBelow = 22050;
WaitSecs(2); %wait for 2s

% Define the list of possible coherences
audInfo.cohSet = [1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1];
audInfo.probs = [0.33 .5 .66 .5]; %Staircase Probs See function




%% exp loop
for ii=1:num_trials
    
    if ii == 1 
        staircase_index = 1 % Start staircase on coherence of 1
        audInfo.dir = randi([1,2])
        audInfo.coh = audInfo.cohSet(staircase_index)
    elseif ii > 1
        [audInfo, staircase_index] = staircase_procedure(trial_status, audInfo, staircase_index)
    end
    
    %% display the stimuli
    while KbCheck; end
    keycorrect=0;
    keyisdown=0;
    responded = 0; %DS mark as no response yet
    resp = nan; %default response is nan
    rt = nan; %default rt in case no response is recorded
    continue_show = round(dur*60);
    priorityLevel = MaxPriority(curWindow,'KbCheck'); %make sure Window commands are correct
    Priority(priorityLevel);
    
    % THE MAIN LOOP
    frames = 0;
    CAM=makeCAM(audInfo.coh, audInfo.dir, dur, silence, Fs);
    wavedata = CAM;
    nrchannels = size(wavedata,1); % Number of rows == number of channels.
        
    while continue_show
        %DS look for key down if no response yet
        if ~responded %if no response
            [key,secs,keycode] = KbCheck; %look for a key
            WaitSecs(0.0002); %tiny wait
            if key %if there was a key
                resp = find(keycode,1,'last');
                rt = GetSecs - start_time; %calculate rt from start time earlier
                responded = 1; %note that there was a response
            end
        end
        
        % Now do next drawing commands
        Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], fix, 1);
        % After all computations, flip
        Screen('Flip', curWindow,0);
        frames = frames + 1;
        
        %% get RTs
        if frames == 1
            start_time = GetSecs;
	        PsychPortAudio('FillBuffer', pahandle, wavedata');
	        PsychPortAudio('Start', pahandle, 1);
        end
        
        % Check for end of loop
        continue_show = continue_show - 1;
    end
  
    %%  ITI & response recording
    interval=makeInterval(typeInt,minNum,maxNum,meanNum);
    interval=interval+dur;
    %DS loop until interval is over
    while KbCheck; end %hold if key is held down
    while ~keyisdown %while no key is down
        [keyisdown,secs,keycode] = KbCheck; %look for a key
        if GetSecs - start_time >= interval %if elapsed time since stim onset is > ISI
            break %break loop
        elseif keyisdown && ~responded %if a key is down
            if length(find(keycode,1)) == 1 %block multikey, if 1 key down
                responded = 1; %mark that they responded
                resp = find(keycode,1,'last');
                rt = GetSecs - start_time; %record rt
                while GetSecs - start_time < interval %wait for rest of ISI
                    WaitSecs(0.0002);
                end
                break; % and break
            else
                keyisdown = 0; %reset to no key down and retry
            end
        end
    end;
    while GetSecs - start_time < interval
        WaitSecs(0.0002);
    end
    while KbCheck; end %hold if key is held down
    %% save data
    data_output(ii, 1) = audInfo.dir; 
    data_output(ii, 2) = audInfo.coh; 
    if resp == 39
        data_output(ii, 3)=1;
    elseif resp == 37
        data_output(ii, 3)=2;
    else
        data_output(ii, 3)= nan;
    end
    data_output(ii, 4)=rt;
    data_output(ii,5)=char(resp);
    if data_output(ii, 3) == data_output(ii, 1)% If response is the same as direction, Correct Trial
        trial_status = 'Correct';
        data_output(ii, 6) = trial_status;
    else 
        trial_status = 'Incorrect';
        data_output(ii, 6) = trial_status;
    end

end

cd(localdirectory)
save([data_directory filename], 'data_output');

%% Goodbye
cont(curWindow, cWhite0);

%% Finalize
closeExperiment;
close all
Screen('CloseAll')

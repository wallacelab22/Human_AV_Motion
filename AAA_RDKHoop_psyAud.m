clear all
close all
clc
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
% AssertOpenGL;
% daqreset;
% daq.getDevices;
% s = daq.createSession('ni');
 s.Rate=44100;
% IsContinuous=true;
% addAnalogOutputChannel(s,'cDAQ1Mod2','ao0','Voltage');
% addAnalogOutputChannel(s,'cDAQ1Mod2','ao1','Voltage');
%% define general values how long recording iTis for, might have been poisson distribution
inputtype=1; typeInt=1; minNum=1.5; maxNum=2.5; meanNum=2;

%% general stimlus variables duration of trial, trial length to keep it open for rt reasons, 
dur=.5; Fs=44100; triallength=2; nbblocks=2; silence=0.03; catchtrials=50; audtrials=20;
buffersize=(dur+silence)*Fs;

%auditory coherence levels
 audcoh1=0.1; audcoh2=0.25; audcoh3=0.35; audcoh4=0.45; audcoh5=0.55;

% visual stimulus properties number of dots, viewing distance from monito
maxdotsframe=150; monWidth=42.5; viewDist =120; cWhite0=255;

addpath('C:\Users\Wallace Lab\Documents\MATLAB\Human_AV_Motion\liblsl-Matlab-master');
addpath('C:\Users\Wallace Lab\Documents\MATLAB\Human_AV_Motion\liblsl-Matlab-master\bin');

% instantiate the LSL library
lib = lsl_loadlib();
 
% make a new stream outlet (name: BioSemi, type: EEG. 8 channels, 100Hz)
info = lsl_streaminfo(lib,'MyMarkerStream','Markers',1,0,'cf_string','wallacelab');
outlet = lsl_outlet(info);

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
filename = strcat('RDKHoop_psyAud',underscore,subjnum_s,underscore,group_s, underscore, sex_s, underscore, age_s);

cd(localdirectory)
save(filename,'filename')
cd(scriptdirectory)

%% make design Matrix
rng('shuffle')
data_output=at_RDKHoopMatrix_psyAud(catchtrials,audtrials);

%% Initialize
curScreen=2;
%Screen('Preference', 'SkipSyncTests', 0);
Screen('Preference', 'SkipSyncTests', 1);
screenInfo = openExperiment(monWidth, viewDist, curScreen);
curWindow= screenInfo.curWindow;
screenRect= screenInfo.screenRect;
% Enable alpha blending with proper blend-function. We need it for drawing
% of smoothed points.

%% Initialize Audio
Screen('BlendFunction', curWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
InitializePsychSound;
% deviceindex = [];
% devices = PsychPortAudio('GetDevices')
% for k = 1:numel(devices)
%     if strcmp(devices(k).DeviceName, 'RME Fireface UC')
%         deviceindex = devices(k).DeviceIndex;
%     end
% end

pahandle = PsychPortAudio('Open', 4, [], 0, Fs, 2);

%% Welcome and Instrctions for the Suject
instructions_psyAud(curWindow, cWhite0);
%% Flip up fixation dot
fix=[screenRect(3)/2,screenRect(4)/2]; %define fix position of fix dot
Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], fix, 1);
Screen('Flip', curWindow,0);
s.NotifyWhenScansQueuedBelow = 22050;
WaitSecs(2); %wait for 2s

%% trial generation
for ii=1:length(data_output)
    %% check whether it's break time for the subject
    tt=[length(data_output)/nbblocks: length(data_output)/nbblocks : length(data_output)-length(data_output)/nbblocks];
    if ismember(ii, tt) == 1
        takebreak(curWindow, cWhite0) % breaks every 5-6 min. Total of nbblocks
        Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], fix, 1);
        Screen('Flip', curWindow,0);
        WaitSecs(2)
    end
    
    currauddir=data_output(ii,1);
    if currauddir == 0
        currauddir=randi(2);
    end
    
    curraudcoh=data_output(ii,2);
    if curraudcoh == 1
        curraudcoh=audcoh1;
    elseif curraudcoh == 2
        curraudcoh=audcoh2;
    elseif curraudcoh == 3
        curraudcoh=audcoh3;
    elseif curraudcoh == 4
        curraudcoh=audcoh4;
    elseif curraudcoh == 5
        curraudcoh=audcoh5;
    end
    
    cLvl=curraudcoh;
    %% display the stimuli
    while KbCheck; end
    keycorrect=0;
    keyisdown=0;
    responded = 0; %DS mark as no response yet
    resp = nan; %defailt response is nan
    rt = nan; %default rt in case no response is recorded
    continue_show = round(dur*60);
    priorityLevel = MaxPriority(curWindow,'KbCheck'); %make sure Window commands are correct
    Priority(priorityLevel);
    
    % THE MAIN LOOP
    frames = 0;
    CAM=makeCAM(cLvl, currauddir, dur, silence, Fs);
    wavedata = CAM;
    nrchannels = size(wavedata,1); % Number of rows == number of channels.
    dir_id = num2str(data_output(ii,1));
    coh_id = num2str(data_output(ii,2));
    markers = strcat([dir_id coh_id]); %unique identifier for LSL


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
            outlet.push_sample({markers});
%              queueOutputData(s,CAM);
%              lh = addlistener(s,'DataRequired', ...
%                  @(src,event) src.queueOutputData(CAM));
%              startBackground(s);
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
    if resp == 39
        data_output(ii, 3)=1;
    elseif resp == 37
        data_output(ii, 3)=2;
    else
        data_output(ii, 3)= nan;
    end
    data_output(ii, 4)=rt;
    data_output(ii,5)=char(resp);
end

cd(localdirectory)
save([data_directory filename], 'data_output');

%% Goodbye
cont(curWindow, cWhite0);

%% Finalize
closeExperiment;
close all
Screen('CloseAll')

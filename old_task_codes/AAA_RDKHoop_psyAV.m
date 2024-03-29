%% AUDIOVISUAL TASK CODE %%%%%%%%%%
% adapted and revised by Adam Tiesman
clear;
close all;
clc;
%% FOR RESPONSE CODING: 1= RIGHTWARD MOTION ; 2=LEFTWARD MOTION
% %% define general variables
scriptdirectory = '/home/wallace/Human_AV_Motion';
localdirectory = '/home/wallace/Human_AV_Motion';
serverdirectory = '/home/wallace/Human_AV_Motion';
data_directory = '/home/wallace/Human_AV_Motion';
cd(scriptdirectory)

%% general variables to smoothly run PTB
KbName('UnifyKeyNames');
AssertOpenGL;
% daqreset;
% daq.getDevices;
% s = daq.createSession('ni');
s.Rate=44100;
% IsContinuous=true;
% addAnalogOutputChannel(s,'cDAQ1Mod2','ao0','Voltage');
% addAnalogOutputChannel(s,'cDAQ1Mod2','ao1','Voltage');
%% define general values
inputtype=1; typeInt=1; minNum=1.5; maxNum=2.5; meanNum=2;

%% general stimlus variables
dur=.5; Fs=44100; triallength=2; nbblocks=14; silence=0.03;

% Define Stimulus repetitions
catchtrials=50; audtrials=20; vistrials=20; mstrials=20;
buffersize=(dur+silence)*Fs;

%visual coherence levels
viscoh1=.05; viscoh2=.15; viscoh3=.25; viscoh4=.35; viscoh5=.45;
%auditory coherence levels
audcoh1=0.1; audcoh2=0.25; audcoh3=0.35; audcoh4=0.45; audcoh5=0.55;
% visual stimulus properties
maxdotsframe=150; 
%monWidth=53; %Antonia's original default
monWidth=42.5; 
viewDist =120; cWhite0=255;

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
filename = strcat('RDKHoop_psyAV',underscore,subjnum_s,underscore,group_s, underscore, sex_s, underscore, age_s);

cd(localdirectory)
save(filename,'filename')
cd(scriptdirectory)

%% make design Matrix
rng('shuffle')
% generate number of trials and different combinations of trials for experiment 
MAT=at_RDKHoopMatrix_psyAV(catchtrials, vistrials, audtrials, mstrials);
save('MAT.mat', 'MAT');
% reload=load('MAT.mat');
% MAT=reload.MAT;

%% Initialize
curScreen=2;
%Screen('Preference', 'SkipSyncTests', 0);
Screen('Preference', 'SkipSyncTests', 1);

screenInfo = openExperiment(monWidth, viewDist, curScreen);
curWindow= screenInfo.curWindow;
screenRect= screenInfo.screenRect;
% Enable alpha blending with proper blend-function. We need it for drawing
% of smoothed points.
Screen('BlendFunction', curWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

%% Initialize Audio (AT)
InitializePsychSound;
pahandle = PsychPortAudio('Open', 4, [], 0, Fs, 2);
%% Welcome and Instrctions for the Suject
instructions_psyAV(curWindow, cWhite0);
%% Flip up fixation dot
fix=[screenRect(3)/2,screenRect(4)/2]; %define fix position of fix dot
Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], fix, 1);
Screen('Flip', curWindow,0);
s.NotifyWhenScansQueuedBelow = 22050;
WaitSecs(2); %wait for 2s

%% trial generation
for ii=1:length(MAT)

    tt=[length(MAT)/nbblocks: length(MAT)/nbblocks : length(MAT)-length(MAT)/nbblocks];
    if ismember(ii, tt) == 1
        takebreak(curWindow, cWhite0);
        Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], fix, 1);
        Screen('Flip', curWindow,0);
        WaitSecs(2)
    end
    
    %% generate stimulus parameters for the current trial
    % 1=rightwardmotion;
    % 2=leftwardmotion
    currvisdir=MAT(ii,3);
    if currvisdir == 1
        currvisdir=0; %RIGHTward
    elseif currvisdir == 2
        currvisdir=180; %LEFTward
    end
    
    currviscoh=MAT(ii,4);
    if currviscoh == 1
        currviscoh=viscoh1;
    elseif currviscoh == 2
        currviscoh=viscoh2;
    elseif currviscoh == 3
        currviscoh=viscoh3;
    elseif currviscoh == 4
        currviscoh=viscoh4;
    elseif currviscoh == 5
        currviscoh=viscoh5;
    end
    
    currauddir=MAT(ii,1);
    if currauddir == 0
        currauddir=randi(2);
    end
    
    curraudcoh=MAT(ii,2);
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
    
    %create info matrix from Visual Stim
    dotInfo = at_createDotInfo(inputtype, currviscoh, currvisdir, typeInt, minNum, maxNum, meanNum, maxdotsframe, dur);
    spf =screenInfo.frameDur; % second per frame
    center=screenInfo.center; %center of the screen
    ppd=screenInfo.ppd; %pixels per degree of visual angle; right now set to 10�/sec
    speed=dotInfo.speed; %speed of dots in �/sec
    dotSize=dotInfo.dotSize; %dot size in pixels
    apD = dotInfo.apXYD(3); %aperture of stimulus in � of visual angle*10; right now set to 5�
   
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
    auddir_id = num2str(MAT(ii,1));
    audcoh_id = num2str(MAT(ii,2));
    visdir_id = num2str(MAT(ii,3));
    viscoh_id = num2str(MAT(ii,4));
    markers = strcat([auddir_id audcoh_id visdir_id viscoh_id]); %unique identifier for LSL

    
    %% at_dotgen content
    Screen('Flip',curWindow,0);
    outlet.push_sample({markers})
    monRefresh = 1/spf; % frames per second
    
    % Everything is initially in coordinates of visual degrees, convert to pixels
    % (pix/screen) * (screen/rad) * rad/deg
    ppd = pi * screenRect(3) / atan(monWidth/viewDist/2)  / 360;
    d_ppd = floor(apD/10 * ppd);
    
    % ndots is the number of dots shown per video frame. Dots are placed in a
    % square of the size of the aperture.
    %   Size of aperture = Apd*Apd/100  sq deg
    %   Number of dots per video frame = 16.7 dots per sq.deg/sec,
    % When rounding up, do not exceed the number of dots that can be plotted in
    % a video frame.
    ndots = min(maxdotsframe, ceil(16.7 * apD .* apD * 0.01 / monRefresh));
    
    % dxdy is an N x 2 matrix that gives jumpsize in units on 0..1
    %   deg/sec * Ap-unit/deg * sec/jump = unit/jump
    dxdy = repmat(speed * 10/apD * (3/monRefresh) ...
        * [cos(pi*currvisdir/180.0) -sin(pi*currvisdir/180.0)], ndots,1);
    
    % ARRAYS, INDICES for loop
    ss = rand(ndots*3, 2); % array of dot positions raw [xposition, yposition]
    
    % Divide dots into three sets
    Ls = cumsum(ones(ndots,3)) + repmat([0 ndots ndots*2], ndots, 1);
    loopi = 1; % Loops through the three sets of dots
    
    priorityLevel = MaxPriority(curWindow,'KbCheck'); %make sure Window commands are correct
    Priority(priorityLevel);
    
    % THE MAIN LOOP
    frames = 0;
    CAM=makeCAM(cLvl, currauddir, dur, silence, Fs);
    
    %% Audio wav file (AT)
%     audiowrite('CAM.wav',CAM,Fs)
%     [y, freq] = psychwavread('CAM.wav');
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
        
        % Get ss & xs from the big matrices. xs and ss are matrices that have
        % stuff for dots from the last 2 positions + current.
        % Ls picks out the previous set (1:5, 6:10, or 11:15)
        Lthis  = Ls(:,loopi); % Lthis picks out the loop from 3 times ago, which
        % is what is then moved in the current loop
        this_s = ss(Lthis,:);  % this is a matrix of random #s - starting positions
        
        % 1 group of dots are shown in the first frame, a second group are shown
        % in the second frame, a third group shown in the third frame. Then in
        % the next frame, some percentage of the dots from the first frame are
        % replotted according to the speed/direction and coherence, the next
        % frame the same is done for the second group, etc.
        % Update the loop pointer
        loopi = loopi+1;
        
        if loopi == 4
            loopi = 1;
        end
        
        % Compute new locations
        % L are the dots that will be moved
        L = rand(ndots,1) < currviscoh;
        this_s(L,:) = this_s(L,:) + dxdy(L,:);    % Offset the selected dots
        
        if sum(~L) > 0  % if not 100% coherence
            this_s(~L,:) = rand(sum(~L),2);    % get new random locations for the rest
        end
        
        % Wrap around - check to see if any positions are greater than one or
        % less than zero which is out of the aperture, and then replace with a
        % dot along one of the edges opposite from direction of motion.
        
        N = sum((this_s > 1 | this_s < 0)')' ~= 0;
        if sum(N) > 0
            xdir = sin(pi*currvisdir/180.0);
            ydir = cos(pi*currvisdir/180.0);
            % Flip a weighted coin to see which edge to put the replaced dots
            if rand < abs(xdir)/(abs(xdir) + abs(ydir))
                this_s(find(N==1),:) = [rand(sum(N),1) (xdir > 0)*ones(sum(N),1)];
            else
                this_s(find(N==1),:) = [(ydir < 0)*ones(sum(N),1) rand(sum(N),1)];
            end
        end
        
        % Convert to stuff we can actually plot
        this_x(:,1:2) = floor(d_ppd(1) * this_s); % pix/ApUnit
        
        % This assumes that zero is at the top left, but we want it to be in the
        % center, so shift the dots up and left, which just means adding half of
        % the aperture size to both the x and y direction.
        dot_show = (this_x(:,1:2) - d_ppd/2)';
        
        % After all computations, flip
        Screen('Flip', curWindow,0);
        % Now do next drawing commands
        Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], fix, 1);
        Screen('DrawDots', curWindow, dot_show, dotSize, [255 255 255], center);
        % Presentation
        Screen('DrawingFinished',curWindow);
        frames = frames + 1;
        
        %% get RTs
        if frames == 1
            start_time = GetSecs;
            
            %% Playing audio (AT)
            PsychPortAudio('FillBuffer', pahandle, wavedata');
	        PsychPortAudio('Start', pahandle, 1);
%             queueOutputData(s,CAM);
%             lh = addlistener(s,'DataRequired', ...
%                 @(src,event) src.queueOutputData(CAM));
%             startBackground(s);
        end
        % Update the arrays so xor works next time
        xs(Lthis, :) = this_x;
        ss(Lthis, :) = this_s;
        
        % Check for end of loop
        continue_show = continue_show - 1;
    end
    % Present last dots
    if ~responded %if no response
        [key,secs,keycode] = KbCheck; %look for a key
        WaitSecs(0.0002); %tiny wait
        if key %if there was a key
            %                     resp = str2double(char(KbName(keycode))); %find response key
            resp = find(keycode,1,'last');
            rt = GetSecs - start_time; %calculate rt from start time earlier
            responded = 1; %note that there was a response
        end
    end
    Screen('Flip', curWindow,0);
    if ~responded %if no response
        [key,secs,keycode] = KbCheck; %look for a key
        WaitSecs(0.0002); %tiny wait
        if key %if there was a key
            %                     resp = str2double(char(KbName(keycode))); %find response key
            resp = find(keycode,1,'last');
            rt = GetSecs - start_time; %calculate rt from start time earlier
            responded = 1; %note that there was a response
        end
    end
    
    % Erase last dots & go back to only plotting fixation
    Screen('DrawingFinished',curWindow);
    Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], fix, 1);
    Screen('Flip', curWindow,0);
    
    %%  ITI & response recording
    interval=makeInterval(typeInt,minNum,maxNum,meanNum);
    interval=interval+dur;
    %DS loop until interval is over
    %while KbCheck; end %hold if key is held down
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
        MAT(ii, 5)=1;
    elseif resp == 37
        MAT(ii, 5)=2;
    else
        MAT(ii, 5)= nan;
    end
    MAT(ii, 6)=rt;
    MAT(ii,7)=char(resp);
    if data(ii, 5) == data_output(ii, 1) && data(ii, 5) == data_output(ii, 3)
        trial_status = 1;
        data_output(ii, 6) = trial_status;
    else 
        trial_status = 0;
        data_output(ii, 6) = trial_status;
    end
end

cd(localdirectory)
save([data_directory filename], 'MAT');

%% Goodbye
cont(curWindow, cWhite0);

%% Finalize
closeExperiment;
close all
Screen('CloseAll')
%% HUMAN AUDIOVISUAL MOTION DISCRIMINATION TASK CODE %%%%%%%%%%
% Wallace Multisensory Lab - Vanderbilt University
% written by Adam Tiesman - adam.j.tiesman@vanderbilt.edu
% Initial commit on 2/27/23
clear;
close all;
clc;

%% FOR RESPONSE CODING: 1= RIGHTWARD MOTION ; 2=LEFTWARD MOTION
right_var = 1; left_var = 2; catch_var = 0;

%% Specify parameters of the block
disp('This is the main script for the AUDIOVISUAL motion discrimination task.')
task_nature = input('Staircase = 1;  Method of constant stimuli (MCS) = 2 : ');
if task_nature == 1
    staircase_nature = input('Coherence only staircase = 1; Velocity only staircase = 2; Coherence and velocity staircase = 3 : ');
    if staircase_nature == 2 || staircase_nature == 3
        vel_stair = 1;
    elseif staircase_nature == 1
        vel_stair = 0;
    end
else 
    % Set these parameters to 0 so staircase_procedure function knows not to
    % manipulate velocity.
    vel_stair = 0;
end
if task_nature == 2
    disp('How do you want to match the visual and auditory stimuli?')
    stim_matching_nature = input('1 = Staircase Coherence Calc, 2 = Participant Slider Response : ');
else
    stim_matching_nature = 0;
end
training_nature = input('Trial by trial feedback? 0 = NO; 1 = YES : ');
aperture_nature = input('Do you want to change the aperture size? 0 = NO; 1 = YES : ');
if aperture_nature ~= 1
    % Original aperture size, in tens of visual degrees (i.e. 50 is 5 degrees)
    aperture_size = 50;
end
noise_jitter_nature = input('Do you want noise before and after stimulus? 0 = NO; 1 = YES : ');
EEG_nature = input('EEG recording? 0 = NO; 1 = YES : ');
if EEG_nature == 1
    addpath('/add/path/to/liblsl-Matlab-master/');
    addpath('/also/add/path/to/liblsl-Matlab-master/bin/');
    [lib, info, outlet] = initialize_lsl;
else
    outlet = NaN;
end
if vel_stair ~= 1
    % Specify the dot speed in the RDK, wil be an input to function
    % at_createDotInfo
    block_dot_speed = input('Dot Speed (in deg/sec): ');
    visInfo.vel = block_dot_speed;
end
% Specify if you want data analysis
data_analysis = input('Data Analysis? 0 = NO, 1 = YES : ');

%% Auditory stimulus properties
% dB SNR 
dB_noise_reduction = input('Enter dB noise reduction: '); % how much less sound intensity (dB) you want from the noise compared to the signal
% Convert dB noise reduction to a scalar for CAM --> dB = 20log(CAM)
noise_reduction_scalar = 10^(-(dB_noise_reduction)/20);
if vel_stair ~= 1
    % Auditory velocity
    aud_vel = input('Enter auditory velocity (if 0, will use original 58.8 deg/sec): ');
end

%% Directories created to navigate code folders throughout script
script_directory = '/home/wallace/Human_AV_Motion/';
data_directory = '/home/wallace/Human_AV_Motion/data/';
analysis_directory = '/home/wallace/Human_AV_Motion/Psychometric_Function_Plot/';
if EEG_nature == 1
    lsl_directory = '/home/wallace/Human_AV_Motion/EEG/';
end
cd(script_directory)

%% General variables to smoothly run PTB
% Necessary for psychtoolbox to read keyboard inputs. UnifyKeyNames allows
% for portability of script. 
KbName('UnifyKeyNames');
AssertOpenGL; 
% Assigned keyboard variables in Linux for left arrow, right arrow, and space keys and extended
% keyboard device. Change depending on what you are using to have
% participants report direction.
right_keypress = [115 13];
left_keypress = [114 12];
space_keypress = [66 14]; % used for the slider

%% Define general values how long recording iTis for, might have been poisson distribution
% inputtype, typeInt, minNum, maxNum, and meanNum all deal with the intertrial interval, which
% is generated in the function iti_response_recording. menaNum is the mean
% time in sec that the iti will be. mMn and max time for iti defined by minNum
% and maxNum respectively.
inputtype = 1; typeInt = 1; minNum = 1.5; maxNum = 2.5; meanNum = 2;
if noise_jitter_nature == 1
    minJitter = 0.04; maxJitter = 0.08; meanJitter = 0.06;
end
%% General stimulus variables
% dur is stimulus duration, triallength is total length of 1 trial (this is
% currently unused in code), Fs is sampling rate, nbblocks is used to divide up num_trials 
% into equal parts to give subject breaks if there are many trials. 
% Set to 0 if num_trials is short and subject does not need break(s).
dur = 0.5; Fs = 44100; triallength = 2; nbblocks = 0; 

% Define buffersize in order to make CAM (auditory stimulus)
silence = 0.03; buffersize = (dur+silence)*Fs;

% All variables that define stimulus repetitions; num_trials defines total
% number of staircase trials, stimtrials defines number of stimulus trials
% per condition for MCS, catchtrials defines total number of catch trials
% for MCS.
num_trials = 100; stimtrials = 12; catchtrials = 25;
congruent_mstrials=18; incongruent_mstrials=2;

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

%% Collect subject information
% Manually set block depending on what task code this is. Function
% collect_subject_information then prompts you to fill in numbers for
% subject that will allow you to uniquely identify subjects. Variable
% filename will be also used as the save_name, so be sure to remember in
% order to access later.
if task_nature == 1
    block = 'RDKHoop_stairAV';
elseif task_nature == 2
    block = 'RDKHoop_psyAV';
else
    error('Need to specify what block task falls under.')
end

[filename, subjnum_s, group_s, sex_s, age_s] = collect_subject_information(block);

%% Coherence and trial matrix generation for Staircase and MCS
if task_nature == 1
    if vel_stair == 1
        data_output = zeros(num_trials, 9);
    else
        % Initialize matrix to store data. Data is recorded every trial using
        % function record_data
        data_output = zeros(num_trials, 8);
    end
    
    % Generate the list of possible coherences by decreasing log values
    stimInfo.cohStart = 0.5;
    stimInfo.nlog_coh_  steps = 12;
    stimInfo.nlog_division = sqrt(2);
    stimInfo = cohSet_generation(stimInfo, block);
    
    if vel_stair == 1
        % Generate list of velocities and durations if the given velocity were to
        % travel from speaker to speaker
        stimInfo.velStart = 55;
        stimInfo.vel_steps = 11;
        stimInfo.vel_subtract = 5;
        stimInfo = velSet_generation(stimInfo, block, dur);
    end
    
    % Prob 1 = chance of coherence lowering after correct response
    % Prob 2 = chance of direction changing after correct response
    % Prob 3 = chance of coherence raising after incorrect response
    % Prob 4 = chance of direction changing after incorrect response
    % Prob 5 = chance of velocity raising after correct response
    % Prob 6 = chance of velocity lowering after incorrect response
    if staircase_nature == 2 % velocity ONLY staircase
        stimInfo.probs = [0 0.5 0 0.5 0.33 0.66];
    elseif staircase_nature == 3 % coherence and velocity staircase
        stimInfo.probs = [0.1 0.5 0.9 0.5 0.33 0.66];
    else % coherence ONLY staircase
        stimInfo.probs = [0.33 0.5 0.66 0.5 0 0];
    end
elseif task_nature == 2
    if stim_matching_nature == 1
        % Create coherences for participant if method of constant stimuli is to be
        % used. Coherences genereated via the same participant's staircase
        % performance. Matrix generation is randomized and determined by the number
        % of stimtrials per condition and number of catchtrials.
        % Load the visual staircase data
        stairAud_filename = sprintf('RDKHoop_stairAud_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
        stairVis_filename = sprintf('RDKHoop_stairVis_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
        try
            % Load the staircase data from same participant to generate
            % coherences
            cd(data_directory)
            load(horzcat(data_directory, stairAud_filename), 'data_output');
            cd(script_directory)
    
            % Generate stimulus coherence levels based on staircase, manipulate stim coherences
            % generated by coherence_calc by changing variables in the function
            [audInfo] = coherence_calc(data_output);
    
            clear("data_output")

            % Load the staircase data from same participant to generate
            % coherences
            cd(data_directory)
            load(horzcat(data_directory, stairVis_filename), 'data_output');
            cd(script_directory)
    
            % Generate stimulus coherence levels based on staircase, manipulate stim coherences
            % generated by coherence_calc by changing variables in the function
            [visInfo] = coherence_calc(data_output);
    
            clear("data_output")

        catch
            warning('Problem finding staircase data for participant. Assigning general coherences for MCS.');
            cd(script_directory)
            % Generate the list of possible coherences by decreasing log values
            stimInfo.cohStart = 0.5;
            nlog_coh_steps = 7;
            nlog_division = sqrt(2);
            visInfo = cohSet_generation(stimInfo, nlog_coh_steps, nlog_division);
            audInfo.cohSet = visInfo.cohSet;
        end
    
        % Create trial matrix
        rng('shuffle')
        data_output = at_generateMatrix(catchtrials, stimtrials, visInfo, right_var, left_var, catch_var);
    end
else
    error('Could not generate coherences. Task nature determines how coherences are generated.')
end

if nbblocks > 0
    [tt] = breaktime_var(data_output, nbblocks);
end

%% Generating coherences from staircase data
% Define coherence calculations from staircase
nlog_division = sqrt(2);

% Load the auditory staircase data
stairAud_filename = sprintf('RDKHoop_stairAud_%s_%s_%s_%s.mat',subjnum_s, group_s, sex_s, age_s);
load(horzcat(data_directory, stairAud_filename), 'data_output');

% Generate auditory coherence levels based on staircase, manipulate aud coherences
% generated by coherence_calc by changing variables in the function
[audInfo] = coherence_calc(data_output);

% Load the visual staircase data
stairVis_filename = sprintf('RDKHoop_stairVis_%s_%s_%s_%s.mat',subjnum_s, group_s, sex_s, age_s);
load(horzcat(data_directory, stairVis_filename), 'data_output');

% Generate auditory coherence levels based on staircase, manipulate vis coherences
% generated by coherence_calc by changing variables in the function
[visInfo] = coherence_calc(data_output);

% save coherence set
audcoh_file = strcat('audInfo.cohSet',underscore,subjnum_s,underscore,group_s, underscore, sex_s, underscore, age_s);
viscoh_file = strcat('visInfo.cohSet',underscore,subjnum_s,underscore,group_s, underscore, sex_s, underscore, age_s);

cd(data_directory)
save(audcoh_file, 'audInfo')
save(viscoh_file, 'visInfo')

%auditory coherence levels
audcoh1 = audInfo.cohSet(7); 
audcoh2 = audInfo.cohSet(6); 
audcoh3 = audInfo.cohSet(5); 
audcoh4 = audInfo.cohSet(4); 
audcoh5 = audInfo.cohSet(3); 
audcoh6 = audInfo.cohSet(2); 
audcoh7 = audInfo.cohSet(1);

%visual coherence levels
viscoh1 = visInfo.cohSet(7); 
viscoh2 = visInfo.cohSet(6); 
viscoh3 = visInfo.cohSet(5); 
viscoh4 = visInfo.cohSet(4); 
viscoh5 = visInfo.cohSet(3); 
viscoh6 = visInfo.cohSet(2); 
viscoh7 = visInfo.cohSet(1);

cd(scriptdirectory)
%% make design Matrix
rng('shuffle')
% generate number of trials and different combinations of trials for experiment 
data_output = at_generateMatrixAV(catchtrials, congruent_mstrials, incongruent_mstrials, audInfo, visInfo, right_var, left_var, catch_var);

%% Initialize
curScreen=0;
Screen('Preference', 'SkipSyncTests', 0);
screenInfo = openExperiment(monWidth, viewDist, curScreen);
curWindow= screenInfo.curWindow;
screenRect= screenInfo.screenRect;
% Enable alpha blending with proper blend-function. We need it for drawing
% of smoothed points.
Screen('BlendFunction', curWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

%% Initialize Audio (AT)
PsychPortAudio('Close')
InitializePsychSound;
pahandle = PsychPortAudio('Open', 5, [], 0, Fs, 2);

%% Welcome and Instrctions for the Suject
instructions_psyAV(curWindow, cWhite0);

%% Flip up fixation dot
fix=[screenRect(3)/2,screenRect(4)/2]; %define fix position of fix dot
Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], fix, 1);
Screen('Flip', curWindow,0);
s.NotifyWhenScansQueuedBelow = 22050;
WaitSecs(2); %wait for 2s

%% trial generation
for ii=1:length(data_output)

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
        currvisdir=0; % RIGHTward
    elseif currvisdir == 2
        currvisdir=180; % LEFTward
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
    elseif currviscoh == 6
        currviscoh=viscoh6;
    elseif currviscoh == 7
        currviscoh=viscoh7;
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
    elseif curraudcoh == 6
        curraudcoh=audcoh6;
    elseif curraudcoh == 7
        curraudcoh=audcoh7;
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
%     outlet.push_sample({markers})
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
    CAM=makeCAM_PILOT(cLvl, currauddir, dur, silence, Fs, noise_reduction_scalar);
    
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
    if resp == 13
        MAT(ii, 5)=1;
    elseif resp == 12
        MAT(ii, 5)=2;
    else
        MAT(ii, 5)= nan;
    end
    MAT(ii, 6)=rt;
    MAT(ii,7)=char(resp);
    if MAT(ii, 5) == MAT(ii, 1) && MAT(ii, 5) == MAT(ii, 3)
        trial_status = 1;
        MAT(ii, 8) = trial_status;
    else 
        trial_status = 0;
        MAT(ii, 8) = trial_status;
    end
end

cd(localdirectory)
save([data_directory filename], 'MAT');
audcoh_list = [audcoh7 audcoh6 audcoh5 audcoh4 audcoh3 audcoh2 audcoh1];
viscoh_list = [viscoh7 viscoh6 viscoh5 viscoh4 viscoh3 viscoh2 viscoh1];
save(filename, 'MAT', 'audcoh_list', 'viscoh_list')

%% Goodbye
cont(curWindow, cWhite0);

%% Finalize
closeExperiment;
close all
Screen('CloseAll')
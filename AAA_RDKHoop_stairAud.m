%% AUDITORY STAIRCASE %%%%%%%%%%
% written by Adam Tiesman - adam.j.tiesman@vanderbilt.edu
% Initial commit on 2/27/2023
clear;
close all;

%% FOR RESPONSE CODING: 1= RIGHTWARD MOTION ; 2=LEFTWARD MOTION
% %% define general variables
% % directories used throughout the experment
scriptdirectory = '/home/wallace/Human_AV_Motion/';
data_directory = '/home/wallace/Human_AV_Motion/data/';
analysis_directory = '/home/wallace/Human_AV_Motion/Psychometric_Function_Plot/';
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

% Specify if you want data analysis
data_analysis = input('Data Analysis? 0 = NO, 1 = YES : ');

% auditory stimulus properties
dB_noise_reduction = input('Enter dB noise reduction: '); % how much less sound intensity (dB) you want from the noise compared to the signal

% convert dB noise reduction to a scalar for CAM --> dB = 20log(CAM)
noise_reduction_scalar = 10^(-(dB_noise_reduction)/20);

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

cd(datadirectory)
save(filename,'filename')
cd(scriptdirectory)

%% Initialize
curScreen=0;
Screen('Preference', 'SkipSyncTests', 1);
screenInfo = openExperiment(monWidth, viewDist, curScreen);
curWindow= screenInfo.curWindow;
screenRect= screenInfo.screenRect;
% Enable alpha blending with proper blend-function. We need it for drawing
% of smoothed points.

%% Initialize Audio
PsychPortAudio('Close')
Screen('BlendFunction', curWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
InitializePsychSound;
pahandle = PsychPortAudio('Open', 5, [], 0, Fs, 2);

%% Welcome and Instrctions for the Suject
instructions_psyAud(curWindow, cWhite0);

%% Flip up fixation dot
fix=[screenRect(3)/2,screenRect(4)/2]; %define fix position of fix dot
Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], fix, 1);
Screen('Flip', curWindow,0);
s.NotifyWhenScansQueuedBelow = 22050;
WaitSecs(2); %wait for 2s

% Generate the list of possible coherences by decreasing log values
audInfo.cohStart = 0.5;
nlog_coh_steps = 19;
nlog_division = sqrt(2);  
audInfo.cohSet = [audInfo.cohStart];
for i = 1:nlog_coh_steps
    if i == 1
        nlog_value = audInfo.cohStart;
    end
    nlog_value = nlog_value/nlog_division;
    audInfo.cohSet = [audInfo.cohSet nlog_value];
end

% Prob 1 = chance of coherence lowering after correct response
% Prob 2 = chance of direction changing after correct response
% Prob 3 = chance of coherence raising after incorrect response
% Prob 4 = chance of direction changing after incorrect response
 audInfo.probs = [0.33 0.5 0.66 0.5];

%% Experiment Loop
for ii=1:num_trials
    
    if ii == 1 
        staircase_index = 1; % Start staircase on coherence of 1
        audInfo.dir = randi([1,2]);
        audInfo.coh = audInfo.cohSet(staircase_index);
    elseif ii > 1
        [audInfo, staircase_index] = staircase_procedure(trial_status, audInfo, staircase_index);
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
    CAM=makeCAM_PILOT(audInfo.coh, audInfo.dir, dur, silence, Fs, noise_reduction_scalar);
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
    if resp == 115 || resp == 13
        data_output(ii, 3)=1;
    elseif resp == 114 || resp == 12
        data_output(ii, 3)=2;
    else
        data_output(ii, 3)= nan;
    end
    data_output(ii, 4)=rt;
    data_output(ii,5)=char(resp);
    if data_output(ii, 3) == data_output(ii, 1)% If response is the same as direction, Correct Trial
        trial_status = 1;
        data_output(ii, 6) = trial_status;
    else 
        trial_status = 0;
        data_output(ii, 6) = trial_status;
    end

end



cd(data_directory)
save(filename, 'data_output');

cd(scriptdirectory)
%% Goodbye
cont(curWindow, cWhite0);

%% Finalize
closeExperiment;
close all
Screen('CloseAll');
PsychPortAudio('Close', pahandle);

%% Data Analysis

if data_analysis == 1
    % Provide specific variables 
    chosen_threshold = 0.72;
    right_var = 1;
    left_var = 2;
    catch_var = 0;
    save_name = filename;

    cd(analysis_directory)

    %% Split the data by direction of motion for the trial
    [right_vs_left, right_group, left_group] = direction_plotter(data_output);
    
    %% Loop over each coherence level and extract the corresponding rows of the matrix for leftward, catch, and rightward trials
    rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
    
    %% Create frequency count for each coherence level
    [total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, coherence_counts, coherence_frequency] = frequency_plotter(data_output, right_vs_left);
    
    %% Create a graph of percent correct at each coherence level
    accuracy = accuracy_plotter(right_vs_left, right_group, left_group, save_name);
    
    %% Create a Normal Cumulative Distribution Function (NormCDF)
%     CDF = normCDF_plotter(coherence_lvls, rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, coherence_frequency, save_name);
    
    %% Create a stairstep graph for visualizing staircase
    stairstep = stairstep_plotter(data_output, save_name);
end

cd(data_directory)
save(filename)


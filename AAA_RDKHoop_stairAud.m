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

%% General variables to smoothly run PTB
% Necessary for psychtoolbox to read keyboard inputs.
KbName('UnifyKeyNames');
AssertOpenGL; % was not in Aud stim code before

%% define general values how long recording iTis for, might have been poisson distribution
% minNum, maxNum, and meanNum all deal with the intertrial interval, which
% is generated in the function iti_response_recording.
inputtype=1; typeInt=1; minNum=1.5; maxNum=2.5; meanNum=2;

% Set these parameters to 0 so staircase_procedure function knows not to
% manipulate velocity.
vel_stair = 0; vel_index = 0;

%% General stimlus variables
% dur is stimulus duration, triallength is total length of 1 trial (this is
% currently unused in code), nbblocks is used to divide up num_trials 
% into equal parts to give subject breaks if there are many trials. 
% Set to 0 if num_trials is short and subject does not need break(s).
dur = 0.5; Fs = 44100; triallength = 2; nbblocks = 2; 

% Define buffersize in order to make CAM (auditory stimulus)
silence=0.03; buffersize=(dur+silence)*Fs; s.Rate=44100; 

% Define stimulus repetitions
num_trials = 100;

% Visual stimulus properties relating to monitor (measure yourself),
% maxdotsframe is for RDK and is a limitation of your graphics card. The
% only way you can know its limit is by trial and error. Variables monWidth
% and viewDist are measured in centimeters.
maxdotsframe = 150; monWidth = 50.8; viewDist = 120;

% General drawing color used for RDK, instructions, etc.
cWhite0 = 255;

% Specify if you want data analysis
data_analysis = input('Data Analysis? 0 = NO, 1 = YES : ');

% auditory stimulus properties
dB_noise_reduction = input('Enter dB noise reduction: '); % how much less sound intensity (dB) you want from the noise compared to the signal

% convert dB noise reduction to a scalar for CAM --> dB = 20log(CAM)
noise_reduction_scalar = 10^(-(dB_noise_reduction)/20);

%% Collect subject information
% Manually set block depending on what task code this is. Function
% collect_subject_information then prompts you to fill in numbers for
% subject that will allow you to uniquely identify subjects. Variable
% filename will be also used as the save_name, so be sure to remember in
% order to access later.
block = 'RDKHoop_stairVis';
filename = collect_subject_information(block);

%% Initialize
% curScreen = 0 if there is only one monitor. If more than one monitor, 
% check display settings on PC. curScreen will probably equal 1 or 2 
% (e.g. monitor for stimulus presentation and monitor to run MATLAB code).
curScreen=0;

% Opens psychtoolbox and initializes experiment
[screenInfo, curWindow, screenRect] = initialize_exp(monWidth, viewDist, curScreen);

%% Initialize Audio
[pahandle] = initialize_aud(curWindow, Fs);

%% Welcome and Instrctions for the Suject
instructions_psyAud(curWindow, cWhite0);

%% Flip up fixation dot
[fix, s] = fixation_dot_flip(screenRect,curWindow);

% Initialize matrix to store data. Data is recorded every trial using
% function record_data
data_output = zeros(num_trials, 6);

% Generate the list of possible coherences by decreasing log values
audInfo.cohStart = 0.5;
nlog_coh_steps = 12;
nlog_division = sqrt(2);
audInfo = cohSet_generation(audInfo, nlog_coh_steps, nlog_division);

% Prob 1 = chance of coherence lowering after correct response
% Prob 2 = chance of direction changing after correct response
% Prob 3 = chance of coherence raising after incorrect response
% Prob 4 = chance of direction changing after incorrect response
 audInfo.probs = [0.33 0.5 0.66 0.5];

%% Experiment Loop
% Loop through every trial.
for ii = 1:num_trials
    
    if ii == 1 % the first trial in the staircase
        staircase_index = 1;
        % Start staircase on random direction (left or right)
        audInfo.dir = randi([1,2]);
        % Start staircase on first coherence in cohSet
        audInfo.coh = audInfo.cohSet(staircase_index);
    elseif ii > 1 % every trial in staircase except for first trial
        % Function staircase_procedure takes the previous trial's accuracy
        % (incorr or corr) and uses a random number (0 to 1) to determine the
        % coherence and direction for the current trial. All based on
        % probabilities, which change depending on if the previous trials
        % was correct or incorrect.t
        [audInfo, staircase_index] = staircase_procedure(trial_status, audInfo, staircase_index, vel_stair, vel_index);
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
    CAM = makeCAM_PILOT(audInfo.coh, audInfo.dir, dur, silence, Fs, noise_reduction_scalar);
    wavedata = CAM;
    nrchannels = size(wavedata,1); % Number of rows = number of channels.
        
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


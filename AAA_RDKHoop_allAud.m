%% HUMAN AUDITORY MOTION DISCRIMINATION TASK CODE %%%%%%%%%%%%%
% Wallace Multisensory Lab - Vanderbilt University
% written by Adam Tiesman - adam.j.tiesman@vanderbilt.edu
% Initial commit on 2/27/2023
clear;
close all;
clc;

%% FOR RESPONSE CODING: 1 = RIGHTWARD MOTION; 2 = LEFTWARD MOTION
right_var = 1; left_var = 2; catch_var = 0; dur = 0.5; silence = 0.03; Fs = 44100;

%% Specify parameters of the block
disp('This is the main script for the AUDITORY ONLY motion discrimination task.')
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
disp('How do you want to match the visual and auditory stimuli?')
stim_matching_nature = input('1 = Staircase Coherence Calc, 2 = Participant Slider Response');
training_nature = input('Trial by trial feedback? 0 = NO; 1 = YES : ');
if training_nature == 1
    % Training sound properties
    correct_freq = 2000;
    incorrect_freq = 800;
    [corr_soundout, incorr_soundout] = at_generateBeep(correct_freq, incorrect_freq, dur, silence, Fs);
end
EEG_nature = input('EEG recording? 0 = NO; 1 = YES :');
if EEG_nature == 1
    addpath('/add/path/to/liblsl-Matlab-master/');
    addpath('/also/add/path/to/liblsl-Matlab-master/bin/');
    [lib, info, outlet] = initialize_lsl;
end
% Auditory stimulus properties
dB_noise_reduction = input('Enter dB noise reduction: '); % how much less sound intensity (dB) you want from the noise compared to the signal
% Convert dB noise reduction to a scalar for CAM --> dB = 20log(CAM)
noise_reduction_scalar = 10^(-(dB_noise_reduction)/20);
% Specify if you want data analysis
data_analysis = input('Data Analysis? 0 = NO, 1 = YES : ');

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
AssertOpenGL; % was not in Aud stim code before
% Assigned keyboard variables in Linux for left and right arrow keys and extended
% keyboard device. Change depending on what you are using to have
% participants report direction.
right_keypress = [115 13];
left_keypress = [114 12];

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
% Set to 0 if num_trials is short and subject does not need break(s).
dur = 0.5; Fs = 44100; triallength = 2; nbblocks = 0; 

% Define buffersize in order to make CAM (auditory stimulus)
silence = 0.03; buffersize = (dur+silence)*Fs;

% All variables that define stimulus repetitions; num_trials defines total
% number of staircase trials, stimtrials defines number of stimulus trials
% per condition for MCS, catchtrials defines total number of catch trials
% for MCS.
num_trials = 250; stimtrials = 12; catchtrials = 25;

% Visual stimulus properties relating to monitor (measure yourself),
% maxdotsframe is for RDK and is a limitation of your graphics card. The
% only way you can know its limit is by trial and error. Variables monWidth
% and viewDist are measured in centimeters.
maxdotsframe = 150; monWidth = 50.8; viewDist = 120;

% General drawing color used for RDK, instructions, etc.
cWhite0 = 255;

%% Collect subject information
% Manually set block depending on what task code this is. Function
% collect_subject_information then prompts you to fill in numbers for
% subject that will allow you to uniquely identify subjects. Variable
% filename will be also used as the save_name, so be sure to remember in
% order to access later.
if task_nature == 1
    block = 'RDKHoop_stairAud';
elseif task_nature == 2
    block = 'RDKHoop_psyAud';
else
    error('Need to specify what block task falls under.')
end

[filename, subjnum_s, group_s, sex_s, age_s] = collect_subject_information(block);

%% Coherence and trial matrix generation for Staircase and MCS
if task_nature == 1
    if vel_stair == 1
        data_output = zeros(num_trials, 7);
    else
        % Initialize matrix to store data. Data is recorded every trial using
        % function record_data
        data_output = zeros(num_trials, 6);
    end
    
    % Generate the list of possible coherences by decreasing log values
    audInfo.cohStart = 0.5;
    audInfo.nlog_coh_steps = 4;
    audInfo.nlog_division = sqrt(2);
    audInfo = cohSet_generation(audInfo, block);
    
    if vel_stair == 1
        audInfo.velStart = 55;
        audInfo.vel_steps = 11;
        audInfo.vel_subtract = 5;
        % Speaker distance in degrees, based on the fact stimulus duration is 0.5 sec and speed is 58.8 deg/s
        audInfo.speaker_distance = 29.4;
        % Generate list of velocities and durations if the given velocity were to
        % travel from speaker to speaker
        [audInfo] = velSet_generation(audInfo, block);
    end

    % Prob 1 = chance of coherence lowering after correct response
    % Prob 2 = chance of direction changing after correct response
    % Prob 3 = chance of coherence raising after incorrect response
    % Prob 4 = chance of direction changing after incorrect response
    % Prob 5 = chance of velocity raising after correct response
    % Prob 6 = chance of velocity lowering after incorrect response
    if staircase_nature == 2 % velocity ONLY staircase
        audInfo.probs = [0 0.5 0 0.5 0.33 0.66];
    elseif staircase_nature == 3 % coherence and velocity staircase
        audInfo.probs = [0.1 0.5 0.9 0.5 0.33 0.66];
    else % coherence ONLY staircase
        audInfo.probs = [0.33 0.5 0.66 0.5 0 0];
    end
elseif task_nature == 2
    % Create coherences for participant if method of constant stimuli is to be
    % used. Coherences genereated via the same participant's staircase
    % performance. Matrix generation is randomized and determined by the number
    % of stimtrials per condition and number of catchtrials.
    % Load the auditory staircase data
    stairAud_filename = sprintf('RDKHoop_%s_%s_%s_%s_%s.mat', block, subjnum_s, group_s, sex_s, age_s);
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
    catch
        warning('Problem finding staircase data for participant. Assigning general coherences for MCS.')
        cd(script_directory)
        % Generate the list of possible coherences by decreasing log values
        audInfo.cohStart = 0.5;
        nlog_coh_steps = 7;
        nlog_division = sqrt(2);
        audInfo = cohSet_generation(audInfo, nlog_coh_steps, nlog_division);
    end

    % Create trial matrix
    rng('shuffle')
    data_output = at_generateMatrix(catchtrials, stimtrials, audInfo, right_var, left_var, catch_var);

    % Define duration in audInfo for makCAM function
    audInfo.durRaw = dur;
else
    error('Could not generate coherences. Task nature determines how coherences are generated')
end

if nbblocks > 0
    % Create break time variable to check when it is time to break during task
    len_data_output = size(data_output, 1);
    block_length = floor(len_data_output/nbblocks);
    tt = block_length:block_length:len_data_output;
    % Combine last two blocks if the last block length is smaller than half the
    % other block lengths
    last_block_length = len_data_output - tt(1, nbblocks);
    if last_block_length < block_length/2
        tt(1, nbblocks) = NaN;
        warning('Last block will be longer than the rest.')
    end
end

%% Initialize
% curScreen = 0 if there is only one monitor. If more than one monitor, 
% check display settings on PC. curScreen will probably equal 1 or 2 
% (e.g. monitor for stimulus presentation and monitor to run MATLAB code).
curScreen = 0;

% Opens psychtoolbox and initializes experiment
[screenInfo, curWindow, screenRect] = initialize_exp(monWidth, viewDist, curScreen);
monRefresh = 1/screenInfo.frameDur;

%% Initialize Audio
[pahandle] = initialize_aud(curWindow, Fs);

%% Welcome and Instrctions for the Suject
% Opens psychtoolbox instructions for participant for the specific task 
% (psyVis for all visual tasks, psyAud for all auditory only tasks, psyAV 
% for all audiovisual tasks). trainAud and trainVis have separate instructions.
if training_nature == 1
    instructions_trainAud(curWindow, cWhite0, pahandle, corr_soundout, incorr_soundout);
else
    instructions_psyAud(curWindow, cWhite0);
end

%% Flip up fixation dot
[fix, s] = fixation_dot_flip(screenRect, curWindow);

%% Experiment Loop
% Loop through every trial.
for ii = 1:length(data_output)

    if task_nature == 1
        if ii == 1 % the first trial in the staircase
            staircase_index = 1;
            % Start staircase on random direction (left or right)
            audInfo.dir = randi([1,2]);
            % Start staircase on first coherence in cohSet
            audInfo.coh = audInfo.cohSet(staircase_index);
            if vel_stair == 1
                vel_index = 1;
                audInfo.vel = audInfo.velSet(vel_index);
                audInfo.snip_start = audInfo.snipSet(1,vel_index);
                audInfo.snip_end = audInfo.snipSet(2,vel_index);
                audInfo.durRaw = audInfo.durSet(vel_index); 
            else
                vel_index = 0;
                audInfo.durRaw = dur;
            end
        elseif ii > 1 % every trial in staircase except for first trial
            % Function staircase_procedure takes the previous trial's accuracy
            % (incorr or corr) and uses a random number (0 to 1) to determine the
            % coherence and direction for the current trial. All based on
            % probabilities, which change depending on if the previous trials
            % was correct or incorrect.
            if vel_stair == 1
                [audInfo, staircase_index, vel_index] = staircase_procedure(trial_status, audInfo, staircase_index, vel_stair, vel_index);
                audInfo.snip_start = audInfo.snipSet(1,vel_index);
                audInfo.snip_end = audInfo.snipSet(2,vel_index);
                audInfo.durRaw = audInfo.durSet(vel_index); 
            else
                [audInfo, staircase_index] = staircase_procedure(trial_status, audInfo, staircase_index, vel_stair, vel_index);
            end
        end
    elseif task_nature == 2
        % Stimulus direction and coherence for a given trial is pre
        % determined via the output of at_generateMatrix.
        audInfo.dir = data_output(ii, 1);
        audInfo.coh = data_output(ii, 2);
    end
    
    %% Keypress input initialize variables, define frames for presentation
    while KbCheck; end
    keycorrect = 0;
    keyisdown = 0;
    responded = 0; %DS mark as no response yet
    resp = nan; %default response is nan
    rt = nan; %default rt in case no response is recorded
    continue_show = round(dur*monRefresh);
    priorityLevel = MaxPriority(curWindow, 'KbCheck'); %make sure Window commands are correct
    Priority(priorityLevel);
    
    %% Generate and present the auditory stimulus
    % Generates auditory stimulus
    frames = 0;
    % makeCAM and makeCAM_PILOT create an array voltages to be presented
    % via speakers that creates perceptual auditory motion from one speaker
    % to another
    CAM = makeCAM_PILOT(audInfo.coh, audInfo.dir, audInfo.durRaw, silence, Fs, noise_reduction_scalar);
    if vel_stair == 1
        % snipCAM snips the CAM file so the duration stays constant and the
        % displacement is changed, dependent on the velocity of the trial
        CAM = snipCAM(CAM, Fs, audInfo.snip_start, audInfo.snip_end);
    end
    wavedata = CAM;
    nrchannels = size(wavedata,1); % Number of rows = number of channels.
    
    % Create marker for EEG
    if EEG_nature == 1
        dir_id = num2str(data_output(ii,1));
        coh_id = num2str(data_output(ii,2));
        markers = strcat([dir_id coh_id]); % unique identifier for LSL
    else
        markers = NaN; % needed for function at_presentAud
        outlet = NaN;
    end

    % Presents auditory stimulus and gets reaction time. Presents stimulus 
    % for duration specified in dur, which is the length of CAM (wavedata)
    [resp, rt, start_time] = at_presentAud(continue_show, responded, resp, rt, curWindow, fix, frames, pahandle, wavedata, EEG_nature, outlet, markers);
  
    %%  ITI & response recording
    [resp, rt] = iti_response_recording(typeInt, minNum, maxNum, meanNum, dur, start_time, keyisdown, responded, resp, rt);
    
    %% Save data into data_output on a trial by trial basis
    [trial_status, data_output] = record_data(data_output, right_var, left_var, right_keypress, left_keypress, audInfo, resp, rt, ii, vel_stair);
    
    %% Present stimulus feedback if requested
    if training_nature == 1
        at_presentFeedback(trial_status, pahandle, corr_soundout, incorr_soundout);
        WaitSecs(1)
    end

    %% Check if it is break time for participant
    if nbblocks >0
        if ismember(ii, tt) == 1
            breaks = ii == tt;
            break_num = find(breaks);
            % Participant can take break given amount of blocks specified in nbblocks
            takebreak(curWindow, cWhite0, fix, break_num, nbblocks)
        end
    end

end

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
    save_name = filename;

    % This function has functions that plot the currect data
    try
        [accuracy, stairstep, CDF] = analyze_data(data_output, save_name, analysis_directory, right_var, left_var, catch_var);
    catch
        warning('Could not plot CDF function.')
        [accuracy, stairstep] = analyze_data(data_output, save_name, analysis_directory, right_var, left_var, catch_var);
    end

end

cd(data_directory)
save(filename)
%% AUDITORY STAIRCASE %%%%%%%%%%
% written by Adam Tiesman - adam.j.tiesman@vanderbilt.edu
% Initial commit on 2/27/2023
clear;
close all;

%% FOR RESPONSE CODING: 1= RIGHTWARD MOTION ; 2=LEFTWARD MOTION

%% Specify parameters of the block
disp('This is the main script for the AUDITORY ONLY motion task.')
task_nature = input('Staircase = 1;  Method of constant stimuli = 2 : ');
if task_nature == 1
    velocity_nature = input('Coherence only staircase = 1; Velocity only staircase = 2; Coherence and velocity staircase = 3 : ');
    if velocity_nature == 1 || velocity_nature == 2
        vel_stair = 1;
    end
else 
    % Set these parameters to 0 so staircase_procedure function knows not to
    % manipulate velocity.
    vel_stair = 0;
    vel_index = 0;
end
training_nature = input('Trial by trial feedback? 0 = NO; 1 = YES : ');
if training_nature == 1
    % Training sound properties
    correct_freq = 2000;
    incorrect_freq = 800;
    correct_sound = MakeBeep(correct_freq, (dur+silence), Fs);
    corr_soundout = [correct_sound', correct_sound'];
    corr_soundout = normalize(corr_soundout);
    incorrect_sound = MakeBeep(incorrect_freq, (dur+silence), Fs);
    incorr_soundout = [incorrect_sound', incorrect_sound'];
    incorr_soundout = normalize(incorr_soundout);
end



% Directories created to navigate code folders throughout script
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

%% General stimlus variables
% dur is stimulus duration, triallength is total length of 1 trial (this is
% currently unused in code), nbblocks is used to divide up num_trials 
% into equal parts to give subject breaks if there are many trials. 
% Set to 0 if num_trials is short and subject does not need break(s).
dur = 0.5; Fs = 44100; triallength = 2; nbblocks = 2; 

% Define buffersize in order to make CAM (auditory stimulus)
silence = 0.03; buffersize = (dur+silence)*Fs; s.Rate = 44100; 

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
if task_nature == 1
    block = 'RDKHoop_stairAud';
elseif task_nature == 2
    block = 'RDKHoop_psyAud';
else
    error('Need to specify what block task falls under.')
end

filename = collect_subject_information(block);

%% Initialize
% curScreen = 0 if there is only one monitor. If more than one monitor, 
% check display settings on PC. curScreen will probably equal 1 or 2 
% (e.g. monitor for stimulus presentation and monitor to run MATLAB code).
curScreen = 0;

% Opens psychtoolbox and initializes experiment
[screenInfo, curWindow, screenRect] = initialize_exp(monWidth, viewDist, curScreen);

%% Initialize Audio
[pahandle] = initialize_aud(curWindow, Fs);

%% Welcome and Instrctions for the Suject
if training_nature == 1
    instructions_trainAud(curWindow, cWhite0, pahandle, corr_soundout, incorr_soundout);
else
    instructions_psyAud(curWindow, cWhite0);
end

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
        % was correct or incorrect.
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
    
    %% THE MAIN LOOP
    % Generates auditory stimulus
    frames = 0;
    CAM = makeCAM_PILOT(audInfo.coh, audInfo.dir, dur, silence, Fs, noise_reduction_scalar);
    wavedata = CAM;
    nrchannels = size(wavedata,1); % Number of rows = number of channels.
    
    % Presents auditory stimulus and gets reaction time both at frame = 1.
    % Presents stimulus for duration specified in dur, which is the length
    % of CAM (wavedata)
    [resp, rt, start_time] = at_generateAud(continue_show, responded, resp, rt, curWindow, fix, frames, pahandle, wavedata);
  
    %%  ITI & response recording
    [resp, rt] = iti_response_recording(typeInt, minNum, maxNum, meanNum, dur, start_time, keyisdown, responded, resp, rt);
    
    %% Save data into data_output on a trial by trial basis
    [trial_status, data_output] = record_data(data_output, audInfo, resp, rt, ii);
    
    %% Present auditory feedback if requested
    if training_nature == 1
        at_generateFeedback(trial_status, pahandle, corr_soundout, incorr_soundout);
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
    right_var = 1;
    left_var = 2;
    catch_var = 0;
    save_name = filename;

    % This function has functions that plot the currect data
    [accuracy, stairstep] = analyze_data(data_output, save_name, analysis_directory);
end

cd(data_directory)
save(filename)
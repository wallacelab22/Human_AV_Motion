%% HUMAN VISUAL MOTION DISCRIMINATION TASK CODE %%%%%%%%%%%%%
% Wallace Multisensory Lab - Vanderbilt University
% written by Adam Tiesman - adam.j.tiesman@vanderbilt.edu
% Initial commit on 2/27/2023
clear;
close all;
clc;

%% FOR RESPONSE CODING: 1 = RIGHTWARD MOTION; 2 = LEFTWARD MOTION
right_var = 1; left_var = 2; catch_var = 0; dur = 0.5; silence = 0.03; Fs = 44100;

%% Specify parameters of the block
disp('This is the main script for the VISUAL ONLY motion discrimination task.')
task_nature = input('Staircase = 1;  Method of constant stimuli (MCS) = 2 : ');
if task_nature == 1
    velocity_nature = input('Coherence only staircase = 1; Velocity only staircase = 2; Coherence and velocity staircase = 3 : ');
    if velocity_nature == 2 || velocity_nature == 3
        vel_stair = 1;
    elseif velocity_nature == 1
        vel_stair = 0;
    end
else 
    % Set these parameters to 0 so staircase_procedure function knows not to
    % manipulate velocity.
    vel_stair = 0;
end
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
    
    % Instantiate the LSL library (LSL stands for lab streaming layer and
    % it is what we use to send stimulus triggers from MATLAB to our EEG
    % recording software to note stimulus onset, stimulus offset, key
    % press, etc.)
    lib = lsl_loadlib();
     
    % Make a new stream outlet- e.g.: (name: BioSemi, type: EEG. 8 channels, 100Hz)
    info = lsl_streaminfo(lib, 'MyMarkerStream', 'Markers', 1, 0, 'cf_string', 'wallacelab');
    outlet = lsl_outlet(info);
end
if vel_stair ~= 1
    % Specify the dot speed in the RDK, wil be an input to function
    % at_createDotInfo
    block_dot_speed = input('Dot Speed (in deg/sec): ');
    visInfo.vel = block_dot_speed;
else
    block_dot_speed = NaN;
end
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
AssertOpenGL;
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
% dur is stimulus duration (in sec), triallength is total length of 1 trial
% (currently unused in code), nbblocks is used to divide up num_trials 
% into equal parts to give subject breaks if there are many trials. 
% Set to 0 if num_trials is short and subject does not need break(s).
dur = 0.5; triallength = 2; nbblocks = 0;

% All variables that define stimulus repetitions; num_trials defines total
% number of staircase trials, stimtrials defines number of stimulus trials
% per condition for MCS, catchtrials defines total number of catch trials
% for MCS.
num_trials = 100; stimtrials = 12; catchtrials = 25;

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
    block = 'RDKHoop_stairVis';
elseif task_nature == 2
    block = 'RDKHoop_psyVis';
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
    visInfo.cohStart = 0.5;
    nlog_coh_steps = 12;
    nlog_division = sqrt(2);
    visInfo = cohSet_generation(visInfo, nlog_coh_steps, nlog_division);
    
    if vel_stair == 1
        visInfo.velSet = [5 10 15 20 25 30 35 40 45 50 55];
    end
    
    % Prob 1 = chance of coherence lowering after correct response
    % Prob 2 = chance of direction changing after correct response
    % Prob 3 = chance of coherence raising after incorrect response
    % Prob 4 = chance of direction changing after incorrect response
    % Prob 5 = chance of velocity raising after correct response
    % Prob 6 = chance of velocity lowering after incorrect response
    if velocity_nature == 2 % velocity ONLY staircase
        visInfo.probs = [0 0.5 0 0.5 0.33 0.66];
    elseif velocity_nature == 3 % coherence and velocity staircase
        visInfo.probs = [0.1 0.5 0.9 0.5 0.33 0.66];
    else % coherence ONLY staircase
        visInfo.probs = [0.33 0.5 0.66 0.5 0 0];
    end
elseif task_nature == 2
    % Create coherences for participant if method of constant stimuli is to be
    % used. Coherences genereated via the same participant's staircase
    % performance. Matrix generation is randomized and determined by the number
    % of stimtrials per condition and number of catchtrials.
    % Load the visual staircase data
    stairVis_filename = sprintf('RDKHoop_%s_%s_%s_%s_%s.mat', block, subjnum_s, group_s, sex_s, age_s);
    try
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
        visInfo.cohStart = 0.5;
        nlog_coh_steps = 7;
        nlog_division = sqrt(2);
        visInfo = cohSet_generation(visInfo, nlog_coh_steps, nlog_division);
    end

    % Create trial matrix
    rng('shuffle')
    data_output = at_generateMatrix(catchtrials, stimtrials, visInfo, right_var, left_var, catch_var);
else
    error('Could not generate coherences. Task nature determines how coherences are generated.')
end

% Create break time variable to check when it is time to break during task
len_data_output = size(data_output, 1);
block_length = floor(len_data_output/nbblocks);
tt = block_length:block_length:len_data_output;
% Combine last two blocks if the last block length is smaller than half the
% other block lengths
last_block_length = len_data_output - tt(1, nbblocks);
if last_block_length < block_length/2
    tt(1, nbblocks) = NaN;
end

%% Initialize
% curScreen = 0 if there is only one monitor. If more than one monitor, 
% check display settings on PC. curScreen will probably equal 1 or 2 
% (e.g. monitor for stimulus presentation and monitor to run MATLAB code).
curScreen = 0;

% Opens psychtoolbox and initializes experiment
[screenInfo, curWindow, screenRect] = initialize_exp(monWidth, viewDist, curScreen);

%% Initialize Audio
if training_nature == 1
    [pahandle] = initialize_aud(curWindow, Fs);
end

%% Welcome and Instrctions for the Suject
% Opens psychtoolbox instructions for participant for the specific task 
% (psyVis for all visual tasks, psyAud for all auditory only tasks, psyAV 
% for all audiovisual tasks). trainAud and trainVis have separate instructions.
if training_nature == 1
    instructions_trainVis(curWindow, cWhite0, pahandle, corr_soundout, incorr_soundout);
else
    instructions_psyVis(curWindow, cWhite0);
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
            visInfo.dir = randi([1,2]);
            % Start staircase on first coherence in cohSet
            visInfo.coh = visInfo.cohSet(staircase_index);
            if vel_stair == 1
                vel_index = 1;
                visInfo.vel = visInfo.velSet(vel_index);
            else
                vel_index = 0;
            end
        elseif ii > 1 % every trial in staircase except for first trial
            % Function staircase_procedure takes the previous trial's accuracy
            % (incorr or corr) and uses a random number (0 to 1) to determine the
            % coherence and direction for the current trial. All based on
            % probabilities, which change depending on if the previous trials
            % was correct or incorrect.
            if vel_stair == 1
                [visInfo, staircase_index, vel_index] = staircase_procedure(trial_status, visInfo, staircase_index, vel_stair, vel_index);
            else
                [visInfo, staircase_index] = staircase_procedure(trial_status, visInfo, staircase_index, vel_stair, vel_index);
            end
        end
    elseif task_nature == 2
        % Stimulus direction and coherence for a given trial is pre
        % determined via the output of at_generateMatrix.
        visInfo.dir = data_output(ii, 1);
        visInfo.coh = data_output(ii, 2);
    end

    % Necessary variable changing for RDK code. 1 = RIGHT, which is 0 
    % degrees on unit circle, 2 = LEFT, which is 180 degrees on unit circle
    visInfo = direction_conversion(visInfo);

    %% Create info matrix for Visual Stim. 
    % This dotInfo  output informs at_dotGenerate how to generate the RDK. 
    dotInfo = at_createDotInfo(inputtype, visInfo.coh, visInfo.dir, typeInt, ...
        minNum, maxNum, meanNum, maxdotsframe, dur, block_dot_speed, vel_stair, visInfo.vel);
    
    %% Keypress input initialize variables, define frames for presentation
    while KbCheck; end
    keycorrect = 0;
    keyisdown = 0;
    responded = 0; %DS mark as no response yet
    resp = nan; %default response is nan
    rt = nan; %default rt in case no response is recorded

    % Create marker for EEG
    if EEG_nature == 1
        dir_id = num2str(data_output(ii,1));
        coh_id = num2str(data_output(ii,2));
        markers = strcat([dir_id coh_id]); % unique identifier for LSL
    else
        markers = NaN; % needed for function at_presentDot
        outlet = NaN;
    end

    %% Dot Generation.
    % This function generates the dots that will be presented to
    % participant in accordance with their coherence, direction, and other dotInfo.
    [center, dotSize, d_ppd, ndots, dxdy, ss, Ls, continue_show] = at_generateDot(visInfo, dotInfo, screenInfo, screenRect, monWidth, viewDist, maxdotsframe, dur, curWindow, fix);
    
    %% Dot Presentation
    % This function uses psychtoolbox to present dots to participant.
    [resp, rt, start_time] = at_presentDot(visInfo, center, dotSize, d_ppd, ndots, dxdy, ss, Ls, continue_show, curWindow, fix, responded, resp, rt, EEG_nature, outlet, markers);

    %% Erase last dots & go back to only plotting fixation
    Screen('DrawingFinished',curWindow);
    Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], fix, 1);
    Screen('Flip', curWindow,0);
    
    %%  ITI & response recording
    [resp, rt] = iti_response_recording(typeInt, minNum, maxNum, meanNum, dur, start_time, keyisdown, responded, resp, rt);
    
    %% Direction conversion
    visInfo = direction_conversion(visInfo);

    %% Save data into data_output on a trial by trial basis
    [trial_status, data_output] = record_data(data_output, right_var, left_var, right_keypress, left_keypress, visInfo, resp, rt, ii, vel_stair);

    %% Present stimulus feedback if requested
    if training_nature == 1
        at_presentFeedback(trial_status, pahandle, corr_soundout, incorr_soundout);
        WaitSecs(1)
    end

    %% Check if it is break time for participant
    if ismember(ii, tt) == 1
        breaks = ii == tt;
        break_num = find(breaks);
        % Participant can take break given amount of blocks specified in nbblocks
        takebreak(curWindow, cWhite0, fix, break_num, nbblocks) 
    end

end

%% Goodbye
cont(curWindow, cWhite0);

%% Finalize 
% Close psychtoolbox window
closeExperiment;
close all
Screen('CloseAll')

%% Data Analysis

if data_analysis == 1
    % Provide specific variables 
    chosen_threshold = 0.72;
    save_name = filename;

    % This function has functions that plot the current data
    [accuracy, stairstep, CDF] = analyze_data(data_output, save_name, analysis_directory);
end

cd(data_directory)
save(filename)
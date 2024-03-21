%% HUMAN VISUAL MOTION DISCRIMINATION TASK CODE %%%%%%%%%%%%%
% Wallace Multisensory Lab - Vanderbilt University
% written by Adam Tiesman - adam.j.tiesman@vanderbilt.edu
% Initial commit on 2/27/2023
clear;
close all;
clc;

%% FOR RESPONSE CODING: 1 = RIGHTWARD MOTION; 2 = LEFTWARD MOTION
right_var = 1; left_var = 2; catch_var = 0;

%% Specify parameters of the block
disp('This is the main script for the VISUAL ONLY motion discrimination task.')
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
selfinit_nature = input('Participant-initiated trials? 0 = NO; 1 = YES : ');
training_nature = input('Trial by trial feedback? 0 = NO; 1 = YES : ');
aperture_nature = input('Do you want to change the aperture size? 0 = NO; 1 = YES : ');
if aperture_nature ~= 1
    % Original aperture size, in tens of visual degrees (e.g. 50 is 5 degrees)
    aperture_size = 50;
end
sliderResp_nature = input('Slider Response following trials? 0 = NO, 1 = YES : ');
if sliderResp_nature == 1
    typeSlide = input('Slider Type? 1 = Confidence, 2 = Strength of motion : ');
else
    sliderResp = NaN;
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
ExampleMatrix = input('Example Matrix? 0 = NO, 1 = YES : ');


%% Directories created to navigate code folders throughout script
OS_nature = input('1 = Linux OS, 2 = Windows OS : ');
[script_directory, data_directory, analysis_directory] = define_directories(OS_nature, EEG_nature);
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
% Set to 0 if num_trials is short and subject does not need break(s).
dur = 0.7; Fs = 44100; triallength = 2; nbblocks = 2; 

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
    visInfo.cohStart = 1;
    visInfo.nlog_coh_steps = 12;
    visInfo.nlog_division = sqrt(2);
    visInfo = cohSet_generation(visInfo, block);
    
    if vel_stair == 1
        % Generate list of velocities and durations if the given velocity were to
        % travel from speaker to speaker
        visInfo.velStart = 55;
        visInfo.vel_steps = 11;
        visInfo.vel_subtract = 5;
        visInfo = velSet_generation(visInfo, block, dur);
    end
    
    % Prob 1 = chance of coherence lowering after correct response
    % Prob 2 = chance of direction changing after correct response
    % Prob 3 = chance of coherence raising after incorrect response
    % Prob 4 = chance of direction changing after incorrect response
    % Prob 5 = chance of velocity raising after correct response
    % Prob 6 = chance of velocity lowering after incorrect response
    if staircase_nature == 2 % velocity ONLY staircase
        visInfo.probs = [0 0.5 0 0.5 0.33 0.66];
    elseif staircase_nature == 3 % coherence and velocity staircase
        visInfo.probs = [0.1 0.5 0.9 0.5 0.33 0.66];
    else % coherence ONLY staircase
        visInfo.probs = [0.33 0.5 0.66 0.5 0 0];
    end
elseif task_nature == 2
    if stim_matching_nature == 1
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
            visInfo.nlog_coh_steps = 8;
            visInfo.nlog_division = sqrt(2);
            visInfo = cohSet_generation(visInfo, block);
        end
    
        % Create trial matrix
        rng('shuffle')
        if ExampleMatrix == 1
            data_output = at_generateExampleMatrix(block);
        else
            data_output = at_generateMatrix(catchtrials, stimtrials, visInfo, right_var, left_var, catch_var);
        end
    end
else
    error('Could not generate coherences. Task nature determines how coherences are generated.')
end

if nbblocks > 0
    [tt] = breaktime_var(data_output, nbblocks);
end

%% Initialize
% curScreen = 0 if there is only one monitor. If more than one monitor, 
% check display settings on PC. curScreen will probably equal 1 or 2 
% (e.g. monitor for stimulus presentation and monitor to run MATLAB code).
curScreen = 0;

% Opens psychtoolbox and initializes experiment
[screenInfo, curWindow, screenRect, xCenter, yCenter] = initialize_exp(monWidth, viewDist, curScreen);

%% Initialize Audio for Feedback
if training_nature == 1
    % Training sound properties
    correct_freq = 1046.5; incorrect_freq = 783.99; % musical notes C, G
    % Generate tones for correct and incorrect responses
    [corr_soundout, incorr_soundout] = at_generateBeep(correct_freq, incorrect_freq, dur, silence, Fs);
    % Open a pahandle
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

%% Stimulus Matching Across Modalities
% Generate and present a slider for participant to subjectively match
% coherence across modalities
if stim_matching_nature == 2
    % Generate a slider for the participant to respond to
    [visInfo, StopPixel_M] = at_generateSlider(visInfo, right_keypress, left_keypress, space_keypress, curWindow, cWhite0, xCenter, yCenter);
end
% Match the computed auditory displacement for a given velocity given dur
% to the size of the visual aperture.
if aperture_nature == 1
    [audInfo, visInfo] = at_generateApertureInfo(audInfo, visInfo, dur);
else
    visInfo.displaceSet = aperture_size;
end

%% Flip up fixation dot
[fix, s] = at_presentFix(screenRect, curWindow);

%% Experiment Loop
% Loop through every trial.
for ii = 1:length(data_output)

    %% Allows participant to self initiate each trial
    if selfinit_nature == 1
         instructions_InitTrial(curWindow, cWhite0, fix, data_output);
    end
    
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
        minNum, maxNum, meanNum, maxdotsframe, dur, visInfo.vel, visInfo.displaceSet);
    
    %% Keypress input initialize variables, define frames for presentation
    while KbCheck; end
    keycorrect = 0;
    keyisdown = 0;
    responded = 0; %DS mark as no response yet
    resp = nan; %default response is nan
    rt = nan; %default rt in case no response is recorded

    % Create marker for EEG
    [markers] = at_generateMarkers(data_output, ii, EEG_nature, block);

    %% Dot Generation.
    % This function generates the dots that will be presented to
    % participant in accordance with their coherence, direction, and other dotInfo.
    [center, dotSize, d_ppd, ndots, dxdy, ss, Ls, continue_show] = at_generateDot(visInfo, dotInfo, screenInfo, screenRect, monWidth, viewDist, maxdotsframe, dur, curWindow, fix);
    
    %% Dot Presentation
    % This function uses psychtoolbox to present dots to participant.
    [resp, rt, start_time] = at_presentDot(visInfo, dotInfo, center, dotSize, d_ppd, ndots, dxdy, ss, Ls, continue_show, curWindow, fix, responded, resp, rt, EEG_nature, outlet, markers);

    %% Erase last dots & go back to only plotting fixation
    Screen('DrawingFinished',curWindow);
    Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], fix, 1);
    Screen('Flip', curWindow,0);
    
    %%  ITI & response recording
    [resp, rt] = iti_response_recording(typeInt, minNum, maxNum, meanNum, dur, start_time, keyisdown, responded, resp, rt);
    
    %% Direction conversion
    visInfo = direction_conversion(visInfo);

    %% Present slider
    if sliderResp_nature == 1
        if typeSlide == 1 % confidence slider
            sliderPrompt = 'How sure are you with your response?';
            sliderLowerText = 'Least';
            sliderUpperText = 'Most';
        elseif typeSlide == 2 % strength of motion slider
            sliderPrompt = 'How strongly did you perceive the motion?';
            sliderLowerText = 'Strongly Left';
            sliderUpperText = 'Strongly Right';
        else
            sliderPrompt = '';
            sliderLowerText = '';
            sliderUpperText = '';
        end
        sliderResp = at_presentSlider(sliderPrompt, sliderLowerText, sliderUpperText, right_keypress, left_keypress, space_keypress, curWindow, cWhite0, xCenter, yCenter);
    end

    %% Save data into data_output on a trial by trial basis
    [trial_status, data_output] = record_data(data_output, right_var, left_var, right_keypress, left_keypress, visInfo, resp, rt, ii, vel_stair, sliderResp);

    %% Present stimulus feedback if requested
    if training_nature == 1
        at_presentFeedback(trial_status, pahandle, corr_soundout, incorr_soundout);
    end

    %% Check if it is break time for participant
    if nbblocks > 0
        if ismember(ii, tt) == 1
            breaks = ii == tt;
            break_num = find(breaks);
            % Participant can take break given amount of blocks specified in nbblocks
            takebreak(curWindow, cWhite0, fix, break_num, nbblocks) 
        end
    end

    if task_nature == 1 && staircase_nature == 1
        num_reversals = 30;
        % Find the direction of each trial (positive or negative)
        differences = diff(data_output(:,2));
        nonzero_differences = differences(differences ~= 0);
        directions = sign(nonzero_differences);        
        
        % Find the indices of the reversal points
        reversal_indices = find(diff(directions) ~= 0);
    
        if length(reversal_indices) >= num_reversals
            break;
        end
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
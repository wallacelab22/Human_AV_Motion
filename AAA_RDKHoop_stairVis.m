%% VISUAL STAIRCASE %%%%%%%%%%
% written by Adam Tiesman - adam.j.tiesman@vanderbilt.edu
% Initial commit on 2/27/2023
clear;
close all;

%% FOR RESPONSE CODING: 1= RIGHTWARD MOTION; 2=LEFTWARD MOTION

% Variables created to navigate code folders throughout script.
scriptdirectory = '/home/wallace/Human_AV_Motion';
localdirectory = '/home/wallace/Human_AV_Motion';
serverdirectory = '/home/wallace/Human_AV_Motion';
data_directory = '/home/wallace/Human_AV_Motion/data';
analysis_directory = '/home/wallace/Human_AV_Motion/Psychometric_Function_Plot';
cd(scriptdirectory)

%% General variables to smoothly run PTB
% Necessary for psychtoolbox to read keyboard inputs.
KbName('UnifyKeyNames');
AssertOpenGL;

%% define general values
% minNum, maxNum, and meanNum all deal with the intertrial interval, which
% is generated in the function iti_response_recording.
inputtype = 1; typeInt = 1; minNum = 1.5; maxNum = 2.5; meanNum = 2;

% Specify if you want data analysis. If 1, task code will print out figures
% after code has completed.
data_analysis = input('Data Analysis? 0 = NO, 1 = YES : ');

% Specify the dot speed in the RDK, wil be an input to function
% at_createDotInfo
block_dot_speed = input('Dot Speed (in deg/sec): ');
visInfo.vel = block_dot_speed;

% Set these parameters to 0 so staircase_procedure function knows not to
% manipulate velocity.
vel_stair = 0; vel_index = 0;

%% General stimulus variables
% dur is stimulus duration (in sec), triallength is total length of 1 trial
% (currently unused in code), nbblocks is used to divide up num_trials 
% into equal parts to give subject breaks if there are many trials. 
% Set to 0 if num_trials is short and subject does not need break(s).
dur = 0.5; triallength = 2; nbblocks = 2;

% Define stimulus repetitions
num_trials = 100;

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
block = 'RDKHoop_stairVis';
filename = collect_subject_information(block);

%% Initialize
% curScreen = 0 if there is only one monitor. If more than one monitor, 
% check display settings on PC. curScreen will probably equal 1 or 2 
% (e.g. monitor for stimulus presentation and monitor to run MATLAB code).
curScreen = 0;

% Opens psychtoolbox and initializes experiment
[screenInfo, curWindow, screenRect] = initialize_exp(monWidth, viewDist, curScreen);

%% Welcome and Instrctions for the Suject
% Opens psychtoolbox instructions for participant for the specific task 
% (psyVis for all visual tasks, psyAud for all auditory only tasks, psyAV 
% for all audiovisual tasks). trainAud and trainVis have separate instructions.
instructions_psyVis(curWindow, cWhite0);

%% Flip up fixation dot
[fix, s] = fixation_dot_flip(screenRect,curWindow);

% Initialize matrix to store data. Data is recorded every trial using
% function record_data
data_output = zeros(num_trials, 6);

% Generate the list of possible coherences by decreasing log values
visInfo.cohStart = 0.5;
nlog_coh_steps = 12;
nlog_division = sqrt(2);
visInfo = cohSet_generation(visInfo, nlog_coh_steps, nlog_division);

% Prob 1 = chance of coherence lowering after correct response
% Prob 2 = chance of direction changing after correct response
% Prob 3 = chance of coherence raising after incorrect response
% Prob 4 = chance of direction changing after incorrect response
visInfo.probs = [0.33 0.5 0.66 0.5];

%% Experiment Loop
% Loop through every trial.
for ii = 1:num_trials
    
    if ii == 1 % the first trial in the staircase
        staircase_index = 1;
        % Start staircase on random direction (left or right)
        visInfo.dir = randi([1,2]);
        % Start staircase on first coherence in cohSet
        visInfo.coh = visInfo.cohSet(staircase_index);
    elseif ii > 1 % every trial in staircase except for first trial
        % Function staircase_procedure takes the previous trial's accuracy
        % (incorr or corr) and uses a random number (0 to 1) to determine the
        % coherence and direction for the current trial. All based on
        % probabilities, which change depending on if the previous trials
        % was correct or incorrect.t
        [visInfo, staircase_index] = staircase_procedure(trial_status, visInfo, staircase_index, vel_stair, vel_index);
    end

    % Necessary variable changing for RDK code. 1 = RIGHT, which is 0 
    % degrees on unit circle, 2 = LEFT, which is 180 degrees on unit circle
    visInfo = direction_conversion(visInfo);

    %% Create info matrix for Visual Stim. 
    % This dotInfo  output informs at_dotGenerate how to generate the RDK. 
    dotInfo = at_createDotInfo(inputtype, visInfo.coh, visInfo.dir, typeInt, ...
        minNum, maxNum, meanNum, maxdotsframe, dur, block_dot_speed, vel_stair, visInfo.vel);
    
    %% Display the stimuli
    while KbCheck; end
    keycorrect=0;
    keyisdown=0;
    responded = 0; %DS mark as no response yet
    resp = nan; %default response is nan
    rt = nan; %default rt in case no response is recorded
    
    %% Dot Generation.
    % This function plots the dots and updates them frame by frame in
    % accordance with their coherence, direction, and other dotInfo.
    [resp, rt, start_time] = at_generateDot(visInfo, dotInfo, screenInfo, ...
    screenRect, monWidth, viewDist, maxdotsframe, dur, curWindow, fix, ...
    responded, resp, rt);
    
    %% Erase last dots & go back to only plotting fixation
    Screen('DrawingFinished',curWindow);
    Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], fix, 1);
    Screen('Flip', curWindow,0);
    
    %%  ITI & response recording
    [resp, rt] = iti_response_recording(typeInt, minNum, maxNum, meanNum, dur, start_time, keyisdown, responded, resp, rt);
    
    %% Direction conversion
    visInfo = direction_conversion(visInfo);

    %% Save data into data_output on a trial by trial basis
    [trial_status, data_output] = record_data(data_output, visInfo, resp, rt, ii);


end

cd(data_directory)
save(filename, 'data_output')

cd(scriptdirectory)
%% Goodbye
cont(curWindow, cWhite0);

%% Finalize
closeExperiment;
close all
Screen('CloseAll')

%% Data Analysis

if data_analysis == 1
    % Provide specific variables 
    chosen_threshold = 0.72;
    right_var = 1;
    left_var = 2;
    catch_var = 0;
    save_name = filename;

    cd(analysis_directory)
    % This function has functions that plot the currect data
    [accuracy, stairstep] = analyze_data(data_output);
end

cd(data_directory)
save(filename)
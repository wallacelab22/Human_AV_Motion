%% VISUAL STAIRCASE %%%%%%%%%%
% written by Adam Tiesman 2/27/2023
clear;
close all;
%% FOR RESPONSE CODING: 1= RIGHTWARD MOTION ; 2=LEFTWARD MOTION
% %% define general variables
scriptdirectory = '/home/wallace/Human_AV_Motion/';
localdirectory = '/home/wallace/Human_AV_Motion/';
serverdirectory = '/home/wallace/Human_AV_Motion/';
data_directory = '/home/wallace/Human_AV_Motion/data/';
analysis_directory = '/home/wallace/Human_AV_Motion/Psychometric_Function_Plot/';
Shadlen_directory = '/home/wallace/Human_AV_Motion/Shadlen_code/';
cd(scriptdirectory)

%% general variables to smoothly run PTB
KbName('UnifyKeyNames');
AssertOpenGL;
%% define general values
inputtype=1; typeInt=1; minNum=1.5; maxNum=2.5; meanNum=2;

% Specify if you want data analysis
data_analysis = input('Data Analysis? 0 = NO, 1 = YES : ');

% Specify the dot speed in the RDK
deg_sec_dot_speed = input('Dot Speed (in deg/sec): ');
block_dot_speed = deg_sec_dot_speed*10;

%% general stimlus variables
dur=.5; triallength=2; nbblocks=2;

% Define Stimulus repetitions
num_trials = 100;
% visual stimulus properties
% maxdotsframe=150; monWidth=42.5; viewDist =120;
maxdotsframe=150; monWidth=50.8; viewDist =120;

% general drawing color
cWhite0=255;

% breaking staircase conditions
recent_acc = 0;
trial_history = 25;
lower_lim = 0.55;
upper_lim = 0.65;

%% collect subject information
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
filename = strcat('RDKHoop_stairVis',underscore,subjnum_s,underscore,group_s, underscore, sex_s, underscore, age_s);

cd(localdirectory)
% save(filename,'filename')
cd(scriptdirectory)

%% Initialize
curScreen=0;
Screen('Preference', 'SkipSyncTests', 0);
%Screen('Preference', 'SkipSyncTests', 1);
screenInfo = openExperiment(monWidth, viewDist, curScreen);
curWindow= screenInfo.curWindow;
screenRect= screenInfo.screenRect;
% Enable alpha blending with proper blend-function. We need it for drawing
% of smoothed points.
Screen('BlendFunction', curWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
%% Welcome and Instrctions for the Suject
instructions_psyVis(curWindow, cWhite0);
%% Flip up fixation dot
fix=[screenRect(3)/2,screenRect(4)/2]; %define fix position of fix dot
Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], fix, 1);
Screen('Flip', curWindow,0);
WaitSecs(2); %wait for 2s

% Generate the list of possible coherences by decreasing log values
visInfo.cohStart = 0.5;
nlog_coh_steps = 19;
nlog_division = sqrt(2);
visInfo.cohSet = [visInfo.cohStart];
for i = 1:nlog_coh_steps
    if i == 1
        nlog_value = visInfo.cohStart;
    end
    nlog_value = nlog_value/nlog_division;
    visInfo.cohSet = [visInfo.cohSet nlog_value];
end

% Prob 1 = chance of coherence lowering after correct response
% Prob 2 = chance of direction changing after correct response
% Prob 3 = chance of coherence raising after incorrect response
% Prob 4 = chance of direction changing after incorrect response
visInfo.probs = [0.33 0.5 0.66 0.5];

%% Experiment Loop
for ii= 1:num_trials
    
    if ii == 1
        staircase_index = 1; % Start staircase on coherence of 1
        visInfo.dir = randi([1,2]);
        visInfo.coh = visInfo.cohSet(staircase_index);
    elseif ii > 1
        [visInfo, staircase_index] = staircase_procedure(trial_status, visInfo, staircase_index);
    end

    if visInfo.dir == 1
        visInfo.dir=0; % RIGHTward
    elseif visInfo.dir == 2
        visInfo.dir=180; % LEFTward
    end

    %create info matrix for RDK and display RDK
    cd(Shadlen_directory)
    [dot_info, frames, rseed, start_time, end_time, response, response_time] = ...
    RDK_draw(inputtype, visInfo.coh, visInfo.dir, typeInt, minNum, maxNum, meanNum, ...
    maxdotsframe, dur, block_dot_speed, screenInfo);

    %% display the stimuli
    while KbCheck; end
    keycorrect=0;
    keyisdown=0;
    responded = 0; %DS mark as no response yet
    resp = nan; %default response is nan
    rt = nan; %default rt in case no response is recorded
    
    %% save data
    if visInfo.dir == 0
        visInfo.dir = 1;
        data_output(ii, 1) = visInfo.dir; 
    elseif visInfo.dir == 180
        visInfo.dir = 2;
        data_output(ii, 1) = visInfo.dir;
    end
    data_output(ii, 2) = visInfo.coh;
    if resp == 115
        data_output(ii, 3) = 1;
    elseif resp == 114
        data_output(ii, 3) = 2;
    else
        data_output(ii, 3) = nan;
    end
    data_output(ii, 4) = rt;
    data_output(ii,5) = char(resp);
    % For the table, column 6 denotes accuracy (used for
    % staircase_procedure). 0 = incorrect, 1 = correct, it checks if the 
    % stimulus direction is equal to the recorded response. If so, then
    % trial is correct.
    if data_output(ii, 3) == data_output(ii, 1)
        trial_status = 1;
        data_output(ii, 6) = trial_status;
    else 
        trial_status = 0;
        data_output(ii, 6) = trial_status;
    end
    % Compute the trial history accuracy to determine if staircase can be
    % finished
    if ii > trial_history
        recent_acc = mean(data_output((ii-(trial_history-1)):ii, 6));
        if recent_acc > lower_lim && recent_acc < upper_lim
            break;
        end
    end
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
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
interleave_nature = input('Interleave A,V, AV trials or just AV? 0 = Just AV, 1 = Interleave : ');
selfinit_nature = input('Participant-initiated trials? 0 = NO, 1 = YES : ');
if selfinit_nature
    cued_nature = input('Cued or Uncued task? 0 = UNCUED, 1 = CUED : ');
end
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
%data_analysis = input('Data Analysis? 0 = NO, 1 = YES : ');
%ExampleMatrix = input('Example Matrix? 0 = NO, 1 = YES : ');
data_analysis = 0; ExampleMatrix = 0; %not changing anytime soon

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
OS_nature = input('1 = Linux OS, 2 = Windows OS : ');
[script_directory, data_directory, analysis_directory] = define_directories(OS_nature, EEG_nature);
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
dur = 0.7; Fs = 44100; triallength = 2; 
if interleave_nature
    nbblocks = 9;
else
    nbblocks = 3;
end

% Define buffersize in order to make CAM (auditory stimulus)
silence = 0.03; buffersize = (dur+silence)*Fs;

% All variables that define stimulus repetitions; num_trials defines total
% number of staircase trials, stimtrials defines number of stimulus trials
% per condition for MCS for unisensory trials/blocks, catchtrials defines total number of catch trials
% for MCS, congruent_mstrials defines number of stimulus trials per
% congruent condition for AV MCS, incongruent_mstrials is same as above for
% incongruent conditions.

% Previous conditions:
% num_trials = 100; stimtrials = 12; catchtrials = 25;
% congruent_mstrials = 20; incongruent_mstrials = 0;

% New conditions:
num_trials = 100; stimtrials = 20; catchtrials = 20;
congruent_mstrials = 20; incongruent_mstrials = 0;

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

% Velocity of trial set to maxVel if not otherwise specified. This will
% make auditory stimulus completely travel from one speaker to the other.
if aud_vel == 0
    audInfo.vel = audInfo.maxVel;
end

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
    stimInfo.nlog_coh_steps = 12;
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
        stim_vs_perf_match_nature = 1;
        extrapolateCoh = 0; % set to 1 if you want to match more than 1 coherence set
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
            aud_coh_step = -1;
            [audInfo] = coherence_calc(data_output, extrapolateCoh, audInfo, aud_coh_step);
    
            clear("data_output")

            % Load the staircase data from same participant to generate
            % coherences
            cd(data_directory)
            load(horzcat(data_directory, stairVis_filename), 'data_output');
            cd(script_directory)
    
            % Generate stimulus coherence levels based on staircase, manipulate stim coherences
            % generated by coherence_calc by changing variables in the function
            vis_coh_step = -1;
            [visInfo] = coherence_calc(data_output, extrapolateCoh, visInfo, vis_coh_step);
    
            clear("data_output")

        catch
            warning('Problem finding staircase data for participant. Assigning general coherences for MCS.');
            cd(script_directory)
            % Generate the list of possible coherences by decreasing log values
            visInfo.cohStart = 0.5;
            visInfo.nlog_coh_steps = 8;
            visInfo.nlog_division = sqrt(2);
            visInfo = cohSet_generation(visInfo, block);
            audInfo.cohSet = visInfo.cohSet;
        end
    
        % Create trial matrix
        rng('shuffle')
        if length(audInfo.cohSet) == length(visInfo.cohSet)
            if interleave_nature == 1
                [data_output] = at_generateMatrixALL(catchtrials, congruent_mstrials, incongruent_mstrials, stimtrials, audInfo, visInfo, right_var, left_var, catch_var);
            else
                % Antonia's old version of creating task structure is commented
                [data_output] = at_generateMatrixAV(catchtrials, congruent_mstrials, incongruent_mstrials, stimtrials, audInfo, visInfo, right_var, left_var, catch_var);
                %[data_output] = at_RDKHoopMatrix_PILOTpsyAV(catchtrials, congruent_mstrials, incongruent_mstrials);
            end
            if stim_vs_perf_match_nature
                audNoise = 0;
                visNoise = 0;
                totalNOISE_trials = 2*congruent_mstrials; 
                data_output_PERF = data_output;
                if ~cued_nature
                    data_output_STIM_AUD = at_generateMatrixALL(0, congruent_mstrials, incongruent_mstrials, 0, audInfo, audInfo, right_var, left_var, catch_var);
                    data_output_STIM_VIS = at_generateMatrixALL(0, congruent_mstrials, incongruent_mstrials, 0, visInfo, visInfo, right_var, left_var, catch_var);
                end

                %data_output_NOISE_VIS = zeros(totalNOISE_trials, 8);
                %data_output_NOISE_VIS(1:congruent_mstrials,1) = right_var;
                %data_output_NOISE_VIS(congruent_mstrials+1:end,1) = left_var;
                %data_output_NOISE_VIS(:,2) = audInfo.cohSet(1);
                %data_output_NOISE_AUD = zeros(totalNOISE_trials, 8);
                %data_output_NOISE_AUD(1:congruent_mstrials,3) = right_var;
                %data_output_NOISE_AUD(congruent_mstrials+1:end,3) = left_var;
                %data_output_NOISE_AUD(:,4) = visInfo.cohSet(1);

                % Generate the list of possible coherences by decreasing log values
                stimInfo.cohStart = 1;
                stimInfo.nlog_coh_steps = 12;
                stimInfo.nlog_division = sqrt(2);
                stimInfo = cohSet_generation(stimInfo, block);
                audIndex = find(stimInfo.cohSet == audInfo.cohSet);
                visIndex = find(stimInfo.cohSet == visInfo.cohSet);

                audInfo_2above.cohSet = stimInfo.cohSet(audIndex-2);
                audInfo_1above.cohSet = stimInfo.cohSet(audIndex-1);
                audInfo_1below.cohSet = stimInfo.cohSet(audIndex+1);
                audInfo_2below.cohSet = stimInfo.cohSet(audIndex+2);
                visInfo_2above.cohSet = stimInfo.cohSet(visIndex-2);
                visInfo_1above.cohSet = stimInfo.cohSet(visIndex-1);
                visInfo_1below.cohSet = stimInfo.cohSet(visIndex+1);
                visInfo_2below.cohSet = stimInfo.cohSet(visIndex+2);

                [data_output_2above] = at_generateMatrixALL(0, congruent_mstrials, incongruent_mstrials, 0, audInfo_2above, visInfo_2above, right_var, left_var, catch_var);
                [data_output_1above] = at_generateMatrixALL(0, congruent_mstrials, incongruent_mstrials, 0, audInfo_1above, visInfo_1above, right_var, left_var, catch_var);
                [data_output_1below] = at_generateMatrixALL(0, congruent_mstrials, incongruent_mstrials, 0, audInfo_1below, visInfo_1below, right_var, left_var, catch_var);
                [data_output_2below] = at_generateMatrixALL(0, congruent_mstrials, incongruent_mstrials, 0, audInfo_2below, visInfo_2below, right_var, left_var, catch_var);

                if cued_nature
                    x = length(data_output_NOISE_VIS);
                    num_each = floor(x/4);
                    remainder = mod(x,4);
        
                    nums = repmat(0:3, 1, num_each);
                    if remainder > 0 
                        nums = [nums, 0:remainder-1];
                    end
                    nums = nums(randperm(length(nums)));
                    data_output_NOISE_VIS = [data_output_NOISE_VIS, nums'];

                    x = length(data_output_NOISE_AUD);
                    num_each = floor(x/4);
                    remainder = mod(x,4);
        
                    nums = repmat(0:3, 1, num_each);
                    if remainder > 0 
                        nums = [nums, 0:remainder-1];
                    end
                    nums = nums(randperm(length(nums)));
                    data_output_NOISE_AUD = [data_output_NOISE_AUD, nums'];

                    x = length(data_output_PERF);
                    num_each = floor(x/4);
                    remainder = mod(x,4);
                    
                    % Find rows with NaNs in columns 1-4
                    nan_rows = any(isnan(data_output_PERF(:, 1:4)), 2);
                    valid_rows = ~nan_rows;
                    
                    % Assign 0 to column 9 for rows with NaNs in columns 1-4
                    data_output_PERF(nan_rows, 9) = 0;
                    
                    % Number of valid rows
                    num_valid = sum(valid_rows);
                    
                    % Ensure there are an equal number of 0-3 for the valid rows
                    num_each_valid = floor(num_valid/4);
                    remainder_valid = mod(num_valid,4);
                    
                    % Generate the nums array for valid rows
                    nums_valid = repmat(0:3, 1, num_each_valid);
                    if remainder_valid > 0
                        nums_valid = [nums_valid, 0:remainder_valid-1];
                    end
                    nums_valid = nums_valid(randperm(length(nums_valid)));
                    
                    % Assign the shuffled nums_valid to column 9 for valid rows
                    data_output_PERF(valid_rows, 9) = nums_valid';
                    
                end

                if cued_nature
                    all_trials = [data_output_PERF; data_output_2above; data_output_1above; data_output_1below; data_output_2below; data_output_NOISE_AUD; data_output_NOISE_VIS];
                else
                    all_trials = [data_output_PERF; data_output_STIM_AUD; data_output_STIM_VIS; data_output_NOISE_AUD; data_output_NOISE_VIS];
                end

                % Randomize trials
                rng('shuffle');
                nbtrials = size(all_trials, 1);
                order = randperm(nbtrials);
                data_output = all_trials(order, :);
            end
        else
            warning('Auditory and Visual coherence sets are NOT the same size')
        end
    end
else
    error('Could not generate coherences. Task nature determines how coherences are generated.')
end

%% Velocity generation for Auditory Stimulus
if aud_vel ~= 0
    audInfo.velStart = aud_vel;
    audInfo.vel_steps = 1;
    audInfo.vel_subtract = 0;
    audInfo = velSet_generation(audInfo, block, dur);
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
monRefresh = 1/screenInfo.frameDur;

%% Initialize Audio
if training_nature == 1
    % Training sound properties
    correct_freq = 1046.5; incorrect_freq = 783.99; % musical notes C, G
    % Generate tones for correct and incorrect responses
    [corr_soundout, incorr_soundout] = at_generateBeep(correct_freq, incorrect_freq, dur, silence, Fs);
end
% Open a pahandle
[pahandle] = initialize_aud(curWindow, Fs);


%% Welcome and Instrctions for the Suject
% Opens psychtoolbox instructions for participant for the specific task 
% (psyVis for all visual tasks, psyAud for all auditory only tasks, psyAV 
% for all audiovisual tasks). trainAud and trainVis have separate instructions.
if training_nature == 1 && cued_nature == 0
    instructions_trainAV(curWindow, cWhite0, pahandle, corr_soundout, incorr_soundout, sliderResp_nature);
elseif training_nature == 0 && cued_nature == 1
    instructions_psyAV_cued(curWindow, cWhite0, sliderResp_nature);
else
    instructions_psyAV(curWindow, cWhite0, sliderResp_nature);
end

if sliderResp_nature == 1
    instructions_slideAV(curWindow, cWhite0, typeSlide);
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

%% trial generation
for ii = 1:length(data_output)

    if cued_nature
        cued_modality = data_output(ii, 9);
    end

    %% Allows participant to self initiate each trial
    if selfinit_nature
        if cued_nature
            instructions_CueAV(curWindow, cWhite0, fix, data_output, 0, cued_modality, xCenter);
        else
            instructions_InitTrialAV(curWindow, cWhite0, fix, data_output);
        end
    end

    if task_nature == 1
        if ii == 1 % the first trial in the staircase
            staircase_index = 1;
            % Start staircase on random direction (left or right)
            visInfo.dir = randi([1,2]);
            audInfo.dir = visInfo.dir;
            % Start staircase on first coherence in cohSet
            visInfo.coh = visInfo.cohSet(staircase_index);
            audInfo.coh = audInfo.cohSet(staircase_index);
            if vel_stair == 1
                vel_index = 1;
                visInfo.vel = visInfo.velSet(vel_index);
                audInfo.vel = audInfo.velSet(vel_index);
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
                [visInfo, audInfo, staircase_index, vel_index] = staircase_procedure(trial_status, visInfo, audInfo, staircase_index, vel_stair, vel_index);
            else
                [visInfo, audInfo, staircase_index] = staircase_procedure(trial_status, visInfo, audInfo, staircase_index, vel_stair, vel_index);
            end
        end
    elseif task_nature == 2
        if ii == 1 && aud_vel ~= 0
            audInfo.vel = audInfo.velSet;
            audInfo.durRaw = audInfo.durSet;
            audInfo.snip_start = audInfo.snipSet(1);
            audInfo.snip_end = audInfo.snipSet(2);
        elseif ii == 1 && aud_vel == 0
            audInfo.durRaw = dur;
        end
        % Stimulus direction and coherence for a given trial is pre
        % determined via the output of at_generateMatrix.
        audInfo.dir = data_output(ii, 1);
        audInfo.coh = data_output(ii, 2);
        visInfo.dir = data_output(ii, 3);
        visInfo.coh = data_output(ii, 4);
    end

        % Necessary variable changing for RDK code. 1 = RIGHT, which is 0 
        % degrees on unit circle, 2 = LEFT, which is 180 degrees on unit circle
    if ~isnan(visInfo.dir) && ~isnan(visInfo.coh)
        visInfo = direction_conversion(visInfo);

        %% Create info matrix for Visual Stim. 
        % This dotInfo  output informs at_dotGenerate how to generate the RDK. 
        dotInfo = at_createDotInfo(inputtype, visInfo.coh, visInfo.dir, typeInt, ...
            minNum, maxNum, meanNum, maxdotsframe, dur, visInfo.vel, visInfo.displaceSet);
    end

    %% Keypress input initialize variables, define frames for presentation
    while KbCheck; end
    keycorrect = 0;
    keyisdown = 0;
    responded = 0; %DS mark as no response yet
    resp = nan; %default response is nan
    rt = nan; %default rt in case no response is recorded
    continue_show = round(dur*60);
    priorityLevel = MaxPriority(curWindow,'KbCheck'); %make sure Window commands are correct
    Priority(priorityLevel);

    % Create marker for EEG
    [markers] = at_generateMarkers(data_output, ii, EEG_nature, block);

    %% Dot Generation.
    % This function generates the dots that will be presented to
    % participant in accordance with their coherence, direction, and other dotInfo.
    if ~isnan(visInfo.dir) && ~isnan(visInfo.coh)
        [center, dotSize, d_ppd, ndots, dxdy, ss, Ls, continue_show] = at_generateDot(visInfo, dotInfo, screenInfo, screenRect, monWidth, viewDist, maxdotsframe, dur, curWindow, fix);
    end

    %% Generate auditory stimulus
    % Generates auditory stimulus
    frames = 0;
    if ~isnan(audInfo.dir) && ~isnan(audInfo.coh)
        % makeCAM and makeCAM_PILOT create an array voltages to be presented
        % via speakers that creates perceptual auditory motion from one speaker
        % to another
        CAM = makeCAM_PILOT(audInfo.coh, audInfo.dir, audInfo.durRaw, silence, Fs, noise_reduction_scalar, noise_jitter_nature);
        if audInfo.vel < audInfo.maxVel
            % snipCAM snips the CAM file so the duration stays constant and the
            % displacement is changed, dependent on the velocity of the trial
            CAM = snipCAM(CAM, Fs, audInfo.snip_start, audInfo.snip_end);
        end
        if noise_jitter_nature == 1
            jittertime = makeInterval(typeInt, minJitter, maxJitter, meanJitter);
            beforeCAM = makeCAM_PILOT(0, 0, jittertime, silence, Fs, noise_reduction_scalar, noise_jitter_nature);
            afterCAM = makeCAM_PILOT(0, 0, jittertime, silence, Fs, noise_reduction_scalar, noise_jitter_nature);
            wavedata = [beforeCAM, CAM, afterCAM];
        else
            wavedata = CAM;
        end
        nrchannels = size(wavedata,1); % Number of rows = number of channels.
    end

   %% AV Stimuli Presentation
    % This function uses psychtoolbox to present dots and auditory stimulus to participant.
    if ~isnan(visInfo.dir) && ~isnan(visInfo.coh) && ~isnan(audInfo.dir) && ~isnan(audInfo.coh)
        [resp, rt, start_time] = at_presentAV(continue_show, responded, resp, rt, curWindow, fix, frames, pahandle, wavedata, visInfo, dotInfo, center, dotSize, ...
            d_ppd, ndots, dxdy, ss, Ls, EEG_nature, outlet, markers);
    elseif isnan(visInfo.dir) && isnan(visInfo.coh) && ~isnan(audInfo.dir) && ~isnan(audInfo.coh)
        [resp, rt, start_time] = at_presentAud(continue_show, responded, resp, rt, curWindow, fix, frames, pahandle, wavedata, EEG_nature, outlet, markers);
    elseif ~isnan(visInfo.dir) && ~isnan(visInfo.coh) && isnan(audInfo.dir) && isnan(audInfo.coh)
        [resp, rt, start_time] = at_presentDot(visInfo, dotInfo, center, dotSize, ...
            d_ppd, ndots, dxdy, ss, Ls, continue_show, curWindow, fix, responded, resp, rt, EEG_nature, outlet, markers);
    end

    %% Erase last dots & go back to only plotting fixation
    Screen('DrawingFinished',curWindow);
    Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], fix, 1);
    Screen('Flip', curWindow,0);
    
    %%  ITI & response recording
    [resp, rt] = iti_response_recording(typeInt, minNum, maxNum, meanNum, dur, start_time, keyisdown, responded, resp, rt);
    
    %% Direction conversion
    if ~isnan(visInfo.dir) && ~isnan(visInfo.coh)
        visInfo = direction_conversion(visInfo);
    end

    %% Present slider
    if sliderResp_nature == 1
        if typeSlide == 1 % confidence slider
            sliderPrompt = 'How sure are you with your response?';
            sliderLowerText = 'Least';
            sliderUpperText = 'Most';
        elseif typeSlide == 2 % strength of motion slider
            sliderPrompt = 'How strongly did you perceive the motion?';
            sliderLowerText = 'No motion';
            sliderUpperText = 'Strongest motion percept';
        else
            sliderPrompt = '';
            sliderLowerText = '';
            sliderUpperText = '';
        end
        sliderResp = at_presentSlider(sliderPrompt, sliderLowerText, sliderUpperText, right_keypress, left_keypress, space_keypress, curWindow, cWhite0, xCenter, yCenter);
    end

    %% Save data into data_output on a trial by trial basis
    [trial_status, data_output] = record_AVdata(data_output, right_var, left_var, right_keypress, left_keypress, audInfo, visInfo, resp, rt, ii, vel_stair, interleave_nature, sliderResp);
    
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
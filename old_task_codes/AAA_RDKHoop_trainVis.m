%% VISUAL TRAINING %%%%%%%%%%
% written by Adam Tiesman 2/27/2023
clear;
close all;
%% FOR RESPONSE CODING: 1= RIGHTWARD MOTION ; 2=LEFTWARD MOTION
%%% define general variables
scriptdirectory = '/home/wallace/Human_AV_Motion';
localdirectory = '/home/wallace/Human_AV_Motion';
serverdirectory = '/home/wallace/Human_AV_Motion';
data_directory = '/home/wallace/Human_AV_Motion/data';
analysis_directory = '/home/wallace/Human_AV_Motion/Psychometric_Function_Plot';
cd(scriptdirectory)

%% general variables to smoothly run PTB
KbName('UnifyKeyNames');
AssertOpenGL;
%% define general values
inputtype=1; typeInt=1; minNum=1.5; maxNum=2.5; meanNum=2;

% Specify if you want data analysis
data_analysis = input('Data Analysis? 0 = NO, 1 = YES : ');

%% general stimlus variables
dur=.5; Fs=44100; triallength=2; nbblocks=2; silence=0.03; audtrials=20;
buffersize=(dur+silence)*Fs; s.Rate=44100;

% Define Stimulus repetitions
num_trials = 200;

% visual stimulus properties
% maxdotsframe=150; monWidth=42.5; viewDist =120;
maxdotsframe=150; monWidth=40; viewDist =120;

% training sound properties
correct_freq = 2000;
incorrect_freq = 800;
correct_sound = MakeBeep(correct_freq, (dur+silence), Fs);
corr_soundout = [correct_sound', correct_sound'];
corr_soundout = normalize(corr_soundout);
incorrect_sound = MakeBeep(incorrect_freq, (dur+silence), Fs);
incorr_soundout = [incorrect_sound', incorrect_sound'];
incorr_soundout = normalize(incorr_soundout);

% general drawing color
cWhite0=255;
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
filename = strcat('RDKHoop_trainVis',underscore,subjnum_s,underscore,group_s, underscore, sex_s, underscore, age_s);

cd(localdirectory)
% save(filename,'filename')
cd(scriptdirectory)

%% Initialize
curScreen=0;
% Screen('Preference', 'SkipSyncTests', 0);
Screen('Preference', 'SkipSyncTests', 1);
screenInfo = openExperiment(monWidth, viewDist, curScreen);
curWindow= screenInfo.curWindow;
screenRect= screenInfo.screenRect;
% Enable alpha blending with proper blend-function. We need it for drawing
% of smoothed points.
Screen('BlendFunction', curWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

%% Initialize Audio
PsychPortAudio('Close')
Screen('BlendFunction', curWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
InitializePsychSound;
pahandle = PsychPortAudio('Open', 5, [], 0, Fs, 2);

%% Welcome and Instrctions for the Suject
instructions_trainVis(curWindow, cWhite0, pahandle, corr_soundout, incorr_soundout);
%% Flip up fixation dot
fix=[screenRect(3)/2,screenRect(4)/2]; %define fix position of fix dot
Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], fix, 1);
Screen('Flip', curWindow,0);
WaitSecs(2); %wait for 2s

% Generate the list of possible coherences by decreasing log values
visInfo.cohStart = 1.0;
nlog_coh_steps = 24;
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

    %create info matrix from Visual Stim
    dotInfo = at_createDotInfo(inputtype, visInfo.coh, visInfo.dir, typeInt, minNum, maxNum, meanNum, maxdotsframe, dur);
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
    resp = nan; %default response is nan
    rt = nan; %default rt in case no response is recorded
    
    %% at_dotgen content
    Screen('Flip',curWindow,0);
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
        * [cos(pi*visInfo.dir/180.0) -sin(pi*visInfo.dir/180.0)], ndots,1);
    
    % ARRAYS, INDICES for loop
    ss = rand(ndots*3, 2); % array of dot positions raw [xposition, yposition]
    
    % Divide dots into three sets
    Ls = cumsum(ones(ndots,3)) + repmat([0 ndots ndots*2], ndots, 1);
    loopi = 1; % Loops through the three sets of dots
    
    % Show for how many frames
    continue_show = round(dur*monRefresh);
    
    priorityLevel = MaxPriority(curWindow,'KbCheck'); %make sure Window commands are correct
    Priority(priorityLevel);
    
    % THE MAIN LOOP
    frames = 0;
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
        L = rand(ndots,1) < visInfo.coh;
        this_s(L,:) = this_s(L,:) + dxdy(L,:);    % Offset the selected dots
        
        if sum(~L) > 0  % if not 100% coherence
            this_s(~L,:) = rand(sum(~L),2);    % get new random locations for the rest
        end
        
        % Wrap around - check to see if any positions are greater than one or
        % less than zero which is out of the aperture, and then replace with a
        % dot along one of the edges opposite from direction of motion.
        
        N = sum((this_s > 1 | this_s < 0)')' ~= 0;
        if sum(N) > 0
            xdir = sin(pi*visInfo.dir/180.0);
            ydir = cos(pi*visInfo.dir/180.0);
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
    if visInfo.dir == 0
        visInfo.dir = 1;
        data_output(ii, 1) = visInfo.dir; 
    elseif visInfo.dir == 180
        visInfo.dir = 2;
        data_output(ii, 1) = visInfo.dir;
    end
    data_output(ii, 2) = visInfo.coh;
    if resp == 115 || resp == 13
        data_output(ii, 3) = 1;
    elseif resp == 114 || resp == 12
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
        PsychPortAudio('FillBuffer', pahandle, corr_soundout')
        PsychPortAudio('Start', pahandle)
        data_output(ii, 6) = trial_status;
    else 
        trial_status = 0;
        PsychPortAudio('FillBuffer', pahandle, incorr_soundout')
        PsychPortAudio('Start', pahandle)
        data_output(ii, 6) = trial_status;
    end
    WaitSecs(1)
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
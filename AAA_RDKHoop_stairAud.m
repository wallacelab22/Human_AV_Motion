%% AUDITORY STAIRCASE TRAINING %%%%%%%%%%
% written by Adam Tiesman 2/27/2023
clear;
close all;
clc;
%% FOR RESPONSE CODING: 1= RIGHTWARD MOTION ; 2=LEFTWARD MOTION
% %% define general variables
% % directories used throughout the experment
scriptdirectory = 'C:\Users\Wallace Lab\Documents\MATLAB\Human_AV_Motion';
localdirectory = 'C:\Users\Wallace Lab\Documents\MATLAB\Human_AV_Motion';
serverdirectory = 'C:\Users\Wallace Lab\Documents\MATLAB\Human_AV_Motion';
data_directory = 'C:\Users\Wallace Lab\Documents\MATLAB\Human_AV_Motion\data\';
cd(scriptdirectory)

% % general variables to smoothly run PTB
 KbName('UnifyKeyNames');

%% define general values how long recording iTis for, might have been poisson distribution
inputtype=1; typeInt=1; minNum=1.5; maxNum=2.5; meanNum=2;

%% general stimlus variables duration of trial, trial length to keep it open for rt reasons, 
dur=.5; Fs=44100; triallength=2; nbblocks=2; silence=0.03; audtrials=20;
buffersize=(dur+silence)*Fs; s.Rate=44100; num_trials = 500;

% visual stimulus properties number of dots, viewing distance from monitor
maxdotsframe=150; monWidth=42.5; viewDist =120; cWhite0=255;

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

cd(localdirectory)
save(filename,'filename')
cd(scriptdirectory)

%% Initialize
curScreen=2;
Screen('Preference', 'SkipSyncTests', 1);
screenInfo = openExperiment(monWidth, viewDist, curScreen);
curWindow= screenInfo.curWindow;
screenRect= screenInfo.screenRect;
% Enable alpha blending with proper blend-function. We need it for drawing
% of smoothed points.

%% Initialize Audio
Screen('BlendFunction', curWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
InitializePsychSound;
pahandle = PsychPortAudio('Open', 4, [], 0, Fs, 2);

%% Welcome and Instrctions for the Suject
instructions_psyAud(curWindow, cWhite0);

%% Flip up fixation dot
fix=[screenRect(3)/2,screenRect(4)/2]; %define fix position of fix dot
Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], fix, 1);
Screen('Flip', curWindow,0);
s.NotifyWhenScansQueuedBelow = 22050;
WaitSecs(2); %wait for 2s

% Generate the list of possible coherences by decreasing log values
audInfo.cohStart = 0.5102;
nlog_coh_steps = 12;
nlog_division = 1.4;
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
        staircase_index = 1 % Start staircase on coherence of 1
        audInfo.dir = randi([1,2])
        audInfo.coh = audInfo.cohSet(staircase_index)
    elseif ii > 1
        [audInfo, staircase_index] = staircase_procedure(trial_status, audInfo, staircase_index)
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
    CAM=makeCAM(audInfo.coh, audInfo.dir, dur, silence, Fs);
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
    if resp == 39
        data_output(ii, 3)=1;
    elseif resp == 37
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

cd(localdirectory)
save([data_directory filename], 'data_output');

%% Goodbye
cont(curWindow, cWhite0);

%% Finalize
closeExperiment;
close all
Screen('CloseAll')

%% PLOT PSYCHOMETRIC FUNCTION
% Provide specific variables 
chosen_threshold = 0.72; % Ask Mark about threshold
right_var = 1;
left_var = 2;
catch_var = 0;

% Replace all the 0s to 3s for catch trials for splitapply
data_output(data_output(:, 1) == 0, 1) = 3; 

% Group trials based on stimulus direction--> 1 = right, 2 = left, 3 = catch
right_or_left = data_output(:, 1);
right_vs_left = splitapply(@(x){x}, data_output, right_or_left);

% Isolate coherences for right and left groups and catch
right_group = findgroups(right_vs_left{1,1}(:,2));
left_group = findgroups(right_vs_left{2,1}(:,2));
catch_group = findgroups(right_vs_left{3,1}(:,2));

%Initialize an empty array to store rightward_prob for all coherences
rightward_prob = [];

% Loop over each coherence level and extract the corresponding rows of the matrix for
% i = max(left_group):-1:1 for leftward trials
for i = max(left_group):-1:1
    group_rows = right_vs_left{2,1}(left_group == i, :);
    logical_array = group_rows(:, 3) == left_var;
    count = sum(logical_array);
    percentage = 1 - (count/ size(group_rows, 1));
    rightward_prob = [rightward_prob percentage];
end

% Add to the righward_prob vector the catch trials
group_rows = right_vs_left{3,1};
logical_array = group_rows(:, 3) == right_var;
count = sum(logical_array);
percentage = (count/ size(group_rows, 1));
rightward_prob = [rightward_prob percentage];

% Loop over each coherence level and extract the corresponding rows of the matrix for
% i = 1:max(right_group) for rightward trials
for i = 1:max(right_group)
    group_rows = right_vs_left{1,1}(right_group == i, :);
    logical_array = group_rows(:, 3) == right_var;
    count = sum(logical_array);
    percentage = count/ size(group_rows, 1);
    rightward_prob = [rightward_prob percentage];
end

% Display prob of right response at each coherence from -5 to 5 (neg being
% leftward trials and pos being rightward trials)
coherence_lvls = [-5, -4, -3, -2, -1, 0, 1, 2, 3 , 4, 5];
scatter(coherence_lvls, rightward_prob);

% Add title and labels to the x and y axis
xlabel('Coherence Level');
ylabel('Rightward Response Probability');
title('TEST Human Visual Psychometric Plot');

% Create a Normal Cumulative Distribution Function (NormCDF)
%
% X input : coherence_lvls
% Y input : rightward_prob
%
% Define the mean and standard deviation of the normal distribution
[xData, yData] = prepareCurveData(coherence_lvls, rightward_prob);

mu = mean(yData);
sigma = std(yData);
parms = [mu, sigma]

fun_1 = @(b, x)cdf('Normal', x, b(1), b(2));
fun = @(b)sum((fun_1(b,xData) - yData).^2); 
opts = optimset('MaxFunEvals',50000, 'MaxIter',10000); 
fit_par = fminsearch(fun, parms, opts);

x = -5:.01:5;

[p_values, bootstat, ci] = p_value_calc(yData, parms);

p = cdf('Normal', x, fit_par(1), fit_par(2));

threshold_location = find(p >= chosen_threshold, 1);
threshold = x(1, threshold_location);

% Plot fit with data.
fig = figure( 'Name', 'Psychometric Function' );
scatter(xData, yData)
hold on 
plot(x, p);
legend('% Rightward Resp. vs. Coherence', 'NormCDF', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
title(sprintf('Auditory Psych. Func. L&R\n%s',save_name), 'Interpreter','none');
xlabel( 'Coherence ((+)Rightward, (-)Leftward)', 'Interpreter', 'none' );
ylabel( '% Rightward Response', 'Interpreter', 'none' );
xlim([-1 1])
ylim([0 1])
grid on
text(0,.2,"p value for CDF coeffs. (mean): " + p_values(1))
text(0,.1, "p value for CDF coeffs. (std): " + p_values(2))


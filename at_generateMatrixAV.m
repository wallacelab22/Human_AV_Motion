function data_output = at_generateMatrixAV(catchtrials, congruent_mstrials, incongruent_mstrials, audInfo, visInfo, right_var, left_var, catch_var)
% Adam J. Tiesman - 7/17/23
% New, improved version of generated trial matrix.


% Define Stimulus repetitions
catchtrials=30; congruent_mstrials=18; incongruent_mstrials=2; audInfo.cohSet = [0.5 0.4 0.3 0.2 0.1 0.05]; right_var = 1; left_var = 2; catch_var = 0;

%% Fill single columns
% condition definitions 
% variable names: 1. modlaity (a, v, av), 2. direction (l:left; u:up),
% 3.coherence (l:low, m:middle, h:high or ordianl number codes)
% matrix values: auditory direction, auditory coherence, visual direction,
% visual coherence

% Catch trials
catchs = [catch_var catch_var catch_var catch_var];

% Stimulus [direction coherence]
% sr = stimulus rightl; sl = stimulus left
for i = 1:length(audInfo.cohSet)
    right_var_name = strcat('sr_cong', num2str(i));
    eval([right_var_name, ' = [right_var audInfo.cohSet(i) right_var audInfo.cohSet(i)];'])

    left_var_name = strcat('sl_cong', num2str(i));
    eval([left_var_name, ' = [left_var audInfo.cohSet(i)] left_var audInfo.cohSet;'])
end

for i = 1:length(audInfo.cohSet)
    right_var_name = strcat('sr_incong', num2str(i));
    eval([right_var_name, ' = [right_var audInfo.cohSet(i) left_var audInfo.cohSet(i)];'])

    left_var_name = strcat('sl_incong', num2str(i));
    eval([left_var_name, ' = [left_var audInfo.cohSet(i)] right_var audInfo.cohSet;'])
end

%% Create Matrices
% Catch trials
catchmat = repmat(catchs, catchtrials, 1);

% Stimulus trials
% Duplicate all stimulus conditions by how much stimtrials is. If
% stimtrials = 10, each stimulus condition (predefined above) will have 10
% repetitions.
cong_right_matrix = cell(length(stimInfo.cohSet), 1);
cong_left_matrix = cell(length(stimInfo.cohSet), 1);

for i = 1:length(stimInfo.cohSet)
    right_var_name = strcat('sr_cong', num2str(i));
    left_var_name = strcat('sl_cong', num2str(i));

    cong_right_matrix{i} = repmat(eval(right_var_name), congruent_mstrials, 1);
    cong_left_matrix{i} = repmat(eval(left_var_name), congruent_mstrials, 1);
end

incong_right_matrix = cell(length(stimInfo.cohSet), 1);
incong_left_matrix = cell(length(stimInfo.cohSet), 1);

for i = 1:length(stimInfo.cohSet)
    right_var_name = strcat('sr_incong', num2str(i));
    left_var_name = strcat('sl_incong', num2str(i));

    incong_right_matrix{i} = repmat(eval(right_var_name), incongruent_mstrials, 1);
    incong_left_matrix{i} = repmat(eval(left_var_name), incongruent_mstrials, 1);
end

% Concatenate all conditions into 1 big matrix (rightward trials, leftward
% trials, and catch trials)
for i = 1:numel(cong_right_matrix) % could also be left_matrix (they are same size)
    if i == 1
        trialStruc = cat(1, catchmat, cong_right_matrix{i}, cong_left_matrix{i}, incong_right_matrix{i}, incong_left_matrix{i});
    else
        trialStruc = cat(1, trialStruc, cong_right_matrix{i}, cong_left_matrix{i}, incong_right_matrix{i}, incong_left_matrix{i});
    end
end

%% Define single columns
% Add trial order and response recording columns to be filled as the task
% progresses
nbtrials = size(trialStruc(:,1));

resp = zeros(nbtrials(1), 1); % whether they responded left or right
rt = zeros(nbtrials(1), 1); % reaction time
keys = zeros(nbtrials(1), 1); % keypress value
trial_status = zeros(nbtrials(1), 1); % if trial was correct

%% Create trial structure
% Create a randomized order the trials will be presented to the participant
rng('shuffle');
order = randperm(nbtrials(1));  %new trial order
trialOrder = trialStruc(order, :);

data_output = cat(2, trialOrder, resp, rt, keys, trial_status);

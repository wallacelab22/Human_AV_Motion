function data_output = at_generateMatrix(catchtrials, stimtrials, audInfo, right_var, left_var, catch_var)
% Adam J. Tiesman - 7/17/23
% New, improved version of generated trial matrix.


%% Fill single columns
% condition definitions 
% variable names: 1. modlaity (a, v, av), 2. direction (l:left; u:up),
% 3.coherence (l:low, m:middle, h:high or ordianl number codes)
% matrix values: auditory direction, auditory coherence, visual direction,
% visual coherence

% Catch trials
catchs = [catch_var catch_var];

% Stimulus [direction coherence]
% sr = stimulus rightl; sl = stimulus left
for i = 1:length(audInfo.cohSet)
    right_var_name = strcat('sr', num2str(i));
    eval([right_var_name, ' = [right_var audInfo.cohSet(i)];'])

    left_var_name = strcat('sl', num2str(i));
    eval([left_var_name, ' = [left_var audInfo.cohSet(i)];'])
end

%% Create Matrices
% Catch trials
catchmat = repmat(catchs, catchtrials, 1);

% Stimulus trials
% Duplicate all stimulus conditions by how much stimtrials is. If
% stimtrials = 10, each stimulus condition (predefined above) will have 10
% repetitions.
right_matrix = cell(length(audInfo.cohSet), 1);
left_matrix = cell(length(audInfo.cohSet), 1);

for i = 1:length(audInfo.cohSet)
    right_var_name = strcat('sr', num2str(i));
    left_var_name = strcat('sl', num2str(i));

    right_matrix{i} = repmat(eval(right_var_name), stimtrials, 1);
    left_matrix{i} = repmat(eval(left_var_name), stimtrials, 1);
end

% Concatenate all conditions into 1 big matrix (rightward trials, leftward
% trials, and catch trials)
for i = 1:numel(right_matrix) % could also be left_matrix (they are same size)
    if i == 1
        trialStruc = cat(1, catchmat, right_matrix{i}, left_matrix{i});
    else
        trialStruc = cat(1, trialStruc, right_matrix{i}, left_matrix{i});
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

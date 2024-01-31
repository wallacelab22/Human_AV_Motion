function [data_output] = at_generateMatrixAV(catchtrials, congruent_mstrials, incongruent_mstrials, stimInfo, right_var, left_var, catch_var)
% Adam J. Tiesman - 7/17/23
% New, improved version of generated trial matrix.

% Catch trials
catchs = [catch_var, catch_var, catch_var, catch_var];
catchmat = repmat(catchs, catchtrials, 1);

% Prepare congruent and incongruent stimulus trials
AV_r_cong_trials = zeros(congruent_mstrials * length(stimInfo.cohSet), 4);
AV_l_cong_trials = zeros(congruent_mstrials * length(stimInfo.cohSet), 4);
AV_rA_incong_trials = zeros(incongruent_mstrials * length(stimInfo.cohSet), 4);
AV_lA_incong_trials = zeros(incongruent_mstrials * length(stimInfo.cohSet), 4);


% Populate congruent and incongruent trials
for i = 1:length(stimInfo.cohSet)
    coh = stimInfo.cohSet(i);
    
    % Congruent trials
    AV_r_cong_trials((i-1)*congruent_mstrials+1:i*congruent_mstrials, :) = [repmat([right_var, coh, right_var, coh], congruent_mstrials, 1)];
    AV_l_cong_trials((i-1)*congruent_mstrials+1:i*congruent_mstrials, :) = [repmat([left_var, coh, left_var, coh], congruent_mstrials, 1)];

    % Incongruent trials
    AV_rA_incong_trials((i-1)*incongruent_mstrials+1:i*incongruent_mstrials, :) = [repmat([right_var, coh, left_var, coh], incongruent_mstrials, 1)];
    AV_lA_incong_trials((i-1)*incongruent_mstrials+1:i*incongruent_mstrials, :) = [repmat([left_var, coh, right_var, coh], incongruent_mstrials, 1)];

end

% Combine all trial types
all_trials = [catchmat; AV_l_cong_trials; AV_r_cong_trials; AV_rA_incong_trials; AV_lA_incong_trials];

% Randomize trials
rng('shuffle');
nbtrials = size(all_trials, 1);
order = randperm(nbtrials);
trialOrder = all_trials(order, :);

% Prepare additional columns
resp = zeros(nbtrials, 1); % Response left or right
rt = zeros(nbtrials, 1); % Reaction time
keys = zeros(nbtrials, 1); % Keypress value
trial_status = zeros(nbtrials, 1); % Trial correctness

% Create final output matrix
data_output = [trialOrder, resp, rt, keys, trial_status];

end

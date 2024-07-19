function [data_output] = at_generateMatrixALL(catchtrials, congruent_mstrials, incongruent_mstrials, stimtrials, audInfo, visInfo, right_var, left_var, catch_var, cued_nature)
% Adam J. Tiesman - 1/24/24
% Revised version of the trial matrix generation script. Interleaves
% trials. Added code 7/18/24 that adds a cued variable to data_output

% Catch trials
catchs = [catch_var, catch_var, catch_var, catch_var];
catchmat = repmat(catchs, catchtrials, 1);

% Prepare congruent and incongruent stimulus trials
AV_r_cong_trials = zeros(congruent_mstrials * length(audInfo.cohSet), 4);
AV_l_cong_trials = zeros(congruent_mstrials * length(audInfo.cohSet), 4);
AV_rA_incong_trials = zeros(incongruent_mstrials * length(audInfo.cohSet), 4);
AV_lA_incong_trials = zeros(incongruent_mstrials * length(audInfo.cohSet), 4);
A_r_trials = zeros(stimtrials * length(audInfo.cohSet), 4);
A_l_trials = zeros(stimtrials * length(audInfo.cohSet), 4);
V_l_trials = zeros(stimtrials * length(visInfo.cohSet), 4);
V_r_trials = zeros(stimtrials * length(visInfo.cohSet), 4);

% Populate congruent and incongruent trials
for i = 1:length(audInfo.cohSet)
    cohAud = audInfo.cohSet(i);
    cohVis = visInfo.cohSet(i);

    % Congruent trials
    AV_r_cong_trials((i-1)*congruent_mstrials+1:i*congruent_mstrials, :) = [repmat([right_var, cohAud, right_var, cohVis], congruent_mstrials, 1)];
    AV_l_cong_trials((i-1)*congruent_mstrials+1:i*congruent_mstrials, :) = [repmat([left_var, cohAud, left_var, cohVis], congruent_mstrials, 1)];

    % Incongruent trials
    AV_rA_incong_trials((i-1)*incongruent_mstrials+1:i*incongruent_mstrials, :) = [repmat([right_var, cohAud, left_var, cohVis], incongruent_mstrials, 1)];
    AV_lA_incong_trials((i-1)*incongruent_mstrials+1:i*incongruent_mstrials, :) = [repmat([left_var, cohAud, right_var, cohVis], incongruent_mstrials, 1)];

    % Auditory only trials
    A_r_trials((i-1)*stimtrials+1:i*stimtrials, :) = [repmat([right_var, cohAud, NaN, NaN], stimtrials, 1)];
    A_l_trials((i-1)*stimtrials+1:i*stimtrials, :) = [repmat([left_var, cohAud, NaN, NaN], stimtrials, 1)];
    
    % Visual only trials
    V_r_trials((i-1)*stimtrials+1:i*stimtrials, :) = [repmat([NaN, NaN, right_var, cohVis], stimtrials, 1)];
    V_l_trials((i-1)*stimtrials+1:i*stimtrials, :) = [repmat([NaN, NaN, left_var, cohVis], stimtrials, 1)];
end

% Add the cued nature to each trial
if cued_nature
    auditory_cue = 1; visual_cue = 2; audiovisual_cue = 3; no_cue = 0;
    cues = [auditory_cue, visual_cue, audiovisual_cue, no_cue];
    catchmat(:, 5) = no_cue;
    AV_l_cong_loop_length = length(AV_l_cong_trials)/length(cues);
    for i = 1:AV_l_cong_loop_length
        AV_l_cong_trials(4*i-3,5) = auditory_cue;
        AV_l_cong_trials(4*i-2,5) = visual_cue;
        AV_l_cong_trials(4*i-1,5) = audiovisual_cue;
        AV_l_cong_trials(4*i,5) = no_cue;
    end
    AV_r_cong_loop_length = length(AV_r_cong_trials)/length(cues);
    for i = 1:AV_r_cong_loop_length
        AV_r_cong_trials(4*i-3,5) = auditory_cue;
        AV_r_cong_trials(4*i-2,5) = visual_cue;
        AV_r_cong_trials(4*i-1,5) = audiovisual_cue;
        AV_r_cong_trials(4*i,5) = no_cue;
    end
    AV_lA_incong_loop_length = length(AV_lA_incong_trials)/length(cues);
    for i = 1:AV_lA_incong_loop_length
        AV_lA_incong_trials(4*i-3,5) = auditory_cue;
        AV_lA_incong_trials(4*i-2,5) = visual_cue;
        AV_lA_incong_trials(4*i-1,5) = audiovisual_cue;
        AV_lA_incong_trials(4*i,5) = no_cue;
    end
    AV_rA_incong_loop_length = length(AV_rA_incong_trials)/length(cues);
    for i = 1:AV_rA_incong_loop_length
        AV_rA_incong_trials(4*i-3,5) = auditory_cue;
        AV_rA_incong_trials(4*i-2,5) = visual_cue;
        AV_rA_incong_trials(4*i-1,5) = audiovisual_cue;
        AV_rA_incong_trials(4*i,5) = no_cue;
    end
    A_l_trials(:, 5) = no_cue;
    A_r_trials(:, 5) = no_cue;
    V_l_trials(:, 5) = no_cue;
    V_r_trials(:, 5) = no_cue;
end

% Combine all trial types
all_trials = [catchmat; AV_l_cong_trials; AV_r_cong_trials; AV_rA_incong_trials; AV_lA_incong_trials; A_r_trials; A_l_trials; V_r_trials; V_l_trials];

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
if cued_nature
    data_output = [trialOrder(:,1:4), resp, rt, keys, trial_status, trialOrder(:,5)];
else
    data_output = [trialOrder, resp, rt, keys, trial_status];
end

%% Prior Trial History Analysis
clc
clear;
close all;

%% Load the data
%% USE YOUR OWN PATH FOR THESE THIS IS FOR MY PC %%%%%%%
script_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/data_analysis/'; %change
data_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/data/'; %change

%% Load the experimental data
subjnum = input('Enter the subject''s number: ');
subjnum_s = num2str(subjnum);
if length(subjnum_s) < 2
    subjnum_s = strcat(['0' subjnum_s]);
end
group = input('Enter the subject''s group: ');
group_s=num2str(group);
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

cd(data_file_directory)
psyAV_filename = sprintf('RDKHoop_psyAV_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
load(psyAV_filename)
cd(script_file_directory)

% Find unique coherence values (excluding zeros which represent no stimulus)
uniqueCoherences = unique(data_output(data_output(:,2) > 0, 2));
if length(uniqueCoherences) > 2
    error('More than two unique coherence levels found.');
end

% Auditory perf coherence
coherence1 = mode(data_output(:,2));
% Visual perf coherence
coherence2 = mode(data_output(:,4));

for trialType = 1:8
    switch trialType
        case 1 % Auditory only, coherence 1
            idx = data_output(:,2) == coherence1 & isnan(data_output(:,4));
            Aud_Only_trials = data_output(idx, :);
            Aud_priorTrials = zeros(length(Aud_Only_trials), 9);
%             for i = 1:length(Aud_Only_trials)
%                 currentTrial = Aud_Only_trials(i, :);
%                 Aud_priorTrials(i) = data_output(currentTrial-1, :);
%             end
        case 2 % Visual only, coherence 2
            idx = data_output(:,4) == coherence2 & isnan(data_output(:,2));
            Vis_Only_trials = data_output(idx, :);
        case 3 % Audiovisual, coherence 1 for auditory, coherence 2 for visual
            idx = data_output(:,2) == coherence1 & data_output(:,4) == coherence2;
            AV_Perf_trials = data_output(idx, :);
        case 4 % Audiovisual, coherence 1 for both
            idx = data_output(:,2) == coherence1 & data_output(:,4) == coherence1;
            Av_Stim_trials = data_output(idx, :);
        case 5 % Audiovisual, coherence 2 for both
            idx = data_output(:,2) == coherence2 & data_output(:,4) == coherence2;
            aV_Stim_trials = data_output(idx, :);
        case 6 % Auditory coherence with visual noise (visual coherence = 0)
            idx = data_output(:,2) > 0 & data_output(:,4) == 0; % Auditory coherence present, visual coherence is 0
            A_Vnoise_trials = data_output(idx, :);
        case 7 % Visual coherence with auditory noise (auditory coherence = 0)
            idx = data_output(:,4) > 0 & data_output(:,2) == 0; % Visual coherence present, auditory coherence is 0
            V_Anoise_trials = data_output(idx, :);
        case 8 % Catch trial
            idx = data_output(:,2) == 0 & data_output(:,4) == 0;
            Catch_trials = data_output(idx, :);
    end
end
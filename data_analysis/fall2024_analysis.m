%% Fall 2024 Cued + Incongruent Blocks Task
% 1st Block = stairAud w/ 30 reversals
% 2nd Block = stairVis w/ 30 reversals
% 3rd Block = psyAV cued Aud w/ 20 cong and 4 incong per condition
% 4th Block = psyAV cued Vis w/ 20 cong and 4 incong per condition
% 5th Block = psyAV cued AV w/ 20 cong and 4 incong per condition

% group = 26 --> 3rd block (cue Aud)
% group = 27 --> 4th block (cue Vis)
% group = 28 --> 5th block (cue AV)

clear;
close all;
clc;

A_and_V = 0;
RT_analysis = 1;
NO_cue = 0;

data_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/data/';
addpath('/Users/a.tiesman/Documents/Research/Human_AV_Motion/data_analysis/RSE-box-master/analysis')


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

data_to_load = [subjnum, group, sex, age];

includeAV = 1;
dataAll = loadParticipantData(data_to_load, data_file_directory, includeAV, 0);

dataALL{1}.dataRaw = dataAll{1}; %aud only
dataALL{2}.dataRaw = dataAll{2}; %vis only
if ~A_and_V
    dataALL{3}.dataRaw = dataAll{3}; %av
    dataAV = dataALL{3}.dataRaw;
end


dataAud = dataALL{1}.dataRaw;
dataVis = dataALL{2}.dataRaw;

%% Load the rest
dataAudCuedAV = dataALL{3}.dataRaw;

viscue_data_to_load = [subjnum, group+1, sex, age];
dataVisCuedAV = loadParticipantData(viscue_data_to_load, data_file_directory, 1, 1);
dataALL{4}.dataRaw = dataVisCuedAV{3};

avcue_data_to_load = [subjnum, group+2, sex, age];
dataAVCuedAV = loadParticipantData(avcue_data_to_load, data_file_directory, 1, 1);
dataALL{5}.dataRaw = dataAVCuedAV{3};

nocue_data_to_load = [subjnum, group+3, sex, age];
dataAVCuedNO = loadParticipantData(nocue_data_to_load, data_file_directory, 1, 1);
dataALL{6}.dataRaw = dataAVCuedNO{3};

for i = 1:size(dataALL, 2)
    if i == 1
        right_var = 1;
        left_var = 2;
        catch_var = 0;
        chosen_threshold = 0.72;
        compare_plot = 0;
        vel_stair = 0;

        fig = figure('Name', sprintf('%d_%d CDF Comparison ', subjnum, group));
    end
   save_name = sprintf('%d_%d', subjnum, group);
%     if i == 3
%       % Replace all the 0s to 3s for catch trials for splitapply
%         dataALL{i+2}.dataRaw(dataALL{i+2}.dataRaw(:, 1) == 0, 1) = 3;
%         dataALL{i+2}.dataRaw(dataALL{i+2}.dataRaw(:, 3) == 0, 1) = 3;
%         
%         % Extract and separate AV congruent trials from AV incongruent trials
%         idx = dataALL{i+2}.dataRaw(:, 1) == dataALL{i+2}.dataRaw(:, 3);
%         congruent_trials = dataALL{i+2}.dataRaw(idx, :);
%         incongruent_trials = dataALL{i+2}.dataRaw(~idx, :);
%         
%         % Group AV congruent trials based on stimulus direction --> 1 = right,
%         % 2 = left, and 3 = catch
%         [groups, values] = findgroups(congruent_trials(:, 1));
%         
%         % Create a cell with 3 groups based on stimulus direction
%         stimulus_direction = cell(numel(values), 1);
%         for k = 1:numel(values)
%             idx = groups == k;
%             matrix = congruent_trials(idx, :);
%             stimulus_direction{k} = matrix;
%         end
%         
%         % Group trials again based on AUDITORY coherence for AV congruent 
%         % RIGHTWARD motion --> 1 = lowest coherence, 7 = highest coherence
%         [groups, values] = findgroups(stimulus_direction{1,1}(:, 2));
%         
%         % Create a cell with 7 groups based on AUDITORY coherence for AV congruent
%         % RIGHTWARD motion
%         right_auditory_coherence = cell(numel(values), 1);
%         for k = 1:numel(values)
%             idx = groups == k;
%             matrix = stimulus_direction{1,1}(idx, :);
%             right_auditory_coherence{k} = matrix;
%         end
%         
%         % Group trials again based on AUDITORY coherence for LEFTWARD motion --> 
%         % 1 = lowest coherence, 5 = highest coherence
%         [groups, values] = findgroups(stimulus_direction{2,1}(:, 2));
%         
%         % Create a cell with 5 groups based on AUDITORY coherence for AV congruent 
%         % LEFTWARD motion
%         left_auditory_coherence = cell(numel(values), 1);
%         for k = 1:numel(values)
%             idx = groups == k;
%             matrix = stimulus_direction{2,1}(idx, :);
%             left_auditory_coherence{k} = matrix;
%         end
%         % Initialize an empty arrays to store rightward_prob for all coherences at
%         % varying auditory coherences
%         
%         right_group = findgroups(stimulus_direction{1,1}(:,2));
%         left_group = findgroups(stimulus_direction{2,1}(:,2));
%         
%         rightward_prob = multisensory_rightward_prob_calc(stimulus_direction, right_group, left_group, right_var, left_var);
%         
%         % Create vector of coherence levels
%         right_coh_vals = stimulus_direction{1,1}(:,2);
%         left_coh_vals = -stimulus_direction{2,1}(:,2);
%         combined_coh = [right_coh_vals; left_coh_vals];
%         if size(stimulus_direction, 1) >= 3 && size(stimulus_direction{3,1}, 2) >= 2
%             combined_coh = [right_coh_vals; left_coh_vals; 0];
%         end
%         coherence_lvls = sort(combined_coh, 'ascend');
%         coherence_lvls = unique(coherence_lvls, 'stable');
%         coherence_lvls = coherence_lvls';
%         [fig, p_values, ci, threshold, dataALL{i+2}.xData, dataALL{i+2}.yData, x, p, sz, dataALL{i+2}.std_gaussian, dataALL{i+2}.mdl] = normCDF_plotter(coherence_lvls, ...
%             rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
%             coherence_frequency, compare_plot, save_name, vel_stair);
%         scatter(dataALL{i+2}.xData, dataALL{i+2}.yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', '#009304', 'HandleVisibility', 'off');
%         hold on
%         plot(x, p, 'LineWidth', 3, 'Color', '#009304', 'DisplayName', 'Audiovisual');
    if i == 1 || i == 2
        save_name = 'stair';
        dataALL{i}.dataRaw(dataALL{i}.dataRaw(:, 1) == 0, 1) = 3; 
        [right_vs_left, right_group, left_group] = direction_plotter(dataALL{i}.dataRaw);
        rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
        [total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, coherence_counts, coherence_frequency] = frequency_plotter(dataALL{i}.dataRaw, right_vs_left);
        [fig, p_values, ci, threshold, dataALL{i}.xData, dataALL{i}.yData, x, p, sz, dataALL{i}.std_gaussian, dataALL{i}.mdl] = normCDF_plotter(coherence_lvls, ...
        rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
        coherence_frequency, compare_plot, save_name, vel_stair);    
        if i == 1
            scatter(dataALL{i}.xData, dataALL{i}.yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', '#d73027', 'HandleVisibility', 'off');
            hold on
            plot(x, p, 'LineWidth', 3, 'Color', '#d73027', 'DisplayName', 'Auditory Only');
        elseif i == 2
            scatter(dataALL{i}.xData, dataALL{i}.yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', '#4575b4', 'HandleVisibility', 'off');
            hold on
            plot(x, p, 'LineWidth', 3, 'Color', '#4575b4', 'DisplayName', 'Visual Only');
        end
        save_name = sprintf('%d_%d', subjnum, group);
    end
end

%% Set figure properties
title(sprintf('Psych. Function Comparison: \n %s', save_name), 'Interpreter','none');
legend('Location', 'NorthWest', 'Interpreter', 'none');
xlabel( 'Coherence ((-)Leftward, (+)Rightward)', 'Interpreter', 'none');
ylabel( 'Proportion Rightward Response', 'Interpreter', 'none');
xlim([-1 1])
ylim([0 1])
grid on
% text(0,0.2,"aud sensitivity: " + dataALL{1}.std_gaussian)
% text(0,0.15,"vis sensitivity: " + dataALL{2}.std_gaussian)
% if ~A_and_V
%     text(0,0.1,"av sensitivity: " + dataALL{5}.std_gaussian)
% end
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
beautifyplot;

%% Plot Unisensory Auditory vs Auditory Cued AV
figure;
hold on;

% Unisensory Auditory
save_name = 'stair';
dataAud = dataALL{1}.dataRaw;
[right_vs_left_aud, right_group_aud, left_group_aud] = direction_plotter(dataAud);
rightward_prob_aud = unisensory_rightward_prob_calc(right_vs_left_aud, right_group_aud, left_group_aud, right_var, left_var);
[total_coh_frequency_aud, left_coh_vals_aud, right_coh_vals_aud, coherence_lvls_aud, coherence_counts_aud, coherence_frequency_aud] = frequency_plotter(dataAud, right_vs_left_aud);
[fig, p_values_aud, ci_aud, threshold_aud, xData_aud, yData_aud, x_aud, p_aud, sz_aud, std_gaussian_aud, mdl_aud] = normCDF_plotter(coherence_lvls_aud, rightward_prob_aud, chosen_threshold, left_coh_vals_aud, right_coh_vals_aud, coherence_frequency_aud, compare_plot, save_name, vel_stair);
scatter(xData_aud, yData_aud, sz_aud, 'LineWidth', 2, 'MarkerEdgeColor', '#d73027', 'HandleVisibility', 'off');
plot(x_aud, p_aud, 'LineWidth', 3, 'Color', '#d73027', 'DisplayName', 'Auditory Only');
save_name = sprintf('%d_%d', subjnum, group);

% Auditory Cued AV
dataAudCuedAV = dataALL{3}.dataRaw;

% Replace all the 0s to 3s for catch trials for splitapply
dataALL{3}.dataRaw(dataALL{3}.dataRaw(:, 1) == 0, 1) = 3;
dataALL{3}.dataRaw(dataALL{3}.dataRaw(:, 3) == 0, 1) = 3;

% Extract and separate AV congruent trials from AV incongruent trials
idx = dataALL{3}.dataRaw(:, 1) == dataALL{3}.dataRaw(:, 3);
congruent_trials = dataALL{3}.dataRaw(idx, :);
incongruent_trials = dataALL{3}.dataRaw(~idx, :);

% Group AV congruent trials based on stimulus direction --> 1 = right,
% 2 = left, and 3 = catch
[groups, values] = findgroups(congruent_trials(:, 1));

% Create a cell with 3 groups based on stimulus direction
stimulus_direction = cell(numel(values), 1);
for k = 1:numel(values)
    idx = groups == k;
    matrix = congruent_trials(idx, :);
    stimulus_direction{k} = matrix;
end

% Group trials again based on AUDITORY coherence for AV congruent 
% RIGHTWARD motion --> 1 = lowest coherence, 7 = highest coherence
[groups, values] = findgroups(stimulus_direction{1,1}(:, 2));

% Create a cell with 7 groups based on AUDITORY coherence for AV congruent
% RIGHTWARD motion
right_auditory_coherence = cell(numel(values), 1);
for k = 1:numel(values)
    idx = groups == k;
    matrix = stimulus_direction{1,1}(idx, :);
    right_auditory_coherence{k} = matrix;
end

% Group trials again based on AUDITORY coherence for LEFTWARD motion --> 
% 1 = lowest coherence, 5 = highest coherence
[groups, values] = findgroups(stimulus_direction{2,1}(:, 2));

% Create a cell with 5 groups based on AUDITORY coherence for AV congruent 
% LEFTWARD motion
left_auditory_coherence = cell(numel(values), 1);
for k = 1:numel(values)
    idx = groups == k;
    matrix = stimulus_direction{2,1}(idx, :);
    left_auditory_coherence{k} = matrix;
end
% Initialize an empty arrays to store rightward_prob for all coherences at
% varying auditory coherences

right_group = findgroups(stimulus_direction{1,1}(:,2));
left_group = findgroups(stimulus_direction{2,1}(:,2));

rightward_prob = multisensory_rightward_prob_calc(stimulus_direction, right_group, left_group, right_var, left_var);

% Create vector of coherence levels
right_coh_vals = stimulus_direction{1,1}(:,2);
left_coh_vals = -stimulus_direction{2,1}(:,2);
combined_coh = [right_coh_vals; left_coh_vals];
if size(stimulus_direction, 1) >= 3 && size(stimulus_direction{3,1}, 2) >= 2
    combined_coh = [right_coh_vals; left_coh_vals; 0];
end
coherence_lvls = sort(combined_coh, 'ascend');
coherence_lvls = unique(coherence_lvls, 'stable');
coherence_lvls = coherence_lvls';
[fig, p_values, ci, threshold, dataALL{3}.xData, dataALL{3}.yData, x_cueAud, p_cueAud, sz_cueAud, dataALL{3}.std_gaussian, dataALL{3}.mdl] = normCDF_plotter(coherence_lvls, ...
    rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
    coherence_frequency, compare_plot, save_name, vel_stair);
scatter(dataALL{3}.xData, dataALL{3}.yData, sz_cueAud, 'LineWidth', 2, 'MarkerEdgeColor', 'k', 'HandleVisibility', 'off');
hold on
plot(x_cueAud, p_cueAud, 'LineWidth', 3, 'Color', 'k', 'DisplayName', 'AV Aud Cue');

% Set figure properties
title('Unisensory Auditory vs Auditory Cued AV');
legend('Location', 'NorthWest');
xlabel('Coherence ((-)Leftward, (+)Rightward)');
ylabel('Proportion Rightward Response');
xlim([-1 1])
ylim([0 1])
grid on
%text(0,0.2,"aud only std: " + dataALL{1}.std_gaussian)
%text(0,0.15,"av cue aud std: " + dataALL{3}.std_gaussian)
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
beautifyplot;

%% Plot Unisensory Visual vs Visual Cued AV
figure;
hold on;

% Unisensory Visual
save_name = 'stair';
dataVis = dataALL{2}.dataRaw;
[right_vs_left_vis, right_group_vis, left_group_vis] = direction_plotter(dataVis);
rightward_prob_vis = unisensory_rightward_prob_calc(right_vs_left_vis, right_group_vis, left_group_vis, right_var, left_var);
[total_coh_frequency_vis, left_coh_vals_vis, right_coh_vals_vis, coherence_lvls_vis, coherence_counts_vis, coherence_frequency_vis] = frequency_plotter(dataVis, right_vs_left_vis);
[fig, p_values_vis, ci_vis, threshold_vis, xData_vis, yData_vis, x_vis, p_vis, sz_vis, std_gaussian_vis, mdl_vis] = normCDF_plotter(coherence_lvls_vis, rightward_prob_vis, chosen_threshold, left_coh_vals_vis, right_coh_vals_vis, coherence_frequency_vis, compare_plot, save_name, vel_stair);
scatter(xData_vis, yData_vis, sz_vis, 'LineWidth', 2, 'MarkerEdgeColor', '#4575b4', 'HandleVisibility', 'off');
plot(x_vis, p_vis, 'LineWidth', 3, 'Color', '#4575b4', 'DisplayName', 'Visual Only');
save_name = sprintf('%d_%d', subjnum, group);

% Replace all the 0s to 3s for catch trials for splitapply
dataALL{4}.dataRaw(dataALL{4}.dataRaw(:, 1) == 0, 1) = 3;
dataALL{4}.dataRaw(dataALL{4}.dataRaw(:, 3) == 0, 1) = 3;

% Extract and separate AV congruent trials from AV incongruent trials
idx = dataALL{4}.dataRaw(:, 1) == dataALL{4}.dataRaw(:, 3);
congruent_trials = dataALL{4}.dataRaw(idx, :);
incongruent_trials = dataALL{4}.dataRaw(~idx, :);

% Group AV congruent trials based on stimulus direction --> 1 = right,
% 2 = left, and 3 = catch
[groups, values] = findgroups(congruent_trials(:, 1));

% Create a cell with 3 groups based on stimulus direction
stimulus_direction = cell(numel(values), 1);
for k = 1:numel(values)
    idx = groups == k;
    matrix = congruent_trials(idx, :);
    stimulus_direction{k} = matrix;
end

% Group trials again based on AUDITORY coherence for AV congruent 
% RIGHTWARD motion --> 1 = lowest coherence, 7 = highest coherence
[groups, values] = findgroups(stimulus_direction{1,1}(:, 2));

% Create a cell with 7 groups based on AUDITORY coherence for AV congruent
% RIGHTWARD motion
right_auditory_coherence = cell(numel(values), 1);
for k = 1:numel(values)
    idx = groups == k;
    matrix = stimulus_direction{1,1}(idx, :);
    right_auditory_coherence{k} = matrix;
end

% Group trials again based on AUDITORY coherence for LEFTWARD motion --> 
% 1 = lowest coherence, 5 = highest coherence
[groups, values] = findgroups(stimulus_direction{2,1}(:, 2));

% Create a cell with 5 groups based on AUDITORY coherence for AV congruent 
% LEFTWARD motion
left_auditory_coherence = cell(numel(values), 1);
for k = 1:numel(values)
    idx = groups == k;
    matrix = stimulus_direction{2,1}(idx, :);
    left_auditory_coherence{k} = matrix;
end
% Initialize an empty arrays to store rightward_prob for all coherences at
% varying auditory coherences

right_group = findgroups(stimulus_direction{1,1}(:,2));
left_group = findgroups(stimulus_direction{2,1}(:,2));

rightward_prob = multisensory_rightward_prob_calc(stimulus_direction, right_group, left_group, right_var, left_var);

% Create vector of coherence levels
right_coh_vals = stimulus_direction{1,1}(:,2);
left_coh_vals = -stimulus_direction{2,1}(:,2);
combined_coh = [right_coh_vals; left_coh_vals];
if size(stimulus_direction, 1) >= 3 && size(stimulus_direction{3,1}, 2) >= 2
    combined_coh = [right_coh_vals; left_coh_vals; 0];
end
coherence_lvls = sort(combined_coh, 'ascend');
coherence_lvls = unique(coherence_lvls, 'stable');
coherence_lvls = coherence_lvls';
[fig, p_values, ci, threshold, dataALL{4}.xData, dataALL{4}.yData, x_cueVis, p_cueVis, sz_cueVis, dataALL{4}.std_gaussian, dataALL{4}.mdl] = normCDF_plotter(coherence_lvls, ...
    rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
    coherence_frequency, compare_plot, save_name, vel_stair);
scatter(dataALL{4}.xData, dataALL{4}.yData, sz_cueVis, 'LineWidth', 2, 'MarkerEdgeColor', 'k', 'HandleVisibility', 'off');
hold on
plot(x_cueVis, p_cueVis, 'LineWidth', 3, 'Color', 'k', 'DisplayName', 'AV Vis Cue');
% Set figure properties
title('Unisensory Visual vs Visual Cued AV');
legend('Location', 'NorthWest');
xlabel('Coherence ((-)Leftward, (+)Rightward)');
ylabel('Proportion Rightward Response');
xlim([-1 1])
ylim([0 1])
grid on
%text(0,0.2,"vis only std: " + dataALL{2}.std_gaussian)
%text(0,0.15,"av cue vis std: " + dataALL{4}.std_gaussian)
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
beautifyplot;

%% Plot all AV Cue Trials
% Number of cue types and coherence levels
numCueTypes = 3;
numCoherenceLevels = 4;

% Create a figure for the CDF plots
figure;
hold on;

% Define colors for the different cue types
cued_colors = ['#d73027'; '#4575b4'; '#009304'; '#fee090']; % red, blue, green, orange

% Define cue labels
cue_labels = {'Aud Cue', 'Vis Cue', 'AV Cue', 'NO Cue'};

% % Combine data for each cue type
% dataALL{3}.dataRaw = vertcat(dataAud_cue{:});
% dataALL{4}.dataRaw = vertcat(dataVis_cue{:});
% dataALL{5}.dataRaw = vertcat(dataAV_cue{:});

% Loop through each cue type to plot their CDFs
incongruent_trials = cell(3,1);
if NO_cue
    num_AVcuedblocks = 4;
else
    num_AVcuedblocks = 3;
end

for i = 1:num_AVcuedblocks

    % Replace all the 0s to 3s for catch trials for splitapply
    dataALL{i+2}.dataRaw(dataALL{i+2}.dataRaw(:, 1) == 0, 1) = 3;
    dataALL{i+2}.dataRaw(dataALL{i+2}.dataRaw(:, 3) == 0, 1) = 3;
    dataALL{i+2}.dataRaw(dataALL{i+2}.dataRaw(:, 3) == 0, 3) = 3;
    dataALL{i+2}.dataRaw(dataALL{i+2}.dataRaw(:, 3) == 0, 3) = 3;

    
    % Extract and separate AV congruent trials from AV incongruent trials
    idx = dataALL{i+2}.dataRaw(:, 1) == dataALL{i+2}.dataRaw(:, 3);
    congruent_trials = dataALL{i+2}.dataRaw(idx, :);
    incongruent_trials{i}.dataRaw = dataALL{i+2}.dataRaw(~idx, :);
    
    % Group AV congruent trials based on stimulus direction --> 1 = right,
    % 2 = left, and 3 = catch
    [groups, values] = findgroups(congruent_trials(:, 1));
    
    % Create a cell with 3 groups based on stimulus direction
    stimulus_direction = cell(numel(values), 1);
    for k = 1:numel(values)
        idx = groups == k;
        matrix = congruent_trials(idx, :);
        stimulus_direction{k} = matrix;
    end
    
    % Group trials again based on AUDITORY coherence for AV congruent 
    % RIGHTWARD motion --> 1 = lowest coherence, 7 = highest coherence
    [groups, values] = findgroups(stimulus_direction{1,1}(:, 2));
    
    % Create a cell with 7 groups based on AUDITORY coherence for AV congruent
    % RIGHTWARD motion
    right_auditory_coherence = cell(numel(values), 1);
    for k = 1:numel(values)
        idx = groups == k;
        matrix = stimulus_direction{1,1}(idx, :);
        right_auditory_coherence{k} = matrix;
    end
    
    % Group trials again based on AUDITORY coherence for LEFTWARD motion --> 
    % 1 = lowest coherence, 5 = highest coherence
    [groups, values] = findgroups(stimulus_direction{2,1}(:, 2));
    
    % Create a cell with 5 groups based on AUDITORY coherence for AV congruent 
    % LEFTWARD motion
    left_auditory_coherence = cell(numel(values), 1);
    for k = 1:numel(values)
        idx = groups == k;
        matrix = stimulus_direction{2,1}(idx, :);
        left_auditory_coherence{k} = matrix;
    end
    % Initialize an empty arrays to store rightward_prob for all coherences at
    % varying auditory coherences
    
    right_group = findgroups(stimulus_direction{1,1}(:,2));
    left_group = findgroups(stimulus_direction{2,1}(:,2));
    
    rightward_prob = multisensory_rightward_prob_calc(stimulus_direction, right_group, left_group, right_var, left_var);
    
    % Create vector of coherence levels
    right_coh_vals = stimulus_direction{1,1}(:,2);
    left_coh_vals = -stimulus_direction{2,1}(:,2);
    combined_coh = [right_coh_vals; left_coh_vals];
    if size(stimulus_direction, 1) >= 3 && size(stimulus_direction{3,1}, 2) >= 2
        combined_coh = [right_coh_vals; left_coh_vals; 0];
    end
    coherence_lvls = sort(combined_coh, 'ascend');
    coherence_lvls = unique(coherence_lvls, 'stable');
    coherence_lvls = coherence_lvls';
    [fig, p_values, ci, threshold, dataALL{i+2}.xData, dataALL{i+2}.yData, x, p, sz, dataALL{i+2}.std_gaussian, dataALL{i+2}.mdl] = normCDF_plotter(coherence_lvls, ...
        rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
        coherence_frequency, compare_plot, save_name, vel_stair);
    
    % Plot the CDF for each cue type on the same figure
    scatter(dataALL{i+2}.xData, dataALL{i+2}.yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', cued_colors(i, :), 'HandleVisibility', 'off');
    hold on
    plot(x, p, 'LineWidth', 3, 'Color', cued_colors(i, :), 'DisplayName', cue_labels{i});
    hold on
end

% Set figure properties
title('All AV Trials Sorted by Cue Type', 'Interpreter', 'none');
legend('Location', 'NorthWest', 'Interpreter', 'none');
xlabel('Coherence ((-)Leftward, (+)Rightward)', 'Interpreter', 'none');
ylabel('Proportion Rightward Response', 'Interpreter', 'none');
xlim([-1 1])
ylim([0 1])
grid on
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)

% Add text annotations for sensitivity
% text(0, 0.26, "aud std: " + dataALL{3}.std_gaussian);
% text(0, 0.185, "vis std: " + dataALL{4}.std_gaussian);
% text(0, 0.125, "av std: " + dataALL{5}.std_gaussian);
% if NO_cue
%     text(0, 0.065, "no cue std: " + dataALL{6}.std_gaussian);
% end
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
beautifyplot;

data_cueAud_incong = incongruent_trials{1}.dataRaw;
data_cueVis_incong = incongruent_trials{2}.dataRaw;
data_cueAV_incong = incongruent_trials{3}.dataRaw;

%% Plot Congruent Auditory Cued AV vs Incong Auditory Cued AV
figure;
hold on;

scatter(xData_aud, yData_aud, sz_aud, 'LineWidth', 2, 'MarkerEdgeColor', '#d73027', 'HandleVisibility', 'off');
hold on;
plot(x_aud, p_aud, 'LineWidth', 3, 'Color', '#d73027', 'DisplayName', 'Auditory Only');

scatter(dataALL{3}.xData, dataALL{3}.yData, sz_cueAud, 'LineWidth', 2, 'MarkerEdgeColor', 'k', 'HandleVisibility', 'off');
hold on;
plot(x_cueAud, p_cueAud, 'LineWidth', 3, 'Color', 'k', 'DisplayName', 'Congruent AV');

% Group AV incongruent trials based on AUD stimulus direction --> 1 = right,
% 2 = left, and 3 = catch
[groups, values] = findgroups(incongruent_trials{1}.dataRaw(:, 1));

% Create a cell with 3 groups based on stimulus direction
stimulus_direction = cell(numel(values), 1);
for k = 1:numel(values)
    idx = groups == k;
    matrix = incongruent_trials{1}.dataRaw(idx, :);
    stimulus_direction{k} = matrix;
end

% Group trials again based on AUDITORY coherence for AV incongruent 
% RIGHTWARD motion --> 1 = lowest coherence, 7 = highest coherence
[groups, values] = findgroups(stimulus_direction{1,1}(:, 2));

% Create a cell with 7 groups based on AUDITORY coherence for AV congruent
% RIGHTWARD motion
right_auditory_coherence = cell(numel(values), 1);
for k = 1:numel(values)
    idx = groups == k;
    matrix = stimulus_direction{1,1}(idx, :);
    right_auditory_coherence{k} = matrix;
end

% Group trials again based on AUDITORY coherence for LEFTWARD motion --> 
% 1 = lowest coherence, 5 = highest coherence
[groups, values] = findgroups(stimulus_direction{2,1}(:, 2));

% Create a cell with 5 groups based on AUDITORY coherence for AV congruent 
% LEFTWARD motion
left_auditory_coherence = cell(numel(values), 1);
for k = 1:numel(values)
    idx = groups == k;
    matrix = stimulus_direction{2,1}(idx, :);
    left_auditory_coherence{k} = matrix;
end
% Initialize an empty arrays to store rightward_prob for all coherences at
% varying auditory coherences

right_group = findgroups(stimulus_direction{1,1}(:,2));
left_group = findgroups(stimulus_direction{2,1}(:,2));

rightward_prob = multisensory_rightward_prob_calc(stimulus_direction, right_group, left_group, right_var, left_var);

% Create vector of coherence levels
right_coh_vals = stimulus_direction{1,1}(:,2);
left_coh_vals = -stimulus_direction{2,1}(:,2);
combined_coh = [right_coh_vals; left_coh_vals];
if size(stimulus_direction, 1) >= 3 && size(stimulus_direction{3,1}, 2) >= 2
    combined_coh = [right_coh_vals; left_coh_vals; 0];
end
coherence_lvls = sort(combined_coh, 'ascend');
coherence_lvls = unique(coherence_lvls, 'stable');
coherence_lvls = coherence_lvls';
[fig, p_values, ci, threshold, incongruent_trials{1}.xData, incongruent_trials{1}.yData, x, p, sz, incongruent_trials{1}.std_gaussian, incongruent_trials{1}.mdl] = normCDF_plotter(coherence_lvls, ...
    rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
    coherence_frequency, compare_plot, save_name, vel_stair);
scatter(incongruent_trials{1}.xData, incongruent_trials{1}.yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', '#fee090', 'HandleVisibility', 'off');

hold on
plot(x, p, 'LineWidth', 3, 'Color', '#fee090', 'DisplayName', 'Incongruent AV');
% Set figure properties
title('AV Cued Aud');
legend('Location', 'NorthWest');
xlabel('Coherence ((-)Leftward, (+)Rightward)');
ylabel('Proportion Rightward Response');
xlim([-1 1])
ylim([0 1])
grid on
% text(0,0.2,"aud only std: " + dataALL{1}.std_gaussian)
% text(0,0.15,"cong av cue aud std: " + dataALL{3}.std_gaussian)
% text(0,0.10,"incong av cue aud std: " + incongruent_trials{1}.std_gaussian)
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
beautifyplot;

%% Plot Congruent Visual Cued AV vs Incong Visual Cued AV
figure;
hold on;

scatter(xData_vis, yData_vis, sz_vis, 'LineWidth', 2, 'MarkerEdgeColor', '#4575b4', 'HandleVisibility', 'off');
hold on;
plot(x_vis, p_vis, 'LineWidth', 3, 'Color', '#4575b4', 'DisplayName', 'Visual Only');

scatter(dataALL{4}.xData, dataALL{4}.yData, sz_cueVis, 'LineWidth', 2, 'MarkerEdgeColor', 'k', 'HandleVisibility', 'off');
hold on;
plot(x_cueVis, p_cueVis, 'LineWidth', 3, 'Color', 'k', 'DisplayName', 'Congruent AV');

% Group AV incongruent trials based on VIS stimulus direction --> 1 = right,
% 2 = left, and 3 = catch
[groups, values] = findgroups(incongruent_trials{2}.dataRaw(:, 3));

% Create a cell with 3 groups based on stimulus direction
stimulus_direction = cell(numel(values), 1);
for k = 1:numel(values)
    idx = groups == k;
    matrix = incongruent_trials{2}.dataRaw(idx, :);
    stimulus_direction{k} = matrix;
end

% Group trials again based on AUDITORY coherence for AV incongruent 
% RIGHTWARD motion --> 1 = lowest coherence, 7 = highest coherence
[groups, values] = findgroups(stimulus_direction{1,1}(:, 4));

% Create a cell with 7 groups based on AUDITORY coherence for AV congruent
% RIGHTWARD motion
right_auditory_coherence = cell(numel(values), 1);
for k = 1:numel(values)
    idx = groups == k;
    matrix = stimulus_direction{1,1}(idx, :);
    right_auditory_coherence{k} = matrix;
end

% Group trials again based on AUDITORY coherence for LEFTWARD motion --> 
% 1 = lowest coherence, 5 = highest coherence
[groups, values] = findgroups(stimulus_direction{2,1}(:, 4));

% Create a cell with 5 groups based on VISUAL coherence for AV incongruent 
% LEFTWARD motion
left_auditory_coherence = cell(numel(values), 1);
for k = 1:numel(values)
    idx = groups == k;
    matrix = stimulus_direction{2,1}(idx, :);
    left_auditory_coherence{k} = matrix;
end
% Initialize an empty arrays to store rightward_prob for all coherences at
% varying visual coherences

right_group = findgroups(stimulus_direction{1,1}(:,4));
left_group = findgroups(stimulus_direction{2,1}(:,4));

rightward_prob = multisensory_rightward_prob_calc(stimulus_direction, right_group, left_group, right_var, left_var);

% Create vector of coherence levels
right_coh_vals = stimulus_direction{1,1}(:,2);
left_coh_vals = -stimulus_direction{2,1}(:,2);
combined_coh = [right_coh_vals; left_coh_vals];
if size(stimulus_direction, 1) >= 3 && size(stimulus_direction{3,1}, 2) >= 2
    combined_coh = [right_coh_vals; left_coh_vals; 0];
end
coherence_lvls = sort(combined_coh, 'ascend');
coherence_lvls = unique(coherence_lvls, 'stable');
coherence_lvls = coherence_lvls';
[fig, p_values, ci, threshold, incongruent_trials{2}.xData, incongruent_trials{2}.yData, x, p, sz, incongruent_trials{2}.std_gaussian, incongruent_trials{2}.mdl] = normCDF_plotter(coherence_lvls, ...
    rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
    coherence_frequency, compare_plot, save_name, vel_stair);
scatter(incongruent_trials{2}.xData, incongruent_trials{2}.yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', '#e0f3f8', 'HandleVisibility', 'off');

hold on
plot(x, p, 'LineWidth', 3, 'Color', '#e0f3f8', 'DisplayName', 'Incongruent AV');
% Set figure properties
title('AV Cued Vis');
legend('Location', 'NorthWest');
xlabel('Coherence ((-)Leftward, (+)Rightward)');
ylabel('Proportion Rightward Response');
xlim([-1 1])
ylim([0 1])
grid on
% text(0,0.2,"vis only std: " + dataALL{2}.std_gaussian)
% text(0,0.15,"cong av cue vis std: " + dataALL{4}.std_gaussian)
% text(0,0.10,"incong av cue vis std: " + incongruent_trials{2}.std_gaussian)
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
beautifyplot;

% Isolate Mu from Each and display
Mu.Auditory_Only = dataALL{1}.mdl.Coefficients{1,1};
Mu.Visual_Only = dataALL{2}.mdl.Coefficients{1,1};
Mu.AudCued_AV = dataALL{3}.mdl.Coefficients{1,1};
Mu.VisCued_AV = dataALL{4}.mdl.Coefficients{1,1};
Mu.AVCued_AV = dataALL{5}.mdl.Coefficients{1,1};
Mu.Incong_AudCued_AV = incongruent_trials{1}.mdl.Coefficients{1,1};
Mu.Incong_VisCued_AV = incongruent_trials{2}.mdl.Coefficients{1,1};
disp(Mu)

% Isolate Std from Each and display
Std.Incong_AudCued_AV = incongruent_trials{1}.std_gaussian;
Std.Incong_VisCued_AV = incongruent_trials{2}.std_gaussian;
%Std.Incong_AVCued_AV = incongruent_trials{3}.std_gaussian;
disp(Std)

Results_MLE_A_V_cueA = MLE_Calculations_A_V_AV(dataALL{1}.mdl, dataALL{2}.mdl, dataALL{3}.mdl, dataALL{1}.yData, dataALL{2}.yData, dataALL{3}.yData, dataALL{1}.xData, dataALL{2}.xData, dataALL{3}.xData);
Results_MLE_A_V_cueA
Results_MLE_A_V_cueV = MLE_Calculations_A_V_AV(dataALL{1}.mdl, dataALL{2}.mdl, dataALL{4}.mdl, dataALL{1}.yData, dataALL{2}.yData, dataALL{4}.yData, dataALL{1}.xData, dataALL{2}.xData, dataALL{4}.xData);
Results_MLE_A_V_cueV
Results_MLE_A_V_cueAV = MLE_Calculations_A_V_AV(dataALL{1}.mdl, dataALL{2}.mdl, dataALL{5}.mdl, dataALL{1}.yData, dataALL{2}.yData, dataALL{5}.yData, dataALL{1}.xData, dataALL{2}.xData, dataALL{5}.xData);
Results_MLE_A_V_cueAV

dataVisCuedAV = dataVisCuedAV{3};

if RT_analysis
    % Extract unique coherence levels
    coherenceLevels = unique(dataAudCuedAV(:, 2));% Assuming the same coherence levels for all conditions
    cohCheck = length(coherenceLevels);
    AV_coherenceLevels = unique(dataAV(:,2));
    AV_coherenceLevels = AV_coherenceLevels(2:end);
    AV_coherenceLevels = round(AV_coherenceLevels, 3, "decimals");
    coherenceLevels = round(coherenceLevels, 3, "decimals");
    dataAudCuedAV(:, 2) = round(dataAudCuedAV(:, 2), 3, "decimals");
    dataVisCuedAV(:, 2) = round(dataVisCuedAV(:, 2), 3, "decimals");
    dataAV(:, 2) = round(dataAV(:, 2), 3, "decimals");
    dataAV(:, 4) = round(dataAV(:, 4), 3, "decimals");
    rtAUD_missingdata = zeros(length(coherenceLevels),1);
    rtVIS_missingdata = zeros(length(coherenceLevels),1);
    rtAV_missingdata = zeros(length(coherenceLevels),1);
    violation = zeros(length(coherenceLevels), 1);
    gain = zeros(length(coherenceLevels), 1);
    
    coherenceLevels(1) = [];
    % Loop over each coherence level
    for c = 1:length(coherenceLevels)
        coherenceLevel = coherenceLevels(c);
    
        % Filter data for the current coherence level
        % Convert seconds to ms, sort RT in ascending order
        rtAuditory = dataAudCuedAV(dataAudCuedAV(:, 2) == coherenceLevel, 6);
        rtAuditory = rtAuditory*1000;
        rtAuditory = sort(rtAuditory, 'ascend');
        rtAuditory = rtAuditory(~isnan(rtAuditory));
        rtVisual = dataVisCuedAV(dataVisCuedAV(:, 2) == coherenceLevel, 6);
        rtVisual = rtVisual*1000;
        rtVisual = sort(rtVisual, 'ascend');
        rtVisual = rtVisual(~isnan(rtVisual));
        rtAudiovisual = dataAV(dataAV(:, 2) == coherenceLevel, 6);
        rtAudiovisual = rtAudiovisual*1000;
        rtAudiovisual = sort(rtAudiovisual, 'ascend');
        rtAudiovisual = rtAudiovisual(~isnan(rtAudiovisual));
        coh = num2str(coherenceLevel);
        if length(rtAuditory) > length(rtVisual)
            rtAUD_oldsize = length(rtAuditory);
            rtAuditory = rtAuditory(1:length(rtVisual));
            rtAUD_newsize = length(rtAuditory);
            rtAUD_missingdata(c) = rtAUD_oldsize - rtAUD_newsize; 
        elseif length(rtAuditory) < length(rtVisual)
            rtVIS_oldsize = length(rtVisual);
            rtVisual = rtVisual(1:length(rtAuditory));
            rtVIS_newsize = length(rtVisual);
            rtVIS_missingdata(c) = rtVIS_oldsize - rtVIS_newsize;
        end
        if length(rtAuditory) < length(rtAudiovisual)
            rtAV_oldsize = length(rtAudiovisual);
            rtAudiovisual = rtAudiovisual(1:length(rtAuditory));
            rtAV_newsize = length(rtAudiovisual);
            rtAV_missingdata(c) = rtAV_oldsize - rtAV_newsize;
        elseif length(rtAuditory) > length(rtAudiovisual)
            rtAuditory = rtAuditory(1:length(rtAudiovisual));
            rtVisual = rtVisual(1:length(rtAudiovisual));
        end
        showplot = 0;
        [violation(c), gain(c)] = RMI_violation(rtAuditory, rtVisual, rtAudiovisual, showplot, save_name, coh);

    end
end

disp(gain)
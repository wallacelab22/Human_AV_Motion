%% Accuracy and Reaction Time
% Analysis
clear;
close all;
clc;

%% INTERLEAVING DATA OR SEPARATE 
interleave = 0;
A_and_V = 0;
nocue_cue_compare = 0;
msize=8; lw=1.5;

%% Load the data
task_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/';
script_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/data_analysis/';
data_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/data/';
figure_file_directory = '/Users/a.tiesman/Documents/Research/Meeting_figures/';
addpath('/Users/a.tiesman/Documents/Research/Human_AV_Motion/data_analysis/RSE-box-master/analysis')

if interleave
    %% Load the experimental data
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

    block_analysis = 'psyAV';
    block_savename = 'RDKHoop_psyAV';
    part_ID = sprintf('%s_%s', subjnum_s, group_s);
    
    search_pattern = sprintf('%s_%s_%s_%s_%s_*.mat', block_savename, subjnum_s, group_s);
    
    % List all files in the directory
    file_list = dir(fullfile(data_file_directory, '*.mat'));
    
    % Initialize a cell array to store matching file names
    matching_files = {};
    
    for j = 1:numel(file_list)
        file_name = file_list(j).name;
        if contains(file_name, search_pattern)
            matching_files{end+1} = file_name;
        end
    end
    
    % Check if any files were found
    if isempty(matching_files)
        fprintf('No matching files found for subj=%s, group=%s.\n', subjnum_s, group_s);
    else
        fprintf('Matching files found for subj=%s, group=%s:\n', subjnum_s, group_s);
        
        file_to_load = fullfile(data_file_directory, matching_files{1});
        fprintf('Loading file: %s\n', file_to_load);
    
        if ~A_and_V
            for i = 1:3
                dataALL{i} = load(file_to_load);
            end
        else
            for i = 1:2
                dataALL{i} = load(file_to_load);
            end
        end
    end 
    
    data_output = dataALL{1}.data_output;
    %data_output = data_output(1:391, :);
    
    A = dataALL{1}.data_output;
if nocue_cue_compare
    nocue_group = group - 1;
    nocue_group_s = num2str(nocue_group);
    part_ID = sprintf('%s_%s', subjnum_s, nocue_group_s);
    
    search_pattern = sprintf('%s_%s_%s_%s_%s_*.mat', block_savename, subjnum_s, nocue_group_s);
    % Initialize a cell array to store matching file names
    no_cue_matching_files = {};
    
    for j = 1:numel(file_list)
        file_name = file_list(j).name;
        if contains(file_name, search_pattern)
            no_cue_matching_files{end+1} = file_name;
        end
    end
    
    % Check if any files were found
    if isempty(no_cue_matching_files)
        fprintf('No matching files found for subj=%s, group=%s.\n', subjnum_s, nocue_group_s);
    else
        fprintf('Matching files found for subj=%s, group=%s:\n', subjnum_s, nocue_group_s);
        
        file_to_load = fullfile(data_file_directory, no_cue_matching_files{1});
        fprintf('Loading file: %s\n', file_to_load);
    
        if ~A_and_V
            for i = 1:3
                dataALL{i} = load(file_to_load);
            end
        else
            for i = 1:2
                dataALL{i} = load(file_to_load);
            end
        end
    end 
    
    dataALL{8}.dataRaw = data_output;
    %data_output = data_output(1:391, :);
end
    
    %% Separate A, V, and AV trials
    % Create logical indices for each condition
    conditionAud = isnan(data_output(:, 3)) & isnan(data_output(:, 4));
    conditionVis = isnan(data_output(:, 1)) & isnan(data_output(:, 2));
    if ~A_and_V
        conditionAV = ~isnan(data_output(:, 1)) & ~isnan(data_output(:, 2)) & ...
                ~isnan(data_output(:, 3)) & ~isnan(data_output(:, 4));
        dataAV = data_output(conditionAV, :);
        dataALL{3}.dataRaw = dataAV;
    end
    
    % Extract data into separate matrices based on conditions
    dataAud = data_output(conditionAud, :);
    dataVis = data_output(conditionVis, :);
    
    dataAud(:, [3, 4]) = [ ];
    dataVis(:, [1, 2]) = [ ];
    
    dataALL{1}.dataRaw = dataAud;
    dataALL{2}.dataRaw = dataVis;
else
    % Input the matrix with number1 and number2 values
    if ~A_and_V
        nfiles_to_load = cell(3, 3);
        nfiles_to_load{3, 3} = 'psyAV';
    else
        nfiles_to_load = cell(3,2);
    end

    nfiles_to_load{3, 1} = 'psyAud';
    nfiles_to_load{3, 2} = 'psyVis';
    
    subjnum = input('Enter the subject''s number: ');
    subjnum_s = num2str(subjnum);
    if length(subjnum_s) < 2
        subjnum_s = ['0' subjnum_s];
    end
    subjnum_s = {subjnum_s};
    nfiles_to_load(1, :) = subjnum_s;
    
    group = input('Enter the test group: ');
    group_s = num2str(group);
    if length(group_s) < 2
        group_s = ['0' group_s];
    end
    group_s = {group_s};
    nfiles_to_load(2, :) = group_s;

    part_ID = sprintf('%s_%s', subjnum_s{1}, group_s{1});
   
    % Initialize a cell array to store the loaded data
    dataALL = cell(1, size(nfiles_to_load, 2));

    for i = 1:size(nfiles_to_load, 2)
    
        % Create the search pattern
        block = nfiles_to_load{3, i};
        block_savename = strcat('RDKHoop_', block);
        first_number = nfiles_to_load{1, i};
        second_number = nfiles_to_load{2, i};
        search_pattern = sprintf('%s_%s_%s_%s_%s_*.mat', block_savename, first_number, second_number);
    
        % List all files in the directory
        file_list = dir(fullfile(data_file_directory, '*.mat'));
    
        % Initialize a cell array to store matching file names
        matching_files = {};
    
        % Check if any files match the search pattern
        for j = 1:numel(file_list)
            file_name = file_list(j).name;
            if contains(file_name, search_pattern)
                matching_files{end+1} = file_name;
            end
        end
    
        % Check if any files were found
        if isempty(matching_files)
            fprintf('No matching files found for number1=%s, number2=%s.\n', first_number, second_number);
        else
            fprintf('Matching files found for number1=%s, number2=%s:\n', first_number, second_number);
            
            file_to_load = fullfile(data_file_directory, matching_files{1});
            fprintf('Loading file: %s\n', file_to_load);
      
            dataALL{i} = load(file_to_load);
        end 
    end
    dataALL{1}.dataRaw = dataALL{1}.data_output; %aud only
    dataALL{2}.dataRaw = dataALL{2}.data_output; %vis only
    if ~A_and_V
        dataALL{3}.dataRaw = dataALL{3}.data_output; %av
        dataAV = dataALL{3}.dataRaw;
    end

    
    dataAud = dataALL{1}.dataRaw;
    dataVis = dataALL{2}.dataRaw;

end

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
    save_name = matching_files{1};
    if i == 3
      % Replace all the 0s to 3s for catch trials for splitapply
        dataALL{i}.dataRaw(dataALL{i}.dataRaw(:, 1) == 0, 1) = 3;
        dataALL{i}.dataRaw(dataALL{i}.dataRaw(:, 3) == 0, 1) = 3;
        
        % Extract and separate AV congruent trials from AV incongruent trials
        idx = dataALL{i}.dataRaw(:, 1) == dataALL{i}.dataRaw(:, 3);
        congruent_trials = dataALL{i}.dataRaw(idx, :);
        incongruent_trials = dataALL{i}.dataRaw(~idx, :);
        
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
        [fig, p_values, ci, threshold, dataALL{i}.xData, dataALL{i}.yData, x, p, sz, dataALL{i}.std_gaussian, dataALL{i}.mdl] = normCDF_plotter(coherence_lvls, ...
            rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
            coherence_frequency, compare_plot, save_name, vel_stair);
        scatter(dataALL{i}.xData, dataALL{i}.yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'k', 'HandleVisibility', 'off');
        hold on
        plot(x, p, 'LineWidth', 3, 'Color', 'k', 'DisplayName', 'AV');
    elseif i == 1 || i == 2
        dataALL{i}.dataRaw(dataALL{i}.dataRaw(:, 1) == 0, 1) = 3; 
        [right_vs_left, right_group, left_group] = direction_plotter(dataALL{i}.dataRaw);
        rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
        [total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, coherence_counts, coherence_frequency] = frequency_plotter(dataALL{i}.dataRaw, right_vs_left);
        [fig, p_values, ci, threshold, dataALL{i}.xData, dataALL{i}.yData, x, p, sz, dataALL{i}.std_gaussian, dataALL{i}.mdl] = normCDF_plotter(coherence_lvls, ...
        rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
        coherence_frequency, compare_plot, save_name, vel_stair);    
        if i == 1
            scatter(dataALL{i}.xData, dataALL{i}.yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'r', 'HandleVisibility', 'off');
            hold on
            plot(x, p, 'LineWidth', 3, 'Color', 'r', 'DisplayName', 'Aud unisensory');
        elseif i == 2
            scatter(dataALL{i}.xData, dataALL{i}.yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'b', 'HandleVisibility', 'off');
            hold on
            plot(x, p, 'LineWidth', 3, 'Color', 'b', 'DisplayName', 'Vis unisensory');
        end
    end
end

%% Set figure properties
title(sprintf('Psych. Function Comparison: \n %s', save_name), 'Interpreter','none');
legend('Location', 'NorthWest', 'Interpreter', 'none');
xlabel( 'Coherence ((-)Leftward, (+)Rightward)', 'Interpreter', 'none');
ylabel( 'Proportion Rightward Response', 'Interpreter', 'none');
xlim([-0.5 0.5])
axis equal
ylim([0 1])
grid on
text(0,0.2,"aud sensitivity: " + dataALL{1}.std_gaussian)
text(0,0.15,"vis sensitivity: " + dataALL{2}.std_gaussian)
if ~A_and_V
    text(0,0.1,"av sensitivity: " + dataALL{3}.std_gaussian)
end
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
beautifyplot;

if ~A_and_V
    [Results_MLE] = MLE_Calculations_A_V_AV(dataALL{1}.mdl, dataALL{2}.mdl, dataALL{3}.mdl, ...
        dataALL{1}.yData, dataALL{2}.yData, dataALL{3}.yData, ...
        dataALL{1}.xData, dataALL{2}.xData, dataALL{3}.xData);
    
    % Extract unique coherence levels
    coherenceLevels = unique(dataAud(:, 2));% Assuming the same coherence levels for all conditions
    cohCheck = length(coherenceLevels);
    if cohCheck == 9
        coherenceLevels = [coherenceLevels(1); coherenceLevels(3:end)]; 
    end
    AV_coherenceLevels = unique(dataAV(:,2));
    AV_coherenceLevels = AV_coherenceLevels(2:end);
    AV_coherenceLevels = round(AV_coherenceLevels, 3, "decimals");
    coherenceLevels = round(coherenceLevels, 3, "decimals");
    dataAud(:, 2) = round(dataAud(:, 2), 3, "decimals");
    dataVis(:, 2) = round(dataVis(:, 2), 3, "decimals");
    dataAV(:, 2) = round(dataAV(:, 2), 3, "decimals");
    dataAV(:, 4) = round(dataAV(:, 4), 3, "decimals");
    if ~interleave && (group == 10 || group == 11)
        % Find the indices of the elements that match the old value in column 2
        indices = dataAV(:, 2) == 0.0630; %old coherence round
        % Replace the elements at those indices with the new value in column 2
        dataAV(indices, 2) = 0.0620; %new coherence round
    end
    rtAUD_missingdata = zeros(length(coherenceLevels),1);
    rtVIS_missingdata = zeros(length(coherenceLevels),1);
    rtAV_missingdata = zeros(length(coherenceLevels),1);
    violation = zeros(length(coherenceLevels), 1);
    gain = zeros(length(coherenceLevels), 1);
    slideResp = zeros(length(coherenceLevels), 3);
    
    % Loop over each coherence level
    for c = 1:length(coherenceLevels)
        coherenceLevel = coherenceLevels(c);
    
        % Filter data for the current coherence level
        % Convert seconds to ms, sort RT in ascending order
        rtAuditory = dataAud(dataAud(:, 2) == coherenceLevel, 4);
        rtAuditory = rtAuditory*1000;
        rtAuditory = sort(rtAuditory, 'ascend');
        rtAuditory = rtAuditory(~isnan(rtAuditory));
        rtVisual = dataVis(dataVis(:, 2) == coherenceLevel, 4);
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
        showplot = 1;
        % [violation(c), gain(c)] = RMI_violation(rtAuditory, rtVisual, rtAudiovisual, showplot, part_ID, coh);
    
%         slideAuditory = dataAud(dataAud(:, 2) == coherenceLevel, 7);
%         slideVisual = dataVis(dataVis(:, 2) == coherenceLevel, 7);
%         slideAudiovisual = dataAV(dataAV(:, 2) == coherenceLevel, 9);
%         slideResp(c, 1) = mean(slideAuditory);
%         slideResp(c, 2) = mean(slideVisual);
%         slideResp(c, 3) = mean(slideAudiovisual);
    end
end
%     %% Plot the RMI_violations across coherence levels 
%     figure;
%     plot(coherenceLevels,violation,'.-k','MarkerSize',msize,'LineWidth',lw);
%     yline(0, '--g','LineWidth',lw);
%     title(sprintf('Violation Across Coherences for %s', part_ID));
%     legend('RACE Violation','Location','SouthEast');
%     xlabel('Coherence'); ylabel('RACE Violation (ms)');
%     axis([0 1  min(violation)-10 max(violation)+10]);
%     box off;
%     beautifyplot;
%     
%     figure;
%     plot(coherenceLevels,gain,'.-k','MarkerSize',msize,'LineWidth',lw);
%     yline(0, '--g','LineWidth',lw);
%     title(sprintf('MS Gain Across Coherences for %s', part_ID));
%     legend('MS Resp Enhancement','Location','SouthEast');
%     xlabel('Coherence'); ylabel('MS Resp. Enhancement (ms)');
%     axis([0 1  min(gain)-10 max(gain)+10]);
%     box off;
%     beautifyplot;
% else
%     % Extract unique coherence levels
%     coherenceLevels = unique(dataAud(:, 2));% Assuming the same coherence levels for all conditions
%     cohCheck = length(coherenceLevels);
%     if cohCheck == 9
%         coherenceLevels = [coherenceLevels(1); coherenceLevels(3:end)]; 
%     end
%     coherenceLevels = round(coherenceLevels, 3, "decimals");
%     dataAud(:, 2) = round(dataAud(:, 2), 3, "decimals");
%     dataVis(:, 2) = round(dataVis(:, 2), 3, "decimals");
%     slideResp = zeros(length(coherenceLevels), 2);
%     
%     % Loop over each coherence level
%     for c = 1:length(coherenceLevels)
%         coherenceLevel = coherenceLevels(c);
%     
%         % Filter data for the current coherence level
%         slideAuditory = dataAud(dataAud(:, 2) == coherenceLevel, 7);
%         slideVisual = dataVis(dataVis(:, 2) == coherenceLevel, 7);
%         slideResp(c, 1) = mean(slideAuditory);
%         slideResp(c, 2) = mean(slideVisual);
%     end
% end
% 
% %% Plot Slider Results against Coherence
% figure; 
% subplot(1,1,1),h1 = scatter(dataAud(:,2), dataAud(:,7),msize, 'MarkerEdgeColor', 'r', 'LineWidth', lw); hold on;
% subplot(1,1,1),h2 = scatter(dataVis(:,2), dataVis(:,7),msize, 'MarkerEdgeColor', 'b', 'LineWidth', lw);
% if ~A_and_V
%     subplot(1,1,1),h3 = scatter(dataAV(:,2), dataAV(:,9),msize, 'MarkerEdgeColor', 'm', 'LineWidth', lw);
% end
% title(sprintf('Slider Response vs. Coherence %s', part_ID));
% legend('A','V','AV','Location','SouthEast');
% xlabel('Coherence'); ylabel('Slider Position');
% axis([-0.1 0.6  0 100]);
% box off;
% beautifyplot;
% 
% %% Plot Slider Results against Coherence
% %slideResp = slideResp(2:end, :);
% figure; 
% subplot(1,1,1),h1 = scatter(coherenceLevels, slideResp(:,1), msize, 'MarkerEdgeColor', 'r', 'LineWidth', lw); hold on;
% subplot(1,1,1),h2 = scatter(coherenceLevels, slideResp(:,2), msize, 'MarkerEdgeColor', 'b', 'LineWidth', lw);
% if ~A_and_V
%     subplot(1,1,1),h3 = scatter(coherenceLevels, slideResp(:,3), msize, 'MarkerEdgeColor', 'm', 'LineWidth', lw);
%     legend('A','V','AV','Location','SouthEast');
% else
%     legend('A','V','Location','SouthEast');
% end
% title(sprintf('Slider Response vs. Coherence %s', part_ID));
% xlabel('Coherence'); ylabel('Slider Position');
% axis([-0.1 0.6  0 100]);
% box off;
% beautifyplot;
% 
% cla()
% subplot(1,1,1),h1 = plot(coherenceLevels, slideResp(:,1), 'o','MarkerSize',msize,'LineWidth',lw, 'Color', 'r'); hold on;
% subplot(1,1,1),h2 = plot(coherenceLevels, slideResp(:,2), 'o','MarkerSize',msize,'LineWidth',lw, 'Color', 'b');
% if ~A_and_V
%     subplot(1,1,1),h3 = plot(coherenceLevels, slideResp(:,3), 'o','MarkerSize',msize,'LineWidth',lw, 'Color', 'm');
%     legend('A','V','AV','Location','SouthEast');
% else
%     legend('A','V','Location','SouthEast');
% end
% % Plot line
% lsline 
% title(sprintf('Slider Response vs. Coherence %s', part_ID));
% xlabel('Coherence'); ylabel('Slider Position');
% axis([-0.1 0.6  0 100]);
% box off;
% beautifyplot;

dataOutput = data_output;
coherenceLevels = unique(dataOutput(:, 2)); % Assuming the same coherence levels for all conditions
coherenceLevels = coherenceLevels(~isnan(coherenceLevels));
coherenceLevels = round(coherenceLevels, 3, "decimals");
dataOutput(:, 2) = round(dataOutput(:, 2), 3, "decimals");
dataOutput(:, 4) = round(dataOutput(:, 4), 3, "decimals");
coherenceLevels = coherenceLevels(2:end);

if group == 23 || group == 25
    auditory_cue = 1; visual_cue = 2; audiovisual_cue = 3; no_cue = 0;
    cued_accuracies = zeros(length(coherenceLevels), 4);
    dataAud_cue = cell(length(coherenceLevels), 1);
    dataVis_cue = cell(length(coherenceLevels), 1);
    dataAV_cue = cell(length(coherenceLevels), 1);
    dataNO_cue = cell(length(coherenceLevels), 1);

    for cohIndex = 1:length(coherenceLevels)
        cohValue = coherenceLevels(cohIndex);
        %idx_coherence = dataOutput(:,2) == cohValue & dataOutput(:,4) == cohValue;
        idx_coherence = dataOutput(:,2) == cohValue;
        data_output = dataOutput(idx_coherence, :);

        for cueType = 1:4
            switch cueType
                case 1 % Auditory cue
                    idx_cue = data_output(:,9) == auditory_cue;
                    correctResponses = data_output(idx_cue, 1) == data_output(idx_cue, 5);
                    dataAud_cue{cohIndex} = data_output(idx_cue, :);
                case 2 % Visual cue
                    idx_cue = data_output(:,9) == visual_cue;
                    correctResponses = data_output(idx_cue, 3) == data_output(idx_cue, 5);
                    dataVis_cue{cohIndex} = data_output(idx_cue, :);
                case 3 % Audiovisual cue
                    idx_cue = data_output(:,9) == audiovisual_cue;
                    correctResponses = data_output(idx_cue, 1) == data_output(idx_cue, 3) & data_output(idx_cue, 3) == data_output(idx_cue, 5);
                    dataAV_cue{cohIndex} = data_output(idx_cue, :);
                case 4 % No cue
                    idx_cue = data_output(:,9) == no_cue & all(~isnan(data_output(:,1:4)), 2);
                    correctResponses = data_output(idx_cue, 1) == data_output(idx_cue, 3) & data_output(idx_cue, 3) == data_output(idx_cue, 5);
                    dataNO_cue{cohIndex} = data_output(idx_cue, :);
            end
            
            if ~isempty(correctResponses)
                cued_accuracies(cohIndex, cueType) = sum(correctResponses) / length(correctResponses);
            else
                cued_accuracies(cohIndex, cueType) = NaN;
            end
        end
    end
end

% Number of cue types and coherence levels
numCueTypes = 4;
numCoherenceLevels = length(coherenceLevels);

% Create a figure for the CDF plots
figure;
hold on;

% Define colors for the different cue types
cued_colors = [1 0 0; 0 0 1; 34/255 139/255 34/255; 1 0.5 0]; % red, blue, green, orange

% Define cue labels
cue_labels = {'Aud Cue', 'Vis Cue', 'AV Cue', 'No Cue'};

% Combine data for each cue type
dataALL{4}.dataRaw = vertcat(dataAud_cue{:});
dataALL{5}.dataRaw = vertcat(dataVis_cue{:});
dataALL{6}.dataRaw = vertcat(dataAV_cue{:});
dataALL{7}.dataRaw = vertcat(dataNO_cue{:});

% Loop through each cue type to plot their CDFs
for i = 1:4

    % Replace all the 0s to 3s for catch trials for splitapply
    dataALL{i+3}.dataRaw(dataALL{i+3}.dataRaw(:, 1) == 0, 1) = 3;
    dataALL{i+3}.dataRaw(dataALL{i+3}.dataRaw(:, 3) == 0, 1) = 3;
    
    % Extract and separate AV congruent trials from AV incongruent trials
    idx = dataALL{i+3}.dataRaw(:, 1) == dataALL{i+3}.dataRaw(:, 3);
    congruent_trials = dataALL{i+3}.dataRaw(idx, :);
    incongruent_trials = dataALL{i+3}.dataRaw(~idx, :);
    
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
    [fig, p_values, ci, threshold, dataALL{i+3}.xData, dataALL{i+3}.yData, x, p, sz, dataALL{i+3}.std_gaussian, dataALL{i+3}.mdl] = normCDF_plotter(coherence_lvls, ...
        rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
        coherence_frequency, compare_plot, save_name, vel_stair);
    
    % Plot the CDF for each cue type on the same figure
    scatter(dataALL{i+3}.xData, dataALL{i+3}.yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', cued_colors(i, :), 'HandleVisibility', 'off');
    hold on
    plot(x, p, 'LineWidth', 3, 'Color', cued_colors(i, :), 'DisplayName', cue_labels{i});
    hold on
end

% Set figure properties
title('All AV Trials Sorted by Cue Type', 'Interpreter', 'none');
legend('Location', 'NorthWest', 'Interpreter', 'none');
xlabel('Coherence ((-)Leftward, (+)Rightward)', 'Interpreter', 'none');
ylabel('Proportion Rightward Response', 'Interpreter', 'none');
xlim([-0.5 0.5])
axis equal
ylim([0 1])
grid on
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)

% Add text annotations for sensitivity
text(0, 0.26, "aud std: " + dataALL{4}.std_gaussian);
text(0, 0.185, "vis std: " + dataALL{5}.std_gaussian);
text(0, 0.105, "av std: " + dataALL{6}.std_gaussian);
text(0, 0.04, "no cue std: " + dataALL{7}.std_gaussian);
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
beautifyplot;

%% Plot Unisensory Auditory vs Auditory Cued AV
figure;
hold on;

% Unisensory Auditory
dataAud = dataALL{1}.dataRaw;
[right_vs_left_aud, right_group_aud, left_group_aud] = direction_plotter(dataAud);
rightward_prob_aud = unisensory_rightward_prob_calc(right_vs_left_aud, right_group_aud, left_group_aud, right_var, left_var);
[total_coh_frequency_aud, left_coh_vals_aud, right_coh_vals_aud, coherence_lvls_aud, coherence_counts_aud, coherence_frequency_aud] = frequency_plotter(dataAud, right_vs_left_aud);
[fig, p_values_aud, ci_aud, threshold_aud, xData_aud, yData_aud, x_aud, p_aud, sz_aud, std_gaussian_aud, mdl_aud] = normCDF_plotter(coherence_lvls_aud, rightward_prob_aud, chosen_threshold, left_coh_vals_aud, right_coh_vals_aud, coherence_frequency_aud, compare_plot, save_name, vel_stair);
scatter(xData_aud, yData_aud, sz_aud, 'LineWidth', 2, 'MarkerEdgeColor', 'r', 'HandleVisibility', 'off');
plot(x_aud, p_aud, 'LineWidth', 3, 'Color', 'r', 'DisplayName', 'Auditory Only');

% Auditory Cued AV
dataAudCuedAV = dataALL{4}.dataRaw;

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
[fig, p_values, ci, threshold, dataALL{4}.xData, dataALL{4}.yData, x, p, sz, dataALL{4}.std_gaussian, dataALL{4}.mdl] = normCDF_plotter(coherence_lvls, ...
    rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
    coherence_frequency, compare_plot, save_name, vel_stair);
scatter(dataALL{4}.xData, dataALL{4}.yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'k', 'HandleVisibility', 'off');
hold on
plot(x, p, 'LineWidth', 3, 'Color', 'k', 'DisplayName', 'AV Cued Aud');

% Set figure properties
title('Unisensory Auditory vs Auditory Cued AV');
legend('Location', 'NorthWest');
xlabel('Coherence ((-)Leftward, (+)Rightward)');
ylabel('Proportion Rightward Response');
xlim([-1 1])
ylim([0 1])
grid on
text(0,0.2,"aud only std: " + dataALL{1}.std_gaussian)
text(0,0.15,"av cue aud std: " + dataALL{4}.std_gaussian)
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
beautifyplot;

%% Plot Unisensory Visual vs Visual Cued AV
figure;
hold on;

% Unisensory Visual
dataVis = dataALL{2}.dataRaw;
[right_vs_left_vis, right_group_vis, left_group_vis] = direction_plotter(dataVis);
rightward_prob_vis = unisensory_rightward_prob_calc(right_vs_left_vis, right_group_vis, left_group_vis, right_var, left_var);
[total_coh_frequency_vis, left_coh_vals_vis, right_coh_vals_vis, coherence_lvls_vis, coherence_counts_vis, coherence_frequency_vis] = frequency_plotter(dataVis, right_vs_left_vis);
[fig, p_values_vis, ci_vis, threshold_vis, xData_vis, yData_vis, x_vis, p_vis, sz_vis, std_gaussian_vis, mdl_vis] = normCDF_plotter(coherence_lvls_vis, rightward_prob_vis, chosen_threshold, left_coh_vals_vis, right_coh_vals_vis, coherence_frequency_vis, compare_plot, save_name, vel_stair);
scatter(xData_vis, yData_vis, sz_vis, 'LineWidth', 2, 'MarkerEdgeColor', 'b', 'HandleVisibility', 'off');
plot(x_vis, p_vis, 'LineWidth', 3, 'Color', 'b', 'DisplayName', 'Visual Only');

% Visual Cued AV
dataVisCuedAV = dataALL{5}.dataRaw;
% Replace all the 0s to 3s for catch trials for splitapply
dataALL{5}.dataRaw(dataALL{5}.dataRaw(:, 1) == 0, 1) = 3;
dataALL{5}.dataRaw(dataALL{5}.dataRaw(:, 3) == 0, 1) = 3;

% Extract and separate AV congruent trials from AV incongruent trials
idx = dataALL{5}.dataRaw(:, 1) == dataALL{5}.dataRaw(:, 3);
congruent_trials = dataALL{5}.dataRaw(idx, :);
incongruent_trials = dataALL{5}.dataRaw(~idx, :);

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
[fig, p_values, ci, threshold, dataALL{5}.xData, dataALL{5}.yData, x, p, sz, dataALL{5}.std_gaussian, dataALL{5}.mdl] = normCDF_plotter(coherence_lvls, ...
    rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
    coherence_frequency, compare_plot, save_name, vel_stair);
scatter(dataALL{5}.xData, dataALL{5}.yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'k', 'HandleVisibility', 'off');
hold on
plot(x, p, 'LineWidth', 3, 'Color', 'k', 'DisplayName', 'AV Cued Vis');
% Set figure properties
title('Unisensory Visual vs Visual Cued AV');
legend('Location', 'NorthWest');
xlabel('Coherence ((-)Leftward, (+)Rightward)');
ylabel('Proportion Rightward Response');
xlim([-1 1])
ylim([0 1])
grid on
text(0,0.2,"vis only std: " + dataALL{2}.std_gaussian)
text(0,0.15,"av cue vis std: " + dataALL{5}.std_gaussian)
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
beautifyplot;

%% Plot Uncued and NO Cue AV
figure;
hold on;

% No Cued AV
dataNoCueAV = dataALL{7}.dataRaw;
% Replace all the 0s to 3s for catch trials for splitapply
dataALL{7}.dataRaw(dataALL{7}.dataRaw(:, 1) == 0, 1) = 3;
dataALL{7}.dataRaw(dataALL{7}.dataRaw(:, 3) == 0, 1) = 3;

% Extract and separate AV congruent trials from AV incongruent trials
idx = dataALL{7}.dataRaw(:, 1) == dataALL{7}.dataRaw(:, 3);
congruent_trials = dataALL{7}.dataRaw(idx, :);
incongruent_trials = dataALL{7}.dataRaw(~idx, :);

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
[fig, p_values, ci, threshold, dataALL{7}.xData, dataALL{7}.yData, x, p, sz_cnc, dataALL{7}.std_gaussian, dataALL{7}.mdl] = normCDF_plotter(coherence_lvls, ...
    rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
    coherence_frequency, compare_plot, save_name, vel_stair);
scatter(dataALL{7}.xData, dataALL{7}.yData, sz_cnc, 'LineWidth', 2, 'MarkerEdgeColor', 'c', 'HandleVisibility', 'off');
hold on
plot(x, p, 'LineWidth', 3, 'Color', 'c', 'DisplayName', 'AV No Cue');
hold on

% Uncued AV
dataNoCueAV = dataALL{8}.dataRaw;
conditionAV = ~isnan(dataNoCueAV(:, 1)) & ~isnan(dataNoCueAV(:, 2)) & ...
        ~isnan(dataNoCueAV(:, 3)) & ~isnan(dataNoCueAV(:, 4));
dataAV = dataNoCueAV(conditionAV, :);
dataALL{8}.dataRaw = dataAV;

% Replace all the 0s to 3s for catch trials for splitapply
dataALL{8}.dataRaw(dataALL{8}.dataRaw(:, 1) == 0, 1) = 3;
dataALL{8}.dataRaw(dataALL{8}.dataRaw(:, 3) == 0, 1) = 3;

% Extract and separate AV congruent trials from AV incongruent trials
idx = dataALL{8}.dataRaw(:, 1) == dataALL{8}.dataRaw(:, 3);
congruent_trials = dataALL{8}.dataRaw(idx, :);
incongruent_trials = dataALL{8}.dataRaw(~idx, :);

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
[fig, p_values, ci, threshold, dataALL{8}.xData, dataALL{8}.yData, x, p, sz_nnc, dataALL{8}.std_gaussian, dataALL{8}.mdl] = normCDF_plotter(coherence_lvls, ...
    rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
    coherence_frequency, compare_plot, save_name, vel_stair);
scatter(dataALL{8}.xData, dataALL{8}.yData, sz_nnc, 'LineWidth', 2, 'MarkerEdgeColor', 'g', 'HandleVisibility', 'off');
hold on
plot(x, p, 'LineWidth', 3, 'Color', 'g', 'DisplayName', 'AV Uncued');

% Set figure properties
title('No Cue vs Uncued AV Trials');
legend('Location', 'NorthWest');
xlabel('Coherence ((-)Leftward, (+)Rightward)');
ylabel('Proportion Rightward Response');
xlim([-1 1])
ylim([0 1])
grid on
text(0,0.2,"no cue std: " + dataALL{7}.std_gaussian)
text(0,0.15,"uncued std: " + dataALL{8}.std_gaussian)
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
beautifyplot;
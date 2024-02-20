%% Accuracy and Reaction Time
% Analysis
clear;
close all;
clc;

%% INTERLEAVING DATA OR SEPARATE 
interleave = 1;
A_and_V = 0;

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
    
    A = dataALL{1}.data_output;
    
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
        scatter(dataALL{i}.xData, dataALL{i}.yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'm', 'HandleVisibility', 'off');
        hold on
        plot(x, p, 'LineWidth', 3, 'Color', 'm', 'DisplayName', 'AV');
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
ylabel( '% Rightward Response', 'Interpreter', 'none');
xlim([-0.5 0.5])
axis equal
ylim([0 1])
grid on
text(0,0.2,"aud cumulative gaussian std: " + dataALL{1}.std_gaussian)
text(0,0.15,"vis cumulative gaussian std: " + dataALL{2}.std_gaussian)
if ~A_and_V
    text(0,0.1,"av cumulative gaussian std: " + dataALL{3}.std_gaussian)
end
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)

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
        [violation(c), gain(c)] = RMI_violation(rtAuditory, rtVisual, rtAudiovisual, showplot, part_ID, coh);
    
        slideAuditory = dataAud(dataAud(:, 2) == coherenceLevel, 7);
        slideVisual = dataVis(dataVis(:, 2) == coherenceLevel, 7);
        slideAudiovisual = dataAV(dataAV(:, 2) == coherenceLevel, 9);
        slideResp(c, 1) = mean(slideAuditory);
        slideResp(c, 2) = mean(slideVisual);
        slideResp(c, 3) = mean(slideAudiovisual);
    end
    %% Plot the RMI_violations across coherence levels 
    figure;
    plot(coherenceLevels,violation,'.-k','MarkerSize',msize,'LineWidth',lw);
    yline(0, '--g','LineWidth',lw);
    title(sprintf('Violation Across Coherences for %s', part_ID));
    legend('RACE Violation','Location','SouthEast');
    xlabel('Coherence'); ylabel('RACE Violation (ms)');
    axis([0 1  min(violation)-10 max(violation)+10]);
    box off;
    beautifyplot;
    
    figure;
    plot(coherenceLevels,gain,'.-k','MarkerSize',msize,'LineWidth',lw);
    yline(0, '--g','LineWidth',lw);
    title(sprintf('MS Gain Across Coherences for %s', part_ID));
    legend('MS Resp Enhancement','Location','SouthEast');
    xlabel('Coherence'); ylabel('MS Resp. Enhancement (ms)');
    axis([0 1  min(gain)-10 max(gain)+10]);
    box off;
    beautifyplot;
else
    % Extract unique coherence levels
    coherenceLevels = unique(dataAud(:, 2));% Assuming the same coherence levels for all conditions
    cohCheck = length(coherenceLevels);
    if cohCheck == 9
        coherenceLevels = [coherenceLevels(1); coherenceLevels(3:end)]; 
    end
    coherenceLevels = round(coherenceLevels, 3, "decimals");
    dataAud(:, 2) = round(dataAud(:, 2), 3, "decimals");
    dataVis(:, 2) = round(dataVis(:, 2), 3, "decimals");
    slideResp = zeros(length(coherenceLevels), 2);
    
    % Loop over each coherence level
    for c = 1:length(coherenceLevels)
        coherenceLevel = coherenceLevels(c);
    
        % Filter data for the current coherence level
        slideAuditory = dataAud(dataAud(:, 2) == coherenceLevel, 7);
        slideVisual = dataVis(dataVis(:, 2) == coherenceLevel, 7);
        slideResp(c, 1) = mean(slideAuditory);
        slideResp(c, 2) = mean(slideVisual);
    end
end

%% Plot Slider Results against Coherence
figure; 
subplot(1,1,1),h1 = scatter(dataAud(:,2), dataAud(:,7),msize, 'MarkerEdgeColor', 'r', 'LineWidth', lw); hold on;
subplot(1,1,1),h2 = scatter(dataVis(:,2), dataVis(:,7),msize, 'MarkerEdgeColor', 'b', 'LineWidth', lw);
if ~A_and_V
    subplot(1,1,1),h3 = scatter(dataAV(:,2), dataAV(:,9),msize, 'MarkerEdgeColor', 'm', 'LineWidth', lw);
end
title(sprintf('Slider Response vs. Coherence %s', part_ID));
legend('A','V','AV','Location','SouthEast');
xlabel('Coherence'); ylabel('Slider Position');
axis([-0.1 0.6  0 100]);
box off;
beautifyplot;

%% Plot Slider Results against Coherence
%slideResp = slideResp(2:end, :);
figure; 
subplot(1,1,1),h1 = scatter(coherenceLevels, slideResp(:,1), msize, 'MarkerEdgeColor', 'r', 'LineWidth', lw); hold on;
subplot(1,1,1),h2 = scatter(coherenceLevels, slideResp(:,2), msize, 'MarkerEdgeColor', 'b', 'LineWidth', lw);
if ~A_and_V
    subplot(1,1,1),h3 = scatter(coherenceLevels, slideResp(:,3), msize, 'MarkerEdgeColor', 'm', 'LineWidth', lw);
    legend('A','V','AV','Location','SouthEast');
else
    legend('A','V','Location','SouthEast');
end
title(sprintf('Slider Response vs. Coherence %s', part_ID));
xlabel('Coherence'); ylabel('Slider Position');
axis([-0.1 0.6  0 100]);
box off;
beautifyplot;

cla()
subplot(1,1,1),h1 = plot(coherenceLevels, slideResp(:,1), 'o','MarkerSize',msize,'LineWidth',lw, 'Color', 'r'); hold on;
subplot(1,1,1),h2 = plot(coherenceLevels, slideResp(:,2), 'o','MarkerSize',msize,'LineWidth',lw, 'Color', 'b');
if ~A_and_V
    subplot(1,1,1),h3 = plot(coherenceLevels, slideResp(:,3), 'o','MarkerSize',msize,'LineWidth',lw, 'Color', 'm');
    legend('A','V','AV','Location','SouthEast');
else
    legend('A','V','Location','SouthEast');
end
% Plot line
lsline 
title(sprintf('Slider Response vs. Coherence %s', part_ID));
xlabel('Coherence'); ylabel('Slider Position');
axis([-0.1 0.6  0 100]);
box off;
beautifyplot;
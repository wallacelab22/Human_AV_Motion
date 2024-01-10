%% A, V, and AV analysis %%%%%%%%%%%%

% Input the matrix with number1 and number2 values
nfiles_to_load = cell(3, 3);

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

nfiles_to_load{3, 1} = 'psyAud';
nfiles_to_load{3, 2} = 'psyVis';
nfiles_to_load{3, 3} = 'psyAV';

% Specify the directory where your files are located
task_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/';
script_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/data_analysis/';
data_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/data/';
figure_file_directory = '/Users/a.tiesman/Documents/Research/Meeting_figures/';

% Initialize a cell array to store the loaded data
loaded_data = cell(1, size(nfiles_to_load, 2));

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
  
        loaded_data{i} = load(file_to_load);
    end 
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
    if contains(block, 'AV')
      % Replace all the 0s to 3s for catch trials for splitapply
        loaded_data{i}.data_output(loaded_data{i}.data_output(:, 1) == 0, 1) = 3;
        loaded_data{i}.data_output(loaded_data{i}.data_output(:, 3) == 0, 1) = 3;
        
        % Extract and separate AV congruent trials from AV incongruent trials
        idx = loaded_data{i}.data_output(:,1) == loaded_data{i}.data_output(:,3);
        congruent_trials = loaded_data{i}.data_output(idx, :);
        incongruent_trials = loaded_data{i}.data_output(~idx, :);
        
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
        [fig, p_values, ci, threshold, loaded_data{i}.xData, loaded_data{i}.yData, x, p, sz, loaded_data{i}.std_gaussian, loaded_data{i}.mdl] = normCDF_plotter(coherence_lvls, ...
            rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
            coherence_frequency, compare_plot, save_name, vel_stair);
        scatter(loaded_data{i}.xData, loaded_data{i}.yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'm', 'HandleVisibility', 'off');
        hold on
        plot(x, p, 'LineWidth', 3, 'Color', 'm', 'DisplayName', 'AV');
    else
        loaded_data{i}.data_output(loaded_data{i}.data_output(:, 1) == 0, 1) = 3; 
        [right_vs_left, right_group, left_group] = direction_plotter(loaded_data{i}.data_output);
        rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
        [total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, coherence_counts, coherence_frequency] = frequency_plotter(loaded_data{i}.data_output, right_vs_left);
        [fig, p_values, ci, threshold, loaded_data{i}.xData, loaded_data{i}.yData, x, p, sz, loaded_data{i}.std_gaussian, loaded_data{i}.mdl] = normCDF_plotter(coherence_lvls, ...
        rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
        coherence_frequency, compare_plot, save_name, vel_stair);    
        if contains(block, 'Aud')
            scatter(loaded_data{i}.xData, loaded_data{i}.yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'r', 'HandleVisibility', 'off');
            hold on
            plot(x, p, 'LineWidth', 3, 'Color', 'r', 'DisplayName', 'Aud unisensory');
        elseif contains(block, 'Vis')
            scatter(loaded_data{i}.xData, loaded_data{i}.yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'b', 'HandleVisibility', 'off');
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
xlim([-1 1])
axis equal
ylim([0 1])
grid on
text(0,0.2,"aud cumulative gaussian std: " + loaded_data{1}.std_gaussian)
text(0,0.15,"vis cumulative gaussian std: " + loaded_data{2}.std_gaussian)
text(0,0.1,"av cumulative gaussian std: " + loaded_data{3}.std_gaussian)
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)



[Results_MLE] = MLE_Calculations_A_V_AV(loaded_data{1}.mdl, loaded_data{2}.mdl, loaded_data{3}.mdl, loaded_data{1}.yData, loaded_data{2}.yData, loaded_data{3}.yData, loaded_data{1}.xData, loaded_data{2}.xData, loaded_data{3}.xData);

indextoKeep = [true(1, 7), false(1, 3), true(1, 7)];
unisensory_matrix = repmat(loaded_data{2}.yData(indextoKeep, :), [1, 1]);
ms_gain = (loaded_data{3}.yData - unisensory_matrix) / unisensory_matrix;
scatter(loaded_data{3}.xData, ms_gain, 'filled');




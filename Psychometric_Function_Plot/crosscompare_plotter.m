function [fig, stimcoh_list] = crosscompare_plotter(compare_plot, coh_change, Antonia_data, ...
    data_file_directory, script_file_directory, task_file_directory)
% This is code to plot psychometric functions of different blocks on top of
% one another.
compare_PILOTpsyAV = 0;

num_compare_plots = input('How many plots do you want to compare? ');

fig = figure('Name', 'Cross Compare Plot');

for i = 1:num_compare_plots

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
    sex = input('Enter the subject''s sex (1 = female; 2 = male): ');
    sex_s=num2str(sex);
    if Antonia_data ~= 1
        if length(sex_s) < 2
            sex_s = strcat(['0' sex_s]);
        end
    end
    age = input('Enter the subject''s age: ');
    age_s=num2str(age);
    if length(age_s) < 2
        age_s = strcat(['0' age_s]);
    end
    
    block = input('1 = stairAud, 2 = stairVis, 3 = psyAud, 4 = psyVis, 5 = trainAud, 6 = trainVis, 7 = psyAV ');
    if block == 1
        block_analysis = 'stairAud';
    elseif block == 2
        block_analysis = 'stairVis';
    elseif block == 3
        block_analysis = 'psyAud';
    elseif block == 4
        block_analysis = 'psyVis';
    elseif block == 5
        block_analysis = 'trainAud';
    elseif block == 6
        block_analysis = 'trainVis';
    elseif block == 7
        block_analysis = 'psyAV';
    end
    
    underscore = '_';
    identifier = strcat(subjnum_s, underscore, group_s, underscore, sex_s, underscore, age_s);
    save_name = strcat('RDKHoop_', block_analysis, underscore, identifier);
    cd(data_file_directory)
    load(save_name, 'data_output');
    
    % Provide specific variables 
    chosen_threshold = 0.72;
    right_var = 1;
    left_var = 2;
    
    
    %% Plot each desired dataset on same figure
    cd(script_file_directory)

    % Auditory training
    if block == 5
        if Antonia_data == 1 && coh_change == 1
            [data_output, cohlvlcoh] = Antonia_coh_level_correction(data_output, save_name);
        elseif Antonia_data ~= 1 && coh_change == 1
            [data_output, cohlvlcoh] = coh_level_correction(data_output, subjnum_s, ...
            group_s, sex_s, age_s, script_file_directory, data_file_directory, ...
            task_file_directory, save_name);
        end
        if compare_PILOTpsyAV == 1
            data_output = coh_to_cohLevel(data_output, save_name);
    
        end
        [right_vs_left, right_group, left_group] = direction_plotter(data_output);
        rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
        [total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, ...
            coherence_counts, coherence_frequency] = frequency_plotter(data_output, right_vs_left);
        [fig, p_values, ci, threshold, xData, yData, x, p, sz, std_gaussian] = normCDF_plotter(coherence_lvls, ...
        rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
        coherence_frequency, compare_plot, save_name);
        scatter(xData, yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'g', 'HandleVisibility', 'off');
        hold on
        plot(x, p, 'LineWidth', 3, 'Color', 'g', 'DisplayName', 'Aud training');
    
    % Visual training
    elseif block == 6
        if Antonia_data == 1 && coh_change == 1
            [data_output, cohlvlcoh] = Antonia_coh_level_correction(data_output, save_name);
        elseif Antonia_data ~= 1 && coh_change == 1
            [data_output, cohlvlcoh] = coh_level_correction(data_output, subjnum_s, ...
            group_s, sex_s, age_s, script_file_directory, data_file_directory, ...
            task_file_directory, save_name);
        end
        if compare_PILOTpsyAV == 1
            data_output = coh_to_cohLevel(data_output, save_name);
        end
        [right_vs_left, right_group, left_group] = direction_plotter(data_output);
        rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
        [total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, ...
            coherence_counts, coherence_frequency] = frequency_plotter(data_output, right_vs_left);
        [fig, p_values, ci, threshold, xData, yData, x, p, sz, std_gaussian] = normCDF_plotter(coherence_lvls, ...
        rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
        coherence_frequency, compare_plot, save_name);
        scatter(xData, yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'g', 'HandleVisibility', 'off');
        hold on
        plot(x, p, 'LineWidth', 3, 'Color', 'g', 'DisplayName', 'Vis training');
    
    
    % Auditory staircase
    elseif block == 1
%         if compare_PILOTpsyAV == 1
%             PILOTpsyAV_filename = sprintf('RDKHoop_PILOTpsyAV_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
%             load(PILOTpsyAV_filename, 'audcoh_list')
%         end
        if Antonia_data == 1 && coh_change == 1
            [data_output, cohlvlcoh] = Antonia_coh_level_correction(data_output, save_name);
        elseif Antonia_data ~= 1 && coh_change == 1
            [data_output, cohlvlcoh] = coh_level_correction(data_output, subjnum_s, ...
            group_s, sex_s, age_s, script_file_directory, data_file_directory, ...
            task_file_directory, save_name);
        end
        if compare_PILOTpsyAV == 1
            viscoh_list = zeros(1, length(audcoh_list));
            stimcoh_list = [audcoh_list; viscoh_list];
            data_output = coh_to_cohLevel(data_output, stimcoh_list, save_name);
        end
        [right_vs_left, right_group, left_group] = direction_plotter(data_output);
        rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
        [total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, ...
            coherence_counts, coherence_frequency] = frequency_plotter(data_output, right_vs_left);
        [fig, p_values, ci, threshold, xData, yData, x, p, sz, aud_std_gaussian] = normCDF_plotter(coherence_lvls, ...
        rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
        coherence_frequency, compare_plot, save_name);
        scatter(xData, yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'r', 'HandleVisibility', 'off');
        hold on
        plot(x, p, 'LineWidth', 3, 'Color', 'r', 'DisplayName', 'Aud staircase');
   
    % Visual staircase
    elseif block == 2
%         if compare_PILOTpsyAV == 1
%             PILOTpsyAV_filename = sprintf('RDKHoop_PILOTpsyAV_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
%             load(PILOTpsyAV_filename, 'viscoh_list')
%         end
        if Antonia_data == 1 && coh_change == 1
            [data_output, cohlvlcoh] = Antonia_coh_level_correction(data_output, save_name);
        elseif Antonia_data ~= 1 && coh_change == 1
            [data_output, cohlvlcoh] = coh_level_correction(data_output, subjnum_s, ...
            group_s, sex_s, age_s, script_file_directory, data_file_directory, ...
            task_file_directory, save_name);
        end
        if compare_PILOTpsyAV == 1
            audcoh_list = zeros(1, length(viscoh_list));
            stimcoh_list = [audcoh_list; viscoh_list];
            data_output = coh_to_cohLevel(data_output, stimcoh_list, save_name);
        end
        [right_vs_left, right_group, left_group] = direction_plotter(data_output);
        rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
        [total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, ...
            coherence_counts, coherence_frequency] = frequency_plotter(data_output, right_vs_left);
        [fig, p_values, ci, threshold, xData, yData, x, p, sz, vis_std_gaussian] = normCDF_plotter(coherence_lvls, ...
        rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
        coherence_frequency, compare_plot, save_name);
        scatter(xData, yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'b', 'HandleVisibility', 'off');
        hold on
        plot(x, p, 'LineWidth', 3, 'Color', 'b', 'DisplayName', 'Vis staircase');
    
    % Auditory unisensory
    elseif block == 3
%         if Antonia_data == 1
%             data_output = MAT;
%         end
        if Antonia_data == 1 && coh_change == 1
            [data_output, cohlvlcoh] = Antonia_coh_level_correction(data_output, save_name);
        elseif Antonia_data ~= 1 && coh_change == 1
            [data_output, cohlvlcoh] = coh_level_correction(data_output, subjnum_s, ...
            group_s, sex_s, age_s, script_file_directory, data_file_directory, ...
            task_file_directory, save_name);
        end
        data_output(data_output(:, 1) == 0, 1) = 3; 
        [right_vs_left, right_group, left_group] = direction_plotter(data_output);
        rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
        [total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, ... 
            coherence_counts, coherence_frequency] = frequency_plotter(data_output, right_vs_left);
        [fig, p_values, ci, threshold, xData, yData, x, p, sz, aud_std_gaussian] = normCDF_plotter(coherence_lvls, ...
        rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
            coherence_frequency, compare_plot, save_name);
        if Antonia_data == 1
            scatter(xData, yData, sz, 'LineWidth', 3, 'MarkerEdgeColor', 'r', 'HandleVisibility', 'off');
            hold on
            plot(x, p, 'LineWidth', 4, 'Color', 'r', 'DisplayName', 'Aud unisensory');
        else
            scatter(xData, yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'r', 'HandleVisibility', 'off');
            hold on
            plot(x, p, 'LineWidth', 3, 'Color', 'r', 'DisplayName', 'Aud unisensory');
        end
    
    % Visual unisensory
    elseif block == 4
%         if Antonia_data == 1
%             data_output = MAT;
%         end
        if Antonia_data == 1 && coh_change == 1
            [data_output, cohlvlcoh] = Antonia_coh_level_correction(data_output, save_name);
        elseif Antonia_data ~= 1 && coh_change == 1
            [data_output, cohlvlcoh] = coh_level_correction(data_output, subjnum_s, ...
            group_s, sex_s, age_s, script_file_directory, data_file_directory, ...
            task_file_directory, save_name);
        end
        data_output(data_output(:, 1) == 0, 1) = 3; 
        [right_vs_left, right_group, left_group] = direction_plotter(data_output);
        rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
        [total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, ... 
            coherence_counts, coherence_frequency] = frequency_plotter(data_output, right_vs_left);
        [fig, p_values, ci, threshold, xData, yData, x, p, sz, vis_std_gaussian] = normCDF_plotter(coherence_lvls, ...
        rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
        coherence_frequency, compare_plot, save_name);
        if Antonia_data == 1
            scatter(xData, yData, sz, 'LineWidth', 3, 'MarkerEdgeColor', 'b', 'HandleVisibility', 'off');
            hold on
            plot(x, p, 'LineWidth', 4, 'Color', 'b', 'DisplayName', 'Vis unisensory');
        else
            scatter(xData, yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'b', 'HandleVisibility', 'off');
            hold on
            plot(x, p, 'LineWidth', 3, 'Color', 'b', 'DisplayName', 'Vis unisensory');
        end
    
    % AV PILOT
    elseif block == 7
%         data_output = MAT;
        if coh_change == 1
            data_output = coh_level_correction(data_output, script_file_directory, task_file_directory, save_name);
        end
        % Replace all the 0s to 3s for catch trials for splitapply
        data_output(data_output(:, 1) == 0, 1) = 3;
        data_output(data_output(:, 3) == 0, 1) = 3;
        
        % Extract and separate AV congruent trials from AV incongruent trials
        idx = data_output(:,1) == data_output(:,3);
        congruent_trials = data_output(idx, :);
        incongruent_trials = data_output(~idx, :);
        
        % Group AV congruent trials based on stimulus direction --> 1 = right,
        % 2 = left, and 3 = catch
        [groups, values] = findgroups(congruent_trials(:, 1));
        
        % Create a cell with 3 groups based on stimulus direction
        stimulus_direction = cell(numel(values), 1);
        for i = 1:numel(values)
            idx = groups == i;
            matrix = congruent_trials(idx, :);
            stimulus_direction{i} = matrix;
        end
        
        % Group trials again based on AUDITORY coherence for AV congruent 
        % RIGHTWARD motion --> 1 = lowest coherence, 7 = highest coherence
        [groups, values] = findgroups(stimulus_direction{1,1}(:, 2));
        
        % Create a cell with 7 groups based on AUDITORY coherence for AV congruent
        % RIGHTWARD motion
        right_auditory_coherence = cell(numel(values), 1);
        for i = 1:numel(values)
            idx = groups == i;
            matrix = stimulus_direction{1,1}(idx, :);
            right_auditory_coherence{i} = matrix;
        end
        
        % Group trials again based on AUDITORY coherence for LEFTWARD motion --> 
        % 1 = lowest coherence, 5 = highest coherence
        [groups, values] = findgroups(stimulus_direction{2,1}(:, 2));
        
        % Create a cell with 5 groups based on AUDITORY coherence for AV congruent 
        % LEFTWARD motion
        left_auditory_coherence = cell(numel(values), 1);
        for i = 1:numel(values)
            idx = groups == i;
            matrix = stimulus_direction{2,1}(idx, :);
            left_auditory_coherence{i} = matrix;
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
        [fig, p_values, ci, threshold, xData, yData, x, p, sz, av_std_gaussian] = normCDF_plotter(coherence_lvls, ...
            rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
            coherence_frequency, compare_plot, save_name);
        scatter(xData, yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'm', 'HandleVisibility', 'off');
        hold on
        plot(x, p, 'LineWidth', 3, 'Color', 'm', 'DisplayName', 'AV');
    end
    
    if block == 7
        coherence_lvls = abs(coherence_lvls);
        coherence_lvls = sort(coherence_lvls, 'descend');
        coherence_lvls = unique(coherence_lvls, 'stable');
        cd(data_file_directory)
        save_name = sprintf('RDKHoop_PILOTpsyAV_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
        load(save_name, 'audcoh_list')
        save_name = sprintf('RDKHoop_PILOTpsyAV_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
        load(save_name, 'viscoh_list')
        stimcoh_list = [coherence_lvls; audcoh_list; viscoh_list];
        disp(stimcoh_list)
    end
end

%% Set figure properties
title(sprintf('Psych. Function Comparison: \n %s', identifier), 'Interpreter','none');
legend('Location', 'NorthWest', 'Interpreter', 'none');
xlabel( 'Coherence ((-)Leftward, (+)Rightward)', 'Interpreter', 'none');
ylabel( '% Rightward Response', 'Interpreter', 'none');
if Antonia_data == 1 && coh_change ~= 1
    xlim([-5 5])
elseif compare_PILOTpsyAV == 1
    xlim([-7 7])
elseif Antonia_data == 1 && coh_change == 1
    xlim([-0.6 0.6])
    axis equal
else
    xlim([-1 1])
end
ylim([0 1])
grid on
try
    text(0,0.2,"aud cumulative gaussian std: " + aud_std_gaussian)
catch
    text(0,0.15,"vis cumulative gaussian std: " + vis_std_gaussian)
end
if compare_PILOTpsyAV == 1
    text(0,0.1,"av cumulative gaussian std: " + av_std_gaussian)
end
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)

end
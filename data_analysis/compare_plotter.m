function [fig, stimcoh_list] = compare_plotter(compare_plot, coh_change, Antonia_data, ...
    data_file_directory, script_file_directory, task_file_directory, ...
    subjnum_s, group_s, sex_s, age_s, identifier, save_name, vel_stair)

% This is code to plot psychometric functions of different blocks on top of
% one another.
compare_trainAud = input('Compare Auditory Training? 0 for NO, 1 for YES: ');
compare_trainVis = input('Compare Visual Training? 0 for NO, 1 for YES: ');
compare_stairAud = input('Compare Auditory Staircase? 0 for NO, 1 for YES: ');
compare_stairVis = input('Compare Visual Staircase? 0 for NO, 1 for YES: ');
compare_psyAud = input('Compare Auditory? 0 for NO, 1 for YES: ');
compare_psyVis = input('Compare Visual? 0 for NO, 1 for YES: ');
compare_PILOTpsyAV = input('Compare PILOT AV? 0 for NO, 1 for YES: ');

% Provide specific variables 
chosen_threshold = 0.72;
right_var = 1;
left_var = 2;


%% Plot each desired dataset on same figure

% Auditory training
if compare_trainAud == 1
    cd(data_file_directory)
    trainAud_filename = sprintf('RDKHoop_trainAud_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
    load(trainAud_filename, 'data_output');
    cd(script_file_directory)
    if Antonia_data == 1 && coh_change == 1
        [data_output, cohlvlcoh] = Antonia_coh_level_correction(data_output, trainAud_filename);
    elseif Antonia_data ~= 1 && coh_change == 1
        [data_output, cohlvlcoh] = coh_level_correction(data_output, subjnum_s, ...
        group_s, sex_s, age_s, script_file_directory, data_file_directory, ...
        task_file_directory, trainAud_filename);
    end
    if compare_PILOTpsyAV == 1
        data_output = coh_to_cohLevel(data_output, trainAud_filename);

    end
    [right_vs_left, right_group, left_group] = direction_plotter(data_output);
    rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
    [total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, ...
        coherence_counts, coherence_frequency] = frequency_plotter(data_output, right_vs_left);
    [fig, p_values, ci, threshold, xData, yData, x, p, sz, std_gaussian] = normCDF_plotter(coherence_lvls, ...
    rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
    coherence_frequency, compare_plot, trainAud_filename);
    scatter(xData, yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'g', 'HandleVisibility', 'off');
    hold on
    plot(x, p, 'LineWidth', 3, 'Color', 'g', 'DisplayName', 'Aud training');
end

% Visual training
if compare_trainVis == 1
    cd(data_file_directory)
    trainVis_filename = sprintf('RDKHoop_trainVis_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
    load(trainVis_filename, 'data_output');
    cd(script_file_directory)
    if Antonia_data == 1 && coh_change == 1
        [data_output, cohlvlcoh] = Antonia_coh_level_correction(data_output, trainVis_filename);
    elseif Antonia_data ~= 1 && coh_change == 1
        [data_output, cohlvlcoh] = coh_level_correction(data_output, subjnum_s, ...
        group_s, sex_s, age_s, script_file_directory, data_file_directory, ...
        task_file_directory, trainVis_filename);
    end
    if compare_PILOTpsyAV == 1
        data_output = coh_to_cohLevel(data_output, trainVis_filename);
    end
    [right_vs_left, right_group, left_group] = direction_plotter(data_output);
    rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
    [total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, ...
        coherence_counts, coherence_frequency] = frequency_plotter(data_output, right_vs_left);
    [fig, p_values, ci, threshold, xData, yData, x, p, sz, std_gaussian] = normCDF_plotter(coherence_lvls, ...
    rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
    coherence_frequency, compare_plot, trainVis_filename);
    scatter(xData, yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'g', 'HandleVisibility', 'off');
    hold on
    plot(x, p, 'LineWidth', 3, 'Color', 'g', 'DisplayName', 'Vis training');
end


% Auditory staircase
if compare_stairAud == 1
    cd(data_file_directory)
    stairAud_filename = sprintf('RDKHoop_stairAud_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
    load(stairAud_filename, 'data_output');
    if compare_PILOTpsyAV == 1
        PILOTpsyAV_filename = sprintf('RDKHoop_PILOTpsyAV_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
        load(PILOTpsyAV_filename, 'audcoh_list')
    end
    cd(script_file_directory)
    if Antonia_data == 1 && coh_change == 1
        [data_output, cohlvlcoh] = Antonia_coh_level_correction(data_output, stairAud_filename);
    elseif Antonia_data ~= 1 && coh_change == 1
        [data_output, cohlvlcoh] = coh_level_correction(data_output, subjnum_s, ...
        group_s, sex_s, age_s, script_file_directory, data_file_directory, ...
        task_file_directory, stairAud_filename);
    end
    if compare_PILOTpsyAV == 1
        viscoh_list = zeros(1, length(audcoh_list));
        stimcoh_list = [audcoh_list; viscoh_list];
        data_output = coh_to_cohLevel(data_output, stimcoh_list, stairAud_filename);
    end
    [right_vs_left, right_group, left_group] = direction_plotter(data_output);
    rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
    [total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, ...
        coherence_counts, coherence_frequency] = frequency_plotter(data_output, right_vs_left);
    [fig, p_values, ci, threshold, xData, yData, x, p, sz, aud_std_gaussian] = normCDF_plotter(coherence_lvls, ...
    rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
    coherence_frequency, compare_plot, stairAud_filename);
    scatter(xData, yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'r', 'HandleVisibility', 'off');
    hold on
    plot(x, p, 'LineWidth', 3, 'Color', 'r', 'DisplayName', 'Aud staircase');
end

% Visual staircase
if compare_stairVis == 1
    cd(data_file_directory)
    stairVis_filename = sprintf('RDKHoop_stairVis_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
    load(stairVis_filename, 'data_output');
    if compare_PILOTpsyAV == 1
        PILOTpsyAV_filename = sprintf('RDKHoop_PILOTpsyAV_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
        load(PILOTpsyAV_filename, 'viscoh_list')
    end
    cd(script_file_directory)
    if Antonia_data == 1 && coh_change == 1
        [data_output, cohlvlcoh] = Antonia_coh_level_correction(data_output, stairVis_filename);
    elseif Antonia_data ~= 1 && coh_change == 1
        [data_output, cohlvlcoh] = coh_level_correction(data_output, subjnum_s, ...
        group_s, sex_s, age_s, script_file_directory, data_file_directory, ...
        task_file_directory, stairVis_filename);
    end
    if compare_PILOTpsyAV == 1
        audcoh_list = zeros(1, length(viscoh_list));
        stimcoh_list = [audcoh_list; viscoh_list];
        data_output = coh_to_cohLevel(data_output, stimcoh_list, stairVis_filename);
    end
    [right_vs_left, right_group, left_group] = direction_plotter(data_output);
    rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
    [total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, ...
        coherence_counts, coherence_frequency] = frequency_plotter(data_output, right_vs_left);
    [fig, p_values, ci, threshold, xData, yData, x, p, sz, vis_std_gaussian] = normCDF_plotter(coherence_lvls, ...
    rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
    coherence_frequency, compare_plot, stairVis_filename);
    scatter(xData, yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'b', 'HandleVisibility', 'off');
    hold on
    plot(x, p, 'LineWidth', 3, 'Color', 'b', 'DisplayName', 'Vis staircase');
end 

% Auditory unisensory
if compare_psyAud == 1
    cd(data_file_directory)
    psyAud_filename = sprintf('RDKHoop_psyAud_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
    if Antonia_data == 1
        load(psyAud_filename, 'MAT');
    else
        load(psyAud_filename, 'data_output');
    end
    cd(script_file_directory)
    if Antonia_data == 1
        data_output = MAT;
    end
    if Antonia_data == 1 && coh_change == 1
        [data_output, cohlvlcoh] = Antonia_coh_level_correction(data_output, psyAud_filename);
    elseif Antonia_data ~= 1 && coh_change == 1
        [data_output, cohlvlcoh] = coh_level_correction(data_output, subjnum_s, ...
        group_s, sex_s, age_s, script_file_directory, data_file_directory, ...
        task_file_directory, psyAud_filename);
    end
    data_output(data_output(:, 1) == 0, 1) = 3; 
    [right_vs_left, right_group, left_group] = direction_plotter(data_output);
    rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
    [total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, ... 
        coherence_counts, coherence_frequency] = frequency_plotter(data_output, right_vs_left);
    [fig, p_values, ci, threshold, xData, yData, x, p, sz, aud_std_gaussian] = normCDF_plotter(coherence_lvls, ...
    rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
        coherence_frequency, compare_plot, psyAud_filename, vel_stair);
    if Antonia_data == 1
        scatter(xData, yData, sz, 'LineWidth', 3, 'MarkerEdgeColor', 'r', 'HandleVisibility', 'off');
        hold on
        plot(x, p, 'LineWidth', 4, 'Color', 'r', 'DisplayName', 'Aud unisensory');
    else
        scatter(xData, yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'r', 'HandleVisibility', 'off');
        hold on
        plot(x, p, 'LineWidth', 3, 'Color', 'r', 'DisplayName', 'Aud unisensory');
    end
end

% Visual unisensory
if compare_psyVis == 1
    cd(data_file_directory)
    psyVis_filename = sprintf('RDKHoop_psyVis_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
    if Antonia_data == 1
        load(psyVis_filename, 'MAT');
    else
        load(psyVis_filename, 'data_output');
    end
    cd(script_file_directory)
    if Antonia_data == 1
        data_output = MAT;
    end
    if Antonia_data == 1 && coh_change == 1
        [data_output, cohlvlcoh] = Antonia_coh_level_correction(data_output, psyVis_filename);
    elseif Antonia_data ~= 1 && coh_change == 1
        [data_output, cohlvlcoh] = coh_level_correction(data_output, subjnum_s, ...
        group_s, sex_s, age_s, script_file_directory, data_file_directory, ...
        task_file_directory, psyVis_filename);
    end
    data_output(data_output(:, 1) == 0, 1) = 3; 
    [right_vs_left, right_group, left_group] = direction_plotter(data_output);
    rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
    [total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, ... 
        coherence_counts, coherence_frequency] = frequency_plotter(data_output, right_vs_left);
    [fig, p_values, ci, threshold, xData, yData, x, p, sz, vis_std_gaussian] = normCDF_plotter(coherence_lvls, ...
    rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
    coherence_frequency, compare_plot, psyVis_filename, vel_stair);
    if Antonia_data == 1
        scatter(xData, yData, sz, 'LineWidth', 3, 'MarkerEdgeColor', 'b', 'HandleVisibility', 'off');
        hold on
        plot(x, p, 'LineWidth', 4, 'Color', 'b', 'DisplayName', 'Vis unisensory');
    else
        scatter(xData, yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'b', 'HandleVisibility', 'off');
        hold on
        plot(x, p, 'LineWidth', 3, 'Color', 'b', 'DisplayName', 'Vis unisensory');
    end
end

% AV PILOT
if compare_PILOTpsyAV == 1
    cd(data_file_directory)
    try
        PILOTpsyAV_filename = sprintf('RDKHoop_PILOTpsyAV_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
        load(PILOTpsyAV_filename, 'MAT');
        data_output = MAT;
    catch
        PILOTpsyAV_filename = sprintf('RDKHoop_psyAV_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
        load(PILOTpsyAV_filename, 'data_output');
    end
    cd(script_file_directory)
    if coh_change == 1
        data_output = coh_level_correction(data_output, script_file_directory, task_file_directory, PILOTpsyAV_filename);
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
        coherence_frequency, compare_plot, PILOTpsyAV_filename, vel_stair);
    scatter(xData, yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'm', 'HandleVisibility', 'off');
    hold on
    plot(x, p, 'LineWidth', 3, 'Color', 'm', 'DisplayName', 'AV');
end

% if compare_PILOTpsyAV == 1
%     coherence_lvls = abs(coherence_lvls);
%     coherence_lvls = sort(coherence_lvls, 'descend');
%     coherence_lvls = unique(coherence_lvls, 'stable');
%     cd(data_file_directory)
%     try
%         PILOTpsyAV_filename = sprintf('RDKHoop_PILOTpsyAV_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
%         load(PILOTpsyAV_filename, 'audcoh_list')
%         PILOTpsyAV_filename = sprintf('RDKHoop_PILOTpsyAV_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
%         load(PILOTpsyAV_filename, 'viscoh_list')
%         stimcoh_list = [coherence_lvls; audcoh_list; viscoh_list];
%         disp(stimcoh_list)
%     catch
%         PILOTpsyAV_filename = sprintf('RDKHoop_psyAV_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
%         load(PILOTpsyAV_filename, 'audcoh_list')
%         PILOTpsyAV_filename = sprintf('RDKHoop_psyAV_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
%         load(PILOTpsyAV_filename, 'viscoh_list')
%         stimcoh_list = [coherence_lvls; audcoh_list; viscoh_list];
%         disp(stimcoh_list)
%     end
% end

%% Set figure properties
title(sprintf('Psych. Function Comparison: \n %s', identifier), 'Interpreter','none');
legend('Location', 'NorthWest', 'Interpreter', 'none');
xlabel( 'Coherence ((-)Leftward, (+)Rightward)', 'Interpreter', 'none');
ylabel( '% Rightward Response', 'Interpreter', 'none');
if Antonia_data == 1 && coh_change ~= 1
    xlim([-5 5])
elseif compare_PILOTpsyAV == 1
    xlim([-0.5 0.5])
elseif Antonia_data == 1 && coh_change == 1
    xlim([-0.6 0.6])
    axis equal
else
    xlim([-0.5 0.5])
end
ylim([0 1])
grid on
text(0,0.2,"aud cumulative gaussian std: " + aud_std_gaussian)
text(0,0.15,"vis cumulative gaussian std: " + vis_std_gaussian)
if compare_PILOTpsyAV == 1
    text(0,0.1,"av cumulative gaussian std: " + av_std_gaussian)
end
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)

end
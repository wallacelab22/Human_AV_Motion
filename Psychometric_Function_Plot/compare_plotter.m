function [fig] = compare_plotter(compare_plot, data_file_directory, script_file_directory, ...
    subjnum_s, group_s, sex_s, age_s, save_name)

% This is code to plot psychometric functions of different blocks on top of
% one another.
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

% Auditory staircase
if compare_stairAud == 1
    cd(data_file_directory)
    stairAud_filename = sprintf('RDKHoop_stairAud_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
    load(stairAud_filename, 'data_output');
    cd(script_file_directory)
    [right_vs_left, right_group, left_group] = direction_plotter(data_output);
    rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
    [total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, 
        coherence_counts, coherence_frequency] = frequency_plotter(data_output, right_vs_left);
    [fig, p_values, ci, threshold, xData, yData, x, p, sz] = normCDF_plotter(coherence_lvls, ...
    rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
    coherence_frequency, compare_plot, save_name);
    scatter(xData, yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'r');
    hold on
    plot(x, p, 'LineWidth', 3, 'Color', 'r');
end

% Visual staircase
if compare_stairVis == 1
    cd(data_file_directory)
    stairVis_filename = sprintf('RDKHoop_stairVis_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
    load(stairVis_filename, 'data_output');
    cd(script_file_directory)
    [right_vs_left, right_group, left_group] = direction_plotter(data_output);
    rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
    [total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, 
        coherence_counts, coherence_frequency] = frequency_plotter(data_output, right_vs_left);
    [fig, p_values, ci, threshold, xData, yData, x, p, sz] = normCDF_plotter(coherence_lvls, ...
    rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
    coherence_frequency, compare_plot, save_name);
    scatter(xData, yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'b');
    hold on
    plot(x, p, 'LineWidth', 3, 'Color', 'b');
end 

% Auditory unisensory
if compare_psyAud == 1
    cd(data_file_directory)
    psyAud_filename = sprintf('RDKHoop_psyAud_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
    load(psyAud_filename, 'data_output');
    cd(script_file_directory)
    data_output(data_output(:, 1) == 0, 1) = 3; 
    [right_vs_left, right_group, left_group] = direction_plotter(data_output);
    rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
    [total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, ... 
        coherence_counts, coherence_frequency] = frequency_plotter(data_output, right_vs_left);
    [fig, p_values, ci, threshold, xData, yData, x, p, sz] = normCDF_plotter(coherence_lvls, ...
    rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
    coherence_frequency, compare_plot, save_name);
    scatter(xData, yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'r');
    hold on
    plot(x, p, 'LineWidth', 3, 'Color', 'r');
end

% Visual unisensory
if compare_psyVis == 1
    cd(data_file_directory)
    psyVis_filename = sprintf('RDKHoop_psyVis_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
    load(psyVis_filename, 'data_output');
    cd(script_file_directory)
    data_output(data_output(:, 1) == 0, 1) = 3; 
    [right_vs_left, right_group, left_group] = direction_plotter(data_output);
    rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
    [total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, ... 
        coherence_counts, coherence_frequency] = frequency_plotter(data_output, right_vs_left);
    [fig, p_values, ci, threshold, xData, yData, x, p, sz] = normCDF_plotter(coherence_lvls, ...
    rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
    coherence_frequency, compare_plot, save_name);
    scatter(xData, yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'b');
    hold on
    plot(x, p, 'LineWidth', 3, 'Color', 'b');
end

% AV PILOT
if compare_PILOTpsyAV == 1
    cd(data_file_directory)
    PILOTpsyAV_filename = sprintf('RDKHoop_PILOTpsyAV_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
    load(PILOTpsyAV_filename, 'MAT');
    cd(script_file_directory)
    [xData, yData, x, p, sz] = normCDF_plotter(coherence_lvls, ...
    rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
    coherence_frequency, compare_plot, save_name)
    scatter(xData, yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'b');
    hold on
    plot(x, p, 'LineWidth', 3, 'Color', 'b');
end


%% Set figure properties
title(sprintf('Psych. Comparison Function: \n %s',save_name), 'Interpreter','none');
xlabel( 'Coherence ((+)Rightward, (-)Leftward)', 'Interpreter', 'none');
ylabel( '% Rightward Response', 'Interpreter', 'none');
xlim([-1 1])
ylim([0 1])
grid on
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)

end
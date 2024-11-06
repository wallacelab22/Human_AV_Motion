%% 2024 Unity RDK Analysis
clear; close all; clc;

CRT_version = 1;
unity_version = 1;

cd('/Users/a.tiesman/Documents/Research/Human_AV_Motion/')

[file_name, subjnum_s, group_s, sex_s, age_s] = collect_subject_information('RDKHoop_psyVis');
partID = sprintf('%s%s.csv', subjnum_s, group_s);

%% UNITY version
if unity_version
    cd('/Users/a.tiesman/Documents/Research/Human_AV_Motion/data_analysis')
    block = 'vrarVis';
    unity_file_name = sprintf('%s_%s', block, partID);
    dataVis = readtable(unity_file_name);
    
    dataVis{dataVis{:, 1} == -1, 1} = 2;
    dataVis{dataVis{:, 3} == -1, 3} = 2;
    
    dataVis = table2array(dataVis);

    save_name = 'psy';
    [right_vs_left, right_group, left_group] = direction_plotter(dataVis);
    rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, 1, 2);
    [total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, coherence_counts, coherence_frequency] = frequency_plotter(dataVis, right_vs_left);
    [fig, p_values, ci, threshold, xData, yData, x, p, sz, std_gaussian_unity, mdl_unity] = normCDF_plotter(coherence_lvls, rightward_prob, 0.72, left_coh_vals, right_coh_vals, coherence_frequency, 0, save_name, 0);    
    scatter(xData, yData, sz, 'LineWidth', 3, 'MarkerEdgeColor', '#4575b4', 'HandleVisibility', 'off');
    hold on
    plot(x, p, 'LineWidth', 3, 'Color', '#4575b4', 'DisplayName', 'Vis Unity');
    hold on
end

if CRT_version
    cd('/Users/a.tiesman/Documents/Research/Human_AV_Motion/data');
    load(file_name);
    dataVis = data_output;
    cd('/Users/a.tiesman/Documents/Research/Human_AV_Motion/data_analysis');
    dataVis(dataVis(:, 1) == 0, 1) = 3; 
    
    save_name = 'psy';
    [right_vs_left, right_group, left_group] = direction_plotter(dataVis);
    rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, 1, 2);
    [total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, coherence_counts, coherence_frequency] = frequency_plotter(dataVis, right_vs_left);
    [fig, p_values, ci, threshold, xData, yData, x, p, sz, std_gaussian_CRT, mdl_CRT] = normCDF_plotter(coherence_lvls, rightward_prob, 0.72, left_coh_vals, right_coh_vals, coherence_frequency, 0, save_name, 0);    
    scatter(xData, yData, sz, 'LineWidth', 3, 'MarkerEdgeColor', 'k', 'HandleVisibility', 'off');
    hold on
    plot(x, p, 'LineWidth', 3, 'Color', 'k', 'DisplayName', 'Vis CRT');
    hold on
end

save_name = sprintf('%s_%s', subjnum_s, group_s);
title(sprintf('Psych. Function Comparison: \n %s', save_name), 'Interpreter','none');
legend('Location', 'NorthWest', 'Interpreter', 'none');
xlabel( 'Coherence ((-)Leftward, (+)Rightward)', 'Interpreter', 'none');
ylabel( 'Proportion Rightward Response', 'Interpreter', 'none');
axis equal
xlim([-0.5 0.5])
ylim([0 1])
grid on
if unity_version
    slope_unity = 1/std_gaussian_unity;
    text(0,0.15,"Unity Vis Slope: " + slope_unity)
end
if CRT_version
    slope_CRT = 1/std_gaussian_CRT;
    text(0,0.05,"CRT Vis Slope: " + slope_CRT)
end
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
beautifyplot;
unmatlabifyplot;
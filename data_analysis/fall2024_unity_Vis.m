%% 2024 Unity RDK Analysis
clear; close all; clc;
unity_version = 1;

if unity_version
    block = 'vrarVis_';
    partID = input('Participant No. : ');
    partID = num2str(partID);
    partID = '000' + partID + '.csv';
    file_name = block + partID;
    dataVis = readtable(file_name);
    
    dataVis{dataVis{:, 1} == -1, 1} = 2;
    dataVis{dataVis{:, 3} == -1, 3} = 2;
    
    dataVis = table2array(dataVis);
else
    cd('/Users/a.tiesman/Documents/Research/Human_AV_Motion');
    task_nature = input('Staircase = 1;  Method of constant stimuli (MCS) = 2 : ');
    if task_nature == 1
        block = 'RDKHoop_stairVis';
    elseif task_nature == 2
        block = 'RDKHoop_psyVis';
    end
    [file_name, subjnum_s, group_s, sex_s, age_s] = collect_subject_information(block);
    cd('/Users/a.tiesman/Documents/Research/Human_AV_Motion/data');
    load(file_name);
    dataVis = data_output;
    cd('/Users/a.tiesman/Documents/Research/Human_AV_Motion/data_analysis');
    dataVis(dataVis(:, 1) == 0, 1) = 3; 
end


save_name = 'stair';
[right_vs_left, right_group, left_group] = direction_plotter(dataVis);
rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, 1, 2);
[total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, coherence_counts, coherence_frequency] = frequency_plotter(dataVis, right_vs_left);
[fig, p_values, ci, threshold, xData, yData, x, p, sz, std_gaussian, mdl] = normCDF_plotter(coherence_lvls, rightward_prob, 0.72, left_coh_vals, right_coh_vals, coherence_frequency, 0, save_name, 0);    
scatter(xData, yData, sz, 'LineWidth', 3, 'MarkerEdgeColor', 'b', 'HandleVisibility', 'off');
hold on
plot(x, p, 'LineWidth', 3, 'Color', 'b', 'DisplayName', 'Vis unisensory');
save_name = file_name;

title(sprintf('Psych. Function Comparison: \n %s', save_name), 'Interpreter','none');
legend('Location', 'NorthWest', 'Interpreter', 'none');
xlabel( 'Coherence ((-)Leftward, (+)Rightward)', 'Interpreter', 'none');
ylabel( 'Proportion Rightward Response', 'Interpreter', 'none');
axis equal
xlim([-0.5 0.5])
ylim([0 1])
grid on
text(0,0.15,"vis sensitivity: " + std_gaussian)
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
beautifyplot;
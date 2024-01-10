function [accuracy, stairstep] = analyze_data(data_output, save_name, analysis_directory, right_var, left_var, catch_var)

cd(analysis_directory)

%% Split the data by direction of motion for the trial
[right_vs_left, right_group, left_group] = direction_plotter(data_output);

%% Loop over each coherence level and extract the corresponding rows of the matrix for leftward, catch, and rightward trials
rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);

%% Create frequency count for each coherence level
[total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, coherence_counts, coherence_frequency] = frequency_plotter(data_output, right_vs_left);

%% Create a graph of percent correct at each coherence level
accuracy = accuracy_plotter(right_vs_left, right_group, left_group, save_name);

%% Create a Normal Cumulative Distribution Function (NormCDF)
%     CDF = normCDF_plotter(coherence_lvls, rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, coherence_frequency, save_name);

%% Create a stairstep graph for visualizing staircase
stairstep = stairstep_plotter(data_output, save_name);
end
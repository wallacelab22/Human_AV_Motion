%% Cued Task Publication Quality Figures
clear; close all; clc;

single_group_scatters = input('Plot Single Group Scatters? 0 = NO; 1 = YES : ');
single_group_regressions = input('Plot Single Group Regressions? 0 = NO; 1 = YES : ');
single_variable_distributions = input('Plot Single Variable Distributions? 0 = NO; 1 = YES : ');
multiple_group_scatters = input('Plot Multiple Groups Scatters? 0 = NO; 1 = YES : ');

%% Figure variables to keep uniform throughout
scatter_size = 500;
aud_color = '#d73027'; vis_color = '#4575b4'; both_color = '#009304';
aud_icon = 'o'; vis_icon = '^'; both_icon = 's';
figure_font_size = 30; single_group = 1;
save_jpg_figures = 0; save_eps_figures = 0; save_names = {};

data_analysis_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/data_analysis';
figure_file_directory = '/Users/a.tiesman/Documents/Research/Paper Figures';

%% Load in the group data
cd(data_analysis_directory)

dataAll = readtable('group_cue_data.xlsx',  'Sheet', 'data_final');

AO_Slope = table2array(dataAll(:, 6));
VO_Slope = table2array(dataAll(:, 8));
AV_Aud_Slope = table2array(dataAll(:, 10));
AV_Vis_Slope = table2array(dataAll(:, 12));
AV_AV_Slope = table2array(dataAll(:, 14));
Best_AO_VO_Slope = table2array(dataAll(:, 16));
Best_MSCue_Slope = table2array(dataAll(:, 18));
Incong_AV_Aud_Slope = table2array(dataAll(:, 20));
Incong_AV_Vis_Slope = table2array(dataAll(:, 22));
Aud_Weight = table2array(dataAll(:, 23));
Vis_Weight = table2array(dataAll(:, 24));
AV_EstimatedSlope = table2array(dataAll(:, 26));
MS_Gain_Slope = table2array(dataAll(:, 28));
Worst_Unisensory_Weight = table2array(dataAll(:, 29));

%% Plot the figures
if single_group_scatters
    % --- Plot 1: Cue Aud vs AO ---
    x_name = 'No Cue Auditory Only Sensitivity';
    y_name = 'Auditory-Cued Congruent Audiovisual Sensitivity';
    
    pubfig_scatter_plotter(AO_Slope, AV_Aud_Slope, aud_icon, aud_color, figure_font_size, scatter_size, x_name, y_name, single_group);
    delta_histogram_plotter(AO_Slope, AV_Aud_Slope, aud_color, figure_font_size, x_name, y_name, single_group);
    
    save_names{end+1} = sprintf('%s vs. %s Scatter', x_name, y_name);
    save_names{end+1} = sprintf('%s vs. %s Delta Histogram', x_name, y_name);
    
    % --- Plot 2: Cue Vis vs VO ---
    x_name = 'No Cue Visual Only Sensitivity';
    y_name = 'Visual-Cued Congruent Audiovisual Sensitivity';
    
    pubfig_scatter_plotter(VO_Slope, AV_Vis_Slope, vis_icon, vis_color, figure_font_size, scatter_size, x_name, y_name, single_group);
    delta_histogram_plotter(VO_Slope, AV_Vis_Slope, vis_color, figure_font_size, x_name, y_name, single_group);
    
    save_names{end+1} = sprintf('%s vs. %s Scatter', x_name, y_name);
    save_names{end+1} = sprintf('%s vs. %s Delta Histogram', x_name, y_name);
    
    % --- Plot 3: AO vs VO ---
    x_name = 'No Cue Auditory Only Sensitivity';
    y_name = 'No Cue Visual Only Sensitivity';
    
    pubfig_scatter_plotter(AO_Slope, VO_Slope, both_icon, both_color, figure_font_size, scatter_size, x_name, y_name, single_group);
    delta_histogram_plotter(AO_Slope, VO_Slope, both_color, figure_font_size, x_name, y_name, single_group);
    
    save_names{end+1} = sprintf('%s vs. %s Scatter', x_name, y_name);
    save_names{end+1} = sprintf('%s vs. %s Delta Histogram', x_name, y_name);
    
    % --- Plot 4: Cue Aud vs Cue Audiovisual  ---
    x_name = 'Auditory-Cued Congruent Audiovisual Sensitivity';
    y_name = 'Audiovisual-Cued Congruent Audiovisual Sensitivity';
    
    pubfig_scatter_plotter(AV_Aud_Slope, AV_AV_Slope, aud_icon, aud_color, figure_font_size, scatter_size, x_name, y_name, single_group);
    delta_histogram_plotter(AV_Aud_Slope, AV_AV_Slope, aud_color, figure_font_size, x_name, y_name, single_group);
    
    save_names{end+1} = sprintf('%s vs. %s Scatter', x_name, y_name);
    save_names{end+1} = sprintf('%s vs. %s Delta Histogram', x_name, y_name);
    
    % --- Plot 5: Cue Vis vs Cue Audiovisual  ---
    x_name = 'Visual-Cued Congruent Audiovisual Sensitivity';
    y_name = 'Audiovisual-Cued Congruent Audiovisual Sensitivity';
    
    pubfig_scatter_plotter(AV_Vis_Slope, AV_AV_Slope, vis_icon, vis_color, figure_font_size, scatter_size, x_name, y_name, single_group);
    delta_histogram_plotter(AV_Vis_Slope, AV_AV_Slope, vis_color, figure_font_size, x_name, y_name, single_group);
    
    save_names{end+1} = sprintf('%s vs. %s Scatter', x_name, y_name);
    save_names{end+1} = sprintf('%s vs. %s Delta Histogram', x_name, y_name);
    
    % --- Plot 6: AO vs Incongruent Cue Auditory ---
    x_name = 'No Cue Auditory Only Sensitivity';
    y_name = 'Auditory-Cued Incongruent Audiovisual Sensitivity';
    
    pubfig_scatter_plotter(AO_Slope, Incong_AV_Aud_Slope, aud_icon, aud_color, figure_font_size, scatter_size, x_name, y_name, single_group);
    delta_histogram_plotter(AO_Slope, Incong_AV_Aud_Slope, aud_color, figure_font_size, x_name, y_name, single_group);
    
    save_names{end+1} = sprintf('%s vs. %s Scatter', x_name, y_name);
    save_names{end+1} = sprintf('%s vs. %s Delta Histogram', x_name, y_name);
    
    % --- Plot 7: VO vs Incongruent Cue Visual  ---
    x_name = 'No Cue Visual Only Sensitivity';
    y_name = 'Visual-Cued Incongruent Audiovisual Sensitivity';
    
    pubfig_scatter_plotter(VO_Slope, Incong_AV_Vis_Slope, vis_icon, vis_color, figure_font_size, scatter_size, x_name, y_name, single_group);
    delta_histogram_plotter(VO_Slope, Incong_AV_Vis_Slope, vis_color, figure_font_size, x_name, y_name, single_group);
    
    save_names{end+1} = sprintf('%s vs. %s Scatter', x_name, y_name);
    save_names{end+1} = sprintf('%s vs. %s Delta Histogram', x_name, y_name);
    
    % --- Plot 8: Congruent Cue Auditory vs Incongruent Cue Auditory ---
    x_name = 'Auditory-Cued Congruent Audiovisual Sensitivity';
    y_name = 'Auditory-Cued Incongruent Audiovisual Sensitivity';
    
    pubfig_scatter_plotter(AV_Aud_Slope, Incong_AV_Aud_Slope, aud_icon, aud_color, figure_font_size, scatter_size, x_name, y_name, single_group);
    delta_histogram_plotter(AV_Aud_Slope, Incong_AV_Aud_Slope, aud_color, figure_font_size, x_name, y_name, single_group);
    
    save_names{end+1} = sprintf('%s vs. %s Scatter', x_name, y_name);
    save_names{end+1} = sprintf('%s vs. %s Delta Histogram', x_name, y_name);
    
    % --- Plot 9: Congruent Cue Visual vs Incongruent Cue Visual  ---
    x_name = 'Visual-Cued Congruent Audiovisual Sensitivity';
    y_name = 'Visual-Cued Incongruent Audiovisual Sensitivity';
    
    pubfig_scatter_plotter(AV_Vis_Slope, Incong_AV_Vis_Slope, vis_icon, vis_color, figure_font_size, scatter_size, x_name, y_name, single_group);
    delta_histogram_plotter(AV_Vis_Slope, Incong_AV_Vis_Slope, vis_color, figure_font_size, x_name, y_name, single_group);
    
    save_names{end+1} = sprintf('%s vs. %s Scatter', x_name, y_name);
    save_names{end+1} = sprintf('%s vs. %s Delta Histogram', x_name, y_name);
    
    % --- Plot 10: Cue Auditory vs Cue Audiovisual  ---
    x_name = 'Auditory-Cued Congruent Audiovisual Sensitivity';
    y_name = 'Audiovisual-Cued Congruent Audiovisual Sensitivity';
    
    pubfig_scatter_plotter(AV_Aud_Slope, AV_AV_Slope, aud_icon, aud_color, figure_font_size, scatter_size, x_name, y_name, single_group);
    delta_histogram_plotter(AV_Aud_Slope, AV_AV_Slope, aud_color, figure_font_size, x_name, y_name, single_group);
    
    save_names{end+1} = sprintf('%s vs. %s Scatter', x_name, y_name);
    save_names{end+1} = sprintf('%s vs. %s Delta Histogram', x_name, y_name);
    
    % --- Plot 11: Cue Visual vs Cue Audiovisual  ---
    x_name = 'Visual-Cued Congruent Audiovisual Sensitivity';
    y_name = 'Audiovisual-Cued Congruent Audiovisual Sensitivity';
    
    pubfig_scatter_plotter(AV_Vis_Slope, AV_AV_Slope, vis_icon, vis_color, figure_font_size, scatter_size, x_name, y_name, single_group);
    delta_histogram_plotter(AV_Vis_Slope, AV_AV_Slope, vis_color, figure_font_size, x_name, y_name, single_group);
    
    save_names{end+1} = sprintf('%s vs. %s Scatter', x_name, y_name);
    save_names{end+1} = sprintf('%s vs. %s Delta Histogram', x_name, y_name);
    
    % --- Plot 12: Cue Auditory vs Cue Visual  ---
    x_name = 'Auditory-Cued Congruent Audiovisual Sensitivity';
    y_name = 'Visual-Cued Congruent Audiovisual Sensitivity';
    
    pubfig_scatter_plotter(AV_Aud_Slope, AV_Vis_Slope, both_icon, both_color, figure_font_size, scatter_size, x_name, y_name, single_group);
    delta_histogram_plotter(AV_Aud_Slope, AV_Vis_Slope, both_color, figure_font_size, x_name, y_name, single_group);
    
    save_names{end+1} = sprintf('%s vs. %s Scatter', x_name, y_name);
    save_names{end+1} = sprintf('%s vs. %s Delta Histogram', x_name, y_name);
end

if single_group_regressions
    % --- Plot 13: Linear Regression Vis Weight vs Cue AV ---
    x_name = 'Visual Weight (1 - Auditory Weight)';
    y_name = 'Audiovisual-Cued Congruent Audiovisual Sensitivity';
    x_lim = [0 1]; x_ticks = [0 0.2 0.4 0.6 0.8 1.0];
    y_lim = [0 20]; y_ticks = [0 4 8 12 16 20];
    
    linear_regression_plotter(Vis_Weight, AV_AV_Slope, both_icon, both_color, figure_font_size, scatter_size, x_name, y_name, x_lim, x_ticks, y_lim, y_ticks)
    
    save_names{end+1} = sprintf('%s vs. %s Linear Regression', x_name, y_name);
    
    % --- Plot 14: Linear Regression Worst Weight vs MS Gain ---
    x_name = 'Worst Unisensory Weight';
    y_name = 'Audiovisual Sensitivity Gain (%)';
    x_lim = [0 0.5]; x_ticks = [0 0.1 0.2 0.3 0.4 0.5];
    y_lim = [-2 2]; y_ticks = [-2 -1.5 -1 -0.5 0 0.5 1 1.5 2];
    
    linear_regression_plotter(Worst_Unisensory_Weight, MS_Gain_Slope, both_icon, both_color, figure_font_size, scatter_size, x_name, y_name, x_lim, x_ticks, y_lim, y_ticks)
    
    save_names{end+1} = sprintf('%s vs. %s Linear Regression', x_name, y_name);
end

%% --- Plot 15a and 15b: Unisensory Slope Distribution
if single_variable_distributions
    x_name = 'No Cue Auditory Only Sensitivity)';
    delta_histogram_plotter(AO_Slope, 0, aud_color, figure_font_size, x_name, 0, single_group);
    
    x_name = 'No Cue Visual Only Sensitivity)';
    delta_histogram_plotter(VO_Slope, 0, vis_color, figure_font_size, x_name, 0, single_group);
end

%% --- Plot 16a, 16b, and 16c: Combining Scatter Plots
if multiple_group_scatters
    % --- Plotting Unisensory Scatters on Same Plot
    x_name = 'No Cue Unisensory Only Sensitivity';
    y_name = 'Unisensory-Cued Congruent Audiovisual Sensitivity';
    single_group = 0; figure;
    
    [h_aud] = pubfig_scatter_plotter(AO_Slope, AV_Aud_Slope, aud_icon, aud_color, figure_font_size, scatter_size, x_name, y_name, single_group);
    
    [h_vis] = pubfig_scatter_plotter(VO_Slope, AV_Vis_Slope, vis_icon, vis_color, figure_font_size, scatter_size, x_name, y_name, single_group);
    
    figure(gcf);
    [leg, icons] = legend([h_aud, h_vis], 'Auditory', 'Visual', 'Location', 'northwest', 'FontSize', figure_font_size, 'FontName', 'Times New Roman');
    h.ItemTokenSize = [25, 25];
    icons = findobj(icons, 'Type', 'patch');
    icons = findobj(icons, 'Marker', 'none', '-xor');
    set(icons(1), 'MarkerSize', 20); 
    set(icons(2), 'MarkerSize', 20); 

    hold off;
    
    [h_aud] = delta_histogram_plotter(AO_Slope, AV_Aud_Slope, aud_color, figure_font_size, x_name, y_name, single_group);
    [h_vis] = delta_histogram_plotter(VO_Slope, AV_Vis_Slope, vis_color, figure_font_size, x_name, y_name, single_group);

    figure(gcf);
    [leg, icons] = legend([h_aud, h_vis], 'Auditory', 'Visual', 'Location', 'northwest', 'FontSize', figure_font_size, 'FontName', 'Times New Roman');
   
    h.ItemTokenSize = [25, 25];
    icons = findobj(icons, 'Type', 'patch');
    icons = findobj(icons, 'Marker', 'none', '-xor');
    set(icons(1), 'MarkerSize', 20); 
    set(icons(2), 'MarkerSize', 20);

    hold off;

    save_names{end+1} = sprintf('%s vs. %s Multiple Scatters', x_name, y_name);
    save_names{end+1} = sprintf('%s vs. %s Multiple Histograms', x_name, y_name);

    % --- Plotting Incongruent Scatters on Same Plot
    x_name = 'No Cue Unisensory Only Sensitivity';
    y_name = 'Unisensory-Cued Incongruent Audiovisual Sensitivity';
    single_group = 0; figure;
    
    [h_aud] = pubfig_scatter_plotter(AO_Slope, Incong_AV_Aud_Slope, aud_icon, aud_color, figure_font_size, scatter_size, x_name, y_name, single_group);
    
    [h_vis] = pubfig_scatter_plotter(VO_Slope, Incong_AV_Vis_Slope, vis_icon, vis_color, figure_font_size, scatter_size, x_name, y_name, single_group);
    
    figure(gcf);
    [leg, icons] = legend([h_aud, h_vis], 'Auditory', 'Visual', 'Location', 'northwest', 'FontSize', figure_font_size, 'FontName', 'Times New Roman');

    h.ItemTokenSize = [25, 25];
    icons = findobj(icons, 'Type', 'patch');
    icons = findobj(icons, 'Marker', 'none', '-xor');
    set(icons(1), 'MarkerSize', 20); 
    set(icons(2), 'MarkerSize', 20);

    hold off;
    
    [h_aud] = delta_histogram_plotter(AO_Slope, AV_Aud_Slope, aud_color, figure_font_size, x_name, y_name, single_group);
    [h_vis] = delta_histogram_plotter(VO_Slope, AV_Vis_Slope, vis_color, figure_font_size, x_name, y_name, single_group);

    figure(gcf);
    [leg, icons] = legend([h_aud, h_vis], 'Auditory', 'Visual', 'Location', 'northwest', 'FontSize', figure_font_size, 'FontName', 'Times New Roman');
    h.ItemTokenSize = [25, 25];
    icons = findobj(icons, 'Type', 'patch');
    icons = findobj(icons, 'Marker', 'none', '-xor');
    set(icons(1), 'MarkerSize', 20); 
    set(icons(2), 'MarkerSize', 20);

    hold off;

    save_names{end+1} = sprintf('%s vs. %s Multiple Scatters', x_name, y_name);
    save_names{end+1} = sprintf('%s vs. %s Multiple Histograms', x_name, y_name);

    % --- Plotting Multisensory Scatters on Same Plot
    x_name = 'Unisensory-Cued Congruent Audiovisual Sensitivity';
    y_name = 'Audiovisual-Cued Congruent Audiovisual Sensitivity';
    single_group = 0; figure;
    
    [h_aud] = pubfig_scatter_plotter(AV_Aud_Slope, AV_AV_Slope, aud_icon, aud_color, figure_font_size, scatter_size, x_name, y_name, single_group);
    
    [h_vis] = pubfig_scatter_plotter(AV_Vis_Slope, AV_AV_Slope, vis_icon, vis_color, figure_font_size, scatter_size, x_name, y_name, single_group);
    
    figure(gcf);
    [leg, icons] = legend([h_aud, h_vis], 'Auditory', 'Visual', 'Location', 'northwest', 'FontSize', figure_font_size, 'FontName', 'Times New Roman');
    h.ItemTokenSize = [25, 25];
    icons = findobj(icons, 'Type', 'patch');
    icons = findobj(icons, 'Marker', 'none', '-xor');
    set(icons(1), 'MarkerSize', 20); 
    set(icons(2), 'MarkerSize', 20);

    hold off;
    
    [h_aud] = delta_histogram_plotter(AO_Slope, AV_Aud_Slope, aud_color, figure_font_size, x_name, y_name, single_group);
    [h_vis] = delta_histogram_plotter(VO_Slope, AV_Vis_Slope, vis_color, figure_font_size, x_name, y_name, single_group);

    figure(gcf);
    [leg, icons] = legend([h_aud, h_vis], 'Auditory', 'Visual', 'Location', 'northwest', 'FontSize', figure_font_size, 'FontName', 'Times New Roman');
    h.ItemTokenSize = [25, 25];
    icons = findobj(icons, 'Type', 'patch');
    icons = findobj(icons, 'Marker', 'none', '-xor');
    set(icons(1), 'MarkerSize', 20); 
    set(icons(2), 'MarkerSize', 20);

    hold off;

    save_names{end+1} = sprintf('%s vs. %s Multiple Scatters', x_name, y_name);
    save_names{end+1} = sprintf('%s vs. %s Multiple Histograms', x_name, y_name);
end

%% Save figures
if save_jpg_figures % JPG format
    cd(figure_file_directory)
    figures = findobj('Type', 'figure');  % Find all figure handles
    
    for i = 1:length(figures)
        fig = figures(i);
        figure(fig);  % Make the figure active
    
        % Append '.jpg' extension to the filename for the JPEG print
        filename_jpg = [save_names{i}, '.jpg'];
    
        % Save the figure as a .jpg
        print(fig, filename_jpg, '-djpeg', '-r300');  % '-r300' for 300 DPI resolution
    end
end

if save_eps_figures % EPS format
    cd(figure_file_directory)
    figures = findobj('Type', 'figure');  % Find all figure handles
    
    for i = 1:length(figures)
        fig = figures(i);
        figure(fig);  % Make the figure active
    
        % Append '.eps' extension to the filename for the EPS print
        filename_eps = [save_names{i}, '.eps'];
    
        % Save the figure as a .eps
        print(fig, filename_eps, '-depsc', '-r300');  % '-depsc' for color EPS format
    end
end

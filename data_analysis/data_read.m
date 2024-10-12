function [finalTable] = data_read(variableNames, excelFileName, inputSheet, outputSheet, data_file_directory, script_file_directory, figure_file_directory)

%% Set variables
vel_stair = 0;
save_fig = 0;
estimated_AV = 1;
figures = 0;

% Read the participant data from `data_to_analyze` sheet
[~, ~, raw] = xlsread(excelFileName, inputSheet);
headers = raw(1, :);
participantData = raw(2:end, :);
numParticipants = size(participantData, 1);

% Initialize the results table
numVariables = length(variableNames);
resultsTable = cell(numParticipants, numVariables);

for p = 1:numParticipants
    % Load participant information
    subjnum = participantData{p, 1};
    group = participantData{p, 2};
    sex = participantData{p, 3};
    age = participantData{p, 4};

    part_ID = [subjnum group sex age];

    % Format participant information for filenames
    subjnum_s = sprintf('%02d', subjnum);
    group_s = sprintf('%02d', group);
    sex_s = sprintf('%02d', sex);
    age_s = sprintf('%02d', age);

    %% Load experimental data
    cd(data_file_directory)
    psyAV_filename = sprintf('RDKHoop_psyAV_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
    load(psyAV_filename)
    cd(script_file_directory)

    [boxplot_accuracies, violation, RT_gain, aud_coh, vis_coh, AV_accuracy_CDF_points] = PERFvsSTIM_accuracy_plotter(data_output, subjnum_s, group_s, figure_file_directory, save_fig, figures);

    clear data_output
    cd(data_file_directory)
    stairAud_filename = sprintf('RDKHoop_stairAud_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
    load(stairAud_filename)
    dataAud = data_output;

    for i = 1:length(dataAud)
        if dataAud(i, 2:7) == 0
            stopRow = i;
            break;
        end
    end
    dataAud = dataAud(1:stopRow - 1, :);

    clear save_name
    clear data_output

    stairVis_filename = sprintf('RDKHoop_stairVis_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
    load(stairVis_filename)
    dataVis = data_output;

    for i = 1:length(dataVis)
        if dataVis(i, 2:7) == 0
            stopRow = i;
            break;
        end
    end
    dataVis = dataVis(1:stopRow - 1, :);

    dataALL = {};
    dataALL{1}.dataRaw = dataAud;
    dataALL{2}.dataRaw = dataVis;

    % Calculate psychometric functions and thresholds
    right_var = 1;
    left_var = 2;
    chosen_threshold = 0.72;
    vel_stair = 0;

    [right_vs_left_Aud, right_group_Aud, left_group_Aud] = direction_plotter(dataALL{1}.dataRaw);
    [right_vs_left_Vis, right_group_Vis, left_group_Vis] = direction_plotter(dataALL{2}.dataRaw);

    rightward_prob_Aud = unisensory_rightward_prob_calc(right_vs_left_Aud, right_group_Aud, left_group_Aud, right_var, left_var);
    rightward_prob_Vis = unisensory_rightward_prob_calc(right_vs_left_Vis, right_group_Vis, left_group_Vis, right_var, left_var);

    [total_coh_frequency_Aud, left_coh_vals_Aud, right_coh_vals_Aud, coherence_lvls_Aud, coherence_counts_Aud, coherence_frequency_Aud] = frequency_plotter(dataALL{1}.dataRaw, right_vs_left_Aud);
    [total_coh_frequency_Vis, left_coh_vals_Vis, right_coh_vals_Vis, coherence_lvls_Vis, coherence_counts_Vis, coherence_frequency_Vis] = frequency_plotter(dataALL{2}.dataRaw, right_vs_left_Vis);

    [~, ~, ~, ~, dataALL{1}.xData, dataALL{1}.yData, ~, ~, ~, dataALL{1}.std_gaussian, dataALL{1}.mdl] = normCDF_plotter(coherence_lvls_Aud, ...
        rightward_prob_Aud, chosen_threshold, left_coh_vals_Aud, right_coh_vals_Aud, ...
        coherence_frequency_Aud, 0, 'stairAud', vel_stair);

    [~, ~, ~, ~, dataALL{2}.xData, dataALL{2}.yData, ~, ~, ~, dataALL{2}.std_gaussian, dataALL{2}.mdl] = normCDF_plotter(coherence_lvls_Vis, ...
        rightward_prob_Vis, chosen_threshold, left_coh_vals_Vis, right_coh_vals_Vis, ...
        coherence_frequency_Vis, 0, 'stairVis', vel_stair);

    % MLE Calculations
    [Results_MLE] = MLE_Calculations_A_V(dataALL{1}.mdl, dataALL{2}.mdl, dataALL{1}.yData, dataALL{2}.yData, dataALL{1}.xData, dataALL{2}.xData);
    if figures
        if estimated_AV
            plot_num = 3;
        else
            plot_num = 2;
        end
        for i = 1:plot_num
            if i == 1
                scatter(dataALL{i}.xData, dataALL{i}.yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'r', 'HandleVisibility', 'off');
                hold on
                plot(x, p, 'LineWidth', 3, 'Color', 'r', 'DisplayName', 'Aud unisensory');
            elseif i == 2
                scatter(dataALL{i}.xData, dataALL{i}.yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', 'b', 'HandleVisibility', 'off');
                hold on
                plot(x, p, 'LineWidth', 3, 'Color', 'b', 'DisplayName', 'Vis unisensory');
            elseif i == 3
                plotEstimatedAV(Results_MLE.AV_EstimatedSD, [dataALL{1}.mdl.Coefficients{1,1} dataALL{2}.mdl.Coefficients{1,1}], [Results_MLE.AUD_Westimate Results_MLE.VIS_Westimate], aud_coh, vis_coh, AV_accuracy_CDF_points)
            end
        end
    end
    
    % Assign variables to be read into excel file
    aud_stair_thres = aud_coh;
    vis_stair_thres = vis_coh;
    aud_std = dataALL{1}.std_gaussian;
    vis_std = dataALL{2}.std_gaussian;
    aud_mu = dataALL{1}.mdl.Coefficients{1,1};
    vis_mu = dataALL{2}.mdl.Coefficients{1,1};
    maxA_V = max(boxplot_accuracies(1:2));
    AV_perf = boxplot_accuracies(3);
    MS_Gain = (AV_perf - maxA_V)/(maxA_V);
    SD_diff = dataALL{1}.std_gaussian - dataALL{2}.std_gaussian;
    Mu_diff = dataALL{1}.mdl.Coefficients{1,1} - dataALL{2}.mdl.Coefficients{1,1};
    SD_ratio = dataALL{1}.std_gaussian / dataALL{2}.std_gaussian;
    Mu_ratio = dataALL{1}.mdl.Coefficients{1,1} / dataALL{2}.mdl.Coefficients{1,1};
    aud_weight = Results_MLE.AUD_Westimate;
    vis_weight = Results_MLE.VIS_Westimate;
    AV_estimated_SD = Results_MLE.AV_EstimatedSD;
    aud_r2 = Results_MLE.AUD_R2;
    vis_r2 = Results_MLE.VIS_R2;
    AO = boxplot_accuracies(1);
    VO = boxplot_accuracies(2);
    Av_stim = boxplot_accuracies(4);
    aV_stim = boxplot_accuracies(5);
    A_Vnoise = boxplot_accuracies(6);
    V_Anoise = boxplot_accuracies(7);
    

    % Populate the resultsTable with the variables requested in `variableNames`
    for varIdx = 1:numVariables
        varName = variableNames{varIdx};
        if exist(varName, "var")
            resultsTable{p, varIdx} = eval(varName);
        else
            warning(['Variable ' varName ' does not exist in the workspace.']);
            resultsTable{p, varIdx} = NaN;
        end
    end
end

% Convert results to a table
finalTable = cell2table(resultsTable, 'VariableNames', variableNames);

% Check if the output Excel file already has headers
try
    [~, ~, raw] = xlsread(excelFileName, outputSheet);
    lastRow = size(raw, 1);
catch
    % If the file or sheet does not exist, initialize the file
    lastRow = 0;
end

% Determine the starting cell
startCell = ['A' num2str(lastRow + 1)];

% Ensure the file has headers if it's a new file
if lastRow == 0
    writecell(variableNames, excelFileName, 'Sheet', outputSheet, 'Range', 'A1');
    startCell = 'A2';
end

% Write the data to the next available row
writetable(finalTable, excelFileName, 'Sheet', outputSheet, 'Range', startCell, 'WriteVariableNames', false);

disp('Data written successfully to Excel!');

end
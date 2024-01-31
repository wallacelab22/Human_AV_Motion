% RACE Model
clear all
close all


%% A, V, and AV analysis %%%%%%%%%%%%

data_analysis = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/data_analysis';
RACE_analysis = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/data_analysis/RaceModel-master';

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
end


% Your data matrices
auditoryData = loaded_data{1,1}.data_output; % Your auditory data matrix
visualData = loaded_data{1,2}.data_output; % Your visual data matrix
audioVisualData = loaded_data{1,3}.data_output; % Your audio-visual data matrix

% Extract unique coherence levels
coherenceLevels = unique(auditoryData(:, 2));% Assuming the same coherence levels for all conditions
cohCheck = length(coherenceLevels);
if cohCheck == 9
    coherenceLevels = [coherenceLevels(1); coherenceLevels(3:end)]; 
end
AV_coherenceLevels = unique(audioVisualData(:,2));

% Initialize variables to store CDFs
auditoryCDFs = [];
visualCDFs = [];
audioVisualCDFs = [];
binCentersGlobal = [];

% Loop over each coherence level
for i = 1:length(coherenceLevels)
    cohLevel = coherenceLevels(i);
    AV_cohLevel = AV_coherenceLevels(i);

    % Extract reaction times for the current coherence level for each condition
    auditoryRT = auditoryData(auditoryData(:, 2) == cohLevel, 4);
    visualRT = visualData(visualData(:, 2) == cohLevel, 4);
    audioVisualRT = audioVisualData(audioVisualData(:, 2) == AV_cohLevel, 6);

    % Check if data is available for the current coherence level
    if isempty(audioVisualRT)
        disp(['No audio-visual data for coherence level ' num2str(cohLevel)]);
        continue; % Skip this iteration if no data
    end

    % Create cumulative distributions
    edges = linspace(min([auditoryRT; visualRT; audioVisualRT]), max([auditoryRT; visualRT; audioVisualRT]), 100);
    auditoryCDF = cumsum(histcounts(auditoryRT, edges, 'Normalization', 'probability'));
    visualCDF = cumsum(histcounts(visualRT, edges, 'Normalization', 'probability'));
    audioVisualCDF = cumsum(histcounts(audioVisualRT, edges, 'Normalization', 'probability'));

    % Center of each bin
    binCenters = edges(1:end-1) + diff(edges)/2;
    auditoryCDFs = [auditoryCDFs; auditoryCDF];
    visualCDFs = [visualCDFs; visualCDF];
    audioVisualCDFs = [audioVisualCDFs; audioVisualCDF];
    binCentersGlobal = [binCentersGlobal; edges(1:end-1) + diff(edges)/2];
   
    % Calculate Miller's Bound
    millersBound = zeros(size(binCenters));
    for j = 1:length(binCenters)
        % Compute the bound at each RT value
        combinedCDF = auditoryCDF(j) + visualCDF(j);
        if combinedCDF > 1
            millersBound(j) = combinedCDF - 1;
        else
            millersBound(j) = min(auditoryCDF(j), visualCDF(j));
        end
    end

    cd(RACE_analysis)
    [Fx,Fy,Fxy,Fmodel,t] = ormodel(auditoryRT, visualRT, audioVisualRT);
    cd(data_analysis)

    % Plotting
    figure;
    plot(binCenters, auditoryCDF, 'r-', 'LineWidth', 2); hold on;
    plot(binCenters, visualCDF, 'b-', 'LineWidth', 2);
    plot(binCenters, audioVisualCDF, 'm-', 'LineWidth', 2);
    plot(binCenters, millersBound, 'k--', 'DisplayName', 'Miller''s Bound');
    xlabel('Reaction Time (ms)');
    ylabel('Cumulative Probability');
    title(['Cumulative Distribution of Reaction Times - Coherence Level ', num2str(cohLevel)]);
    legend('Auditory', 'Visual', 'Audiovisual', 'Miller''s Bound');
    ylim([0 1])
    xlim([0 2])
    grid on;
end

% Aggregate reaction times across all coherence levels for each condition
auditoryRT = auditoryData(:, 4);
visualRT = visualData(:, 4);
audioVisualRT = audioVisualData(:, 6);

% Create cumulative distributions
edges = linspace(min([auditoryRT; visualRT; audioVisualRT]), max([auditoryRT; visualRT; audioVisualRT]), 100);
auditoryCDF = cumsum(histcounts(auditoryRT, edges, 'Normalization', 'probability'));
visualCDF = cumsum(histcounts(visualRT, edges, 'Normalization', 'probability'));
audioVisualCDF = cumsum(histcounts(audioVisualRT, edges, 'Normalization', 'probability'));

% Center of each bin
binCenters = edges(1:end-1) + diff(edges)/2;

% Plotting
figure;
plot(binCenters, auditoryCDF, 'r-', 'LineWidth', 2); hold on;
plot(binCenters, visualCDF, 'b-', 'LineWidth', 2);
plot(binCenters, audioVisualCDF, 'm-', 'LineWidth', 2);
xlabel('Reaction Time (ms)');
ylabel('Cumulative Probability');
title('Cumulative Distribution of Reaction Times Across All Coherences');
legend('Auditory', 'Visual', 'Audio-Visual');
ylim([0 1])
xlim([0 2])
grid on;

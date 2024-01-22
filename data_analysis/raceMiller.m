%% RACE Model
clear all
close all


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

showplot = input('Plot RMI violation? 1 = YES, 0 = NO : ');

nfiles_to_load{3, 1} = 'psyAud';
nfiles_to_load{3, 2} = 'psyVis';
nfiles_to_load{3, 3} = 'psyAV';

% Specify the directory where your files are located
task_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/';
script_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/data_analysis/';
data_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/data/';
figure_file_directory = '/Users/a.tiesman/Documents/Research/Meeting_figures/';
addpath('/Users/a.tiesman/Documents/Research/Human_AV_Motion/data_analysis/RSE-box-master/analysis/');
addpath('/Users/a.tiesman/Documents/Research/Human_AV_Motion/data_analysis/RSE-box-master/demo/');
addpath('/Users/a.tiesman/Documents/Research/Human_AV_Motion/data_analysis/RSE-box-master/model/');
addpath('/Users/a.tiesman/Documents/Research/Human_AV_Motion/data_analysis/RSE-box-master/simulation/');

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
audiovisualData = loaded_data{1,3}.data_output; % Your audio-visual data matrix

% Extract unique coherence levels
coherenceLevels = unique(auditoryData(:, 2));% Assuming the same coherence levels for all conditions
cohCheck = length(coherenceLevels);
if cohCheck == 9
    coherenceLevels = [coherenceLevels(1); coherenceLevels(3:end)]; 
end
AV_coherenceLevels = unique(audiovisualData(:,2));

% Loop over each coherence level
for c = 1:length(coherenceLevels)
    coherenceLevel = coherenceLevels(c);
    AVcoherenceLevel = AV_coherenceLevels(c);

    % Filter data for the current coherence level
    rtAuditory = auditoryData(auditoryData(:, 2) == coherenceLevel, 4);
    rtVisual = visualData(visualData(:, 2) == coherenceLevel, 4);
    rtAudiovisual = audiovisualData(audiovisualData(:, 2) == AVcoherenceLevel, 6);

    rtData = [rtAuditory rtVisual rtAudiovisual];
    violation = RMI_violation(rtData, showplot);

    % Compute CDFs for auditory and visual data
    [cdfAuditory, rtValues] = ecdf(rtAuditory);
    [cdfVisual, ~] = ecdf(rtVisual);
    [cdfAudiovisual, rtAV] = ecdf(rtAudiovisual);

    % Calculate Miller's Bound
    millersBound = max(0, cdfAuditory + cdfVisual - 1);

    % Find area where the Race Model is violated
    violationAreaX = [rtValues; flipud(rtValues)];
    violationAreaY = [millersBound; flipud(cdfAudiovisual)];

    % Plot the results for this coherence level
    figure;
    fill(violationAreaX, violationAreaY, [0.9 0.9 0.9], 'EdgeColor', 'none'); % Fill area
    plot(rtValues, cdfAuditory, 'r-', 'DisplayName', 'Auditory CDF');
    hold on;
    plot(rtValues, cdfVisual, 'b-', 'DisplayName', 'Visual CDF');
    plot(rtAV, cdfAudiovisual, 'm-', 'DisplayName', 'Audiovisual CDF');
    plot(rtValues, millersBound, 'k--', 'DisplayName', 'Miller''s Bound');
    hold off;
    legend;
    xlabel('Reaction Time');
    ylabel('Cumulative Probability');
    title(sprintf('CDFs, Miller''s Bound, and Violation Area (Coherence: %g)', coherenceLevel));
end
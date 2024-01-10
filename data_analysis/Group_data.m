%% Multisensory Gain Calc and Plot %%%%%%
clear; 
close all;

nfiles_to_load = {'01' '01' '01' '02' '02' '02' '03' '03' '03' '04' '04' '04' '01' '01' '01' '03' '03' '03' '05' '05' '05' '06' '06' '06' '08' '08' '08'; '10' '10' '10' '10' '10' '10' '10' '10' '10' '10' '10' '10' '11' '11' '11' '11' '11' '11' '11' '11' '11' '11' '11' '11' '11' '11' '11'; 'psyAud' 'psyVis' 'psyAV' 'psyAud' 'psyVis' 'psyAV' 'psyAud' 'psyVis' 'psyAV' 'psyAud' 'psyVis' 'psyAV' 'psyAud' 'psyVis' 'psyAV' 'psyAud' 'psyVis' 'psyAV' 'psyAud' 'psyVis' 'psyAV' 'psyAud' 'psyVis' 'psyAV' 'psyAud' 'psyVis' 'psyAV'};

% Initialize a cell array to store the loaded data
loaded_data = cell(1, size(nfiles_to_load, 2));

% Specify the directory where your files are located
task_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/';
script_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/data_analysis/';
data_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/data/';
figure_file_directory = '/Users/a.tiesman/Documents/Research/Meeting_figures/';

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
        fprintf('No matching files found for subj_num = %s, group_num = %s.\n', first_number, second_number);
    else
        fprintf('Matching files found for subj_num = %s, group_num = %s:\n', first_number, second_number);
        
        file_to_load = fullfile(data_file_directory, matching_files{1});
        fprintf('Loading file: %s\n', file_to_load);
  
        loaded_data{i} = load(file_to_load);
    end 

    % Define the coherence levels
    coherence_levels = [0, 0.0442, 0.0625, 0.0884, 0.1250, 0.1768, 0.2500, 0.3536, 0.5];
    
    % Initialize a structure to hold the results
    multisensory_gain = struct();
    num_participants = length(loaded_data) / 3;
    %d_prime_matrix = zeros(num_participants, 3);
    multisensory_gain = zeros(num_participants, length(coherence_levels));
    
    % Assuming coherence_levels is defined as earlier
    tolerance = 0.001;  % Adjust as needed for precision issues
    % Loop through each participant
    for participant = 1:num_participants
        % Initialize arrays to store accuracies for each condition
        auditory_accuracy = zeros(1, length(coherence_levels));
        visual_accuracy = zeros(1, length(coherence_levels));
        av_accuracy = zeros(1, length(coherence_levels));

        for condition = 1:3  % 1: auditory, 2: visual, 3: AV
        % Check if current_data is a structure and has the field 'data_output'
        current_data = loaded_data{participant * 3 - 3 + condition};
        if isstruct(current_data) && isfield(current_data, 'data_output')
            data_output = current_data.data_output;

            for level = 1:length(coherence_levels)
                % Extract trials for this coherence level with tolerance
                trials = data_output(abs(data_output(:, 2) - coherence_levels(level)) < tolerance, :);

                % Calculate accuracy (proportion of correct responses)
                correct_responses = sum(trials(:, 1) == trials(:, 3));
                total_responses = sum(~isnan(trials(:, 3)));
                accuracy = correct_responses / total_responses;

                % Store accuracy in the corresponding array
                switch condition
                    case 1
                        auditory_accuracy(level) = accuracy;
                    case 2
                        visual_accuracy(level) = accuracy;
                    case 3
                        av_accuracy(level) = accuracy;
                end

                % Example calculations - adjust these based on your experiment design
                if condition == 3
                    hits = sum(trials(:, 1) == trials(:, 5));
                    false_alarms = sum(trials(:, 1) ~=  trials(:, 5));
                else
                    hits = sum(trials(:, 1) == trials(:, 3));
                    false_alarms = sum(trials(:, 1) ~=  trials(:, 3));
                end
                total_trials = size(trials, 1);
        
                % Calculate hit rate and false alarm rate
                hit_rate = hits / total_trials;
                false_alarm_rate = false_alarms / total_trials;
        
                % Adjust rates to avoid infinity in z-score conversion
                hit_rate = max(min(hit_rate, 1 - 1e-5), 1e-5);
                false_alarm_rate = max(min(false_alarm_rate, 1 - 1e-5), 1e-5);
        
                % Convert rates to z-scores
                z_hit = norminv(hit_rate);
                z_false_alarm = norminv(false_alarm_rate);
        
                % Calculate d'
                d_prime = z_hit - z_false_alarm;
        
                % Store in matrix
                d_prime_matrix(participant, condition, level) = d_prime;

            end

%             % Example calculations - adjust these based on your experiment design
%             if condition == 3
%                 hits = sum(data_output(:, 1) == data_output(:, 5));
%                 false_alarms = sum(data_output(:, 1) ~=  data_output(:, 5));
%             else
%                 hits = sum(data_output(:, 1) == data_output(:, 3));
%                 false_alarms = sum(data_output(:, 1) ~=  data_output(:, 3));
%             end
%             total_trials = size(data_output, 1);
%     
%             % Calculate hit rate and false alarm rate
%             hit_rate = hits / total_trials;
%             false_alarm_rate = false_alarms / total_trials;
%     
%             % Adjust rates to avoid infinity in z-score conversion
%             hit_rate = max(min(hit_rate, 1 - 1e-5), 1e-5);
%             false_alarm_rate = max(min(false_alarm_rate, 1 - 1e-5), 1e-5);
%     
%             % Convert rates to z-scores
%             z_hit = norminv(hit_rate);
%             z_false_alarm = norminv(false_alarm_rate);
%     
%             % Calculate d'
%             d_prime = z_hit - z_false_alarm;
%     
%             % Store in matrix
%             d_prime_matrix(participant, condition) = d_prime;
        
        end
    
    % You can now analyze the multisensory_gain structure for your research
        end
     % Calculate multisensory gain for each coherence level
        for level = 1:length(coherence_levels)
            best_unisensory_accuracy = max(auditory_accuracy(level), visual_accuracy(level));
            gain = av_accuracy(level) - best_unisensory_accuracy;
    
            % Store the accuracies and gain
            accuracy_matrix(participant, 1, level) = auditory_accuracy(level);
            accuracy_matrix(participant, 2, level) = visual_accuracy(level);
            accuracy_matrix(participant, 3, level) = av_accuracy(level);
            multisensory_gain(participant, level) = gain;
        end
    end
end

% Create a heatmap
figure;  % Create a new figure
imagesc(d_prime_matrix);  % Create the heatmap
colormap('cool');  % Choose a colormap, e.g., 'hot', 'jet', etc.
colorbar;  % Add a colorbar to show the mapping of data values to colors

% Add labels and titles
xlabel('Condition');
ylabel('Participant');
title('D Prime Scores Heatmap');
set(gca, 'XTick', 1:3, 'XTickLabel', {'Auditory', 'Visual', 'Audiovisual'});
set(gca, 'YTick', 1:10, 'YTickLabel', arrayfun(@num2str, 1:10, 'UniformOutput', false));

% Optionally, adjust the aspect ratio
pbaspect([1 1.5 1]);  % Adjust aspect ratio as needed

% Display the values on the heatmap
[numParticipants, numConditions] = size(d_prime_matrix);
for i = 1:numParticipants
    for j = 1:numConditions
        text(j, i, num2str(d_prime_matrix(i, j), '%0.2f'), ...
             'HorizontalAlignment', 'center', ...
             'Color', 'white');
    end
end

% Assuming coherence_levels is already defined
% Extract the relevant coherence levels (assuming they correspond to columns 3 through 9)
selected_coherence_levels = coherence_levels(3:9);

% Number of participants
num_participants = size(multisensory_gain, 1);

% Create a single figure for all plots
figure;

% Optional: Define a larger set of colors if needed
colors = lines(num_participants); % 'lines' colormap provides a good range of distinct colors

% Loop to plot each participant's data
for participant = 1:num_participants
    plot(selected_coherence_levels, multisensory_gain(participant, 3:9), '-o', ...
         'Color', colors(participant, :));  % Plot with lines connecting dots
    hold on;  % Keep the plot active for the next participant's data
end

% Add labels, title, and legend
xlabel('Coherence Level');
ylabel('Multisensory Gain');
title('Multisensory Gain across Coherence Levels for All Participants');
legend(arrayfun(@(x) sprintf('Participant %d', x), 1:num_participants, 'UniformOutput', false));

% Additional plot settings
grid on;  % Add a grid for easier reading


%% VISUAL STAIRCASE TRAINING %%%%%%%%%%
% written by Adam Tiesman 2/27/2023

% Define the list of possible coherences
coherences = [1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1];

% Define the starting coherence and staircase pointer
start_coherence = 1; % 100% coherence
staircase_pointer = start_coherence;

% Define the probability of coherence getting lower after a correct choice
P = 0.33;

% Define the probability of coherence getting higher after an error
Q = 0.66;

% Define the probability of direction changing after a correct choice
X = 0.5;

% Define the probability of direction changing after an error
Y = 0.5;

% Define the number of trials in the session
num_trials = 100;

% Run the staircase procedure
for trial = 1:num_trials
    % Choose the direction of motion randomly
    if rand() < 0.5
        direction = 1; % Rightward motion
    else
        direction = 2; % Leftward motion
    end
    
    % Determine the coherence for the current trial
    coherence = coherences(staircase_pointer);
    
    % Check if direction should change
    if rand() <= X
        direction = mod(direction, 2) + 1; % Toggle between 1 and 2
    end
    
    % Simulate the monkey's response
    if (direction == 1 && rand() <= coherence) || (direction == 2 && rand() > coherence)
        % Monkey chooses the correct direction
        if rand() <= P && staircase_pointer > 1
            % Coherence gets lower after a correct choice
            staircase_pointer = staircase_pointer - 1;
        end
    else
        % Monkey chooses the wrong direction
        if rand() <= Q && staircase_pointer < length(coherences)
            % Coherence gets higher after an error
            staircase_pointer = staircase_pointer + 1;
        end
        
        % Check if direction should change
        if rand() <= Y
            direction = mod(direction, 2) + 1; % Toggle between 1 and 2
        end
    end
    
    % Check if staircase pointer is at the highest or lowest value
    if staircase_pointer == 1
        % Staircase pointer is already pointing to 100% coherence, can't go higher
        if rand() <= Y
            direction = mod(direction, 2) + 1; % Toggle between 1 and 2
        end
    elseif staircase_pointer == length(coherences)
        % Staircase pointer is already pointing to the lowest coherence, can't go lower
        if rand() <= X
            direction = mod(direction, 2) + 1; % Toggle between 1 and 2
        end
    end
    
    % Print out the trial information
    fprintf('Trial %d: coherence=%0.2f, direction=%d\n', trial, coherence, direction);
end
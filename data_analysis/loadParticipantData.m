function allData = loadParticipantData(data_to_load, dataDirectory, includeAV, justAV)
    % data_to_load: an n by 4 array with participant information
    %   - Column 1: subj_num (unique subject number)
    %   - Column 2: group_num (group number)
    %   - Column 3: sex_num (sex identifier: 1, 2, or 3)
    %   - Column 4: age_num (participant age)
    % dataDirectory: the directory where participant data is stored
    % includeAV: a boolean flag (true/false) to include AV condition
    % Output: a cell array (n by 2 or n by 3) containing the data matrices for each participant's blocks

    % Number of participants
    numParticipants = size(data_to_load, 1);

    % Determine number of columns in the cell array based on includeAV flag
    if includeAV
        numBlocks = 3;  % Auditory, Visual, and AV
    else
        numBlocks = 2;  % Auditory and Visual
    end

    % Initialize cell array to store data matrices
    allData = cell(numParticipants, numBlocks);

    % Iterate through each participant
    for i = 1:numParticipants
        % Define participant info from data_to_load
        subj_num = data_to_load(i, 1);  % Column 1: Subject Number
        group_num = data_to_load(i, 2); % Column 2: Group Number
        sex_num = data_to_load(i, 3);   % Column 3: Sex Number
        age_num = data_to_load(i, 4);   % Column 4: Age Number
        
        % Format subj_num and group_num as two-digit strings
        subj_num_str = sprintf('%02d', subj_num);
        group_num_str = sprintf('%02d', group_num);
        
        % Create participant ID by combining formatted subj_num and group_num
        participantID = [subj_num_str '_' group_num_str];
        
        % Get a list of all files in the data directory
        dataFiles = dir(dataDirectory);
        if ~justAV
            % Load Auditory Block
            audFile = findFileContaining(dataFiles, ['Aud_', participantID]);
            if ~isempty(audFile)
                audData = load(fullfile(dataDirectory, audFile));
                allData{i, 1} = audData.data_output; 
            else
                warning('Auditory data file for participant %d not found.', subj_num);
                allData{i, 1} = [];
            end
            
            % Load Visual Block
            visFile = findFileContaining(dataFiles, ['Vis_', participantID]);
            if ~isempty(visFile)
                visData = load(fullfile(dataDirectory, visFile));
                allData{i, 2} = visData.data_output;  
            else
                warning('Visual data file for participant %d not found.', subj_num);
                allData{i, 2} = [];
            end
    
            % Load Audio-Visual Block (if includeAV is true)
            if includeAV
                avFile = findFileContaining(dataFiles, ['AV_', participantID]);
                if ~isempty(avFile)
                    avData = load(fullfile(dataDirectory, avFile));
                    allData{i, 3} = avData.data_output;
                else
                    warning('AV data file for participant %d not found.', subj_num);
                    allData{i, 3} = [];
                end
            end
        else
            avFile = findFileContaining(dataFiles, ['AV_', participantID]);
            if ~isempty(avFile)
                avData = load(fullfile(dataDirectory, avFile));
                allData{i, 3} = avData.data_output;
            else
                warning('AV data file for participant %d not found.', subj_num);
                allData{i, 1} = [];
            end
    end
end
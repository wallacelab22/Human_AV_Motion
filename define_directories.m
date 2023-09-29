function [script_directory, data_directory, analysis_directory, lsl_directory] = define_directories(OS_nature, EEG_nature)

%% Directories created to navigate code folders throughout script
% If OS_nature = 1, then we are using our Linux OS. If OS_nature = 2, then
% we are using our Windows OS
if OS_nature == 1 % Linux
    script_directory = '/home/wallace/Human_AV_Motion/';
    data_directory = '/home/wallace/Human_AV_Motion/data/';
    analysis_directory = '/home/wallace/Human_AV_Motion/data_analysis/';
    if EEG_nature == 1
        lsl_directory = '/home/wallace/Human_AV_Motion/EEG/';
    end
elseif OS_nature == 2 % Windows
    script_directory = 'C:\Users\Wallace Lab\Documents\MATLAB\Human_AV_Motion\';
    data_directory = 'C:\Users\Wallace Lab\Documents\MATLAB\Human_AV_Motion\data\';
    analysis_directory = 'C:\Users\Wallace Lab\Documents\MATLAB\Human_AV_Motion\data_analysis';
    if EEG_nature == 1
        lsl_directory = 'C:\Users\Wallace Lab\Documents\MATLAB\Human_AV_Motion\EEG\';
    end
end

end
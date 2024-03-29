% dotsOnlyDemo
%
% Simple script for testing dots (dotsX)
%
addpath('/home/wallace/Human_AV_Motion/')
addpath('/home/wallace/Human_AV_Motion/Shadlen_code')
try
    clear;
    
    % Initialize the screen
    % touchscreen is 34, laptop is 32, viewsonic is 38
    screenInfo = openExperiment(50.8,120,0);
        
    % Initialize dots
    % Check createMinDotInfo to change parameters
    dotInfo = createDotInfo(1);

    [frames, rseed, start_time, end_time, response, response_time] = ...
        dotsX(screenInfo, dotInfo);    
    pause(0.5)

    % Clear the screen and exit
    closeExperiment;
    
catch
    disp('caught error');
    lasterr
    closeExperiment;
    
end



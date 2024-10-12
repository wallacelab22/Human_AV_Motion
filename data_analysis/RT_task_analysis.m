%% RACE Model for Meta RT Task
%% Change excel doc name, sheet name, and part_ID
% Load data from excel
dataAll = readtable('Session_07_30_24__16_13_03_AT_AV_Detection__TrialData.xlsx',  'Sheet', 'Session_07_30_24__16_13_03_AT_A');
visStim = table2array(dataAll(:, 19));
audStim = table2array(dataAll(:, 20));
rtAll = table2array(dataAll(:, 23));
part_ID = 'AT';

% Initialize the variables
rtAuditory = [];
rtVisual = [];
rtAudiovisual = [];

% Loop through and seperate RTs
for i = 1:length(rtAll)
    if ~isnan(audStim(i)) && isnan(visStim(i))
        % Only auditory stimulus present
        rtAuditory = [rtAuditory; rtAll(i)];
    elseif isnan(audStim(i)) && ~isnan(visStim(i))
        % Only visual stimulus present
        rtVisual = [rtVisual; rtAll(i)];
    elseif ~isnan(audStim(i)) && ~isnan(visStim(i))
        % Both auditory and visual stimuli present
        rtAudiovisual = [rtAudiovisual; rtAll(i)];
    end
end

% Changes seconds to milliseconds and remove NaN trials
rtAuditory = rtAuditory*1000;
rtAuditory = sort(rtAuditory, 'ascend');
rtAuditory = rtAuditory(~isnan(rtAuditory));
rtVisual = rtVisual*1000;
rtVisual = sort(rtVisual, 'ascend');
rtVisual = rtVisual(~isnan(rtVisual));
rtAudiovisual = rtAudiovisual*1000;
rtAudiovisual = sort(rtAudiovisual, 'ascend');
rtAudiovisual = rtAudiovisual(~isnan(rtAudiovisual));


% The arrays need to be the same size for RACE model
if length(rtAuditory) > length(rtVisual)
    rtAUD_oldsize = length(rtAuditory);
    rtAuditory = rtAuditory(1:length(rtVisual));
    rtAUD_newsize = length(rtAuditory);
    rtAUD_missingdata = rtAUD_oldsize - rtAUD_newsize; 
elseif length(rtAuditory) < length(rtVisual)
    rtVIS_oldsize = length(rtVisual);
    rtVisual = rtVisual(1:length(rtAuditory));
    rtVIS_newsize = length(rtVisual);
    rtVIS_missingdata = rtVIS_oldsize - rtVIS_newsize;
end
if length(rtAuditory) < length(rtAudiovisual)
    rtAV_oldsize = length(rtAudiovisual);
    rtAudiovisual = rtAudiovisual(1:length(rtAuditory));
    rtAV_newsize = length(rtAudiovisual);
    rtAV_missingdata = rtAV_oldsize - rtAV_newsize;
elseif length(rtAuditory) > length(rtAudiovisual)
    rtAuditory = rtAuditory(1:length(rtAudiovisual));
    rtVisual = rtVisual(1:length(rtAudiovisual));
end

% Apply and plot RACE model
showplot = 1;
[violation, gain] = RMI_violation(rtAuditory, rtVisual, rtAudiovisual, showplot, part_ID);

% Run a permutation test to test for significance 
[pVIS, observeddifferenceVIS, effectsizeVIS] = permutationTest(rtVisual, rtAudiovisual, 500, 'plotresult', 1);
[pAUD, observeddifferenceAUD, effectsizeAUD] = permutationTest(rtAuditory, rtAudiovisual, 500, 'plotresult', 1);
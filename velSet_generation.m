function [stimInfo] = velSet_generation(stimInfo, block)

% For both auditory and visual, create velSet by just jumping in increments
% of vel_substract, starting with velStart. E.g., start with 55 deg/s and 
% end with 15 deg/sec, going down by increments of 5.
stimInfo.velSet = zeros(1, stimInfo.vel_steps);
for i = 1:length(stimInfo.velSet)
    stimInfo.velSet(i) = stimInfo.velStart - ((i-1)*stimInfo.vel_subtract);
end

% For visual block, flip the velSet so participant starts at lowest
% velocity and the velocity increases.
if contains(block, 'Vis')
    stimInfo.velSet = flip(stimInfo.velSet);
% For auditory block, create a durSet and snipSet that finds the time in
% the CAM file that needs to be presented to the participant
elseif contains(block, 'Aud')
    stimInfo.durSet = zeros(1, length(stimInfo.velSet));
    stimInfo.snipSet = zeros(2, length(stimInfo.velSet));
    for j = 1:length(stimInfo.velSet)
        stimInfo.durSet(j) = stimInfo.speaker_distance/stimInfo.velSet(j);
        stimInfo.snipSet(1, j) = (stimInfo.durSet(j)/2) - (dur/2);
        stimInfo.snipSet(2, j) = (stimInfo.durSet(j)/2) + (dur/2);
    end
end

end
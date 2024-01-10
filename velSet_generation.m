function [stimInfo] = velSet_generation(stimInfo, block, dur)

try 
    stimInfo.vel_steps = stimInfo.vel_steps;
    stimInfo.velStart = stimInfo.velStart;
    stimInfo.vel_subtract = stimInfo.vel_subtract;
catch
    stimInfo.vel_steps = 1;
    stimInfo.velStart = stimInfo.vel;
    stimInfo.vel_subtract = 0;
end


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
    stimInfo.displaceSet = NaN; % FIGURE OUT APERTURE SIZE IN DEG
% For auditory block, create a durSet and snipSet that finds the time in
% the CAM file that needs to be presented to the participant
elseif contains(block, 'Aud')
    stimInfo.durSet = zeros(1, length(stimInfo.velSet));
    stimInfo.snipSet = zeros(2, length(stimInfo.velSet));
    stimInfo.displaceSet = zeros(1, length(stimInfo.velSet));
    for j = 1:length(stimInfo.velSet)
        % Compute the duration it would take for sound to travel from one
        % speaker to the other given the velocity
        stimInfo.durSet(j) = stimInfo.speakerDistance/stimInfo.velSet(j);
        % Take the stimulus duration and snip the durSet in the middle to
        % how long the stimulus duration is
        stimInfo.snipSet(1, j) = (stimInfo.durSet(j)/2) - (dur/2);
        stimInfo.snipSet(2, j) = (stimInfo.durSet(j)/2) + (dur/2);
        % Find the displacement of the auditory stimulus in degrees given
        % the velocity and the duration. With snipSet, the displacement for
        % the auditory stimulus will always be centered via the azimuth.
        stimInfo.displaceSet(j) = (stimInfo.velSet(j) * dur);
    end
end

end
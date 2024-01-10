function [Snipped_CAM] = snipCAM(CAM, Fs, snip_start, snip_end)
% 7/11/23 - Adam Tiesman
%Takes CAM function and snips the given velocity to only last the stimulus
%duration. The stimulus start (snip_start) and end (snip_end) of the CAM function
%is dependent on the raw duration it takes for signal (CAM) to move from
%one speaker to another.

Snipped_CAM_dur = (snip_end - snip_start); % in s
CAM_1 = CAM(:,1);
CAM_2 = CAM(:,2);

% Convert the start and end time to samples
samp_start = snip_start * Fs;
samp_end = snip_end * Fs;

% Cut CAM at sample locations
if samp_start == 0
    samp_start = 1;
end
samp_start = round(samp_start);
samp_end = round(samp_end);

Snip_CAM_1 = CAM_1(samp_start:samp_end, 1);
Snip_CAM_2 = CAM_2(samp_start:samp_end, 1);
Snip_CAM = [Snip_CAM_1 Snip_CAM_2];

% Set ramps on the new snipped CAM
Snipped_CAM = makeramp(Snipped_CAM_dur, Fs, Snip_CAM);

end
function [Snipped_CAM] = snipCAM(CAM, Fs, t_start, t_end)
%Takes CAM function and snips the given velocity to only last the stimulus
%duration.

Snipped_CAM_dur = (t_end - t_start); % in s
CAM_1 = CAM(:,1);
CAM_2 = CAM(:,2);

% Convert the start and end time to samples
samp_start = t_start * Fs;
samp_end = t_end * Fs;

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
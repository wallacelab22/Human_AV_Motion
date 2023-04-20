% function [CAM] = makeCAM(cLvl,speed, direction, dur, Fs)
function [CAM] = makeCAM(cLvl, direction, dur, silence, Fs, ii)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CAM =       array of voltages to present to speakers                 %
% cLvl =      coherence level (between 0 and 1)                        %
% speed =     an abandoned way to slow or speed the motion stimuli.    %
% direction = explanatory. 1 = leftward motion.                        %
% dur =       duration of stimuli in seconds. Can accept decimals,     %
%             but for uneven durations, you may need to round the Fs*t %
%             operation when generating duration in samples   
% silence =   period of silence at the beggin of the sound in seconds
% Fs =        Sampling frequency                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialize Audio
PsychPortAudio('Close')
InitializePsychSound;
pahandle = PsychPortAudio('Open', 5, [], 0, 44100, 2);

audInfo.cohStart = 0.5102;
nlog_coh_steps = 9;
nlog_division = 1.4;  
audInfo.cohSet = [audInfo.cohStart];
for i = 1:nlog_coh_steps
    if i == 1
        nlog_value = audInfo.cohStart;
    end
    nlog_value = nlog_value/nlog_division;
    audInfo.cohSet = [audInfo.cohSet nlog_value];
end


for i_coherence = 1:length(audInfo.cohSet)
    %% Define function variables
    cLvl = audInfo.cohSet(i_coherence);
    direction = 1;
    dur = 0.5;
    silence = 0.03;
    Fs = 44100;
    ii = 2;


    % Calculate duration in samples. Rounding is unnessesary if you have an
    % even duration (one that doesn't produce a decimal when multiplying by Fs)
    samples = round(dur.*Fs);
    silent = zeros((silence.*Fs),2);
    
    % Generate the 4 noise signals
    N1 =(rand(samples,1)-.5)*.707; %gives 3db reduction. clac is 20log(v)
    N2 =(rand(samples,1)-.5);
    N3 =(rand(samples,1)-.5);
    N4 = rand(samples,1)-.5;

    % Generate noise signals of 0, 100, and 50% correlation
    n0 = [N1 N2];
    n100 = [N3 N3];
    n50 = (n100 + n0)./2;
    % Unused array of all noises together
    Y = [n0 n50 n100];

    % Generate ramp for increasing and decreasing N4 amplitute in speaker
    rampu = (1/samples:1/samples:1)';
    rampd = (1:-1/samples:1/samples)';
    % Convolve the ramps with N4
    nup = N4 .* rampu;
    ndown = N4 .* rampd;

    % Generate the leftward and rightward motion signal
    left = [nup ndown];
    right = [ndown nup];

    % Apply the proper motion
    if direction == 1
        motion = right;
    else
        motion = left;
    end

    % Titrates the SNR
    if cLvl <.5
        noise = n50;
        motion = motion.*cLvl.*2;
        CAM = noise + motion;
    else
        noise = n50.*(1-cLvl).*2;
        CAM = noise + motion;
    end

    % Applies an onset and offset ramped "gate"
    CAM = makeramp(dur,Fs,CAM);
    % Scales the signal between -1 and 1
    CAM = normalize(CAM);
    CAM = cat(1, silent, CAM);

    if ii == 1
        figure;
        plot(CAM);
        ylim([-1 1]);
    end

     wavedata = CAM;
     nrchannels = size(wavedata,1); % Number of rows == number of channels.
    
     PsychPortAudio('FillBuffer', pahandle, wavedata');
     PsychPortAudio('Start', pahandle, 1);
    
    WaitSecs(3);

    %% If you want to change the dB SNR of the stimulus:

    % Define the desired dB SNR reduction
    SNR_reduction = 2;

    % Calculate the power of the signal
    signal_power = rms(motion(:))^2;

    % Calculate the power of the noise
    noise_power = rms(noise(:))^2;

    % Calculate the current SNR in dB
    current_SNR = 10*log10(signal_power / noise_power);

    % Calculate the desired noise power based on the desired SNR reduction
    desired_noise_power = signal_power / (10^(SNR_reduction/10));

    % Calculate the scaling factor for the noise that will achieve the desired SNR
    noise_scale_factor = sqrt(desired_noise_power / noise_power);

    % Apply the scaling factor to the noise
    noise = noise * noise_scale_factor;

    % Combine the noise and motion signal to create the final stimulus
    stimulus = noise + motion;

    % Normalize the stimulus to be between -1 and 1
    stimulus = normalize(stimulus);

    % Apply an onset and offset ramped "gate"
    stimulus = makeramp(dur, Fs, stimulus);
    CAM = stimulus;
    
    if ii == 1
        figure;
        plot(CAM);
        ylim([-1 1]);
    end

    wavedata = CAM;
    nrchannels = size(wavedata,1); % Number of rows == number of channels.

    PsychPortAudio('FillBuffer', pahandle, wavedata');
    PsychPortAudio('Start', pahandle, 1);

    WaitSecs(3);
end

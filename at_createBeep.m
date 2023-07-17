function [corr_soundout, incorr_soundout] = at_createBeep(correct_freq, incorr_freq, dur, silence, Fs)

% Training sound properties
    correct_sound = MakeBeep(correct_freq, (dur+silence), Fs);
    corr_soundout = [correct_sound', correct_sound'];
    corr_soundout = normalize(corr_soundout);
    incorrect_sound = MakeBeep(incorrect_freq, (dur+silence), Fs);
    incorr_soundout = [incorrect_sound', incorrect_sound'];
    incorr_soundout = normalize(incorr_soundout);

end
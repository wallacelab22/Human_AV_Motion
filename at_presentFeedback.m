function at_presentFeedback(trial_status, pahandle, corr_soundout, incorr_soundout)
% Plays either correct sound or incorrect sound based on whether
% participant responded correctly or incorrectly.

if trial_status == 1
    PsychPortAudio('FillBuffer', pahandle, corr_soundout')
    PsychPortAudio('Start', pahandle)
elseif isnan(trial_status) % on catch trials, randomize feedback
    rand_feedback = randi([1,2]);
    if rand_feedback == 1
        PsychPortAudio('FillBuffer', pahandle, corr_soundout')
        PsychPortAudio('Start', pahandle)
    elseif rand_feedback == 2
        PsychPortAudio('FillBuffer', pahandle, incorr_soundout')
        PsychPortAudio('Start', pahandle)
    end
else
    PsychPortAudio('FillBuffer', pahandle, incorr_soundout')
    PsychPortAudio('Start', pahandle)
end

end
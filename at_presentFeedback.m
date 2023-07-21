function at_presentFeedback(trial_status, pahandle, corr_soundout, incorr_soundout)
% Plays either correct sound or incorrect sound based on whether
% participant responded correctly or incorrectly.

if trial_status == 1
    PsychPortAudio('FillBuffer', pahandle, corr_soundout')
    PsychPortAudio('Start', pahandle)
else
    PsychPortAudio('FillBuffer', pahandle, incorr_soundout')
    PsychPortAudio('Start', pahandle)
end

WaitSecs(1)

end
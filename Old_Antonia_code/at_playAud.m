function at_playAud(CAM, Fs)
% InitializePsychSound(0);
% pahandle = PsychPortAudio('Open', [], [], 0, 44100, 2);

% Fill the audio playback buffer with the audio data 'wavedata':
% PsychPortAudio('FillBuffer', pahandle, CAM');
% Start the playback
Priority(2)
PsychPortAudio('Start', pahandle, 1, 0);
Priority(0)

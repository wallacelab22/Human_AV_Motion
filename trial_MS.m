function [r,rt] = trial_MS(win0, stimS, stimRect, outRect, RDK, CAM, Fs, dur, pahandle)

global hz cWhite0 stimVoffset

Priority(2);
FlushEvents('keyDown');

for ii = 1:dur
    RDK_video(ii) = Screen('MakeTexture',win0,RDK(:,:,ii));
end

% cursor middle
Screen('DrawLine', win0 ,255, outRect(3)/2 - 30, outRect(4)/2, outRect(3)/2 + 30, outRect(4)/2, 4);
Screen('DrawLine', win0 ,255, outRect(3)/2, outRect(4)/2 - 30, outRect(3)/2, outRect(4)/2 + 30, 4);
Screen('Flip',win0);


% jitter
jit  = .5 + rand.*.25;
WaitSecs(jit);

% Fill the audio playback buffer with the audio data 'wavedata':
PsychPortAudio('FillBuffer', pahandle, CAM');

KbName('UnifyKeyNames');
while KbCheck; end
keycorrect=0;

% Start the playback
key = 0;
t = 0;
PsychPortAudio('Start', pahandle, 1, 0);
start_time = GetSecs;
for ii = 1:dur
    if ~keycorrect
        [key,secs,keycode] = KbCheck;
        WaitSecs(0.0001);
        if key
            r = str2double(char(KbName(keycode)));
            if r == 1 || r == 2 || r == 9
                keycorrect = 1;
            end
        end
    end
    
    Screen('DrawLine', win0 ,255, outRect(3)/2 - 30, outRect(4)/2, outRect(3)/2 + 30, outRect(4)/2, 4);
    Screen('DrawLine', win0 ,255, outRect(3)/2, outRect(4)/2 - 30, outRect(3)/2, outRect(4)/2 + 30, 4);
    Screen('CopyWindow', RDK_video(ii), win0, stimS, stimRect);
    Screen('Flip',win0);
end
disp('out')
Screen('Flip',win0);


% prompt
Screen('DrawText', win0, 'What was the direction of the motion? Left or right?',400,400,cWhite0);
Screen('DrawText', win0, 'Left = 1',400,440,cWhite0);
Screen('DrawText', win0, 'Right = 2',400,480,cWhite0);
Screen('Flip',win0);

while ~keycorrect
    [key,secs,keycode] = KbCheck;
    WaitSecs(0.0001);
    if key
        r = str2double(char(KbName(keycode)));
        if r == 1 || r == 2 || r == 9
            keycorrect = 1;
        end
    end
end




Screen('Flip',win0);
rt = (secs-start_time)*1000; %Response time in ms

Priority(0);


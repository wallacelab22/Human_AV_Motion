function cont(curWindow, cWhite0)

Screen('DrawText', curWindow, '!!!You are finished with this block of trials!!!',500,300,cWhite0);
Screen('DrawText', curWindow, '...Take a short break...',500,350,cWhite0);
Screen('Flip',curWindow);
WaitSecs(3);

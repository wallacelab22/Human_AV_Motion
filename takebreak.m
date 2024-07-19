function takebreak(curWindow, cWhite0, fix, break_num, nbblocks)


Screen('DrawText', curWindow, ['You have completed ' num2str(break_num) ' blocks out of' num2str(nbblocks)],200,300,cWhite0);
Screen('DrawText', curWindow, 'If you need to take a break, please do so now.',200,400,cWhite0);
Screen('DrawText', curWindow, 'The experiment will continue shortly after you',200,500,cWhite0);
Screen('DrawText', curWindow, 'press any key to continue.',200,600,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;

Screen('TextSize', curWindow, 32);

Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], fix, 1);
Screen('Flip', curWindow,0);
WaitSecs(2)

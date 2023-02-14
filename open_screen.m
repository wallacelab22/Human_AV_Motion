function [monRefresh, cWhite0, screenRect, curScreen] = open_screen

scrAvail = Screen('Screens');
if length(scrAvail)>1
    scr0 = scrAvail(2);
    scr1 = scrAvail(3);
elseif length(scrAvail)==1
    scr0 = scrAvail(1);
end
[curScreen, screenRect] = Screen('OpenWindow',scr1,0,[],32,2);
rect0 = screenRect;
clut = [[0:255]' [0:255]' [0:255]'];
oldclut = Screen('LoadCLUT',curScreen,clut,0);
cWhite0 = 255;
cBlack0 = 0;
cGrey0 = 160;
Screen('TextSize',curScreen,24');
Screen('TextFont',curScreen,'Georgia');
monRefresh = Screen('FrameRate', curScreen);

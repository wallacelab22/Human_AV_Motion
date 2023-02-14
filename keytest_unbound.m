function [resp,rt]= keytest_unbound

start_time = GetSecs;
KbName('UnifyKeyNames');
while KbCheck; end

while 1
    keyisdown=0;
    while ~keyisdown
        [keyisdown,secs,keycode] = KbCheck;
        WaitSecs(0.0001);
    end
   
    break
end

    
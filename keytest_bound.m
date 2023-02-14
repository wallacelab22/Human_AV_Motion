function [resp,rt]= keytest_bound

start_time = GetSecs;
KbName('UnifyKeyNames');
while KbCheck; end

while 1
    keyisdown=0;
    while ~keyisdown
        [keyisdown,secs,keycode] = KbCheck;
        WaitSecs(0.0001);
    end
    rt = (secs-start_time)*1000; %Response time in ms
    response=char(KbName(keycode));
    resp = str2double(response);
    
    %     if resp == 89 || resp == 77 || resp == 80
%          break
%     end
end


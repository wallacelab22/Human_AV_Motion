function init_rdk = dotsOnly(inputtype)
% This function initializes the RDK on a trial by trial basis

dot_info = createDotInfo(1);
[frames, rseed, start_time, end_time, response, response_time] = dotsX(screenInfo, dotInfo);    
pause(0.5)
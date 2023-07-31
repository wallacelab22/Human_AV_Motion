function [audInfo, visInfo] = at_generateApertureInfo(audInfo, visInfo, dur)
% Generate the visual aperture size based on the auditory displacement of
% the same velocity. The visInfo.displaceSet will go into at_createDotInfo
% in order to be used to create the diameter of the aperture.

try
    audInfo.velSet = visInfo.velSet;
catch
    warning('No visInfo.velSet variable, using visInfo.vel variable instead.')
    audInfo.velSet = visInfo.vel;
end
audInfo.vel = visInfo.vel;
opp_block = 'Aud';
audInfo = velSet_generation(audInfo, opp_block, dur);
visInfo.displaceSet = audInfo.displaceSet*10; % need to multiply by 10 b/c that is what dotInfo does to aperture variable

end
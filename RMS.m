function [left right maxl maxr] = RMS(CAM)
for ii = 1:size(CAM,3)
    left(ii) = sqrt(mean(CAM(:,1,ii).^2));
    right(ii) = sqrt(mean(CAM(:,2,ii).^2));
    
    maxl(ii) = max(abs(CAM(:,1,ii)));
    maxr(ii) = max(abs(CAM(:,2,ii)));
end
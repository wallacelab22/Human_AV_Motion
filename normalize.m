function CAM = normalize(CAM)
for ii = 1:size(CAM,3)
    for jj = 1:2
    CAM(:,jj,ii) = CAM(:,jj,ii)./max(CAM(:,jj,ii));
    end
end
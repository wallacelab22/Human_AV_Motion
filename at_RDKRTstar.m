function MAT=at_RDKRTstar(subject)
% get directory with data, then select data file to load
% Dir = uigetdir; cd(Dir);

for sub=1:length(subject)
    thissub=subject(sub)
    if length(num2str(thissub))==2
        subID=num2str(thissub);
    elseif length(num2str(thissub)) < 2
        subID = strcat(['0' num2str(thissub)]);
        
    end
    
    filename=strcat(['RDKdata_' subID '.mat']);
    load(filename);
    %% A alone condition, i.e. Vcoh = 0;
    Aalone = MAT(MAT(:,4)==0,:); % find all trials with Vcoh = 0
    
    for kk = 1:5 % 5 Acoh levels not including 0, i.e. no catch trials, looping over each Acoh levels
        Acoh = Aalone(Aalone(:,2)==kk,:); %
        y(kk) = (length(find(Acoh(:,1)==Acoh(:,5)))/length(Acoh)); % %correct responses for each Acoh levels not including catch trials
        yrt(:, kk) = Acoh(:,6);
        aud_median(1, kk)=nanmedian(yrt(:,kk));
        aud_rtstar(1,kk)=aud_median(1,kk)/y(kk);
    end
    
    %% same as above, now with congruent visual levels
    Vlow = MAT(MAT(:,4)==1,:); % all trials with low Vcoh
    Vhigh = MAT(MAT(:,4)==2,:); % all trials with high Vcoh
    tmp = Vlow(Vlow(:,1) == Vlow(:,3),:); % all Vlow congruent trials
    tmp1=Vhigh(Vhigh(:,1) == Vhigh(:,3),:); % all Vhigh congruent trials
    
    for kk=1:5
        Acoh_Vlow = tmp(tmp(:,2)==kk,:); % find each A-level
        Acoh_Vhigh = tmp1(tmp1(:,2)==kk,:);
        ylow(kk) = length(find(Acoh_Vlow(:,1)==Acoh_Vlow(:,5)))/length(Acoh_Vlow); % correct trials
        yhigh(kk) = length(find(Acoh_Vhigh(:,1)==Acoh_Vhigh(:,5)))/length(Acoh_Vhigh);
        ylowrt(:, kk) = Acoh_Vlow(:,6);
        yhighrt(:, kk)= Acoh_Vhigh(:,6);
        audvislow_median(1, kk)=nanmedian(ylowrt(:,kk));
        audvishigh_median(1, kk)=nanmedian(yhighrt(:,kk));
        audvislow_rtstar(1,kk)=audvislow_median(1,kk)/ylow(kk);
        audvishigh_rtstar(1,kk)=audvishigh_median(1,kk)/yhigh(kk);
    end
    
    %% multisensory incongruent
    Vlow = MAT(MAT(:,4)==1,:); % all trials with low Vcoh
    Vhigh = MAT(MAT(:,4)==2,:); % all trials with high Vcoh
    tmp = Vlow(Vlow(:,1) ~= Vlow(:,3),:); % all Vlow congruent trials
    tmp1=Vhigh(Vhigh(:,1) ~= Vhigh(:,3),:); % all Vhigh congruent trials
    
    for kk=1:5
        Acoh_Vlow = tmp(tmp(:,2)==kk,:); % find each A-level
        Acoh_Vhigh = tmp1(tmp1(:,2)==kk,:);
        ylow2(kk) = length(find(Acoh_Vlow(:,1)==Acoh_Vlow(:,5)))/length(Acoh_Vlow); % correct trials
        yhigh2(kk) = length(find(Acoh_Vhigh(:,1)==Acoh_Vhigh(:,5)))/length(Acoh_Vhigh);
        ylow2rt(:, kk) = Acoh_Vlow(:,6);
        yhigh2rt(:, kk)= Acoh_Vhigh(:,6);
        audvislow2_median(1, kk)=nanmedian(ylow2rt(:,kk));
        audvishigh2_median(1, kk)=nanmedian(yhigh2rt(:,kk));
        audvislow2_rtstar(1,kk)=audvislow2_median(1, kk)/ylow2(kk);
        audvishigh2_rtstar(1,kk)=audvishigh2_median(1, kk)/yhigh2(kk);
    end
    
    %% V alone condition, i.e. Acoh = 0;
    Valone = MAT(MAT(:,2)==0,:); % find all trials with Acoh = 0
    
    for vv = 1:2 % 2 Vcoh levels not including 0, i.e. no catch trials, looping over each Vcoh levels
        Vcoh = Valone(Valone(:,4)==vv,:); %
        v(vv) = (length(find(Vcoh(:,3)==Vcoh(:,5)))/length(Vcoh)); % %correct responses for each Acoh levels not including catch trials
        vrt(:,vv) = Vcoh(:,6);
        vis_median(1, vv)=nanmedian(vrt(:,vv));
        vis_rtstar(1,vv)=vis_median(1,vv)/v(vv);
    end

    VisualRTstar(sub,:)=vis_rtstar;
    AudioRTstar(sub,:)=aud_rtstar;
    AVcRTstar(sub,:)=cat(2,audvislow_rtstar, audvishigh_rtstar);
    AViRTstar(sub,:)=cat(2,audvislow2_rtstar, audvishigh2_rtstar);
    
end

save('VisualRTstar.mat', 'VisualRTstar')
save('AuditoryRTstar.mat', 'AudioRTstar')
save('AVcRTstar.mat', 'AVcRTstar')
save('AViRTstar.mat', 'AViRTstar')
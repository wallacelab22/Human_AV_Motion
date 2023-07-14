function MAT=at_RDKRT(subject)
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
%% get subject matrix
    Aalone = MAT(MAT(:,4)==0,:); % find all trials with Vcoh = 0
    for kk = 1:5 % 5 Acoh levels not including 0, i.e. no catch trials, looping over each Acoh levels
        Acoh = Aalone(Aalone(:,2)==kk,:); %  each Acoh level
        y(:, kk) = Acoh(:,6);
    end

    %% add visual only
    Valone = MAT(MAT(:,2)==0,:); % find all trials with Acoh = 0
    for vv = 1:2 % 2 Vcoh levels not including 0, i.e. no catch trials, looping over each Vcoh levels
        Vcoh = Valone(Valone(:,4)==vv,:); %  each Acoh level
        v(:,vv) = Vcoh(:,6);
    end
   
    %% same as above, now with congruent visual levels
    Vlow = MAT(MAT(:,4)==1,:); % all trials with low Vcoh
    Vhigh = MAT(MAT(:,4)==2,:); % all trials with high Vcoh
    
    tmp = Vlow(Vlow(:,1) == Vlow(:,3),:); % all Vlow congruent trials
    tmp1=Vhigh(Vhigh(:,1) == Vhigh(:,3),:); % all Vhigh congruent trials

    for kk=1:5
        Acoh_Vlow = tmp(tmp(:,2)==kk,:); % find each A-level
        ylow(:, kk) = Acoh_Vlow(:,6);
    end
    
    for kk=1:5
        Acoh_Vhigh = tmp1(tmp1(:,2)==kk,:);
        yhigh(:, kk)= Acoh_Vhigh(:,6);
    end
       
    %% INCONGRUENT same as above, now with congruent visual levels
    Vlow = MAT(MAT(:,4)==1,:); % all trials with low Vcoh
    Vhigh = MAT(MAT(:,4)==2,:); % all trials with high Vcoh
    
    tmp = Vlow(Vlow(:,1) ~= Vlow(:,3),:); % all Vlow incongruent trials
    tmp1=Vhigh(Vhigh(:,1) ~= Vhigh(:,3),:); % all Vhigh incongruent trials
    
    for kk=1:5
        Acoh_Vlow = tmp(tmp(:,2)==kk,:); % find each A-level
        ylow2(:, kk) = Acoh_Vlow(:,6);
    end

    for kk=1:5
        Acoh_Vhigh = tmp1(tmp1(:,2)==kk,:);
        yhigh2(:, kk)= Acoh_Vhigh(:,6);
    end
%% get subject means      
    for zz=1:2
        vis_mean(1, zz)=nanmean(v(:,zz));
        vis_median(1, zz)=nanmedian(v(:,zz));
        vis_std(1, zz)=nanstd(v(:,zz));
        vis_sem(1, zz)=vis_std(1,zz)/sqrt(length(v(~isnan(v(:,zz)))));
        vis_iqr(:, zz)=iqr(v(~isnan(v(:, zz))));
    end
    
    for aa=1:5
        aud_mean(1, aa)=nanmean(y(:,aa));
        aud_median(1, aa)=nanmedian(y(:,aa));
        aud_std(1, aa)=nanstd(y(:,aa));
        aud_sem(1, aa)=aud_std(1, aa)/sqrt(length(y(~isnan(y(:,aa)))));
    end
    
    for avl=1:5
        audvislow_mean(1, avl)=nanmean(ylow(:,avl));
        audvislow_median(1, avl)=nanmedian(ylow(:,avl));
        audvislow_std(1, avl)=nanstd(ylow(:,avl));
        audvislow_sem(1, avl)=audvislow_std(1, avl)/sqrt(length(y(~isnan(ylow(:,avl)))));
    end
    
    for avh=1:5
        audvishigh_mean(1, avh)=nanmean(yhigh(:,avh));
        audvishigh_median(1, avh)=nanmedian(yhigh(:,avh));
        audvishigh_std(1, avh)=nanstd(yhigh(:,avh));
        audvishigh_sem(1, avh)=audvishigh_std(1, avh)/sqrt(length(y(~isnan(yhigh(:,avh)))));
    end
    
    for avli=1:5
        audvislow2_mean(1, avli)=nanmean(ylow2(:,avli));
        audvislow2_median(1, avli)=nanmedian(ylow2(:,avli));
        audvislow2_std(1, avli)=nanstd(ylow2(:,avli));
        audvislow2_sem(1, avli)=audvislow2_std(1, avli)/sqrt(length(y(~isnan(ylow2(:,avli)))));
    end
    
    for avhi=1:5
        audvishigh2_mean(1, avhi)=nanmean(yhigh2(:,avhi));
        audvishigh2_median(1, avhi)=nanmedian(yhigh2(:,avhi));
        audvishigh2_std(1, avhi)=nanstd(yhigh2(:,avhi));
        audvishigh2_sem(1, avhi)=audvishigh2_std(1, avhi)/sqrt(length(y(~isnan(yhigh2(:,avhi)))));
    end
    
    VisualRT(sub,:)=vis_median;
    AudioRT(sub,:)=aud_median;
    AVcRT(sub,:)=cat(2,audvislow_median, audvishigh_median);
    AViRT(sub,:)=cat(2,audvislow2_median, audvishigh2_median);
    
    VisualSTD(sub,:)=vis_std;
    AudioSTD(sub,:)=aud_std;
    AVcSTD(sub,:)=cat(2,audvislow_std, audvishigh_std);
    AViSTD(sub,:)=cat(2,audvislow2_std, audvishigh2_std);
    
    VisualSEM(sub,:)=vis_sem;
    AudioSEM(sub,:)=aud_sem;
    AVcSEM(sub,:)=cat(2,audvislow_sem, audvishigh_sem);
    AViSEM(sub,:)=cat(2,audvislow2_sem, audvishigh2_sem);
end

save('VisualRT.mat', 'VisualRT')
save('AuditoryRT.mat', 'AudioRT')
save('AVcRT.mat', 'AVcRT')
save('AViRT.mat', 'AViRT')

save('VisualSTD.mat', 'VisualSTD')
save('AuditorySTD.mat', 'AudioSTD')
save('AVcSTD.mat', 'AVcSTD')
save('AViSTD.mat', 'AViSTD')

save('VisualSEM.mat', 'VisualSEM')
save('AuditorySEM.mat', 'AudioSEM')
save('AVcSEM.mat', 'AVcSEM')
save('AViSEM.mat', 'AViSEM')
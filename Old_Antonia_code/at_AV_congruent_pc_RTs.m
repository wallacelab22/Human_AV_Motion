function MAT=at_AV_congruent_pc_RTs(subject)

for sub=1:length(subject)
    thissub=subject(sub)
    if length(num2str(thissub))==2
        subID=num2str(thissub);
    elseif length(num2str(thissub)) < 2
        subID = strcat(['0' num2str(thissub)]);
        
    end

    filename=strcat(['RDKdata_' subID '.mat']);
    load(filename);

% Dir = uigetdir; cd(Dir); load(uigetfile);
audx=[5,10,20,30,40];
Aalone = MAT(MAT(:,4)==0,:); % find all trials with Vcoh = 0
subplot(3,2,1);
for kk = 1:5 % 5 Acoh levels not including 0, i.e. no catch trials, looping over each Acoh levels
    Acoh = Aalone(Aalone(:,2)==kk,:); %  each Acoh level
    y(:, kk) = Acoh(:,6); 
    plot(audx(kk), y(:, kk), 'ok');hold on;
end
xlabel('Auditory Coherence Level');ylabel('RT');
xlim([0 45]); ylim([0.2 1.5]);

%% add visual only
Valone = MAT(MAT(:,2)==0,:); % find all trials with Acoh = 0
subplot(3,2,2);
visz=[6, 60];
for vv = 1:2 % 2 Vcoh levels not including 0, i.e. no catch trials, looping over each Vcoh levels
    Vcoh = Valone(Valone(:,4)==vv,:); %  each Acoh level
    v(:,vv) = Vcoh(:,6);
    plot(visz(vv), v(:, vv), 'ok');hold on;
end
xlabel('Visual Coherence level');ylabel('RT');
xlim([0 65]);ylim([0.2 1.5]);

%% same as above, now with congruent visual levels


Vlow = MAT(MAT(:,4)==1,:); % all trials with low Vcoh
Vhigh = MAT(MAT(:,4)==2,:); % all trials with high Vcoh

tmp = Vlow(Vlow(:,1) == Vlow(:,3),:); % all Vlow congruent trials
tmp1=Vhigh(Vhigh(:,1) == Vhigh(:,3),:); % all Vhigh congruent trials

subplot(3,2,3);
for kk=1:5
    Acoh_Vlow = tmp(tmp(:,2)==kk,:); % find each A-level
    ylow(:, kk) = Acoh_Vlow(:,6);
    plot(audx(kk), ylow(:, kk), 'ok');hold on;   
end
xlabel('AVc - VisLow');ylabel('RT');
xlim([0 45]);ylim([0.2 1.5]);

subplot(3,2,4);
for kk=1:5
    Acoh_Vhigh = tmp1(tmp1(:,2)==kk,:);
    yhigh(:, kk)= Acoh_Vhigh(:,6);
    plot(audx(kk), yhigh(:, kk), 'ok');hold on;   
end
xlabel('AVc - VisHigh');ylabel('RT');
xlim([0 45]);ylim([0.2 1.5]);


%% INCONGRUENT same as above, now with congruent visual levels

Vlow = MAT(MAT(:,4)==1,:); % all trials with low Vcoh
Vhigh = MAT(MAT(:,4)==2,:); % all trials with high Vcoh

tmp = Vlow(Vlow(:,1) ~= Vlow(:,3),:); % all Vlow incongruent trials
tmp1=Vhigh(Vhigh(:,1) ~= Vhigh(:,3),:); % all Vhigh incongruent trials

subplot(3,2,5);
for kk=1:5
    Acoh_Vlow = tmp(tmp(:,2)==kk,:); % find each A-level
    ylow2(:, kk) = Acoh_Vlow(:,6);
    plot(audx(kk), ylow2(:, kk), 'ok');hold on;   
end
xlabel('AVi - VisLow');ylabel('RT');
xlim([0 45]);ylim([0.2 1.5]);

subplot(3,2,6);
for kk=1:5
    Acoh_Vhigh = tmp1(tmp1(:,2)==kk,:);
    yhigh2(:, kk)= Acoh_Vhigh(:,6);
    plot(audx(kk), yhigh2(:, kk), 'ok');hold on;   
end
xlabel('AVi - VisHigh');ylabel('RT');
xlim([0 45]);ylim([0.2 1.5]);



%% barplots
figure;
subplot(3,2,1)
barplot(y, 'sem','stars');hold on;
ylim([0 1.5])
subplot(3,2,2)
barplot(v,'sem','stars');hold on;
ylim([0 1.5])
subplot(3,2,3)
barplot(ylow,'sem','stars');hold on;
ylim([0 1.5])
subplot(3,2,4)
barplot(yhigh,'sem','stars');hold on;
ylim([0 1.5])
subplot(3,2,5)
barplot(ylow2,'sem','stars');hold on;
ylim([0 1.5])
subplot(3,2,6)
barplot(yhigh2,'sem','stars');hold on;
ylim([0 1.5])

% %% for stats
for visz=1:2
vis_mean(1, visz)=nanmean(v(:,visz));
vis_median(1, visz)=nanmedian(v(:,visz));
vis_std(1, visz)=nanstd(v(:,visz));
vis_sem(1, visz)=vis_std(1,visz)/sqrt(length(v(~isnan(v(:,visz)))));
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
end
function MAT=at_RDKUnisensoryRT_plot(subject)
% subject=6
for sub=1:length(subject)
    thissub=subject(sub);
    if length(num2str(thissub))==2
        subID=num2str(thissub);
    elseif length(num2str(thissub)) < 2
        subID = strcat(['0' num2str(thissub)]);
        
    end

    fileAudio=strcat(['RDKAudio_' subID '.mat']);
    AUDIO=load(fileAudio);
    fileVisual=strcat(['RDKVisual_' subID '.mat']);
    VISUAL=load(fileVisual);
% % get directory with data, then select data file to load
% Dir = uigetdir; cd(Dir); load(uigetfile);
   
%% A alone condition, i.e. Vcoh = 0;
AudAalone = AUDIO.MAT(AUDIO.MAT(:,4)==0,:); % find all trials with Vcoh = 0

for kk = 1:5 % 5 Acoh levels not including 0, i.e. no catch trials, looping over each Acoh levels
    AudAcoh = AudAalone(AudAalone(:,2)==kk,:); %  
    Audy(kk) = nanmedian(AudAcoh(:,6)); % %correct responses for each Acoh levels not including catch trials
end

VisAalone = VISUAL.MAT(VISUAL.MAT(:,4)==0,:); % find all trials with Vcoh = 0

for kk = 1:5 % 5 Acoh levels not including 0, i.e. no catch trials, looping over each Acoh levels
    VisAcoh = VisAalone(VisAalone(:,2)==kk,:); %  
    Visy(kk) = nanmedian(VisAcoh(:,6)); % %correct responses for each Acoh levels not including catch trials
end

acoh = [5,10,20,30,40]; % actual Acoh levels, plotted below
figure;subplot(2,2,1); plot(acoh,Audy,'ok-', 'LineWidth', 2); hold on; plot(acoh,Visy,'o-.m', 'LineWidth', 1);
xlim([0 45]); ylim([0 1.5]);
xlabel('Auditory coherence level');ylabel('p[Auditory Direction]');
legend('Attend Auditory', 'Attend Visual', 'Location', 'northwest')
title('Auditory-only trials')


%% V alone condition, i.e. Acoh = 0;

AudValone = AUDIO.MAT(AUDIO.MAT(:,2)==0,:); % find all trials with Acoh = 0

for vv = 1:2 % 2 Vcoh levels not including 0, i.e. no catch trials, looping over each Vcoh levels
    AudVcoh = AudValone(AudValone(:,4)==vv,:); %  
    Audv(vv) = nanmedian(AudVcoh(:,6)); % %correct responses for each Acoh levels not including catch trials
end

VisValone = VISUAL.MAT(VISUAL.MAT(:,2)==0,:); % find all trials with Acoh = 0

for vv = 1:2 % 2 Vcoh levels not including 0, i.e. no catch trials, looping over each Vcoh levels
    VisVcoh = VisValone(VisValone(:,4)==vv,:); %  
    Visv(vv) = nanmedian(VisVcoh(:,6)); % %correct responses for each Acoh levels not including catch trials
end


vcoh = [6, 60]; % actual Vcoh levels, plotted below
subplot(2,2,3);plot(vcoh,Audv,'ok-.', 'LineWidth', 1); hold on; plot(vcoh,Visv,'o-m', 'LineWidth', 2);
xlim([0 70]); ylim([0 1.5]);
xlabel('Visual Motion coherence level');ylabel('p[Visual Direction]');
legend('Attend Auditory', 'Attend Visual', 'Location', 'northwest')
title('Visual-only trials')


%% attend AUDITORY
AudVlow = AUDIO.MAT(AUDIO.MAT(:,4)==1,:); % all trials with low Vcoh
AudVhigh = AUDIO.MAT(AUDIO.MAT(:,4)==2,:); % all trials with high Vcoh

Audtmp = AudVlow(AudVlow(:,1) == AudVlow(:,3),:); % all Vlow congruent trials
Audtmp1= AudVhigh(AudVhigh(:,1) == AudVhigh(:,3),:); % all Vhigh congruent trials

for kk=1:5
    Aud_Acoh_Vlow = Audtmp(Audtmp(:,2)==kk,:); % find each A-level
    Aud_Acoh_Vhigh = Audtmp1(Audtmp1(:,2)==kk,:);
    Aud_ylow(kk) = nanmedian(Aud_Acoh_Vlow(:,6)); % correct trials
    Aud_yhigh(kk) = nanmedian(Aud_Acoh_Vhigh(:,6));
end

subplot(2,2,2)
plot(acoh,Aud_ylow,'ro-'); % V-low = red
hold on;plot(acoh,Aud_yhigh,'bo-'); % V-high = blue


% Multisensory INCONGRUENT

AudVlowi = AUDIO.MAT(AUDIO.MAT(:,4)==1,:); % all trials with low Vcoh
AudVhighi = AUDIO.MAT(AUDIO.MAT(:,4)==2,:); % all trials with high Vcoh

Audtmpi = AudVlowi(AudVlowi(:,1) ~= AudVlowi(:,3),:); % all Vlow congruent trials
Audtmp1i= AudVhighi(AudVhighi(:,1) ~= AudVhighi(:,3),:); % all Vhigh congruent trials

for kk=1:5
    Aud_Acoh_Vlowi = Audtmpi(Audtmpi(:,2)==kk,:); % find each A-level
    Aud_Acoh_Vhighi = Audtmp1i(Audtmp1i(:,2)==kk,:);
    Aud_ylowi(kk) = nanmedian(Aud_Acoh_Vlowi(:,6)); % correct trials
    Aud_yhighi(kk) = nanmedian(Aud_Acoh_Vhighi(:,6));
end

subplot(2, 2, 2)
hold on; plot(acoh,Aud_ylowi,'ro-.'); % V-low = red
hold on; plot(acoh,Aud_yhighi,'bo-.'); % V-high = blue
xlabel('Auditory coherence level');ylabel('p[Auditory Direction]');
title('Attend Auditory - Multisensory trials')
xlim([0 45]);ylim([0 1.5])
legend('AVc Low Visual', 'AVc High Visual', 'AVi - visual low', 'AVi - visual high', 'Location', 'southeast')


%% attend VISUAL

VisVlow = VISUAL.MAT(VISUAL.MAT(:,4)==1,:); % all trials with low Vcoh
VisVhigh = VISUAL.MAT(VISUAL.MAT(:,4)==2,:); % all trials with high Vcoh

Vistmp = VisVlow(VisVlow(:,1) == VisVlow(:,3),:); % all Vlow congruent trials
Vistmp1= VisVhigh(VisVhigh(:,1) == VisVhigh(:,3),:); % all Vhigh congruent trials

for kk=1:5
    Vis_Acoh_Vlow = Vistmp(Vistmp(:,2)==kk,:); % find each A-level
    Vis_Acoh_Vhigh = Vistmp1(Vistmp1(:,2)==kk,:);
    Vis_ylow(kk) = nanmedian(Vis_Acoh_Vlow(:,6)); % correct trials
    Vis_yhigh(kk) = nanmedian(Vis_Acoh_Vhigh(:,6));
end

subplot(2,2,4)
plot(acoh,Vis_ylow,'ro-'); % V-low = red
hold on;plot(acoh,Vis_yhigh,'bo-'); % V-high = blue
legend('AVc Low Visual', 'AVc High Visual', 'Location', 'northwest')


% Multisensory INCONGRUENT

VisVlowi = VISUAL.MAT(VISUAL.MAT(:,4)==1,:); % all trials with low Vcoh
VisVhighi = VISUAL.MAT(VISUAL.MAT(:,4)==2,:); % all trials with high Vcoh

Vistmpi = VisVlowi(VisVlowi(:,1) ~= VisVlowi(:,3),:); % all Vlow congruent trials
Vistmp1i= VisVhighi(VisVhighi(:,1) ~= VisVhighi(:,3),:); % all Vhigh congruent trials

for kk=1:5
    Vis_Acoh_Vlowi = Vistmpi(Vistmpi(:,2)==kk,:); % find each A-level
    Vis_Acoh_Vhighi = Vistmp1i(Vistmp1i(:,2)==kk,:);
    Vis_ylowi(kk) = nanmedian(Vis_Acoh_Vlowi(:,6)); % correct trials
    Vis_yhighi(kk) = nanmedian(Vis_Acoh_Vhighi(:,6));
end

subplot(2, 2, 4)
hold on; plot(acoh,Vis_ylowi,'ro-.'); % V-low = red
hold on; plot(acoh,Vis_yhighi,'bo-.'); % V-high = blue
xlabel('Auditory coherence level');ylabel('p[Visual Direction]');
title('Attend Visual - Multisensory trials')
xlim([0 45]);ylim([0 1.5])
legend('AVc Low Visual', 'AVc High Visual', 'AVi - visual low', 'AVi - visual high', 'Location', 'southwest')
end


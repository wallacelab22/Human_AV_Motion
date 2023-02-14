function MAT=at_RDKUnisensory_psychometric(subject)

for sub=1:length(subject)
    thissub=subject(sub);
    if length(num2str(thissub))==2
        subID=num2str(thissub);
    elseif length(num2str(thissub)) < 2
        subID = strcat(['0' num2str(thissub)]);
        
    end

    fileAudio=strcat(['RDKAudio_' subID '.mat']);
    AUDIO=load(fileAudio);
    fileVisual=strcat(['RDKVisual_01_01_1_1.mat']);
    VISUAL=load(fileVisual);

%% A alone condition, i.e. Vcoh = 0;
AudAalone = AUDIO.MAT(AUDIO.MAT(:,4)==0,:); % find all trials with Vcoh = 0

for kk = 1:5 % 5 Acoh levels not including 0, i.e. no catch trials, looping over each Acoh levels
    AudAcoh = AudAalone(AudAalone(:,2)==kk,:); %  
    Audy(kk) = (length(find(AudAcoh(:,1)==AudAcoh(:,5)))/length(AudAcoh)); % %correct responses for each Acoh levels not including catch trials
end

VisAalone = VISUAL.MAT(VISUAL.MAT(:,4)==0,:); % find all trials with Vcoh = 0

for kk = 1:5 % 5 Acoh levels not including 0, i.e. no catch trials, looping over each Acoh levels
    VisAcoh = VisAalone(VisAalone(:,2)==kk,:); %  
    Visy(kk) = (length(find(VisAcoh(:,1)==VisAcoh(:,5)))/length(VisAcoh)); % %correct responses for each Acoh levels not including catch trials
end

acoh = [5,10,20,30,40]; % actual Acoh levels, plotted below
subplot(2,2,1); plot(acoh,Audy,'ok'); hold on;
xlim([0 45]); ylim([0 1]);
xlabel('Auditory coherence level');ylabel('p[Auditory Direction]');
title('Attend Auditory - Auditory-only trials')
subplot(2,2,2);plot(acoh,Visy,'ok');hold on;
xlim([0 45]); ylim([0 1]);
xlabel('Auditory coherence level');ylabel('p[Auditory Direction]');
title('Attend Visual - Auditory-only trials')


%% V alone condition, i.e. Acoh = 0;

AudValone = AUDIO.MAT(AUDIO.MAT(:,2)==0,:); % find all trials with Acoh = 0

for vv = 1:2 % 2 Vcoh levels not including 0, i.e. no catch trials, looping over each Vcoh levels
    AudVcoh = AudValone(AudValone(:,4)==vv,:); %  
    Audv(vv) = (length(find(AudVcoh(:,3)==AudVcoh(:,5)))/length(AudVcoh)); % %correct responses for each Acoh levels not including catch trials
end

VisValone = VISUAL.MAT(VISUAL.MAT(:,2)==0,:); % find all trials with Acoh = 0

for vv = 1:2 % 2 Vcoh levels not including 0, i.e. no catch trials, looping over each Vcoh levels
    VisVcoh = VisValone(VisValone(:,4)==vv,:); %  
    Visv(vv) = (length(find(VisVcoh(:,3)==VisVcoh(:,5)))/length(VisVcoh)); % %correct responses for each Acoh levels not including catch trials
end

vcoh = [6, 60]; % actual Vcoh levels, plotted below
subplot(2,2,3);plot(vcoh,Audv,'ok'); hold on;
xlim([0 70]); ylim([0 1]);
xlabel('Visual Motion coherence level');ylabel('p[Visual Direction]');
title('Attend Auditory - Visual-only trials')
subplot(2,2,4); plot(vcoh,Visv,'ok'); hold on;
xlim([0 70]); ylim([0 1]);
xlabel('Attend Visual - Visual Motion coherence level');ylabel('p[Visual Direction]');
title('Visual-only trials')
end

load('Auditory_aud.mat')
load('Visual_aud.mat')
load('Auditory_vis.mat')
load('Visual_vis.mat')

subplot(2, 2, 1)
plot(acoh,mean(Audio_aud),'o-r', 'MarkerFaceColor', 'r');
xlim([0 45]); ylim([0 1]);
xlabel('Auditory coherence level');ylabel('p[Auditory Direction]');
title('Attend Auditory - Auditory-only trials')
subplot(2,2,2);
plot(acoh,mean(Audio_vis),'o-r', 'MarkerFaceColor', 'r');
xlim([0 45]); ylim([0 1]);
xlabel('Auditory coherence level');ylabel('p[Auditory Direction]');
title('Attend Visual - Auditory-only trials')
subplot(2,2,3);
plot(vcoh,mean(Visual_aud),'o-r', 'MarkerFaceColor', 'r');
xlim([0 70]); ylim([0 1]);
xlabel('Visual Motion coherence level');ylabel('p[Visual Direction]');
title('Attend Auditory - Visual-only trials')
subplot(2,2,4); 
plot(vcoh,mean(Visual_vis),'o-r', 'MarkerFaceColor', 'r');
xlim([0 70]); ylim([0 1]);
xlabel('Visual Motion coherence level');ylabel('p[Visual Direction]');
title('Attend Visual - Visual-only trials')


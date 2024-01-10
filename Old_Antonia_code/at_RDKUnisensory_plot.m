function MAT=at_RDKUnisensory_plot(subject)

for sub=1:length(subject)
    thissub=subject(sub);
    if length(num2str(thissub))==2
        subID=num2str(thissub);
    elseif length(num2str(thissub)) < 2
        subID = strcat(['0' num2str(thissub)]);
        %change subID to whatever the subject filename is, ex. '15_03_1_32'
        
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
    Audy(kk) = (length(find(AudAcoh(:,1)==AudAcoh(:,5)))/length(AudAcoh)); % %correct responses for each Acoh levels not including catch trials
end

VisAalone = VISUAL.MAT(VISUAL.MAT(:,4)==0,:); % find all trials with Vcoh = 0

for kk = 1:5 % 5 Acoh levels not including 0, i.e. no catch trials, looping over each Acoh levels
    VisAcoh = VisAalone(VisAalone(:,2)==kk,:); %  
    Visy(kk) = (length(find(VisAcoh(:,1)==VisAcoh(:,5)))/length(VisAcoh)); % %correct responses for each Acoh levels not including catch trials
end

acoh = [5,10,20,30,40]; % actual Acoh levels, plotted below
figure;subplot(2,2,1); plot(acoh,Audy,'ok-', 'LineWidth', 2); hold on; plot(acoh,Visy,'o-.m', 'LineWidth', 1);
xlim([0 45]); ylim([0 1]);
xlabel('Auditory coherence level');ylabel('p[Auditory Direction]');
legend('Attend Auditory', 'Attend Visual', 'Location', 'northwest')
title('Auditory-only trials')


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


% vcoh = [6, 60]; % actual Vcoh levels, plotted below
% subplot(2,2,3);plot(vcoh,Audv,'ok-.', 'LineWidth', 1); hold on; plot(vcoh,Visv,'o-m', 'LineWidth', 2);
% xlim([0 70]); ylim([0 1]);
% xlabel('Visual Motion coherence level');ylabel('p[Visual Direction]');
% legend('Attend Auditory', 'Attend Visual', 'Location', 'northwest')
% title('Visual-only trials')


%% attend AUDITORY
AudVlow = AUDIO.MAT(AUDIO.MAT(:,4)==1,:); % all trials with low Vcoh
AudVhigh = AUDIO.MAT(AUDIO.MAT(:,4)==2,:); % all trials with high Vcoh

Audtmp = AudVlow(AudVlow(:,1) == AudVlow(:,3),:); % all Vlow congruent trials
Audtmp1= AudVhigh(AudVhigh(:,1) == AudVhigh(:,3),:); % all Vhigh congruent trials

for kk=1:5
    Aud_Acoh_Vlow = Audtmp(Audtmp(:,2)==kk,:); % find each A-level
    Aud_Acoh_Vhigh = Audtmp1(Audtmp1(:,2)==kk,:);
    Aud_ylow(kk) = length(find(Aud_Acoh_Vlow(:,1)==Aud_Acoh_Vlow(:,5)))/length(Aud_Acoh_Vlow); % correct trials
    Aud_yhigh(kk) = length(find(Aud_Acoh_Vhigh(:,1)==Aud_Acoh_Vhigh(:,5)))/length(Aud_Acoh_Vhigh);
end

% subplot(2,2,2)
% plot(acoh,Aud_ylow,'ro-'); % V-low = red
% hold on;plot(acoh,Aud_yhigh,'bo-'); % V-high = blue


% Multisensory INCONGRUENT

AudVlowi = AUDIO.MAT(AUDIO.MAT(:,4)==1,:); % all trials with low Vcoh
AudVhighi = AUDIO.MAT(AUDIO.MAT(:,4)==2,:); % all trials with high Vcoh

Audtmpi = AudVlowi(AudVlowi(:,1) ~= AudVlowi(:,3),:); % all Vlow congruent trials
Audtmp1i= AudVhighi(AudVhighi(:,1) ~= AudVhighi(:,3),:); % all Vhigh congruent trials

for kk=1:5
    Aud_Acoh_Vlowi = Audtmpi(Audtmpi(:,2)==kk,:); % find each A-level
    Aud_Acoh_Vhighi = Audtmp1i(Audtmp1i(:,2)==kk,:);
    Aud_ylowi(kk) = length(find(Aud_Acoh_Vlowi(:,1)==Aud_Acoh_Vlowi(:,5)))/length(Aud_Acoh_Vlowi); % correct trials
    Aud_yhighi(kk) = length(find(Aud_Acoh_Vhighi(:,1)==Aud_Acoh_Vhighi(:,5)))/length(Aud_Acoh_Vhighi);
end

% subplot(2, 2, 2)
% hold on; plot(acoh,Aud_ylowi,'ro-.'); % V-low = red
% hold on; plot(acoh,Aud_yhighi,'bo-.'); % V-high = blue
% xlabel('Auditory coherence level');ylabel('p[Auditory Direction]');
% title('Attend Auditory - Multisensory trials')
% xlim([0 45]);ylim([0 1])
% legend('AVc Low Visual', 'AVc High Visual', 'AVi - visual low', 'AVi - visual high', 'Location', 'southeast')


%% attend VISUAL

VisVlow = VISUAL.MAT(VISUAL.MAT(:,4)==1,:); % all trials with low Vcoh
VisVhigh = VISUAL.MAT(VISUAL.MAT(:,4)==2,:); % all trials with high Vcoh

Vistmp = VisVlow(VisVlow(:,1) == VisVlow(:,3),:); % all Vlow congruent trials
Vistmp1= VisVhigh(VisVhigh(:,1) == VisVhigh(:,3),:); % all Vhigh congruent trials

for kk=1:5
    Vis_Acoh_Vlow = Vistmp(Vistmp(:,2)==kk,:); % find each A-level
    Vis_Acoh_Vhigh = Vistmp1(Vistmp1(:,2)==kk,:);
    Vis_ylow(kk) = length(find(Vis_Acoh_Vlow(:,3)==Vis_Acoh_Vlow(:,5)))/length(Vis_Acoh_Vlow); % correct trials
    Vis_yhigh(kk) = length(find(Vis_Acoh_Vhigh(:,3)==Vis_Acoh_Vhigh(:,5)))/length(Vis_Acoh_Vhigh);
end

% subplot(2,2,4)
% plot(acoh,Vis_ylow,'ro-'); % V-low = red
% hold on;plot(acoh,Vis_yhigh,'bo-'); % V-high = blue
% legend('AVc Low Visual', 'AVc High Visual', 'Location', 'northwest')


% Multisensory INCONGRUENT

VisVlowi = VISUAL.MAT(VISUAL.MAT(:,4)==1,:); % all trials with low Vcoh
VisVhighi = VISUAL.MAT(VISUAL.MAT(:,4)==2,:); % all trials with high Vcoh

Vistmpi = VisVlowi(VisVlowi(:,1) ~= VisVlowi(:,3),:); % all Vlow congruent trials
Vistmp1i= VisVhighi(VisVhighi(:,1) ~= VisVhighi(:,3),:); % all Vhigh congruent trials

for kk=1:5
    Vis_Acoh_Vlowi = Vistmpi(Vistmpi(:,2)==kk,:); % find each A-level
    Vis_Acoh_Vhighi = Vistmp1i(Vistmp1i(:,2)==kk,:);
    Vis_ylowi(kk) = length(find(Vis_Acoh_Vlowi(:,3)==Vis_Acoh_Vlowi(:,5)))/length(Vis_Acoh_Vlowi); % correct trials
    Vis_yhighi(kk) = length(find(Vis_Acoh_Vhighi(:,3)==Vis_Acoh_Vhighi(:,5)))/length(Vis_Acoh_Vhighi);
end


% subplot(2, 2, 4)
% hold on; plot(acoh,Vis_ylowi,'ro-.'); % V-low = red
% hold on; plot(acoh,Vis_yhighi,'bo-.'); % V-high = blue
% xlabel('Auditory coherence level');ylabel('p[Visual Direction]');
% title('Attend Visual - Multisensory trials')
% xlim([0 45]);ylim([0 1])
% legend('AVc Low Visual', 'AVc High Visual', 'AVi - visual low', 'AVi - visual high', 'Location', 'southwest')

 %% get response BIAS (button press on catch trials)
 
    CatchAud = AUDIO.MAT(AUDIO.MAT(:,4)==0,:); % find all trials with Vcoh = 0
    Zerocoh_Aud = CatchAud(CatchAud(:,2)==0,:); %
    bias_aud = length(Zerocoh_Aud(Zerocoh_Aud(:,5)==1))/length(Zerocoh_Aud(~isnan(Zerocoh_Aud(:,5)))); % %correct responses for each Acoh levels not including catch trials
    
    CatchVis = VISUAL.MAT(VISUAL.MAT(:,4)==0,:); % find all trials with Vcoh = 0
    Zerocoh_Vis = CatchVis(CatchVis(:,2)==0,:); %
    bias_vis = length(Zerocoh_Vis(Zerocoh_Vis(:,5)==1))/length(Zerocoh_Vis(~isnan(Zerocoh_Vis(:,5)))); % %correct responses for each Acoh levels not including catch trials

figure; hold on;
plot(bias_aud,'ro-.');
plot(bias_vis,'bo-.');
ylabel('p[Respond LEFT]');
title('False Alarms upon Catch trials')
ylim([0 1])
legend('Attend - Auditory', 'Attend - Visual', 'Location', 'southwest')

Bias_aud(sub, :)=bias_aud;
Bias_vis(sub, :)=bias_vis;
Visual_aud(sub,:)=Audv;
Visual_vis(sub,:)=Visv;
Audio_aud(sub,:)=Audy;
Audio_vis(sub,:)=Visy;
AVc_aud(sub,:)=cat(2,Aud_ylow, Aud_yhigh);
AVc_vis(sub,:)=cat(2,Vis_ylow, Vis_yhigh);
AVi_aud(sub,:)=cat(2,Aud_ylowi, Aud_yhighi);
AVi_vis(sub,:)=cat(2,Vis_ylowi, Vis_yhighi);

end
save('Bias_aud.mat', 'Bias_aud')
save('Bias_vis.mat', 'Bias_vis')
save('Visual_aud.mat', 'Visual_aud')
save('Visual_vis.mat', 'Visual_vis')
save('Auditory_aud.mat', 'Audio_aud')
save('Auditory_vis.mat', 'Audio_vis')
save('AVc_aud.mat', 'AVc_aud')
save('AVc_vis.mat', 'AVc_vis')
save('AVi_aud.mat', 'AVi_aud')
save('AVi_vis.mat', 'AVi_vis')

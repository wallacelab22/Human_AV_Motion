function MAT=at_RDKHoop_psychometric(subject)
%
for sub=1:length(subject)
    thissub=subject(sub);
    if length(num2str(thissub))==2
        subID=num2str(thissub);
    elseif length(num2str(thissub)) < 2
        subID = strcat(['0' num2str(thissub)]);
    end
    
    
%     figure;
    % Auditory Psyphys
%     display('Please add Select a Folder & then the Auditory results')
    % % get directory with data, then select data file to load
%     Dir = uigetdir; cd(Dir); load(uigetfile);
    MAT=strcat(['RDKHoop_psyAud_' subID '.mat']);
    load(MAT);
    Aud = MAT;
    
    for kk = 1:5 % 5 Acoh levels not including 0, i.e. no catch trials, looping over each Acoh levels
        Audcoh = Aud(Aud(:,2)==kk,:); %
        AudSignal(kk) = (length(find(Audcoh(:,1)==Audcoh(:,3)))/size(Audcoh,1)); % %correct responses for each Acoh levels not including catch trials
    end
    
    for bb = 1% BIAS
        Audb = Aud(Aud(:,2)==0,:); %
        Audbias(bb) = (length(find(Audb(:,3)==2))/length(Audb(~isnan(Audb(:,3))))); % number of LEFTWARD RESPONSES
    end
 %% RT computation   
    for kk = 1:5 % 5 Acoh levels not including 0, i.e. no catch trials, looping over each Acoh levels
        Audcoh = Aud(Aud(:,2)==kk,:); %
        AudSignal_rtcorr(kk) = nanmean(Audcoh(Audcoh(:,1)==Audcoh(:,3),4));
        AudSignal_rtall(kk) = nanmean(Audcoh(:,4));
        AudSignal_subrt(:, kk) = Audcoh(:,4);
    end
    
    for bb = 1% BIAS
        Audb = Aud(Aud(:,2)==0,:); %
        Audbias_rt(:, bb) = nanmean(Audb(:,4));
        Audbias_subrt(:, bb) = Audb(:,4);
    end
    
    clear kk bb
    %% Visual PsyPhys
%     display('Please add Select a Folder & then the Visual results')
    % % get directory with data, then select data file to load
%     load(uigetfile);
    MAT=strcat(['RDKHoop_psyVis_' subID '.mat']);
    load(MAT);
    Vis = MAT;
    for kk = 1:5 % 5 Acoh levels not including 0, i.e. no catch trials, looping over each Acoh levels
        Viscoh = Vis(Vis(:,2)==kk,:); %
        VisSignal(kk) = (length(find(Viscoh(:,1)==Viscoh(:,3)))/size(Viscoh,1)); % %correct responses for each Vcoh levels not including catch trials
    end
    
    for bb = 1 % BIAS
        Visb = Vis(Vis(:,2)==0,:); %
        Visbias(bb) = (length(find(Viscoh(:,3)==2))/length(Visb(~isnan(Visb(:,3))))); % number of LEFTWARD RESPONSES
    end
    %% RT computations
    for kk = 1:5 % 5 Acoh levels not including 0, i.e. no catch trials, looping over each Acoh levels
        Viscoh = Vis(Vis(:,2)==kk,:); %
        VisSignal_rtcorr(kk) = nanmean(Viscoh(Viscoh(:,1)==Viscoh(:,3),4));
        VisSignal_rtall(kk) = nanmean(Viscoh(:,4));
    end
    
    for bb = 1% BIAS
        Visb = Vis(Vis(:,2)==0,:); %
        Visbias_rt(bb) = nanmean(Visb(:,4));
    end    
    
    Aud_acc(sub,:)=AudSignal;
    Vis_acc(sub,:)=VisSignal;
    Aud_rtall(sub, :)=AudSignal_rtall;
    Vis_rtall(sub, :)=VisSignal_rtall;
    Aud_rtcorr(sub, :)=AudSignal_rtcorr;
    Vis_rtcorr(sub, :)=VisSignal_rtcorr;


%     %% plot single subject data
    acoh=[10,25,35,45,55];
    vcoh=[5,15,25,35,45];
%     subplot(2,6,2:6); plot(acoh,AudSignal,'-.o'); hold on;
%     xlim([0 60]); ylim([0 1]);
%     xlabel('Auditory coherence level');ylabel('p[Correct]');
%     title('Auditory Block')
%     subplot(2,6,1); plot(0, Audbias,'o'); hold on;
%     xlim([-1 1]); ylim([0 1]);
%     xlabel('CATCH trial');ylabel('p[LEFT responses]');
%     
%     subplot(2,6,8:12);plot(vcoh,VisSignal,'-.o');hold on;
%     xlim([0 60]); ylim([0 1]);
%     xlabel('Visual coherence level');ylabel('p[Correct]');
%     title('Visual Block')
%     subplot(2,6,7); plot(0, Visbias,'o'); hold on;
%     xlim([-1 1]); ylim([0 1]);
%     xlabel('CATCH trial');ylabel('p[LEFT responses]');
%     
% %% RT figure 
%     figure; 
%     subplot(2,6,2:6); plot(acoh,AudSignal_rt,'-.o'); hold on;
%     xlim([0 60]); ylim([0 1.5]);
%     xlabel('Auditory coherence level');ylabel('RT[s]');
%      subplot(2,6,1); plot(0, Audbias_rt,'o'); hold on;
%     xlim([-1 1]); ylim([0 1.5]);
%     xlabel('CATCH trial');ylabel('RT[s]');
%     
%     subplot(2,6,8:12);plot(vcoh,VisSignal_rt,'-.o');hold on;
%     xlim([0 60]); ylim([0 1.5]);
%     xlabel('Visual coherence level');ylabel('RT[s]');
%     subplot(2,6, 7); plot(0, Visbias_rt,'o'); hold on;
%     xlim([-1 1]); ylim([0 1.5]);
%     xlabel('CATCH trial');ylabel('RT[s]');
% 
end
save('Aud_acc.mat', 'Aud_acc')
save('Vis_acc.mat', 'Vis_acc')
save('Aud_rtall.mat', 'Aud_rtall')
save('Vis_rtall.mat', 'Vis_rtall')
save('Aud_rtcorr.mat', 'Aud_rtcorr')
save('Vis_rtcorr.mat', 'Vis_rtcorr')


% %% plot all subject data
% subplot(1, 2, 1)
% for ii = 1:size(Aud_acc, 1)
%     plot(acoh, Aud_acc(ii, :),'o-.' ); hold on
% end
% xlim([0 60]); ylim([0 1]);title('Auditory Block');xlabel('Auditory coherence in [%]');ylabel('pHIT[Auditory direction]')
% subplot(1, 2, 2)
% for ii = 1:size(Vis_acc, 1)
%     plot(vcoh, Vis_acc(ii, :),'o-.' ); hold on
% end
% xlim([0 60]); ylim([0 1]);title('Visual Block');xlabel('Visual coherence in [%]');ylabel('pHIT[Visual direction]')
% legend('Subject 08', 'Subject 10', 'Subject 11', 'Subject 12', 'Subject 13', 'Subject 14', 'Subject 15', 'Subject 16')
% 
% figure;
% subplot(1, 2, 1)
% for ii = 1:size(Aud_rt, 1)
%     plot(acoh, Aud_rt(ii, :),'o-.' ); hold on
% end
% xlim([0 60]); ylim([0 1.5]);title('Auditory Block');xlabel('Auditory coherence in [%]');ylabel('RTs in [s]')
% subplot(1, 2, 2)
% for ii = 1:size(Vis_rt, 1)
%     plot(vcoh, Vis_rt(ii, :),'o-.' ); hold on
% end
% xlim([0 60]); ylim([0 1.5]);title('Visual Block');xlabel('Visual coherence in [%]');ylabel('RTs in [s]')
% legend('Subject 08', 'Subject 10', 'Subject 11', 'Subject 12', 'Subject 13', 'Subject 14', 'Subject 15', 'Subject 16')
% 
% 
% Aud_rtstar = Aud_rt./Aud_acc;
% Vis_rtstar = Vis_rt./Vis_acc;
% 
% figure;
% subplot(1, 2, 1)
% for ii = 1:size(Aud_rtstar, 1)
%     plot(acoh, Aud_rtstar(ii, :),'o-.' ); hold on
% end
% xlim([0 60]); ylim([0 3]);title('Auditory Block');xlabel('Auditory coherence in [%]');ylabel('RT* in [s/pHit]')
% subplot(1, 2, 2)
% for ii = 1:size(Vis_rtstar, 1)
%     plot(vcoh, Vis_rtstar(ii, :),'o-.' ); hold on
% end
% xlim([0 60]); ylim([0 3]);title('Visual Block');xlabel('Visual coherence in [%]');ylabel('RT* in [s/pHit]')
% legend('Subject 08', 'Subject 10', 'Subject 11', 'Subject 12', 'Subject 13', 'Subject 14', 'Subject 15', 'Subject 16')

%% plot group mean data
subplot(1, 2, 1)
    plot(acoh, mean(Aud_acc),'o-.' ); hold on
xlim([0 60]); ylim([0 1]);title('Auditory Block');xlabel('Auditory coherence in [%]');ylabel('pHIT[Auditory direction]')

subplot(1, 2, 2)
    plot(vcoh, mean(Vis_acc),'o-.' ); hold on
xlim([0 60]); ylim([0 1]);title('Visual Block');xlabel('Visual coherence in [%]');ylabel('pHIT[Visual direction]')
%% RTs
figure;
subplot(2, 2, 1)
% suplabel('RTs of all trials (correct & incorrect choices)')
    plot(acoh, mean(Aud_rtall),'o-.' ); hold on
xlim([0 60]); ylim([0 1.5]);title('Auditory Block');xlabel('Auditory coherence in [%]');ylabel('RTs in [s]')

subplot(2, 2, 2)
    plot(vcoh, mean(Vis_rtall),'o-.' ); hold on
xlim([0 60]); ylim([0 1.5]);title('Visual Block');xlabel('Visual coherence in [%]');ylabel('RTs in [s]')

subplot(2, 2, 3)
% suplabel('RTs of accurate trials (correct choices only)')
    plot(acoh, mean(Aud_rtcorr),'o-.' ); hold on
xlim([0 60]); ylim([0 1.5]);title('Auditory Block');xlabel('Auditory coherence in [%]');ylabel('RTs in [s]')

subplot(2, 2, 4)
    plot(vcoh, mean(Vis_rtcorr),'o-.' ); hold on
xlim([0 60]); ylim([0 1.5]);title('Visual Block');xlabel('Visual coherence in [%]');ylabel('RTs in [s]')


%% RT star
Aud_rtstarall = Aud_rtall./Aud_acc;
Vis_rtstarall = Vis_rtall./Vis_acc;
figure;
subplot(2, 2, 1)
% suplabel('RT* of all trials (correct & incorrect RTs)')
    plot(acoh, mean(Aud_rtstarall),'o-.' ); hold on
xlim([0 60]); ylim([0 3]);title('Auditory Block');xlabel('Auditory coherence in [%]');ylabel('RT* in [s/pHit]')

subplot(2, 2, 2)
    plot(vcoh, mean(Vis_rtstarall),'o-.' ); hold on
xlim([0 60]); ylim([0 3]);title('Visual Block');xlabel('Visual coherence in [%]');ylabel('RT* in [s/pHit]')

Aud_rtstarcorr = Aud_rtcorr./Aud_acc;
Vis_rtstarcorr = Vis_rtcorr./Vis_acc;

subplot(2, 2, 3)
% suplabel('RT* of accurate trials (correct choice RTs only)')
    plot(acoh, mean(Aud_rtstarcorr),'o-.' ); hold on
xlim([0 60]); ylim([0 3]);title('Auditory Block');xlabel('Auditory coherence in [%]');ylabel('RT* in [s/pHit]')

subplot(2, 2, 4)
    plot(vcoh, mean(Vis_rtstarcorr),'o-.' ); hold on
xlim([0 60]); ylim([0 3]);title('Visual Block');xlabel('Visual coherence in [%]');ylabel('RT* in [s/pHit]')



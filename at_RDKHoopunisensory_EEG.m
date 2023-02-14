function MAT=at_RDKHoopunisensory_EEG(subject)
%
for sub=1:length(subject)
    thissub=subject(sub);
    subID=num2str(thissub);
     
    N=5;
    MAT = [];
    for bb=1:N
     blockID=num2str(bb);
    
    if length(num2str(bb))== 2
        blockID=num2str(bb);
    elseif length(num2str(bb)) < 2
        blockID = strcat(['0' num2str(bb)]);
    end

    thisMAT=strcat(['RDKHoop_psyAud_' subID '_' blockID '.mat']);
    newdata=load(thisMAT);
    newdata=newdata.MAT;
    MAT= [MAT; newdata];
    end
    Aud = MAT;
    
    for kk = 1:2 % 5 Acoh levels not including 0, i.e. no catch trials, looping over each Acoh levels
        Audcoh = Aud(Aud(:,2)==kk,:); %
        AudSignal(kk) = (length(find(Audcoh(:,1)==Audcoh(:,3)))/size(Audcoh,1)); % %correct responses for each Acoh levels not including catch trials
    end
    

    clear kk bb
    %% Visual PsyPhys
    MAT = [];
    for bb=1:N
     blockID=num2str(bb);
    
    if length(num2str(bb))== 2
        blockID=num2str(bb);
    elseif length(num2str(bb)) < 2
        blockID = strcat(['0' num2str(bb)]);
    end

    thisMAT=strcat(['RDKHoop_psyVis_' subID '_' blockID '.mat']);
    newdata=load(thisMAT);
    newdata=newdata.MAT;
    MAT= [MAT; newdata];
    end
    Vis = MAT;
    
    for kk = 1:2 % 5 Acoh levels not including 0, i.e. no catch trials, looping over each Acoh levels
        Viscoh = Vis(Vis(:,2)==kk,:); %
        VisSignal(kk) = (length(find(Viscoh(:,1)==Viscoh(:,3)))/size(Viscoh,1)); % %correct responses for each Vcoh levels not including catch trials
    end
    
     
    Aud_acc(sub,:)=AudSignal;
    Vis_acc(sub,:)=VisSignal;
 
%     %% plot single subject data
    acoh=[10,45];
    vcoh=[5,35];
    subplot(2,2,1); plot(acoh,AudSignal,'k*'); hold on;
    xlim([0 50]); ylim([0.3 1]);
%     xlabel('Auditory coherence level');ylabel('p[Correct]');
    title('Auditory Block')
%     subplot(2,6,1); plot(0, Audbias,'o'); hold on;
%     xlim([-1 1]); ylim([0 1]);
%     xlabel('CATCH trial');ylabel('p[LEFT responses]');
%     
    subplot(2,2,2);plot(vcoh,VisSignal,'k*');hold on;
    xlim([0 50]); ylim([0.3 1]);
%     xlabel('Visual coherence level');ylabel('p[Correct]');
    title('Visual Block')
%     subplot(2,6,7); plot(0, Visbias,'o'); hold on;
%     xlim([-1 1]); ylim([0 1]);
%     xlabel('CATCH trial');ylabel('p[LEFT responses]');
%     

end

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

%% plot group mean data
subplot(2, 2, 1)
    plot(acoh, mean(Aud_acc),'ko-' ); hold on
    xlim([0 50]); ylim([0 1]);title('Auditory-only Block');xlabel('Auditory coherence in [%]');ylabel('pHIT[Auditory direction]')
% xlim([0 60]); ylim([0 1]);title('Auditory Block');xlabel('Auditory coherence in [%]');ylabel('pHIT[Auditory direction]')

subplot(2, 2, 2)
    plot(vcoh, mean(Vis_acc),'ko-' ); hold on
    xlim([0 50]); ylim([0 1]);title('Visual-only');xlabel('Visual coherence in [%]');ylabel('pHIT[Visual direction]')
% xlim([0 60]); ylim([0 1]);title('Visual Block');xlabel('Visual coherence in [%]');ylabel('pHIT[Visual direction]')


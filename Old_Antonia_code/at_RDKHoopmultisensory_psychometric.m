function MAT=at_RDKHoopmultisensory_psychometric(subject)
%
for sub=1:length(subject)
    thissub=subject(sub);
    if length(num2str(thissub))==2
        subID=num2str(thissub);
    elseif length(num2str(thissub)) < 2
        subID = strcat(['0' num2str(thissub)]);
    end
    
    % display('Please add Select a Folder & then the AV results')
    % % % get directory with data, then select data file to load
    % Dir = uigetdir; cd(Dir); load(uigetfile);
    MAT=strcat(['RDKHoop_psyAV_' subID '.mat']);
    load(MAT);
    % figure;
    acoh=[10,25,35,45,55];
    vcoh=[5,15,25,35,45];
    
    auditoryonly=MAT(MAT(:, 4)==0, :);
    visualonly=MAT(MAT(:, 2)==0, :);
    
    for uu=1:5
        visual=visualonly(visualonly(:,4)==uu,:);
        auditory=auditoryonly(auditoryonly(:,2)==uu,:);
        Accvonly(uu) = length(find(visual(:,3)==visual(:,5)))/size(visual,1);
        Accaonly(uu) = length(find(auditory(:,1)==auditory(:,5)))/size(auditory,1);
        RTvonly_all(uu) = nanmean(visual(:,6));
        RTaonly_all(uu) = nanmean(auditory(:,6));
        RTvonly_corr(uu) = nanmean(visual(visual(:,3)==visual(:,5), 6));
        RTaonly_corr(uu) = nanmean(auditory(auditory(:,1)==auditory(:,5), 6));
    end
    
    
    % hold on;
    % subplot(2, 2, 1);plot(vcoh, Accvonly, 'ko-'); xlim([0 60]); ylim([0 1]); title('VISUAL in auditory noise'); ylabel('pHit [Visual direction]'); xlabel('Visual coherence level');
    % hold on;
    % subplot(2, 2, 2);plot(acoh, Accaonly, 'ko-'); xlim([0 60]); ylim([0 1]); title('AUDITORY in visual noise'); ylabel('pHit [Auditory direction]'); xlabel('Auditory coherence level')
    
    
    
    for va=1:5
        auditorytrials = MAT(MAT(:, 2)==va, :);
        avcongruent = auditorytrials(auditorytrials(:, 1) == auditorytrials(:, 3),:);
        avincongruent = auditorytrials(auditorytrials(:, 1) ~= auditorytrials(:, 3),:);
        
        for av=1:5
            avcong=avcongruent(avcongruent(:,4)==av,:);
            avincong=avincongruent(avincongruent(:,4)==av,:);
            Accavcong(av) = length(find(avcong(:,3)==avcong(:,5)))/size(avcong,1);
            Accavincong(av) = length(find(avincong(:,3)==avincong(:,5)))/size(avincong,1);
            RTavcong_all(av) = nanmean(avcong(:,6));
            RTavincong_all(av) = nanmean(avincong(:,6));
            RTavcong_corr(av) = nanmean(avcong(avcong(:,3)==avcong(:,5), 6));
            RTavincong_corr(av) = nanmean(avincong(avincong(:,3)==avincong(:,5), 6));
        end
        subaccavcong(va, :)=Accavcong;
        subaccavincong(va, :)=Accavincong;
        subRTallavcong(va, :)=RTavcong_all;
        subRTallavincong(va, :)=RTavincong_all;
        subRTcorravcong(va, :)=RTavcong_corr;
        subRTcorravincong(va, :)=RTavincong_corr;
        
        %     hold on;
        %     subplot(2, 2, 3);plot(vcoh, Accavcong, 'o-.'); xlim([0 60]); ylim([0 1]); title('AV CONGRUENT'); ylabel('pHit [Visual direction]'); xlabel('Visual coherence level');
        %     hold on;
        %     subplot(2, 2, 4);plot(vcoh, Accavincong, 'o-.'); xlim([0 60]); ylim([0 1]); title('AV INCONGRUENT'); ylabel('pHit [Visual direction]'); xlabel('Visual coherence level')
    end
    allaccavcong = reshape(subaccavcong', [1, 25]);
    allaccavincong = reshape(subaccavincong', [1, 25]);
    allRTallavcong = reshape(subRTallavcong', [1, 25]);
    allRTallavincong = reshape(subRTallavincong', [1, 25]);
    allRTcorravcong = reshape(subRTcorravcong', [1, 25]);
    allRTcorravincong = reshape(subRTcorravincong', [1, 25]);
    
    % legend('A - 10%', 'A - 25%', 'A - 35%', 'A - 45%', 'A - 55%')
    
    Vnoise_acc(sub, :) = Accvonly;
    Anoise_acc(sub, :) = Accaonly;
    AVcong_acc(sub, :) = allaccavcong;
    AVincong_acc(sub, :) = allaccavincong;
    
    Vnoise_rtall(sub, :) = RTvonly_all;
    Anoise_rtall(sub, :) = RTaonly_all;
    AVcong_rtall(sub, :) = allRTallavcong;
    AVincong_rtall(sub, :) = allRTallavincong;
    
    Vnoise_rtcorr(sub, :) = RTvonly_corr;
    Anoise_rtcorr(sub, :) = RTaonly_corr;
    AVcong_rtcorr(sub, :) = allRTcorravcong;
    AVincong_rtcorr(sub, :) = allRTcorravincong;
    
end
save('Vnoise_acc.mat', 'Vnoise_acc')
save('Anoise_acc.mat', 'Anoise_acc')
save('AVcong_acc.mat', 'AVcong_acc')
save('AVincong_acc.mat', 'AVincong_acc')

save('Vnoise_rtall.mat', 'Vnoise_rtall')
save('Anoise_rtall.mat', 'Anoise_rtall')
save('AVcong_rtall.mat', 'AVcong_rtall')
save('AVincong_rtall.mat', 'AVincong_rtall')

save('Vnoise_rtcorr.mat', 'Vnoise_rtcorr')
save('Anoise_rtcorr.mat', 'Anoise_rtcorr')
save('AVcong_rtcorr.mat', 'AVcong_rtcorr')
save('AVincong_rtcorr.mat', 'AVincong_rtcorr')


%% plot all subject data
acoh=[10,25,35,45,55];
vcoh=[5,15,25,35,45];

subplot(2, 2, 1)
plot(acoh, mean(Anoise_acc),'o-.' ); hold on
xlim([0 60]); ylim([0 1]);title('Auditory in Visual noise');xlabel('Auditory coherence in [%]');ylabel('pHIT[Auditory direction]')

subplot(2, 2, 2)
plot(vcoh, mean(Vnoise_acc),'o-.' ); hold on
xlim([0 60]); ylim([0 1]);title('Visual in Auditory noise');xlabel('Visual coherence in [%]');ylabel('pHIT[Visual direction]')

subplot(2, 2, 3)
plot(vcoh, mean(AVcong_acc(:, 1:5)),'o-.' ); hold on
plot(vcoh, mean(AVcong_acc(:, 6:10)),'o-.' ); hold on
plot(vcoh, mean(AVcong_acc(:, 11:15)),'o-.' ); hold on
plot(vcoh, mean(AVcong_acc(:, 16:20)),'o-.' ); hold on
plot(vcoh, mean(AVcong_acc(:, 21:25)),'o-.' ); hold on
plot(vcoh, mean(Vnoise_acc),'k-' ); hold on
xlim([0 60]); ylim([0 1]);title('AV congruent trials');xlabel('Visual coherence in [%]');ylabel('pHIT[Visual direction]')
legend('A - 10%', 'A - 25%', 'A - 35%', 'A - 45%', 'A - 55%')

subplot(2, 2, 4)
plot(vcoh, mean(AVincong_acc(:, 1:5)),'o-.' ); hold on
plot(vcoh, mean(AVincong_acc(:, 6:10)),'o-.' ); hold on
plot(vcoh, mean(AVincong_acc(:, 11:15)),'o-.' ); hold on
plot(vcoh, mean(AVincong_acc(:, 16:20)),'o-.' ); hold on
plot(vcoh, mean(AVincong_acc(:, 21:25)),'o-.' ); hold on
plot(vcoh, mean(Vnoise_acc),'k-' ); hold on
xlim([0 60]); ylim([0 1]);title('AV incongruent trials');xlabel('Visual coherence in [%]');ylabel('pHIT[Visual direction]')
legend('A - 10%', 'A - 25%', 'A - 35%', 'A - 45%', 'A - 55%')

%% RT plots
figure;
suptitle('RTs of all trials (independent of choice of direction)')
subplot(2, 2, 1)
plot(acoh, mean(Anoise_rtall),'o-.' ); hold on
xlim([0 60]); ylim([0 1.5]);title('Auditory in Visual noise');xlabel('Auditory coherence in [%]');ylabel('RTs in [s]')

subplot(2, 2, 2)
plot(vcoh, mean(Vnoise_rtall),'o-.' ); hold on
xlim([0 60]); ylim([0 1.5]);title('Visual in Auditory noise');xlabel('Visual coherence in [%]');ylabel('RTs in [s]')

subplot(2, 2, 3)
plot(vcoh, mean(AVcong_rtall(:, 1:5)),'o-.' ); hold on
plot(vcoh, mean(AVcong_rtall(:, 6:10)),'o-.' ); hold on
plot(vcoh, mean(AVcong_rtall(:, 11:15)),'o-.' ); hold on
plot(vcoh, mean(AVcong_rtall(:, 16:20)),'o-.' ); hold on
plot(vcoh, mean(AVcong_rtall(:, 21:25)),'o-.' ); hold on
xlim([0 60]); ylim([0 1.5]);title('AV congruent trials');xlabel('Visual coherence in [%]');ylabel('RTs in [s]')
legend('A - 10%', 'A - 25%', 'A - 35%', 'A - 45%', 'A - 55%')

subplot(2, 2, 4)
plot(vcoh, mean(AVincong_rtall(:, 1:5)),'o-.' ); hold on
plot(vcoh, mean(AVincong_rtall(:, 6:10)),'o-.' ); hold on
plot(vcoh, mean(AVincong_rtall(:, 11:15)),'o-.' ); hold on
plot(vcoh, mean(AVincong_rtall(:, 16:20)),'o-.' ); hold on
plot(vcoh, mean(AVincong_rtall(:, 21:25)),'o-.' ); hold on
xlim([0 60]); ylim([0 1.5]);title('AV incongruent trials');xlabel('Visual coherence in [%]');ylabel('RTs in [s]')
legend('A - 10%', 'A - 25%', 'A - 35%', 'A - 45%', 'A - 55%')

figure;
suptitle('RTs corresponding to behavioral choice (trials corresponding to pHit)')
subplot(2, 2, 1)
plot(acoh, mean(Anoise_rtcorr),'o-.' ); hold on
xlim([0 60]); ylim([0 1.5]);title('Auditory in Visual noise');xlabel('Auditory coherence in [%]');ylabel('RTs in [s]')

subplot(2, 2, 2)
plot(vcoh, mean(Vnoise_rtcorr),'o-.' ); hold on
xlim([0 60]); ylim([0 1.5]);title('Visual in Auditory noise');xlabel('Visual coherence in [%]');ylabel('RTs in [s]')

subplot(2, 2, 3)
plot(vcoh, mean(AVcong_rtcorr(:, 1:5)),'o-.' ); hold on
plot(vcoh, mean(AVcong_rtcorr(:, 6:10)),'o-.' ); hold on
plot(vcoh, mean(AVcong_rtcorr(:, 11:15)),'o-.' ); hold on
plot(vcoh, mean(AVcong_rtcorr(:, 16:20)),'o-.' ); hold on
plot(vcoh, mean(AVcong_rtcorr(:, 21:25)),'o-.' ); hold on
xlim([0 60]); ylim([0 1.5]);title('AV congruent trials');xlabel('Visual coherence in [%]');ylabel('RTs in [s]')
legend('A - 10%', 'A - 25%', 'A - 35%', 'A - 45%', 'A - 55%')

subplot(2, 2, 4)
plot(vcoh, mean(AVincong_rtcorr(:, 1:5)),'o-.' ); hold on
plot(vcoh, mean(AVincong_rtcorr(:, 6:10)),'o-.' ); hold on
plot(vcoh, mean(AVincong_rtcorr(:, 11:15)),'o-.' ); hold on
plot(vcoh, mean(AVincong_rtcorr(:, 16:20)),'o-.' ); hold on
plot(vcoh, mean(AVincong_rtcorr(:, 21:25)),'o-.' ); hold on
xlim([0 60]); ylim([0 1.5]);title('AV incongruent trials');xlabel('Visual coherence in [%]');ylabel('RTs in [s]')
legend('A - 10%', 'A - 25%', 'A - 35%', 'A - 45%', 'A - 55%')
%% RT star computations
Anoise_rtstar_all = Anoise_rtall./Anoise_acc;
Vnoise_rtstar_all = Vnoise_rtall./Vnoise_acc;
AVcong_rtstar_all = AVcong_rtall./AVcong_acc;
AVincong_rtstar_all = AVincong_rtall./AVincong_acc;

figure;
suptitle('RT* computed across RTs from all trials')
subplot(2, 2, 1)
plot(acoh, mean(Anoise_rtstar_all),'o-.' ); hold on
xlim([0 60]); ylim([0 3]);title('Auditory in Visual noise');xlabel('Auditory coherence in [%]');ylabel('RT* in [s/pHit]')

subplot(2, 2, 2)
plot(vcoh, mean(Vnoise_rtstar_all),'o-.' ); hold on
xlim([0 60]); ylim([0 3]);title('Visual in Auditory noise');xlabel('Visual coherence in [%]');ylabel('RT* in [s/pHit]')

subplot(2, 2, 3)
plot(vcoh, mean(AVcong_rtstar_all(:, 1:5)),'o-.' ); hold on
plot(vcoh, mean(AVcong_rtstar_all(:, 6:10)),'o-.' ); hold on
plot(vcoh, mean(AVcong_rtstar_all(:, 11:15)),'o-.' ); hold on
plot(vcoh, mean(AVcong_rtstar_all(:, 16:20)),'o-.' ); hold on
plot(vcoh, mean(AVcong_rtstar_all(:, 21:25)),'o-.' ); hold on
xlim([0 60]); ylim([0 3]);title('AV congruent trials');xlabel('Visual coherence in [%]');ylabel('RT* in [s/pHit]')
legend('A - 10%', 'A - 25%', 'A - 35%', 'A - 45%', 'A - 55%')

subplot(2, 2, 4)
plot(vcoh, mean(AVincong_rtstar_all(:, 1:5)),'o-.' ); hold on
plot(vcoh, mean(AVincong_rtstar_all(:, 6:10)),'o-.' ); hold on
plot(vcoh, mean(AVincong_rtstar_all(:, 11:15)),'o-.' ); hold on
plot(vcoh, mean(AVincong_rtstar_all(:, 16:20)),'o-.' ); hold on
plot(vcoh, mean(AVincong_rtstar_all(:, 21:25)),'o-.' ); hold on
xlim([0 60]); ylim([0 3]);title('AV incongruent trials');xlabel('Visual coherence in [%]');ylabel('RT* in [s/pHit]')
legend('A - 10%', 'A - 25%', 'A - 35%', 'A - 45%', 'A - 55%')

%
Anoise_rtstar_corr = Anoise_rtcorr./Anoise_acc;
Vnoise_rtstar_corr = Vnoise_rtcorr./Vnoise_acc;
AVcong_rtstar_corr = AVcong_rtcorr./AVcong_acc;
AVincong_rtstar_corr = AVincong_rtcorr./AVincong_acc;

figure;
suptitle('RT* computed across RTs from all trials')
subplot(2, 2, 1)
plot(acoh, mean(Anoise_rtstar_corr),'o-.' ); hold on
xlim([0 60]); ylim([0 3]);title('Auditory in Visual noise');xlabel('Auditory coherence in [%]');ylabel('RT* in [s/pHit]')

subplot(2, 2, 2)
plot(vcoh, mean(Vnoise_rtstar_corr),'o-.' ); hold on
xlim([0 60]); ylim([0 3]);title('Visual in Auditory noise');xlabel('Visual coherence in [%]');ylabel('RT* in [s/pHit]')

subplot(2, 2, 3)
plot(vcoh, mean(AVcong_rtstar_corr(:, 1:5)),'o-.' ); hold on
plot(vcoh, mean(AVcong_rtstar_corr(:, 6:10)),'o-.' ); hold on
plot(vcoh, mean(AVcong_rtstar_corr(:, 11:15)),'o-.' ); hold on
plot(vcoh, mean(AVcong_rtstar_corr(:, 16:20)),'o-.' ); hold on
plot(vcoh, mean(AVcong_rtstar_corr(:, 21:25)),'o-.' ); hold on
xlim([0 60]); ylim([0 3]);title('AV congruent trials');xlabel('Visual coherence in [%]');ylabel('RT* in [s/pHit]')
legend('A - 10%', 'A - 25%', 'A - 35%', 'A - 45%', 'A - 55%')

subplot(2, 2, 4)
plot(vcoh, mean(AVincong_rtstar_corr(:, 1:5)),'o-.' ); hold on
plot(vcoh, mean(AVincong_rtstar_corr(:, 6:10)),'o-.' ); hold on
plot(vcoh, mean(AVincong_rtstar_corr(:, 11:15)),'o-.' ); hold on
plot(vcoh, mean(AVincong_rtstar_corr(:, 16:20)),'o-.' ); hold on
plot(vcoh, mean(AVincong_rtstar_corr(:, 21:25)),'o-.' ); hold on
xlim([0 60]); ylim([0 3]);title('AV incongruent trials');xlabel('Visual coherence in [%]');ylabel('RT* in [s/pHit]')
legend('A - 10%', 'A - 25%', 'A - 35%', 'A - 45%', 'A - 55%')


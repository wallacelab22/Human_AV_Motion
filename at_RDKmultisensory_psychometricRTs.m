display('Please add Select a Folder & then the AV results')
% % get directory with data, then select data file to load
Dir = uigetdir; cd(Dir); load(uigetfile);
acoh=[10,25,35,45,55];
vcoh = [5, 15, 25, 35, 45];

auditoryonly=MAT(MAT(:, 4)==0, :);
visualonly=MAT(MAT(:, 2)==0, :);

for uu=1:5
    visual=visualonly(visualonly(:,4)==uu,:);
    auditory=auditoryonly(auditoryonly(:,2)==uu,:);
    RTvonly_all(uu) = nanmean(visual(:,6));
    RTaonly_all(uu) = length(find(auditory(:,1)==auditory(:,5)))/size(auditory,1);
end

subplot(2, 2, 1);plot(vcoh, RTvonly_all, 'o-'); xlim([0 60]); ylim([0 1.5]); title('VISUAL in auditory noise'); ylabel('RTs in [s]'); xlabel('Visual coherence level');
hold on;
subplot(2, 2, 2);plot(acoh, RTaonly_all, 'o-'); xlim([0 60]); ylim([0 1.5]); title('AUDITORY in visual noise'); ylabel('RTs in [s]'); xlabel('Auditory coherence level')
suptitle('All RTs (correct and incorrect choices)');

for au=1:5
    auditrials = MAT(MAT(:, 2)==au, :);
    avcongruent = auditrials(auditrials(:, 1) == auditrials(:, 3),:);
    avincongruent = auditrials(auditrials(:, 1) ~= auditrials(:, 3),:);
    
    for vi=1:5
        viscong=avcongruent(avcongruent(:,4)==vi,:);
        visincong=avincongruent(avincongruent(:,4)==vi,:);
        RTavcong_all(vi) = nanmean(viscong(:,6));
        RTavincong_all(vi) = nanmean(visincong(:,6));
    end
    
    hold on;
    subplot(2, 2, 3);plot(vcoh, RTavcong_all, 'o-.'); xlim([0 60]); ylim([0 1.5]); title('AV CONGRUENT'); ylabel('RTs in [s]'); xlabel('Visual coherence level');
    hold on;
    subplot(2, 2, 4);plot(vcoh, RTavincong_all, 'o-.'); xlim([0 60]); ylim([0 1.5]); title('AV INCONGRUENT'); ylabel('RTs in [s]'); xlabel('Visual coherence level')
end
legend('A - 10%', 'A - 25%', 'A - 35%', 'A - 45%', 'A - 55%')

figure;
auditoryonly=MAT(MAT(:, 4)==0, :);
visualonly=MAT(MAT(:, 2)==0, :);

for uu=1:5
    visual=visualonly(visualonly(:,4)==uu,:);
    auditory=auditoryonly(auditoryonly(:,2)==uu,:);
    RTvonly_corr(uu) = nanmean(visual(visual(:,3)==visual(:,5), 6));
    RTaonly_corr(uu) = nanmean(auditory(auditory(:,1)==auditory(:,5), 6));
end

subplot(2, 2, 1);plot(vcoh, RTvonly_corr, 'o-'); xlim([0 60]); ylim([0 1.5]); title('VISUAL in auditory noise'); ylabel('RTs in [s]'); xlabel('Visual coherence level');
hold on;
subplot(2, 2, 2);plot(acoh, RTaonly_corr, 'o-'); xlim([0 60]); ylim([0 1.5]); title('AUDITORY in visual noise'); ylabel('RTs in [s]'); xlabel('Auditory coherence level')
suptitle('RTs (correct trials only)');

for au=1:5
    auditrials = MAT(MAT(:, 2)==au, :);
    avcongruent = auditrials(auditrials(:, 1) == auditrials(:, 3),:);
    avincongruent = auditrials(auditrials(:, 1) ~= auditrials(:, 3),:);
    
    for vi=1:5
        viscong=avcongruent(avcongruent(:,4)==vi,:);
        visincong=avincongruent(avincongruent(:,4)==vi,:);
        RTavcong_corr(vi) = nanmean(viscong(viscong(:,3)==viscong(:,5), 6));
        RTavincong_corr(vi) = nanmean(visincong(visincong(:,3)==visincong(:,5), 6));
    end
    
    hold on;
    subplot(2, 2, 3);plot(vcoh, RTavcong_corr, 'o-.'); xlim([0 60]); ylim([0 1.5]); title('AV CONGRUENT'); ylabel('RTs in [s]'); xlabel('Visual coherence level');
    hold on;
    subplot(2, 2, 4);plot(vcoh, RTavincong_corr, 'o-.'); xlim([0 60]); ylim([0 1.5]); title('AV INCONGRUENT'); ylabel('RTs in [s]'); xlabel('Visual coherence level')
end
legend('A - 10%', 'A - 25%', 'A - 35%', 'A - 45%', 'A - 55%')
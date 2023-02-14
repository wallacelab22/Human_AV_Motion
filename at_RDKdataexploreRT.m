function MAT=at_RDKdataexploreRT(subject)
%% for data exploration

for ii=length(subject)
    at_RDKRT(subject);
    at_RDKRTstar(subject);
end

load('AuditoryRT.mat')
load('VisualRT.mat')
load('AVcRT.mat')
load('AViRT.mat')

%% Predicting Visual Bias - Congruent
figure; suptitle('Median RTs [sec]')
subplot(4,2,1)
scatter(VisualRT(:,1), AVcRT(:,1), 'filled'); hold on;
scatter(VisualRT(:,1), AVcRT(:,2), 'filled');
scatter(VisualRT(:,1), AVcRT(:,3), 'filled');
scatter(VisualRT(:,1), AVcRT(:,4), 'filled');
scatter(VisualRT(:,1), AVcRT(:,5), 'filled');

xlim([0 1]);ylim([0 1]);lsline
xlabel('Visual LOW coherence');ylabel('AVlow congruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

subplot(4,2,2)
scatter(VisualRT(:,2), AVcRT(:,6), 'filled'); hold on;
scatter(VisualRT(:,2), AVcRT(:,7), 'filled');
scatter(VisualRT(:,2), AVcRT(:,8), 'filled');
scatter(VisualRT(:,2), AVcRT(:,9), 'filled');
scatter(VisualRT(:,2), AVcRT(:,10), 'filled');

xlim([0 1]);ylim([0 1]);lsline
xlabel('Visual HIGH coherence');ylabel('AVhigh congruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

%% Predicting Visual Bias - Incongruent
subplot(4,2,3)
scatter(VisualRT(:,1), AViRT(:,1), 'filled'); hold on;
scatter(VisualRT(:,1), AViRT(:,2), 'filled');
scatter(VisualRT(:,1), AViRT(:,3), 'filled');
scatter(VisualRT(:,1), AViRT(:,4), 'filled');
scatter(VisualRT(:,1), AViRT(:,5), 'filled');

xlim([0 1]);ylim([0 1]);lsline
xlabel('Visual LOW coherence');ylabel('AVlow incongruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

subplot(4,2,4)
scatter(VisualRT(:,2), AViRT(:,6), 'filled'); hold on;
scatter(VisualRT(:,2), AViRT(:,7), 'filled');
scatter(VisualRT(:,2), AViRT(:,8), 'filled');
scatter(VisualRT(:,2), AViRT(:,9), 'filled');
scatter(VisualRT(:,2), AViRT(:,10), 'filled');

xlim([0 1]);ylim([0 1]);lsline
xlabel('Visual HIGH coherence');ylabel('AVhigh incongruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

%% Predicting Auditory Bias - Congruent
subplot(4,2,5)
scatter(AudioRT(:,1), AVcRT(:,1), 'filled'); hold on;
scatter(AudioRT(:,2), AVcRT(:,2), 'filled');
scatter(AudioRT(:,3), AVcRT(:,3), 'filled');
scatter(AudioRT(:,4), AVcRT(:,4), 'filled');
scatter(AudioRT(:,5), AVcRT(:,5), 'filled');

xlim([0 1]);ylim([0 1]);lsline
xlabel('Auditory-Only Performance');ylabel('AVlow congruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

subplot(4,2,6)
scatter(AudioRT(:,1), AVcRT(:,6), 'filled'); hold on;
scatter(AudioRT(:,2), AVcRT(:,7), 'filled');
scatter(AudioRT(:,3), AVcRT(:,8), 'filled');
scatter(AudioRT(:,4), AVcRT(:,9), 'filled');
scatter(AudioRT(:,5), AVcRT(:,10), 'filled');

xlim([0 1]);ylim([0 1]);lsline
xlabel('Auditory-Only Performance');ylabel('AVhigh congruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

%% Predicting Auditory Bias - Incongruent
subplot(4,2,7)
scatter(AudioRT(:,1), AViRT(:,1), 'filled'); hold on;
scatter(AudioRT(:,2), AViRT(:,2), 'filled');
scatter(AudioRT(:,3), AViRT(:,3), 'filled');
scatter(AudioRT(:,4), AViRT(:,4), 'filled');
scatter(AudioRT(:,5), AViRT(:,5), 'filled');

xlim([0 1]);ylim([0 1]);lsline
xlabel('Auditory-Only Performance');ylabel('AVlow incongruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

subplot(4,2,8)
scatter(AudioRT(:,1), AViRT(:,6), 'filled'); hold on;
scatter(AudioRT(:,2), AViRT(:,7), 'filled');
scatter(AudioRT(:,3), AViRT(:,8), 'filled');
scatter(AudioRT(:,4), AViRT(:,9), 'filled');
scatter(AudioRT(:,5), AViRT(:,10), 'filled');

xlim([0 1]);ylim([0 1]);lsline
xlabel('Auditory-Only Performance');ylabel('AVhigh incongruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

%% Predicting Visual Bias - Congruent STD
clearvars

load('AuditorySTD.mat')
load('VisualSTD.mat')
load('AVcSTD.mat')
load('AViSTD.mat')

figure; suptitle('STDs [sec]')
subplot(4,2,1)
scatter(VisualSTD(:,1), AVcSTD(:,1), 'filled'); hold on;
scatter(VisualSTD(:,1), AVcSTD(:,2), 'filled');
scatter(VisualSTD(:,1), AVcSTD(:,3), 'filled');
scatter(VisualSTD(:,1), AVcSTD(:,4), 'filled');
scatter(VisualSTD(:,1), AVcSTD(:,5), 'filled');

xlim([0 .5]);ylim([0 .5]);lsline
xlabel('Visual LOW coherence');ylabel('AVlow congruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

subplot(4,2,2)
scatter(VisualSTD(:,2), AVcSTD(:,6), 'filled'); hold on;
scatter(VisualSTD(:,2), AVcSTD(:,7), 'filled');
scatter(VisualSTD(:,2), AVcSTD(:,8), 'filled');
scatter(VisualSTD(:,2), AVcSTD(:,9), 'filled');
scatter(VisualSTD(:,2), AVcSTD(:,10), 'filled');

xlim([0 .5]);ylim([0 .5]);lsline
xlabel('Visual HIGH coherence');ylabel('AVhigh congruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

%% Predicting Visual Bias - Incongruent
subplot(4,2,3)
scatter(VisualSTD(:,1), AViSTD(:,1), 'filled'); hold on;
scatter(VisualSTD(:,1), AViSTD(:,2), 'filled');
scatter(VisualSTD(:,1), AViSTD(:,3), 'filled');
scatter(VisualSTD(:,1), AViSTD(:,4), 'filled');
scatter(VisualSTD(:,1), AViSTD(:,5), 'filled');

xlim([0 .5]);ylim([0 .5]);lsline
xlabel('Visual LOW coherence');ylabel('AVlow incongruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

subplot(4,2,4)
scatter(VisualSTD(:,2), AViSTD(:,6), 'filled'); hold on;
scatter(VisualSTD(:,2), AViSTD(:,7), 'filled');
scatter(VisualSTD(:,2), AViSTD(:,8), 'filled');
scatter(VisualSTD(:,2), AViSTD(:,9), 'filled');
scatter(VisualSTD(:,2), AViSTD(:,10), 'filled');

xlim([0 .5]);ylim([0 .5]);lsline
xlabel('Visual HIGH coherence');ylabel('AVhigh incongruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

%% Predicting Auditory Bias - Congruent
subplot(4,2,5)
scatter(AudioSTD(:,1), AVcSTD(:,1), 'filled'); hold on;
scatter(AudioSTD(:,2), AVcSTD(:,2), 'filled');
scatter(AudioSTD(:,3), AVcSTD(:,3), 'filled');
scatter(AudioSTD(:,4), AVcSTD(:,4), 'filled');
scatter(AudioSTD(:,5), AVcSTD(:,5), 'filled');

xlim([0 .5]);ylim([0 .5]);lsline
xlabel('Auditory-Only Performance');ylabel('AVlow congruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

subplot(4,2,6)
scatter(AudioSTD(:,1), AVcSTD(:,6), 'filled'); hold on;
scatter(AudioSTD(:,2), AVcSTD(:,7), 'filled');
scatter(AudioSTD(:,3), AVcSTD(:,8), 'filled');
scatter(AudioSTD(:,4), AVcSTD(:,9), 'filled');
scatter(AudioSTD(:,5), AVcSTD(:,10), 'filled');

xlim([0 .5]);ylim([0 .5]);lsline
xlabel('Auditory-Only Performance');ylabel('AVhigh congruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

%% Predicting Auditory Bias - Incongruent
subplot(4,2,7)
scatter(AudioSTD(:,1), AViSTD(:,1), 'filled'); hold on;
scatter(AudioSTD(:,2), AViSTD(:,2), 'filled');
scatter(AudioSTD(:,3), AViSTD(:,3), 'filled');
scatter(AudioSTD(:,4), AViSTD(:,4), 'filled');
scatter(AudioSTD(:,5), AViSTD(:,5), 'filled');

xlim([0 .5]);ylim([0 .5]);lsline
xlabel('Auditory-Only Performance');ylabel('AVlow incongruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

subplot(4,2,8)
scatter(AudioSTD(:,1), AViSTD(:,6), 'filled'); hold on;
scatter(AudioSTD(:,2), AViSTD(:,7), 'filled');
scatter(AudioSTD(:,3), AViSTD(:,8), 'filled');
scatter(AudioSTD(:,4), AViSTD(:,9), 'filled');
scatter(AudioSTD(:,5), AViSTD(:,10), 'filled');

xlim([0 .5]);ylim([0 .5]);lsline
xlabel('Auditory-Only Performance');ylabel('AVhigh incongruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');


%% Predicting Visual Bias - Congruent SEM
clearvars

load('AuditorySEM.mat')
load('VisualSEM.mat')
load('AVcSEM.mat')
load('AViSEM.mat')

figure; suptitle('SEMs [sec]')
subplot(4,2,1)
scatter(VisualSEM(:,1), AVcSEM(:,1), 'filled'); hold on;
scatter(VisualSEM(:,1), AVcSEM(:,2), 'filled');
scatter(VisualSEM(:,1), AVcSEM(:,3), 'filled');
scatter(VisualSEM(:,1), AVcSEM(:,4), 'filled');
scatter(VisualSEM(:,1), AVcSEM(:,5), 'filled');

xlim([0 .1]);ylim([0 .1]);lsline
xlabel('Visual LOW coherence');ylabel('AVlow congruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

subplot(4,2,2)
scatter(VisualSEM(:,2), AVcSEM(:,6), 'filled'); hold on;
scatter(VisualSEM(:,2), AVcSEM(:,7), 'filled');
scatter(VisualSEM(:,2), AVcSEM(:,8), 'filled');
scatter(VisualSEM(:,2), AVcSEM(:,9), 'filled');
scatter(VisualSEM(:,2), AVcSEM(:,10), 'filled');

xlim([0 .1]);ylim([0 .1]);lsline
xlabel('Visual HIGH coherence');ylabel('AVhigh congruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

%% Predicting Visual Bias - Incongruent
subplot(4,2,3)
scatter(VisualSEM(:,1), AViSEM(:,1), 'filled'); hold on;
scatter(VisualSEM(:,1), AViSEM(:,2), 'filled');
scatter(VisualSEM(:,1), AViSEM(:,3), 'filled');
scatter(VisualSEM(:,1), AViSEM(:,4), 'filled');
scatter(VisualSEM(:,1), AViSEM(:,5), 'filled');

xlim([0 .1]);ylim([0 .1]);lsline
xlabel('Visual LOW coherence');ylabel('AVlow incongruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

subplot(4,2,4)
scatter(VisualSEM(:,2), AViSEM(:,6), 'filled'); hold on;
scatter(VisualSEM(:,2), AViSEM(:,7), 'filled');
scatter(VisualSEM(:,2), AViSEM(:,8), 'filled');
scatter(VisualSEM(:,2), AViSEM(:,9), 'filled');
scatter(VisualSEM(:,2), AViSEM(:,10), 'filled');

xlim([0 .1]);ylim([0 .1]);lsline
xlabel('Visual HIGH coherence');ylabel('AVhigh incongruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

%% Predicting Auditory Bias - Congruent
subplot(4,2,5)
scatter(AudioSEM(:,1), AVcSEM(:,1), 'filled'); hold on;
scatter(AudioSEM(:,2), AVcSEM(:,2), 'filled');
scatter(AudioSEM(:,3), AVcSEM(:,3), 'filled');
scatter(AudioSEM(:,4), AVcSEM(:,4), 'filled');
scatter(AudioSEM(:,5), AVcSEM(:,5), 'filled');

xlim([0 .1]);ylim([0 .1]);lsline
xlabel('Auditory-Only Performance');ylabel('AVlow congruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

subplot(4,2,6)
scatter(AudioSEM(:,1), AVcSEM(:,6), 'filled'); hold on;
scatter(AudioSEM(:,2), AVcSEM(:,7), 'filled');
scatter(AudioSEM(:,3), AVcSEM(:,8), 'filled');
scatter(AudioSEM(:,4), AVcSEM(:,9), 'filled');
scatter(AudioSEM(:,5), AVcSEM(:,10), 'filled');

xlim([0 .1]);ylim([0 .1]);lsline
xlabel('Auditory-Only Performance');ylabel('AVhigh congruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

%% Predicting Auditory Bias - Incongruent
subplot(4,2,7)
scatter(AudioSEM(:,1), AViSEM(:,1), 'filled'); hold on;
scatter(AudioSEM(:,2), AViSEM(:,2), 'filled');
scatter(AudioSEM(:,3), AViSEM(:,3), 'filled');
scatter(AudioSEM(:,4), AViSEM(:,4), 'filled');
scatter(AudioSEM(:,5), AViSEM(:,5), 'filled');

xlim([0 .1]);ylim([0 .1]);lsline
xlabel('Auditory-Only Performance');ylabel('AVlow incongruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

subplot(4,2,8)
scatter(AudioSEM(:,1), AViSEM(:,6), 'filled'); hold on;
scatter(AudioSEM(:,2), AViSEM(:,7), 'filled');
scatter(AudioSEM(:,3), AViSEM(:,8), 'filled');
scatter(AudioSEM(:,4), AViSEM(:,9), 'filled');
scatter(AudioSEM(:,5), AViSEM(:,10), 'filled');

xlim([0 .1]);ylim([0 .1]);lsline
xlabel('Auditory-Only Performance');ylabel('AVhigh incongruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

%% Predicting Visual Bias - Congruent RTstar
clearvars

load('AuditoryRTstar.mat')
load('VisualRTstar.mat')
load('AVcRTstar.mat')
load('AViRTstar.mat')

figure; suptitle('RTstar [sec/pHit]')
subplot(4,2,1)
scatter(VisualRTstar(:,1), AVcRTstar(:,1), 'filled'); hold on;
scatter(VisualRTstar(:,1), AVcRTstar(:,2), 'filled');
scatter(VisualRTstar(:,1), AVcRTstar(:,3), 'filled');
scatter(VisualRTstar(:,1), AVcRTstar(:,4), 'filled');
scatter(VisualRTstar(:,1), AVcRTstar(:,5), 'filled');

xlim([0 3]);ylim([0 6]);lsline
xlabel('Visual LOW coherence');ylabel('AVlow congruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

subplot(4,2,2)
scatter(VisualRTstar(:,2), AVcRTstar(:,6), 'filled'); hold on;
scatter(VisualRTstar(:,2), AVcRTstar(:,7), 'filled');
scatter(VisualRTstar(:,2), AVcRTstar(:,8), 'filled');
scatter(VisualRTstar(:,2), AVcRTstar(:,9), 'filled');
scatter(VisualRTstar(:,2), AVcRTstar(:,10), 'filled');

xlim([0 3]);ylim([0 6]);lsline
xlabel('Visual HIGH coherence');ylabel('AVhigh congruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

%% Predicting Visual Bias - Incongruent
subplot(4,2,3)
scatter(VisualRTstar(:,1), AViRTstar(:,1), 'filled'); hold on;
scatter(VisualRTstar(:,1), AViRTstar(:,2), 'filled');
scatter(VisualRTstar(:,1), AViRTstar(:,3), 'filled');
scatter(VisualRTstar(:,1), AViRTstar(:,4), 'filled');
scatter(VisualRTstar(:,1), AViRTstar(:,5), 'filled');

xlim([0 3]);ylim([0 6]);lsline
xlabel('Visual LOW coherence');ylabel('AVlow incongruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

subplot(4,2,4)
scatter(VisualRTstar(:,2), AViRTstar(:,6), 'filled'); hold on;
scatter(VisualRTstar(:,2), AViRTstar(:,7), 'filled');
scatter(VisualRTstar(:,2), AViRTstar(:,8), 'filled');
scatter(VisualRTstar(:,2), AViRTstar(:,9), 'filled');
scatter(VisualRTstar(:,2), AViRTstar(:,10), 'filled');

xlim([0 3]);ylim([0 6]);lsline
xlabel('Visual HIGH coherence');ylabel('AVhigh incongruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

%% Predicting Auditory Bias - Congruent
subplot(4,2,5)
scatter(AudioRTstar(:,1), AVcRTstar(:,1), 'filled'); hold on;
scatter(AudioRTstar(:,2), AVcRTstar(:,2), 'filled');
scatter(AudioRTstar(:,3), AVcRTstar(:,3), 'filled');
scatter(AudioRTstar(:,4), AVcRTstar(:,4), 'filled');
scatter(AudioRTstar(:,5), AVcRTstar(:,5), 'filled');

xlim([0 3]);ylim([0 6]);lsline
xlabel('Auditory-Only Performance');ylabel('AVlow congruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

subplot(4,2,6)
scatter(AudioRTstar(:,1), AVcRTstar(:,6), 'filled'); hold on;
scatter(AudioRTstar(:,2), AVcRTstar(:,7), 'filled');
scatter(AudioRTstar(:,3), AVcRTstar(:,8), 'filled');
scatter(AudioRTstar(:,4), AVcRTstar(:,9), 'filled');
scatter(AudioRTstar(:,5), AVcRTstar(:,10), 'filled');

xlim([0 3]);ylim([0 6]);lsline
xlabel('Auditory-Only Performance');ylabel('AVhigh congruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

%% Predicting Auditory Bias - Incongruent
subplot(4,2,7)
scatter(AudioRTstar(:,1), AViRTstar(:,1), 'filled'); hold on;
scatter(AudioRTstar(:,2), AViRTstar(:,2), 'filled');
scatter(AudioRTstar(:,3), AViRTstar(:,3), 'filled');
scatter(AudioRTstar(:,4), AViRTstar(:,4), 'filled');
scatter(AudioRTstar(:,5), AViRTstar(:,5), 'filled');

xlim([0 3]);ylim([0 6]);lsline
xlabel('Auditory-Only Performance');ylabel('AVlow incongruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

subplot(4,2,8)
scatter(AudioRTstar(:,1), AViRTstar(:,6), 'filled'); hold on;
scatter(AudioRTstar(:,2), AViRTstar(:,7), 'filled');
scatter(AudioRTstar(:,3), AViRTstar(:,8), 'filled');
scatter(AudioRTstar(:,4), AViRTstar(:,9), 'filled');
scatter(AudioRTstar(:,5), AViRTstar(:,10), 'filled');

xlim([0 3]);ylim([0 6]);lsline
xlabel('Auditory-Only Performance');ylabel('AVhigh incongruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');
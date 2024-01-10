function MAT=at_RDKdataexploreUnisensory(subject)
%% for data exploration
for ii=length(subject)
    at_RDKUnisensory_plot(subject)
end

load('Bias_aud.mat')
load('Bias_vis.mat')
load('Visual_aud.mat')
load('Visual_vis.mat')
load('Auditory_aud.mat')
load('Auditory_vis.mat')
load('AVc_aud.mat')
load('AVc_vis.mat')
load('AVi_aud.mat')
load('AVi_vis.mat')

%% Predicting Visual Bias - Congruent
figure; suptitle('Reported Direction [Attend to VISION block]')
subplot(4,2,1)
for aa=1:5
scatter(Visual_vis(:,1), AVc_vis(:,aa), 'filled'); hold on;
[r,m,b]=regression(Visual_vis(:,1), AVc_vis(:,aa), 'one');
end
xlim([0 1]);ylim([0 1]);lsline

xlabel('Visual LOW coherence');ylabel('AVlow congruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

subplot(4,2,2)
for aa=6:10
scatter(Visual_vis(:,2), AVc_vis(:,aa), 'filled'); hold on;
[r,m,b]=regression(Visual_vis(:,2), AVc_vis(:,aa), 'one');
end
xlim([0 1]);ylim([0 1]);lsline
xlabel('Visual HIGH coherence');ylabel('AVhigh congruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

%% Predicting Visual Bias - Incongruent
subplot(4,2,3)
for av=1:5
scatter(Visual_vis(:,1), AVi_vis(:,av), 'filled'); hold on;
[r,m,b]=regression(Visual_vis(:,1), AVi_vis(:,av), 'one');
end
xlim([0 1]);ylim([0 1]);lsline
xlabel('Visual LOW coherence');ylabel('AVlow incongruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

subplot(4,2,4)
for av=6:10
scatter(Visual_vis(:,2), AVi_vis(:,av), 'filled'); hold on;
[r,m,b]=regression(Visual_vis(:,2), AVi_vis(:,av), 'one');
end

xlim([0 1]);ylim([0 1]);lsline
xlabel('Visual HIGH coherence');ylabel('AVhigh incongruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

%% Predicting Auditory Bias - Congruent
subplot(4,2,5)
for aa=1:5
scatter(Audio_vis(:,aa), AVc_vis(:,aa), 'filled'); hold on;
[r,m,b]=regression(Audio_vis(:,aa), AVc_vis(:,aa), 'one');
end
xlim([0 1]);ylim([0 1]);lsline
xlabel('Auditory-Only Performance');ylabel('AVlow congruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

subplot(4,2,6)
scatter(Audio_vis(:,1), AVc_vis(:,6), 'filled'); hold on;
scatter(Audio_vis(:,2), AVc_vis(:,7), 'filled');
scatter(Audio_vis(:,3), AVc_vis(:,8), 'filled');
scatter(Audio_vis(:,4), AVc_vis(:,9), 'filled');
scatter(Audio_vis(:,5), AVc_vis(:,10), 'filled');

xlim([0 1]);ylim([0 1]);lsline
xlabel('Auditory-Only Performance');ylabel('AVhigh congruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

%% Predicting Auditory Bias - Incongruent
subplot(4,2,7)
for aa=1:5
scatter(Audio_vis(:,aa), AVi_vis(:,aa), 'filled'); hold on;
[r,m,b]=regression(Audio_vis(:,aa), AVi_vis(:,aa), 'one');
end

xlim([0 1]);ylim([0 1]);lsline
xlabel('Auditory-Only Performance');ylabel('AVlow incongruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

subplot(4,2,8)
scatter(Audio_vis(:,1), AVi_vis(:,6), 'filled'); hold on;
scatter(Audio_vis(:,2), AVi_vis(:,7), 'filled');
scatter(Audio_vis(:,3), AVi_vis(:,8), 'filled');
scatter(Audio_vis(:,4), AVi_vis(:,9), 'filled');
scatter(Audio_vis(:,5), AVi_vis(:,10), 'filled');

xlim([0 1]);ylim([0 1]);lsline
xlabel('Auditory-Only Performance');ylabel('AVhigh incongruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

%% Predicting Visual Bias - Congruent
figure; suptitle('Reported Direction [Attend to AUDITION block]')
subplot(4,2,1)
for aa=1:5
scatter(Visual_aud(:,1), AVc_aud(:,aa), 'filled'); hold on;
[r,m,b]=regression(Visual_aud(:,1), AVc_aud(:,aa), 'one');
end
xlim([0 1]);ylim([0 1]);lsline

xlabel('Visual LOW coherence');ylabel('AVlow congruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

subplot(4,2,2)
for aa=6:10
scatter(Visual_aud(:,2), AVc_aud(:,aa), 'filled'); hold on;
[r,m,b]=regression(Visual_aud(:,2), AVc_aud(:,aa), 'one');
end
xlim([0 1]);ylim([0 1]);lsline
xlabel('Visual HIGH coherence');ylabel('AVhigh congruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

%% Predicting Visual Bias - Incongruent
subplot(4,2,3)
for av=1:5
scatter(Visual_aud(:,1), AVi_aud(:,av), 'filled'); hold on;
[r,m,b]=regression(Visual_aud(:,1), AVi_aud(:,av), 'one');
end
xlim([0 1]);ylim([0 1]);lsline
xlabel('Visual LOW coherence');ylabel('AVlow incongruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

subplot(4,2,4)
for av=6:10
scatter(Visual_aud(:,2), AVi_aud(:,av), 'filled'); hold on;
[r,m,b]=regression(Visual_aud(:,2), AVi_aud(:,av), 'one');
end

xlim([0 1]);ylim([0 1]);lsline
xlabel('Visual HIGH coherence');ylabel('AVhigh incongruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

%% Predicting Auditory Bias - Congruent
subplot(4,2,5)
for aa=1:5
scatter(Audio_aud(:,aa), AVc_aud(:,aa), 'filled'); hold on;
[r,m,b]=regression(Audio_aud(:,aa), AVc_aud(:,aa), 'one');
end
xlim([0 1]);ylim([0 1]);lsline
xlabel('Auditory-Only Performance');ylabel('AVlow congruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

subplot(4,2,6)
scatter(Audio_aud(:,1), AVc_aud(:,6), 'filled'); hold on;
scatter(Audio_aud(:,2), AVc_aud(:,7), 'filled');
scatter(Audio_aud(:,3), AVc_aud(:,8), 'filled');
scatter(Audio_aud(:,4), AVc_aud(:,9), 'filled');
scatter(Audio_aud(:,5), AVc_aud(:,10), 'filled');

xlim([0 1]);ylim([0 1]);lsline
xlabel('Auditory-Only Performance');ylabel('AVhigh congruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

%% Predicting Auditory Bias - Incongruent
subplot(4,2,7)
for aa=1:5
scatter(Audio_aud(:,aa), AVi_aud(:,aa), 'filled'); hold on;
[r,m,b]=regression(Audio_aud(:,aa), AVi_aud(:,aa), 'one');
end

xlim([0 1]);ylim([0 1]);lsline
xlabel('Auditory-Only Performance');ylabel('AVlow incongruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

subplot(4,2,8)
scatter(Audio_aud(:,1), AVi_aud(:,6), 'filled'); hold on;
scatter(Audio_aud(:,2), AVi_aud(:,7), 'filled');
scatter(Audio_aud(:,3), AVi_aud(:,8), 'filled');
scatter(Audio_aud(:,4), AVi_aud(:,9), 'filled');
scatter(Audio_aud(:,5), AVi_aud(:,10), 'filled');

xlim([0 1]);ylim([0 1]);lsline
xlabel('Auditory-Only Performance');ylabel('AVhigh incongruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

%% Predicting Crossmodal Bias - Unisensory
figure; suptitle('Reported Direction [CROSSMODAL Predictions]')
subplot(3,2,1)
for aa=1:2
scatter(Visual_vis(:,aa), Visual_aud(:,aa), 'filled'); hold on;
[r,m,b]=regression(Visual_vis(:,aa), Visual_aud(:,aa), 'one');
end
xlim([0 1]);ylim([0 1]);lsline

xlabel('Attend VISION');ylabel('Attend Audition');
legend('V-6%','V-60%', 'Location', 'northwest');
title('Visual only trials')

subplot(3,2,2)
for aa=1:5
scatter(Audio_vis(:,aa), Audio_aud(:,aa), 'filled'); hold on;
[r,m,b]=regression(Audio_vis(:,aa), Audio_aud(:,aa), 'one');
end
xlim([0 1]);ylim([0 1]);lsline
xlabel('Attend VISION');ylabel('Attend AUDITION');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');
title('Auditory only trials')

%% Predicting Crossmodal Bias - Congruent
subplot(3,2,3)
for av=1:5
scatter(AVc_vis(:,av), AVc_aud(:,av), 'filled'); hold on;
[r,m,b]=regression(AVc_vis(:,av), AVc_aud(:,av), 'one');
end
xlim([0 1]);ylim([0 1]);lsline
xlabel('Attend VISION');ylabel('Attend AUDITION');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');
title('AVlow congruent only trials')

subplot(3,2,5)
for av=6:10
scatter(AVc_vis(:,av), AVc_aud(:,av), 'filled'); hold on;
[r,m,b]=regression(AVc_vis(:,av), AVc_aud(:,av), 'one');
end
xlim([0 1]);ylim([0 1]);lsline
xlabel('Attend VISION');ylabel('Attend AUDITION');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');
title('AVhigh congruent only trials')

%% Predicting Crossmodal Bias - Incongruent
subplot(3,2,4)
for av=1:5
scatter(AVi_vis(:,av), AVi_aud(:,av), 'filled'); hold on;
[r,m,b]=regression(AVi_vis(:,av), AVi_aud(:,av), 'one');
end
xlim([0 1]);ylim([0 1]);lsline
xlabel('Attend VISION');ylabel('Attend AUDITION');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');
title('AVlow incongruent only trials')

subplot(3,2,6)
for av=6:10
scatter(AVi_vis(:,av), AVi_aud(:,av), 'filled'); hold on;
[r,m,b]=regression(AVi_vis(:,av), AVi_aud(:,av), 'one');
end
xlim([0 1]);ylim([0 1]);lsline
xlabel('Attend VISION');ylabel('Attend AUDITION');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');
title('AVhigh incongruent only trials')

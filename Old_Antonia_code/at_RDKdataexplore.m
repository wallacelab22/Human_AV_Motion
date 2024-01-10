function MAT=at_RDKdataexplore(subject)
%% for data exploration
for ii=length(subject)
    at_RDK(subject)
end

load('Bias.mat')
load('Auditory.mat')
load('Visual.mat')
load('AVc.mat')
load('AVi.mat')

%% Predicting Visual Bias - Congruent
figure; suptitle('Reported Direction [pHit upon Unisensory]')
subplot(4,2,1)
for aa=1:5
scatter(Visual(:,1), AVc(:,aa), 'filled'); hold on;
[r,m,b]=regression(Visual(:,1), AVc(:,aa), 'one');
end
xlim([0 1]);ylim([0 1]);lsline

xlabel('Visual LOW coherence');ylabel('AVlow congruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

subplot(4,2,2)
for aa=6:10
scatter(Visual(:,2), AVc(:,aa), 'filled'); hold on;
[r,m,b]=regression(Visual(:,2), AVc(:,aa), 'one');
end
xlim([0 1]);ylim([0 1]);lsline
xlabel('Visual HIGH coherence');ylabel('AVhigh congruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

%% Predicting Visual Bias - Incongruent
subplot(4,2,3)
for av=1:5
scatter(Visual(:,1), AVi(:,av), 'filled'); hold on;
[r,m,b]=regression(Visual(:,1), AVi(:,av), 'one');
end
xlim([0 1]);ylim([0 1]);lsline
xlabel('Visual LOW coherence');ylabel('AVlow incongruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

subplot(4,2,4)
for av=6:10
scatter(Visual(:,2), AVi(:,av), 'filled'); hold on;
[r,m,b]=regression(Visual(:,2), AVi(:,av), 'one');
end

xlim([0 1]);ylim([0 1]);lsline
xlabel('Visual HIGH coherence');ylabel('AVhigh incongruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

%% Predicting Auditory Bias - Congruent
subplot(4,2,5)
for aa=1:5
scatter(Audio(:,aa), AVc(:,aa), 'filled'); hold on;
[r,m,b]=regression(Audio(:,aa), AVc(:,aa), 'one');
end
xlim([0 1]);ylim([0 1]);lsline
xlabel('Auditory-Only Performance');ylabel('AVlow congruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

subplot(4,2,6)
scatter(Audio(:,1), AVc(:,6), 'filled'); hold on;
scatter(Audio(:,2), AVc(:,7), 'filled');
scatter(Audio(:,3), AVc(:,8), 'filled');
scatter(Audio(:,4), AVc(:,9), 'filled');
scatter(Audio(:,5), AVc(:,10), 'filled');

xlim([0 1]);ylim([0 1]);lsline
xlabel('Auditory-Only Performance');ylabel('AVhigh congruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

%% Predicting Auditory Bias - Incongruent
subplot(4,2,7)
for aa=1:5
scatter(Audio(:,aa), AVi(:,aa), 'filled'); hold on;
[r,m,b]=regression(Audio(:,aa), AVi(:,aa), 'one');
end

xlim([0 1]);ylim([0 1]);lsline
xlabel('Auditory-Only Performance');ylabel('AVlow incongruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');

subplot(4,2,8)
scatter(Audio(:,1), AVi(:,6), 'filled'); hold on;
scatter(Audio(:,2), AVi(:,7), 'filled');
scatter(Audio(:,3), AVi(:,8), 'filled');
scatter(Audio(:,4), AVi(:,9), 'filled');
scatter(Audio(:,5), AVi(:,10), 'filled');

xlim([0 1]);ylim([0 1]);lsline
xlabel('Auditory-Only Performance');ylabel('AVhigh incongruent');
legend('A-5%','A-10%','A-20%', 'A-30%','A-40%', 'Location', 'northwest');


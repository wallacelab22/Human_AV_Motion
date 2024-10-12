%% Group 15, 16 Group Data Analysis
clear;
close all;
clc;

% Set initial variables
msize=100; lw=1.5;

groupData = readtable('group_perf_data.xlsx', 'Sheet', 'Sheet2');

thresAud = [0.125 0.177 0.25 0.177 0.177 0.062 0.125 0.044 0.707 0.177 0.177 0.088 0.354 0.177 0.177 0.177 0.062 0.177 0.031 0.177];
thresVis = [0.125 0.044 0.088 0.125 0.125 0.088 0.25 0.031 0.354 0.088 0.125 0.354 0.088 0.044 0.022 0.5 0.088 0.177 0.125 0.5]; 

figure;
scatter(thresAud, thresVis, msize, 'filled', 'Color', 'c', 'LineWidth', lw); hold on;
xline = linspace(min(0), max(0.5), 100);
yline = xline;
plot(xline, yline, '--', 'Color', 'k', 'LineWidth', lw);
hold off;

title('Group Coherence Thresholds');
legend('Participant','Stimulus Matched');
xlabel('Auditory Coherence'); ylabel('Visual Coherence');
axis([0 0.5  0 0.5]);
box off;
beautifyplot;

data = [0.5	0.875	0.908333	0.908333	0.908333
0.825	0.7	0.775	0.95	0.75
0.95	0.725	0.825	0.875	0.775
0.825	0.725	0.825	0.9	0.9
0.425	0.4	0.525	0.6	0.65
0.575	0.675	0.55	0.425	0.65
0.625	0.65	0.65	0.575	0.925
0.45	0.4	0.6	0.625	0.6
0.9	1	0.9	1	0.975
0.675	0.825	0.8	1	0.75
0.725	0.875	0.775	0.725	0.65
0.625	0.45	0.55	0.5	0.55
0.9	0.5	0.625	1	0.425
0.9	0.575	0.475	0.925	0.475
0.925	0.6	0.8	0.9	0.55
0.675	0.8	0.85	0.55	0.85
0.55	0.775	0.675	0.675	0.625
0.875	0.775	0.658333333	0.658333333	0.658333333
0.5	0.925	0.9	0.5	0.85
0.775	0.95	0.95	0.675	1];

conditions = {'AO', 'VO', 'Perf_AV', 'Stim_Av', 'Stim_aV'};

figure;
h = boxplot(data, 'Labels', conditions);

% Color the boxes
set(h, {'linew'}, {2});
colors = {'g', 'y', 'm', 'b', 'r'}; % Red for AUD, Blue for VIS
h = findobj(gca, 'Tag', 'Box');
for j = 1:length(h)
   patch(get(h(j), 'XData'), get(h(j), 'YData'), colors{j}, 'FaceAlpha', 0.5);
end

% Customize the plot
ylabel('Accuracy');
ylim([0 1])
xlabel('Condition');
title('Boxplots of Accuracy Across Conditions');
beautifyplot;

Uni_acc = data(:, 1:2);
gain = zeros(length(Uni_acc), 1);
for i = 1:length(data)
    best_uni_acc = max(data(i,1), data(i,2));
    av_acc = data(i,3);
    gain(i) = (av_acc - best_uni_acc)/av_acc;
    %gain(i) = av_acc - best_uni_acc;
end

data = [data(:,1), data(:,2), data(:,3), gain];

conditions = {'AO', 'VO', 'Perf_AV', 'MS_Gain'};

figure;
h = boxplot(data, 'Labels', conditions);

% Color the boxes
set(h, {'linew'}, {2});
colors = {'g', 'm', 'b', 'r'}; % Red for AUD, Blue for VIS
h = findobj(gca, 'Tag', 'Box');
for j = 1:length(h)
   patch(get(h(j), 'XData'), get(h(j), 'YData'), colors{j}, 'FaceAlpha', 0.5);
end

% Customize the plot
ylabel('Accuracy');
ylim([-1 1])
xlabel('Condition');
title('Boxplots of Accuracy with Gain');
beautifyplot;

data = [0.035907	0.014528
0.079817	0.81416
0.042016	0.079253
0.0661	0.092576
0.019843	0.024058
0.0261484	0.052531
0.041346	0.24962
0.020267	0.015876
0.050925	0.058685
0.028741	0.043864
0.035485	0.45577
0.032033	0.0168665
0.03676	0.18423
0.030345	0.17786
0.053218	0.047216
0.024436	0.04554
0.035991	0.18683
0.022856	0.031914];

conditions = {'AO STD', 'VO STD'};

figure;
h = boxplot(data, 'Labels', conditions);

% Color the boxes
set(h, {'linew'}, {2});
colors = {'b', 'r'}; % Red for AUD, Blue for VIS
h = findobj(gca, 'Tag', 'Box');
for j = 1:length(h)
   patch(get(h(j), 'XData'), get(h(j), 'YData'), colors{j}, 'FaceAlpha', 0.5);
end

% Customize the plot
ylabel('STD');
xlabel('Condition');
title('Boxplots of STD Across Conditions');
beautifyplot;

data = [0.5	0.875	0.908333	0.908333	0.908333	0.425	0.9
0.825	0.7	0.775	0.95	0.75	0.55	0.75
0.95	0.725	0.825	0.875	0.775	0.85	0.675
0.825	0.725	0.825	0.9	0.9	0.65	0.85
0.425	0.4	0.525	0.6	0.65	0.55	0.5
0.575	0.675	0.55	0.425	0.65	0.475	0.525
0.625	0.65	0.65	0.575	0.925	0.55	0.675
0.45	0.4	0.6	0.625	0.6	0.475	0.55
0.9	1	0.9	1	0.975	0.6	0.95
0.675	0.825	0.8	1	0.75	0.5	0.875
0.725	0.875	0.775	0.725	0.65	0.575	0.675];

conditions = {'AO', 'VO', 'Perf_AV', 'Stim_Av', 'Stim_aV', 'A_Vnoise', 'V_Anoise'};

figure;
h = boxplot(data, 'Labels', conditions);

% Color the boxes
set(h, {'linew'}, {2});
colors = {'c', 'g', 'k', 'y', 'm', 'b', 'r'}; % Red for AUD, Blue for VIS
h = findobj(gca, 'Tag', 'Box');
for j = 1:length(h)
   patch(get(h(j), 'XData'), get(h(j), 'YData'), colors{j}, 'FaceAlpha', 0.5);
end

% Customize the plot
ylabel('Accuracy');
ylim([0 1])
xlabel('Condition');
title('Boxplots of Accuracy Across Conditions');
beautifyplot;


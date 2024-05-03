%% Prior Trial History Analysis
clc
clear;
close all;

%% Load the data
script_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/data_analysis/'; 
data_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/data/';

%% Load the experimental data

subjnum = input('Enter the subject''s number: ');
subjnum_s = num2str(subjnum);
if length(subjnum_s) < 2
    subjnum_s = strcat(['0' subjnum_s]);
end
group = input('Enter the subject''s group: ');
group_s=num2str(group);
if length(group_s) < 2
    group_s = strcat(['0' group_s]);
end
sex = input('Enter the subject''s sex (1 = female; 2 = male): ');
sex_s=num2str(sex);
if length(sex_s) < 2
    sex_s = strcat(['0' sex_s]);
end
age = input('Enter the subject''s age: ');
age_s=num2str(age);
if length(age_s) < 2
    age_s = strcat(['0' age_s]);
end

cd(data_file_directory)
psyAV_filename = sprintf('RDKHoop_psyAV_%s_%s_%s_%s.mat', subjnum_s, group_s, sex_s, age_s);
load(psyAV_filename)
cd(script_file_directory)

%% Create coherences

% Find unique coherence values (excluding zeros which represent no stimulus)
uniqueCoherences = unique(data_output(data_output(:,2) > 0, 2));
if length(uniqueCoherences) > 2
    error('More than two unique coherence levels found.');
end

% Auditory perf coherence
coherence1 = mode(data_output(:,2));
% Visual perf coherence
coherence2 = mode(data_output(:,4));

%% Find audiovisual performance matched trials that come after a certain trial type 

%Find all AV performance match trials
idx = data_output(:,2) == coherence1 & data_output(:,4) == coherence2;
AVP_trials = data_output(idx, :);

%Creating matrix with trials after auditory only trials
AO_indices = find(data_output(:,2) == coherence1 & isnan(data_output(:,4)));
row_afterAO_indices = max(AO_indices + 1, 1);
afterAO = data_output(row_afterAO_indices, :);

AVP_indices = find(afterAO(:,2) == coherence1 & afterAO(:,4) == coherence2);
AVP_afterAO = afterAO(AVP_indices, :);

%Creating matrix with trials after visual only trials
VO_indices = find(data_output(:,4) == coherence2 & isnan(data_output(:,2)));
row_afterVO_indices = max(VO_indices + 1, 1);
afterVO = data_output(row_afterVO_indices, :);

AVP_indices = find(afterVO(:,2) == coherence1 & afterVO(:,4) == coherence2);
AVP_afterVO = afterVO(AVP_indices, :);

%Creating matrix with trials after catch trials
catch_indices = find(data_output(:,2) == 0 & data_output(:,4) == 0);
row_afterCatch_indices = max(catch_indices + 1, 1);
afterCatch = data_output(row_afterCatch_indices, :);

AVP_indices = find(afterCatch(:,2) == coherence1 & afterCatch(:,4) == coherence2);
AVP_afterCatch = afterCatch(AVP_indices, :);

%% Calculate accuracy 

% For all AV performance matched trials 
correctAVP = sum(AVP_trials(:,8) == 1);
totalAVP = height(AVP_trials);
accuracyAVP = correctAVP / totalAVP;

% For all AVP trials after AO trials 
correctAVP_AO = sum(AVP_afterAO(:,8) == 1);
totalAVP_AO = height(AVP_afterAO);
accuracyAVP_AO = correctAVP_AO / totalAVP_AO;

% For all AVP trials after VO trials 
correctAVP_VO = sum(AVP_afterVO(:,8) == 1);
totalAVP_VO = height(AVP_afterVO);
accuracyAVP_VO = correctAVP_VO / totalAVP_VO;

% For all AVP trials after catch trials 
correctAVP_catch = sum(AVP_afterCatch(:,8) == 1);
totalAVP_catch = height(AVP_afterCatch);
accuracyAVP_catch = correctAVP_catch / totalAVP_catch;


%% Create histogram

% Define the categories and accuracies
categories = {'AVP after Catch', 'AVP after VO', 'AVP after AO', 'All AVP Trials'};
accuracies = [accuracyAVP_catch, accuracyAVP_VO, accuracyAVP_AO, accuracyAVP];

% Create a bar graph
figure;
bar(accuracies);

% Set the x-axis labels
xticklabels(categories);

% Set axis labels and title
xlabel('Categories');
ylim([0 1])
ylabel('Accuracy');
title('Accuracy for Different Trial Categories');

% Display the values on top of the bars
text(1:length(categories), accuracies, num2str(accuracies', '%0.2f'), ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');

% Display the plot
grid off;

beautifyplot;




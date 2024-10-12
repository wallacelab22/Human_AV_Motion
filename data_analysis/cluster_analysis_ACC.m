%% Clustering Analysis for Data %%%%%%%%
close all;
clear;
clc;

data_file_directory = "/Users/a.tiesman/Documents/Research/Human_AV_Motion/data";

% Define the Excel file and sheet name
fileName = 'group_perf_data.xlsx';
sheetName = 'data_to_analyze';

% Define the participant ID information
range = 'A:D';

% Use readtable to read the data
data_to_load = readtable(fileName, 'Sheet', sheetName, 'Range', range);

% Convert the table to an array if needed
data_to_load = table2array(data_to_load);

includeAV = 0;
allData = loadParticipantData(data_to_load, data_file_directory, includeAV);

% Remove empty rows in allData
allData = allData(~cellfun(@(x) isempty(x), allData(:,1)) & ~cellfun(@(x) isempty(x), allData(:,2)), :);

%% Separate Clustering for Auditory and Visual Blocks
% Initialize structures to hold aggregated accuracy data
aggregatedData_auditory_rightward = [];
aggregatedData_auditory_leftward = [];
aggregatedData_visual_rightward = [];
aggregatedData_visual_leftward = [];

for i = 1:size(allData, 1)
    % Get auditory and visual data separately
    auditoryData = allData{i, 1};
    visualData = allData{i, 2};
    
    % Filter out rows where coherence is 0 or greater than 0.5
    auditoryData = auditoryData(auditoryData(:, 2) > 0 & auditoryData(:, 2) <= 0.5, :);
    visualData = visualData(visualData(:, 2) > 0 & visualData(:, 2) <= 0.5, :);
    
    % Find unique coherence levels
    uniqueCoherences_auditory = unique(auditoryData(:, 2));
    uniqueCoherences_visual = unique(visualData(:, 2));
    
    for j = 1:length(uniqueCoherences_auditory)
        coherenceLevel = uniqueCoherences_auditory(j);
        
        % Separate trials based on direction (1 = right, 2 = left) for auditory
        rightwardTrials_auditory = auditoryData(auditoryData(:, 1) == 1 & auditoryData(:, 2) == coherenceLevel, :);
        leftwardTrials_auditory = auditoryData(auditoryData(:, 1) == 2 & auditoryData(:, 2) == coherenceLevel, :);
        
        % Calculate accuracy for rightward and leftward trials (auditory)
        accuracy_right_auditory = mean(rightwardTrials_auditory(:, 6));  % Column 6 is the accuracy (0 or 1)
        accuracy_left_auditory = mean(leftwardTrials_auditory(:, 6));    % Column 6 is the accuracy (0 or 1)
        
        % Append to aggregated data (auditory)
        aggregatedData_auditory_rightward = [aggregatedData_auditory_rightward; coherenceLevel, accuracy_right_auditory];
        aggregatedData_auditory_leftward = [aggregatedData_auditory_leftward; coherenceLevel, accuracy_left_auditory];
    end
    
    for j = 1:length(uniqueCoherences_visual)
        coherenceLevel = uniqueCoherences_visual(j);
        
        % Separate trials based on direction (1 = right, 2 = left) for visual
        rightwardTrials_visual = visualData(visualData(:, 1) == 1 & visualData(:, 2) == coherenceLevel, :);
        leftwardTrials_visual = visualData(visualData(:, 1) == 2 & visualData(:, 2) == coherenceLevel, :);
        
        % Calculate accuracy for rightward and leftward trials (visual)
        accuracy_right_visual = mean(rightwardTrials_visual(:, 6));  % Column 6 is the accuracy (0 or 1)
        accuracy_left_visual = mean(leftwardTrials_visual(:, 6));    % Column 6 is the accuracy (0 or 1)
        
        % Append to aggregated data (visual)
        aggregatedData_visual_rightward = [aggregatedData_visual_rightward; coherenceLevel, accuracy_right_visual];
        aggregatedData_visual_leftward = [aggregatedData_visual_leftward; coherenceLevel, accuracy_left_visual];
    end
end

%% Clustering for Auditory Rightward Trials
clusteringData_auditory_rightward = aggregatedData_auditory_rightward;

% Determine the number of clusters using the elbow method
maxClusters = 10;
wcss = zeros(1, maxClusters);

for k = 1:maxClusters
    [~, ~, sumd] = kmeans(clusteringData_auditory_rightward, k, 'Replicates', 10);
    wcss(k) = sum(sumd);
end

% Plot the elbow curve for auditory rightward trials
figure;
plot(1:maxClusters, wcss, '-o');
xlabel('Number of Clusters');
ylabel('Within-Cluster Sum of Squares (WCSS)');
title('Elbow Method for Optimal k (Auditory Rightward Trials)');

% Choose the optimal number of clusters
optimalK_auditory_rightward = 4;  % Adjust this based on the elbow method plot

% Perform k-means clustering
[idx_auditory_rightward, centroids_auditory_rightward] = kmeans(clusteringData_auditory_rightward, optimalK_auditory_rightward, 'Replicates', 10);

% Visualize the clusters
figure;
gscatter(clusteringData_auditory_rightward(:,1), clusteringData_auditory_rightward(:,2), idx_auditory_rightward);
hold on;
plot(centroids_auditory_rightward(:,1), centroids_auditory_rightward(:,2), 'kx', 'MarkerSize', 15, 'LineWidth', 3);
xlabel('Coherence');
ylabel('Accuracy');
title('Cluster Assignments and Centroids (Auditory Rightward Trials)');
legend('Cluster 1', 'Cluster 2', 'Cluster 3', 'Centroids');

% Analyze the clusters
for k = 1:optimalK_auditory_rightward
    clusterData = clusteringData_auditory_rightward(idx_auditory_rightward == k, :);
    clusterMean = mean(clusterData);
    fprintf('Auditory Rightward Cluster %d mean coherence: %f, mean accuracy: %f\n', k, clusterMean(1), clusterMean(2));
end

%% Clustering for Auditory Leftward Trials
clusteringData_auditory_leftward = aggregatedData_auditory_leftward;

% Determine the number of clusters using the elbow method
wcss = zeros(1, maxClusters);

for k = 1:maxClusters
    [~, ~, sumd] = kmeans(clusteringData_auditory_leftward, k, 'Replicates', 10);
    wcss(k) = sum(sumd);
end

% Plot the elbow curve for auditory leftward trials
figure;
plot(1:maxClusters, wcss, '-o');
xlabel('Number of Clusters');
ylabel('Within-Cluster Sum of Squares (WCSS)');
title('Elbow Method for Optimal k (Auditory Leftward Trials)');

% Choose the optimal number of clusters
optimalK_auditory_leftward = 4;  % Adjust this based on the elbow method plot

% Perform k-means clustering
[idx_auditory_leftward, centroids_auditory_leftward] = kmeans(clusteringData_auditory_leftward, optimalK_auditory_leftward, 'Replicates', 10);

% Visualize the clusters
figure;
gscatter(clusteringData_auditory_leftward(:,1), clusteringData_auditory_leftward(:,2), idx_auditory_leftward);
hold on;
plot(centroids_auditory_leftward(:,1), centroids_auditory_leftward(:,2), 'kx', 'MarkerSize', 15, 'LineWidth', 3);
xlabel('Coherence');
ylabel('Accuracy');
title('Cluster Assignments and Centroids (Auditory Leftward Trials)');
legend('Cluster 1', 'Cluster 2', 'Cluster 3', 'Centroids');

% Analyze the clusters
for k = 1:optimalK_auditory_leftward
    clusterData = clusteringData_auditory_leftward(idx_auditory_leftward == k, :);
    clusterMean = mean(clusterData);
    fprintf('Auditory Leftward Cluster %d mean coherence: %f, mean accuracy: %f\n', k, clusterMean(1), clusterMean(2));
end

%% Clustering for Visual Rightward Trials
clusteringData_visual_rightward = aggregatedData_visual_rightward;

% Determine the number of clusters using the elbow method
wcss = zeros(1, maxClusters);

for k = 1:maxClusters
    [~, ~, sumd] = kmeans(clusteringData_visual_rightward, k, 'Replicates', 10);
    wcss(k) = sum(sumd);
end

% Plot the elbow curve for visual rightward trials
figure;
plot(1:maxClusters, wcss, '-o');
xlabel('Number of Clusters');
ylabel('Within-Cluster Sum of Squares (WCSS)');
title('Elbow Method for Optimal k (Visual Rightward Trials)');

% Choose the optimal number of clusters
optimalK_visual_rightward = 4;  % Adjust this based on the elbow method plot

% Perform k-means clustering
[idx_visual_rightward, centroids_visual_rightward] = kmeans(clusteringData_visual_rightward, optimalK_visual_rightward, 'Replicates', 10);

% Visualize the clusters
figure;
gscatter(clusteringData_visual_rightward(:,1), clusteringData_visual_rightward(:,2), idx_visual_rightward);
hold on;
plot(centroids_visual_rightward(:,1), centroids_visual_rightward(:,2), 'kx', 'MarkerSize', 15, 'LineWidth', 3);
xlabel('Coherence');
ylabel('Accuracy');
title('Cluster Assignments and Centroids (Visual Rightward Trials)');
legend('Cluster 1', 'Cluster 2', 'Cluster 3', 'Centroids');

% Analyze the clusters
for k = 1:optimalK_visual_rightward
    clusterData = clusteringData_visual_rightward(idx_visual_rightward == k, :);
    clusterMean = mean(clusterData);
    fprintf('Visual Rightward Cluster %d mean coherence: %f, mean accuracy: %f\n', k, clusterMean(1), clusterMean(2));
end

%% Clustering for Visual Leftward Trials
clusteringData_visual_leftward = aggregatedData_visual_leftward;

% Determine the number of clusters using the elbow method
wcss = zeros(1, maxClusters);

for k = 1:maxClusters
    [~, ~, sumd] = kmeans(clusteringData_visual_leftward, k, 'Replicates', 10);
    wcss(k) = sum(sumd);
end

% Plot the elbow curve for visual leftward trials
figure;
plot(1:maxClusters, wcss, '-o');
xlabel('Number of Clusters');
ylabel('Within-Cluster Sum of Squares (WCSS)');
title('Elbow Method for Optimal k (Visual Leftward Trials)');

% Choose the optimal number of clusters
optimalK_visual_leftward = 4;  % Adjust this based on the elbow method plot

% Perform k-means clustering
[idx_visual_leftward, centroids_visual_leftward] = kmeans(clusteringData_visual_leftward, optimalK_visual_leftward, 'Replicates', 10);

% Visualize the clusters
figure;
gscatter(clusteringData_visual_leftward(:,1), clusteringData_visual_leftward(:,2), idx_visual_leftward);
hold on;
plot(centroids_visual_leftward(:,1), centroids_visual_leftward(:,2), 'kx', 'MarkerSize', 15, 'LineWidth', 3);
xlabel('Coherence');aud_weights = readtable(fileName, 'Sheet', sheetName, 'Range', 'AB:AB');
aud_weights = table2array(aud_weights);

sensitivities = readtable(fileName, 'Sheet', sheetName, 'Range', 'I:J');
sensitivities = table2array(sensitivities);

% Assuming you have a 51x2 double called sensitivities where:
% Column 1 = auditory sensitivities
% Column 2 = visual sensitivities

% Step 1: Visualize the data to identify potential outliers
figure;
scatter(sensitivities(:,1), sensitivities(:,2), 'o');
xlabel('Auditory Sensitivity');
ylabel('Visual Sensitivity');
title('Scatter Plot of Sensitivities with Potential Outliers');
grid on;

% Step 2: Use Z-scores to identify outliers
z_scores = zscore(sensitivities);  % Calculate Z-scores for each column
threshold = 2;  % Threshold for identifying outliers (Z-score > 3 or < -3)

% Identify outliers
outliers = any(abs(z_scores) > threshold, 2);

% Step 3: Remove the outliers from the data
sensitivities_no_outliers = sensitivities(~outliers, :);

% Visualize the cleaned data
figure;
scatter(sensitivities_no_outliers(:,1), sensitivities_no_outliers(:,2), 'o');
xlabel('Auditory Sensitivity');
ylabel('Visual Sensitivity');
title('Scatter Plot of Sensitivities After Outlier Removal');
grid on;

% Display the number of removed outliers
num_outliers = sum(outliers);
disp(['Number of outliers removed: ', num2str(num_outliers)]);

% Assuming you have the cleaned data in sensitivities_no_outliers

% Determine the number of clusters using the elbow method first (optional but recommended)
maxClusters = 10;
wcss = zeros(1, maxClusters);

for k = 1:maxClusters
    [~, ~, sumd] = kmeans(sensitivities_no_outliers, k, 'Replicates', 10);
    wcss(k) = sum(sumd);
end

% Plot the elbow curve
figure;
plot(1:maxClusters, wcss, '-o');
xlabel('Number of Clusters');
ylabel('Within-Cluster Sum of Squares (WCSS)');
title('Elbow Method for Optimal Number of Clusters');
grid on;

% Based on the elbow curve, select the number of clusters
optimalK = 4;  % Adjust this number based on the elbow curve

% Perform k-means clustering on the cleaned data
[idx, centroids] = kmeans(sensitivities_no_outliers, optimalK, 'Replicates', 10);

% Plot the clustering results
figure;
gscatter(sensitivities_no_outliers(:,1), sensitivities_no_outliers(:,2), idx, 'rgbm', 'o', 8);
hold on;
plot(centroids(:,1), centroids(:,2), 'kx', 'MarkerSize', 15, 'LineWidth', 3);
xlabel('Auditory Sensitivity');
ylabel('Visual Sensitivity');
title('Clustering of Auditory and Visual Sensitivities (No Outliers)');
legend('Cluster 1', 'Cluster 2', 'Cluster 3', 'Cluster 4', 'Centroids');
grid on;
hold off;

% Display cluster centroids
disp('Cluster Centroids:');
disp(centroids);

% Assuming you have already performed the initial clustering and have the 'idx' variable

% Extract data points that belong to Cluster 1
cluster1_data = sensitivities_no_outliers(idx == 1, :);

% Determine the number of clusters for the secondary clustering using the elbow method (optional)
maxClusters = 10;
wcss_cluster1 = zeros(1, maxClusters);

for k = 1:maxClusters
    [~, ~, sumd] = kmeans(cluster1_data, k, 'Replicates', 10);
    wcss_cluster1(k) = sum(sumd);
end

% Plot the elbow curve for Cluster 1
figure;
plot(1:maxClusters, wcss_cluster1, '-o');
xlabel('Number of Clusters');
ylabel('Within-Cluster Sum of Squares (WCSS)');
title('Elbow Method for Optimal Number of Clusters (Cluster 1)');
grid on;

% Based on the elbow curve, select the number of clusters for Cluster 1
optimalK_cluster1 = 3;  % Adjust this number based on the elbow curve

% Perform k-means clustering on the data from Cluster 1
[idx_cluster1, centroids_cluster1] = kmeans(cluster1_data, optimalK_cluster1, 'Replicates', 10);

% Plot the secondary clustering results
figure;
gscatter(cluster1_data(:,1), cluster1_data(:,2), idx_cluster1, 'rgb', 'o', 8);
hold on;
plot(centroids_cluster1(:,1), centroids_cluster1(:,2), 'kx', 'MarkerSize', 15, 'LineWidth', 3);
xlabel('Auditory Sensitivity');
ylabel('Visual Sensitivity');
title('Secondary Clustering of Cluster 1 (Auditory and Visual Sensitivities)');
legend('Sub-Cluster 1', 'Sub-Cluster 2', 'Sub-Cluster 3', 'Centroids');
grid on;
hold off;

% Display the centroids of the secondary clustering
disp('Sub-Cluster Centroids for Cluster 1:');
disp(centroids_cluster1);
ylabel('Accuracy');
title('Cluster Assignments and Centroids (Visual Leftward Trials)');
legend('Cluster 1', 'Cluster 2', 'Cluster 3', 'Centroids');

% Analyze the clusters
for k = 1:optimalK_visual_leftward
    clusterData = clusteringData_visual_leftward(idx_visual_leftward == k, :);
    clusterMean = mean(clusterData);
    fprintf('Visual Leftward Cluster %d mean coherence: %f, mean accuracy: %f\n', k, clusterMean(1), clusterMean(2));
end

%% Plotting Combined Accuracy for All Conditions and Directions
figure;

% Plot for auditory rightward trials
scatter(aggregatedData_auditory_rightward(:, 1), aggregatedData_auditory_rightward(:, 2), 'o', 'MarkerEdgeColor', 'r');
hold on;

% Plot for auditory leftward trials
scatter(aggregatedData_auditory_leftward(:, 1), aggregatedData_auditory_leftward(:, 2), 'o', 'MarkerEdgeColor', 'b');

% Plot for visual rightward trials
scatter(aggregatedData_visual_rightward(:, 1), aggregatedData_visual_rightward(:, 2), 'x', 'MarkerEdgeColor', 'g');

% Plot for visual leftward trials
scatter(aggregatedData_visual_leftward(:, 1), aggregatedData_visual_leftward(:, 2), 'x', 'MarkerEdgeColor', 'm');

% Adding labels and legend
xlabel('Coherence');
ylabel('Accuracy');
title('Combined Accuracy Across All Conditions and Directions');
legend('Auditory Rightward', 'Auditory Leftward', 'Visual Rightward', 'Visual Leftward');
grid on;
hold off;


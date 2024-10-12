close all;
clc;
clear;

data_file_directory = "/Users/a.tiesman/Documents/Research/Human_AV_Motion/data";

% Define the Excel file and sheet name
fileName = 'group_perf_data.xlsx';
sheetName = 'data_to_analyze';

aud_weights = readtable(fileName, 'Sheet', sheetName, 'Range', 'AB:AB');
aud_weights = table2array(aud_weights);

sensitivities = readtable(fileName, 'Sheet', sheetName, 'Range', 'I:J');
sensitivities = table2array(sensitivities);

% Step 1: Visualize the data to identify potential outliers
figure;
scatter(sensitivities(:,1), sensitivities(:,2), 'o');
xlabel('Auditory Sensitivity');
ylabel('Visual Sensitivity');
title('Scatter Plot of Sensitivities with Potential Outliers');
grid on;

% Step 2: Use Z-scores to identify outliers
z_scores = zscore(sensitivities);  % Calculate Z-scores for each column
threshold = 2;  % Threshold for identifying outliers (Z-score > 2 or < -2)

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

% Determine the number of clusters using the elbow method first (optional)
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
optimalK = 3;  % Adjust this number based on the elbow curve

% Perform k-means clustering on the cleaned data
[idx, centroids] = kmeans(sensitivities_no_outliers, optimalK, 'Replicates', 10);

% Reorder clusters so that the cluster with the centroid closest to (0,0) is labeled as Cluster 1
[~, order] = sort(sqrt(sum(centroids.^2, 2)));  % Sort centroids by distance to origin
idx = changem(idx, 1:optimalK, order);  % Reorder idx according to the new order
centroids = centroids(order, :);  % Reorder centroids

% Plot the clustering results
figure;
gscatter(sensitivities_no_outliers(:,1), sensitivities_no_outliers(:,2), idx, 'rgbm', 'o', 8);
hold on;
plot(centroids(:,1), centroids(:,2), 'kx', 'MarkerSize', 15, 'LineWidth', 3);
xlabel('Auditory Sensitivity');
ylabel('Visual Sensitivity');
title('Clustering of Auditory and Visual Sensitivities (No Outliers)');
legend('Cluster 1', 'Cluster 2', 'Cluster 3', 'Centroids');
grid on;
hold off;

% Display cluster centroids
disp('Cluster Centroids:');
disp(centroids);

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

% Find the indices of participants in Cluster 1
participants_in_cluster1 = find(idx == 1);

% Initialize an array to store the average auditory weight for each sub-cluster
numSubClusters = max(idx_cluster1);  % This is the number of sub-clusters
avgWeight_subclusters = zeros(numSubClusters, 1);

% Calculate average auditory weight for each sub-cluster
for k = 1:numSubClusters
    % Find which participants are in sub-cluster k
    subcluster_indices = participants_in_cluster1(idx_cluster1 == k);
    % Calculate the average auditory weight for these participants
    avgWeight_subclusters(k) = mean(aud_weights(subcluster_indices, 1));
end

% Display the results
disp('Average Auditory Weight for Each Sub-Cluster in Cluster 1:');
for k = 1:numSubClusters
    fprintf('Sub-Cluster %d: %f\n', k, avgWeight_subclusters(k));
end

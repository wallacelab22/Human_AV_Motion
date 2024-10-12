close all;
clc;
clear;

data_file_directory = "/Users/a.tiesman/Documents/Research/Human_AV_Motion/data";

% Define the Excel file and sheet name
fileName = 'group_cue_data.xlsx';
sheetName = 'data_to_analyze';

aud_weights = readtable(fileName, 'Sheet', sheetName, 'Range', 'Y:Y');
aud_weights = table2array(aud_weights);

aud_sensitivities = readtable(fileName, 'Sheet', sheetName, 'Range', 'E:E');
vis_sensitivities = readtable(fileName, 'Sheet', sheetName, 'Range', 'G:G');
aud_sensitivities = table2array(aud_sensitivities);
vis_sensitivities = table2array(vis_sensitivities);
sensitivities = [aud_sensitivities, vis_sensitivities];

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

close all

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
beautifyplot;

% Extract data points that belong to Cluster 1
cluster1_data = sensitivities_no_outliers(idx == 1, :);
cluster2_data = sensitivities_no_outliers(idx == 2, :);

%% Plot histogram of AV cue AV Std
av_cueav_sensitivities = readtable(fileName, 'Sheet', sheetName, 'Range', 'M:M');
av_cueav_sensitivities = table2array(av_cueav_sensitivities);

% Extract AV cue sensitivities for each cluster
av_cueav_cluster1 = av_cueav_sensitivities(idx == 1);
av_cueav_cluster2 = av_cueav_sensitivities(idx == 2);

% Define the number of bins for the histogram
num_bins = 10;

% Calculate the bin edges based on the combined data
edges = linspace(min(av_cueav_sensitivities), max(av_cueav_sensitivities), num_bins + 1);

% Calculate the histogram counts for each cluster
counts_cluster1 = histcounts(av_cueav_cluster1, edges);
counts_cluster2 = histcounts(av_cueav_cluster2, edges);

% Create a stacked bar plot
figure;
bar(edges(1:end-1), [counts_cluster1; counts_cluster2]', 'stacked');
xlabel('AV Cue Sensitivities');
ylabel('Frequency');
title('Stacked Histogram of AV Cue Sensitivities by Cluster');
legend('Cluster 1', 'Cluster 2');
grid on;
beautifyplot;

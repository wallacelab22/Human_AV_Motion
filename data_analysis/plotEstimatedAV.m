% function plotEstimatedAV(estimated_sigma, mus, weights, aud_coh, vis_coh, AV_accuracy_CDF_points)
% 
% mu_aud = mus(1); 
% mu_vis = mus(2);
% weight_aud = weights(1); 
% weight_vis = weights(2);
% 
% estimated_mu = (mu_aud * weight_aud) + (mu_vis * weight_vis);
% 
% % Define the range of x values
% x = linspace(-1, 1, 1000);
% 
% % Define the psychometric function using the normal CDF
% y = 0.5 * (1 + erf((x - estimated_mu) / (estimated_sigma * sqrt(2))));
% 
% % Plot the psychometric curve
% plot(x, y, 'g', 'LineWidth', 3, 'DisplayName', 'Estimated AV');
% hold on;
% 
% % Calculate thresholds or related data points (assumed here, modify if different)
% % Estimations based on the coherence and the model
% estimated_audthres_lefty = 0.5 * (1 + erf((-aud_coh - estimated_mu) / (estimated_sigma * sqrt(2))));
% estimated_audthres_righty = 0.5 * (1 + erf((aud_coh - estimated_mu) / (estimated_sigma * sqrt(2))));
% 
% % Apply condition if auditory and visual coherence levels differ
% if aud_coh ~= vis_coh
%     estimated_visthres_lefty = 0.5 * (1 + erf((-vis_coh - estimated_mu) / (estimated_sigma * sqrt(2))));
%     estimated_visthres_righty = 0.5 * (1 + erf((vis_coh - estimated_mu) / (estimated_sigma * sqrt(2))));
% else
%     estimated_visthres_lefty = estimated_audthres_lefty;
%     estimated_visthres_righty = estimated_audthres_righty;    
% end
% 
% % Empirical data points from the description
% Av_empirical_left = 1 - AV_accuracy_CDF_points(2);
% Av_empirical_right = AV_accuracy_CDF_points(1);
% aV_empirical_left = 1 -  AV_accuracy_CDF_points(4);
% aV_empirical_right = AV_accuracy_CDF_points(3);
% 
% % Coordinates for black and green dots
% points_coh = [-aud_coh, aud_coh, -vis_coh, vis_coh, -aud_coh, aud_coh, -vis_coh, vis_coh]; 
% points_prob = [estimated_audthres_lefty, estimated_audthres_righty, estimated_visthres_lefty, estimated_visthres_righty, Av_empirical_left, Av_empirical_right, aV_empirical_left, aV_empirical_right];
% 
% % Indices for empirical (black) and estimated (green) points
% black_indices = [5, 6, 7, 8]; % empirical AV points
% green_indices = [1, 2, 3, 4]; % estimated AV points
% 
% % Plot estimated AV points (green)
% plot(points_coh(green_indices), points_prob(green_indices), 'go', 'MarkerFaceColor', 'g', 'MarkerSize', 8, 'HandleVisibility', 'off');
% 
% % Plot empirical AV points (black)
% plot(points_coh(black_indices), points_prob(black_indices), 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 8, 'DisplayName', 'Empirical AV Points');
% 
% % Adding vertical dotted lines for each black dot to connect with the green curve
% for i = 1:length(black_indices)
%     % Interpolating to find matching y on the curve
%     interp_y = interp1(x, y, points_coh(black_indices(i)), 'linear');
%     % Plotting the vertical line
%     plot([points_coh(black_indices(i)), points_coh(black_indices(i))], [points_prob(black_indices(i)), interp_y], 'k:', 'LineWidth', 3, 'HandleVisibility', 'off');
% end
% 
% end

function plotEstimatedAV(estimated_sigma, mus, weights, aud_coh, vis_coh, AV_accuracy_CDF_points, A, V)

mu_aud = mus(1); 
mu_vis = mus(2);
weight_aud = weights(1); 
weight_vis = weights(2);

% Calculate the estimated_mu
estimated_mu = (mu_aud * weight_aud) + (mu_vis * weight_vis);

% Define the range of x values
x = linspace(-1, 1, 1000);

% Calculate the psychometric function using the normal CDF for MLE model
y = 0.5 * (1 + erf((x - estimated_mu) / (estimated_sigma * sqrt(2))));

% Plot the psychometric curve for MLE model
plot(x, y, 'g', 'LineWidth', 3, 'DisplayName', 'Estimated AV (MLE)');
hold on;

% Calculate the new sigma for cue averaging model
sigma_cue_averaging = sqrt(weight_aud * A + weight_vis * V);

% Calculate the psychometric function using the normal CDF for cue averaging model
y_cue_averaging = 0.5 * (1 + erf((x - estimated_mu) / (sigma_cue_averaging * sqrt(2))));

% Plot the psychometric curve for cue averaging model
plot(x, y_cue_averaging, 'color', [1, 0.5, 0], 'LineWidth', 3, 'DisplayName', 'Estimated AV (Cue Averaging)');

% Calculate thresholds or related data points (assumed here, modify if different)
% Estimations based on the coherence and the model for MLE
estimated_audthres_lefty = 0.5 * (1 + erf((-aud_coh - estimated_mu) / (estimated_sigma * sqrt(2))));
estimated_audthres_righty = 0.5 * (1 + erf((aud_coh - estimated_mu) / (estimated_sigma * sqrt(2))));

% Apply condition if auditory and visual coherence levels differ for MLE
if aud_coh ~= vis_coh
    estimated_visthres_lefty = 0.5 * (1 + erf((-vis_coh - estimated_mu) / (estimated_sigma * sqrt(2))));
    estimated_visthres_righty = 0.5 * (1 + erf((vis_coh - estimated_mu) / (estimated_sigma * sqrt(2))));
else
    estimated_visthres_lefty = estimated_audthres_lefty;
    estimated_visthres_righty = estimated_audthres_righty;    
end

% Calculate thresholds or related data points for cue averaging
estimated_audthres_lefty_cue_averaging = 0.5 * (1 + erf((-aud_coh - estimated_mu) / (sigma_cue_averaging * sqrt(2))));
estimated_audthres_righty_cue_averaging = 0.5 * (1 + erf((aud_coh - estimated_mu) / (sigma_cue_averaging * sqrt(2))));

if aud_coh ~= vis_coh
    estimated_visthres_lefty_cue_averaging = 0.5 * (1 + erf((-vis_coh - estimated_mu) / (sigma_cue_averaging * sqrt(2))));
    estimated_visthres_righty_cue_averaging = 0.5 * (1 + erf((vis_coh - estimated_mu) / (sigma_cue_averaging * sqrt(2))));
else
    estimated_visthres_lefty_cue_averaging = estimated_audthres_lefty_cue_averaging;
    estimated_visthres_righty_cue_averaging = estimated_audthres_righty_cue_averaging;    
end

% Coordinates for green dots for MLE model
points_coh = [-aud_coh, aud_coh, -vis_coh, vis_coh]; 
points_prob_mle = [estimated_audthres_lefty, estimated_audthres_righty, estimated_visthres_lefty, estimated_visthres_righty];

% Coordinates for orange dots for cue averaging model
points_prob_cue_averaging = [estimated_audthres_lefty_cue_averaging, estimated_audthres_righty_cue_averaging, estimated_visthres_lefty_cue_averaging, estimated_visthres_righty_cue_averaging];

% Indices for estimated (green) points
green_indices = [1, 2, 3, 4]; % estimated AV points (MLE)
orange_indices = [1, 2, 3, 4]; % estimated AV points (Cue Averaging)

% Plot estimated AV points for MLE (green)
plot(points_coh(green_indices), points_prob_mle(green_indices), 'go', 'MarkerFaceColor', 'g', 'MarkerSize', 8, 'HandleVisibility', 'off');

% Plot estimated AV points for Cue Averaging (orange)
plot(points_coh(orange_indices), points_prob_cue_averaging, 'o', 'MarkerFaceColor', [1, 0.5, 0], 'MarkerSize', 8, 'Color', [1, 0.5, 0], 'HandleVisibility', 'off');

hold off;

end


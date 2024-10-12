% Example usage:
p_auditory = 0.55;
p_visual = 0.775;
w_auditory = ; 
w_visual = ;
predicted_multisensory_accuracy = compute_multisensory_accuracy(p_auditory, p_visual);
fprintf('Predicted Multisensory Accuracy: %.4f\n', predicted_multisensory_accuracy);

function p_AV = compute_multisensory_accuracy(p_auditory, p_visual)
    % Function to compute the predicted multisensory accuracy given
    % auditory and visual unisensory accuracies

    % Convert accuracy to z-scores
    z_A = norminv(p_auditory);
    z_V = norminv(p_visual);

    % Calculate reliabilities (inverse variance)
    R_A = 1 / (2 * z_A^2);
    R_V = 1 / (2 * z_V^2);

    % Combined reliability
    R_AV = R_A + R_V;

    % Calculate combined z-score
    z_AV = sqrt(1 / (2 * (1 / R_AV)));

    % Calculate predicted multisensory accuracy
    p_AV = normcdf(z_AV);
end
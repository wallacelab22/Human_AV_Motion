function createParticipantAccPlots(AO_acc, VO_acc, AV_perf, MLE_acc, CA_acc, MaxA_V, aud_weight)
    % Define color groups based on aud_weight
    group1 = find(aud_weight > 0.6);
    group2 = find(aud_weight > 0.4 & aud_weight < 0.6);
    group3 = find(aud_weight < 0.4);
    
    % Check that all input arrays are the same size
    assert(isequal(size(AO_acc), size(VO_acc), size(AV_perf), size(MLE_acc), size(CA_acc), size(MaxA_V)), 'All input arrays must be the same size.');
    
    % Handles for legend
    h_handles = [];
    h_labels = [];
    
    % Function to apply formatting to each subplot
    function formatSubplot()
        set(gca, 'xcolor', 'k');
        set(gca, 'ycolor', 'k');
        set(gca, 'LineWidth', 1.5);
        set(gca, 'FontName', 'Helvetica');
        set(gca, 'FontSize', 30);
        set(gca, 'TickDir', 'in');
        box off;
        set(gca, 'Layer', 'Top');
    end
    
    % Function to create individual plots for each group
    function createGroupPlot(group_indices, group_name, show_legend)
        numParticipants = length(group_indices);
        numCols = numParticipants;
        
        % Create a figure for the group
        figure('Name', group_name, 'NumberTitle', 'off');
        
        % Add a title to the entire figure
        sgtitle(['AV Individual Performance - ', group_name]);
        
        % Plot for each participant in the group
        for i = 1:numParticipants
            % Create subplot for each participant
            subplot(1, numCols, i);
            hold on;
            
            % Get participant index
            idx = group_indices(i);
            
            % Plot AO_acc and VO_acc as horizontal black lines
            h1 = line([0, 1.5], [AO_acc(idx), AO_acc(idx)], 'Color', 'k', 'LineWidth', 2, 'DisplayName', 'Unisensory Accuracy');
            line([0, 1.5], [VO_acc(idx), VO_acc(idx)], 'Color', 'k', 'LineWidth', 2, 'HandleVisibility', 'off');
            
            % Determine bounds for orange shaded region (AO_acc to VO_acc)
            bottom_bound_orange = min(AO_acc(idx), VO_acc(idx));
            top_bound_orange = max(AO_acc(idx), VO_acc(idx));
            
            % Create orange shaded region (RGB triplet for orange is [1, 0.5, 0])
            h_fill_orange = fill([0, 0, 1.5, 1.5], [bottom_bound_orange, top_bound_orange, top_bound_orange, bottom_bound_orange], [1, 0.5, 0], 'FaceAlpha', 0.2, 'EdgeColor', 'none', 'DisplayName', 'Response Depression');
            
            % Determine bounds for green shaded region (MaxA_V to 1)
            bottom_bound_green = max(AO_acc(idx), VO_acc(idx));
            top_bound_green = 1;
            
            % Create green shaded region
            h_fill_green = fill([0, 0, 1.5, 1.5], [bottom_bound_green, top_bound_green, top_bound_green, bottom_bound_green], [0, 1, 0], 'FaceAlpha', 0.2, 'EdgeColor', 'none', 'DisplayName', 'Response Enhancement');
            
            % Plot MLE_acc as a horizontal green line
            h3 = line([0, 1.5], [MLE_acc(idx), MLE_acc(idx)], 'Color', 'g', 'LineWidth', 2, 'DisplayName', 'MLE Estimated Accuracy');
            
            % Plot CA_acc as a horizontal orange line (RGB triplet for orange is [1, 0.5, 0])
            h4 = line([0, 1.5], [CA_acc(idx), CA_acc(idx)], 'Color', [1, 0.5, 0], 'LineWidth', 2, 'DisplayName', 'Cue Averaging Estimated Accuracy');
            
            % Plot AV_perf as a magenta star
            h5 = plot(0.75, AV_perf(idx), '*', 'Color', 'magenta', 'MarkerSize', 12, 'LineWidth', 2.5, 'DisplayName', 'AV Accuracy');
            
            % Set y-axis limits to show all relevant data points
            ylim([0, 1]);
            
            % Remove x-axis for clarity
            set(gca, 'XTick', [], 'XColor', 'none');
            
            % Collect handles for the legend (only once)
            if isempty(h_handles)
                h_handles = [h1, h_fill_orange, h_fill_green, h3, h4, h5];
                h_labels = {h1.DisplayName, h_fill_orange.DisplayName, h_fill_green.DisplayName, h3.DisplayName, h4.DisplayName, h5.DisplayName};
            end
            
            % Remove y-axis labels for all but the leftmost subplot
            if i == 1
                ylabel('Accuracy');
            else
                set(gca, 'YTickLabel', []);
            end
            
            % Label x-axis with the participant number
            xlabel(num2str(i));
            
            % Apply formatting to each subplot
            formatSubplot();
            
            hold off;
        end
        
        % Apply beautifyplot function
        beautifyplot;
        
        % Show legend if specified
        if show_legend
            legend(h_handles, h_labels, 'Location', 'bestoutside');
        end
    end
    
    % Create plots for each group
    createGroupPlot(group1, 'Aud Weight > 0.6', false);
    createGroupPlot(group2, '0.4 < Aud Weight < 0.6', true);
    createGroupPlot(group3, 'Aud Weight < 0.4', false);
end

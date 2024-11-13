function unmatlabifyplot(delta_hist)
    % This function customizes the current MATLAB figure by applying 
    % non-default properties for a more publication-friendly appearance.

    % Get the current axes
    ax = gca;
    
    % Make the axes lines thicker
    ax.LineWidth = 2.5;
    
    % Move the tick marks outside
    ax.TickDir = 'out';
    
    % Set the axes to take up the full monitor screen
    %width = 235;
    width = 705; % Width in pixels x3
    %height = 246;  % Height in pixels x3
    height = 738;

    % Create figure with specified size
    if delta_hist
        set(gcf, 'Units', 'normalized', 'OuterPosition', [0 0 1 1]);
    else
        set(gcf, 'Units', 'pixels', 'Position', [100, 100, width, height]);
    end
%set(gcf, 'Units', 'normalized', 'OuterPosition', [0 0 0.235 0.246]);
    
    % Break the x and y axes by setting limits where there's space 
    % (adjust according to the data, here is an example)
    ax.XLim = [min(ax.XLim(1), mean(xlim) - range(xlim)/2), max(ax.XLim(2), mean(xlim) + range(xlim)/2)];
    ax.YLim = [min(ax.YLim(1), mean(ylim) - range(ylim)/2), max(ax.YLim(2), mean(ylim) + range(ylim)/2)];
    
    % Turn off grid lines
    ax.XGrid = 'off';
    ax.YGrid = 'off';

    % Apply changes to the current figure
    drawnow;
end

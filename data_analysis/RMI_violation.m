function [violation, gain] = RMI_violation(rtAuditory, rtVisual, rtAudiovisual, figures, part_ID, coherenceLevel, subjnum_s, group_s, figure_file_directory, save_fig)

%% Round RTs
downSampledAudRTdata = round(rtAuditory);
downSampledVisRTdata = round(rtVisual);
downSampledAVRTdata = round(rtAudiovisual);

%% Split RTs

RT_A = downSampledAudRTdata;
RT_V = downSampledVisRTdata;
RT_AV = downSampledAVRTdata;

minRT = min([min(RT_A), min(RT_V), min(RT_AV)]);
maxRT = min([max(RT_A), max(RT_V), max(RT_AV)]);

%% Get cumulative probabilities
CP_A = getCP(RT_A);
CP_V = getCP(RT_V);
CP_AV = getCP(RT_AV);

%% Get Race model (Miller)
UnisensoryRTs = [RT_A RT_V];

[miller, P_Miller] = getMiller(UnisensoryRTs); % Determine race model

violation = getViolation(RT_A, RT_V, RT_AV); % RMI violation
violation = round(violation);

gain = getGain(RT_A, RT_V, RT_AV); % Multisensory response enhancement
gain = round(gain);

[grice, P_Grice] = getGrice(UnisensoryRTs); % Grice bound

%% Plot CDFs + race CDF
if figures==1
     msize = 8;
     lw = 1.5;

     figure;
    % 
    % % CDFS and MRE
    subplot(1,2,1),fillArea([RT_AV, grice]); hold on;

    subplot(1,2,1),h1 = plot(RT_A,CP_A,'.-r','MarkerSize',msize,'LineWidth',lw); 
    subplot(1,2,1),h2 = plot(RT_V,CP_V,'.-b','MarkerSize',msize,'LineWidth',lw);
    subplot(1,2,1),h3 = plot(RT_AV,CP_AV,'.-m','MarkerSize',msize,'LineWidth',lw); hold off;

    subplot(1,2,1),text(minRT, 0.9,['MRE = ' num2str(gain) ' ms']);

    title(sprintf('MS Resp. Enchancement %s - Coh: %s', part_ID, coherenceLevel));
    legend([h1 h2 h3],'A','V','AV','Location','SouthEast');
    xlabel('Response time (ms)'); ylabel('Cumulative probability');
    axis([minRT-100 maxRT+100  0 1]);
    box off;
    beautifyplot;


    % CDFS and RMI violation
    subplot(1,2,2),fillArea([RT_AV(~isnan(miller)), miller(~isnan(miller))], [], 1); hold on;

    subplot(1,2,2),h1 = plot(RT_A,CP_A,'.-r','MarkerSize',msize,'LineWidth',lw); 
    subplot(1,2,2),h2 = plot(RT_V,CP_V,'.-b','MarkerSize',msize,'LineWidth',lw);
    subplot(1,2,2),h3 = plot(RT_AV,CP_AV,'.-m','MarkerSize',msize,'LineWidth',lw);
    subplot(1,2,2),h4 = plot(miller,P_Miller,'.--k','MarkerSize',msize,'LineWidth',lw); hold off;

    subplot(1,2,2),text(minRT, 0.9,['Violation = ' num2str(violation) ' ms']);

    title(sprintf('RMI Violation %s - Coh: %s', part_ID, coherenceLevel));
    legend([h1 h2 h3 h4],'A','V','AV','Race','Location','SouthEast');
    xlabel('Response time (ms)'); ylabel('Cumulative probability');
    axis([minRT-100 maxRT+100  0 1]);
    box off;
    beautifyplot;

    set(gcf, 'Units', 'normalized', 'OuterPosition', [0 0 1 1]);
    rt = gcf;
    fig_type = 'rt';
    filename = fullfile(figure_file_directory, [subjnum_s '_' group_s '_' fig_type '.jpg']);
    if save_fig
        saveas(rt, filename, 'jpeg');
    end

end
end


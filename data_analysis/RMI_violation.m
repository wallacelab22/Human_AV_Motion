function [violation] = RMI_violation(downSampledRTdata,showplot)

%% Round RTs
downSampledRTdata = round(downSampledRTdata);

%% Split RTs

RT_A = downSampledRTdata(:,1);
RT_V = downSampledRTdata(:,2);
RT_AV = downSampledRTdata(:,3);

minRT = min([min(RT_A), min(RT_V), min(RT_AV)]);
maxRT = min([max(RT_A), max(RT_V), max(RT_AV)]);

%% Get cumulative probabilities
CP_A = getCP(RT_A);
CP_V = getCP(RT_V);
CP_AV = getCP(RT_AV);

%% Get Race model (Miller)
UnisensoryRTs = [RT_A RT_V];

[miller, P_Miller] = getMiller(UnisensoryRTs); % Determine race model

violation = getViolation(downSampledRTdata); % RMI violation
violation = round(violation);

gain = getGain(downSampledRTdata); % Multisensory response enhancement
gain = round(gain);

[grice, P_Grice] = getGrice(downSampledRTdata(:,1:2)); % Grice bound

%% Plot CDFs + race CDF
if showplot==1
     msize = 8;
     lw = 1.5;

     figure;
    % 
    % % CDFS and MRE
    subplot(1,2,1),fillArea([RT_AV, grice]); hold on;

    subplot(1,2,1),h1 = plot(RT_A,CP_A,'.-','color',[0.5 0.5 0.5],'MarkerSize',msize,'LineWidth',lw); 
    subplot(1,2,1),h2 = plot(RT_V,CP_V,'.-r','MarkerSize',msize,'LineWidth',lw);
    subplot(1,2,1),h3 = plot(RT_AV,CP_AV,'.-b','MarkerSize',msize,'LineWidth',lw); hold off;

    subplot(1,2,1),text(minRT, 0.9,['MRE = ' num2str(gain) ' ms']);

    title('Multisensory response enhancement');
    legend([h1 h2 h3],'A','V','AV','Location','SouthEast');
    xlabel('Response time (ms)'); ylabel('Cumulative probability');
    axis([minRT-100 maxRT+100  0 1]);
    box off;
    beautifyplot;


    % CDFS and RMI violation
    subplot(1,2,2),fillArea([RT_AV(~isnan(miller)), miller(~isnan(miller))], [], 1); hold on;

    subplot(1,2,2),h1 = plot(RT_A,CP_A,'.-','color',[0.5 0.5 0.5],'MarkerSize',msize,'LineWidth',lw); 
    subplot(1,2,2),h2 = plot(RT_V,CP_V,'.-r','MarkerSize',msize,'LineWidth',lw);
    subplot(1,2,2),h3 = plot(RT_AV,CP_AV,'.-b','MarkerSize',msize,'LineWidth',lw);
    subplot(1,2,2),h4 = plot(miller,P_Miller,'.--k','MarkerSize',msize,'LineWidth',lw); hold off;

    subplot(1,2,2),text(minRT, 0.9,['Violation = ' num2str(violation) ' ms']);

    title('RMI violation');
    legend([h1 h2 h3 h4],'A','V','AV','Race','Location','SouthEast');
    xlabel('Response time (ms)'); ylabel('Cumulative probability');
    axis([minRT-100 maxRT+100  0 1]);
    box off;
    beautifyplot;

end
end


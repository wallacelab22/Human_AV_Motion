function [Results_Unisensory, Results_Multisensory, RT_A, RT_V, RT_AV_Con, RT_AV_Incon] = PP_Analysis(ppNumber,showplot)

%% Info
% Single participant analysis function for RDK data Antonia Thelen
% Written by Nathan van der Stoep
%
% Collaboration between: 
% Adriana Schoenhaut (VU)
% Nathan van der Stoep (UU), 
% Ramnarayan Ramachandran (VU), Mark Wallace (VU)

%% Logdate: 03-02-2020 by NVDS
% Finished analysis of AV conditions

%% Logdate: 13-02-2020 by NVDS
% Finished CDF RT analysis
% To do: Calculate n correct responses in congruent condition?

%% Data organization 
% (refer to at_RDKHoopMatrix_psyVis.m, at_RDKHoopMatrix_psyAud.m, or at_RDKHoopMatrix_psyAV.m in data folder for additional detail)

% Auditory or visual only
% Columns:
% 1=direction (1=right, 2=left, 0 = no direction)
% 2=coherence level (1:5, see levels of coherence below for coding)
% 3=response (1=right, 2=left)
% 4=RT
% 5=key press value
% See next bullet for coding schemes

% Audiovisual 
% Columns:  
% 1=auditory direction
% 2=auditory coherence
% 3=visual direction
% 4=visual coherence
% 5=response
% 6=RT
% 7=actual key pressed (depends on computer how its coded, redundant info with response)

% Direction coding: right=1, left=2

% Coherence coding: 1-5 (1 being lowest level of coherence, 5 being the highest. Exact value depends on whether auditory or visual stim. See below)

% Response coding: im assuming 1=right, 2=left

% Congruent trials=when values in columns 1 and 3 have the same values

% Incongruent trials=when values in columns 1 and 3 have different values
% When columns 1:4=[0 0 0 0], catch trial

% Procedure info determined from code:
% Use the AAA_RDKHoop_psyAV.m (or psyVis, or psyAud) ones to run task, script in data folder

% Per block: stim trials 20 (for AV, says 20 aud, 20 vis, 20 AV?) 
% 50 catch trials

% 5 levels of coherence

% Visual coherence levels
% viscoh1=.05; viscoh2=.15; viscoh3=.35; viscoh4=.55; viscoh5=.75

% Auditory coherence levels
% audcoh1=0.1; audcoh2=0.25; audcoh3=0.35; audcoh4=0.45; audcoh5=0.55

%% Analysis parameters
VisCoh_R = [0.05 0.15 0.25 0.35 0.45];
VisCoh_L = VisCoh_R .* -1;
VisCoh_all = [fliplr(VisCoh_L) 0 VisCoh_R];

AudCoh_R = [0.1 0.25 0.35 0.45 0.55];
AudCoh_L = AudCoh_R .* -1;
AudCoh_all = [fliplr(AudCoh_L) 0 AudCoh_R];

RightResp = 2;

%% Load files
ppNumber==ppNumber
if ppNumber < 10
    fname_A = [pwd '/Data/RDKHoop_psyAud_0' num2str(ppNumber) '.mat'];
    fname_V = [pwd '/Data/RDKHoop_psyVis_0' num2str(ppNumber) '.mat'];
    fname_AV = [pwd '/Data/RDKHoop_psyAV_0' num2str(ppNumber) '.mat'];
else
    fname_A = [pwd '/Data/RDKHoop_psyAud_' num2str(ppNumber) '.mat'];
    fname_V = [pwd '/Data/RDKHoop_psyVis_' num2str(ppNumber) '.mat'];
    fname_AV = [pwd '/Data/RDKHoop_psyAV_' num2str(ppNumber) '.mat'];
end

if exist(fname_A) == 0 || exist(fname_V) == 0 || exist(fname_AV) == 0
    disp(['At least one of the files is missing']);
    return
else    
    load(fname_A); A_data = MAT; clear MAT;
    load(fname_V); V_data = MAT; clear MAT;
    load(fname_AV); AV_data = MAT; clear MAT;
end

%% Preprocess data to useful format

% Auditory
for n = 1:length(AudCoh_L)
    A_data(A_data(:,1)==1 & A_data(:,2)==n,6) = AudCoh_L(n);
    A_data(A_data(:,1)==2 & A_data(:,2)==n,6) = AudCoh_R(n);
end

% 50 Catch trials
A_data(A_data(:,1)==0 & A_data(:,2)==0,6) = 0;

% Visual
for n = 1:length(VisCoh_L)
    V_data(V_data(:,1)==1 & V_data(:,2)==n,6) = VisCoh_L(n);
    V_data(V_data(:,1)==2 & V_data(:,2)==n,6) = VisCoh_R(n);
end

% 50 Catch trials
V_data(V_data(:,1)==0 & V_data(:,2)==0,6) = 0;


% Audiovisual

for n = 1:length(VisCoh_L)   
    
    % Add auditory coherence values to column 8
    AV_data(AV_data(:,1)==1 & AV_data(:,2)==n,8) = AudCoh_L(n);
    AV_data(AV_data(:,1)==2 & AV_data(:,2)==n,8) = AudCoh_R(n);

    % Add visual coherence values to column 9
    AV_data(AV_data(:,3)==1 & AV_data(:,4)==n,9) = VisCoh_L(n);
    AV_data(AV_data(:,3)==2 & AV_data(:,4)==n,9) = VisCoh_R(n);   
    
end  

% 50 Catch trials
AV_data(AV_data(:,1)==0 & AV_data(:,2)==0,8) = 0;

%% Get RTs of each unisensory condition and each coherence level

% Auditory only
RT_A_L = [A_data(A_data(:,1)==1,2) A_data(A_data(:,1)==1,4)];
RT_A_R = [A_data(A_data(:,1)==2,2) A_data(A_data(:,1)==2,4)];
RT_A_Total = [RT_A_L; RT_A_R];

for A_cond = 1:5    
    All_RT_A(A_cond,:) = RT_A_Total(RT_A_Total(:,1) == A_cond,2);
    All_medianRT_A(A_cond,:) = nanmedian(RT_A_Total(RT_A_Total(:,1) == A_cond,2));    
end

%All_RT_A = All_RT_A(~isnan(All_RT_A)); % Filter NaNs

% Visual only
RT_V_L = [V_data(V_data(:,1)==1,2) V_data(V_data(:,1)==1,4)];
RT_V_R = [V_data(V_data(:,1)==2,2) V_data(V_data(:,1)==2,4)];
RT_V_Total = [RT_V_L; RT_V_R];

for V_cond = 1:5    
    All_RT_V(V_cond,:) = RT_A_Total(RT_V_Total(:,1) == V_cond,2);
    All_medianRT_V(V_cond,:) = nanmedian(RT_V_Total(RT_V_Total(:,1) == V_cond,2));    
end

%All_RT_V = All_RT_V(~isnan(All_RT_V)); % Filter NaNs

% Audiovisual congruent
AVconLFilt = (AV_data(:,1) == 1 & AV_data(:,3) == 1);
AVconRFilt = (AV_data(:,1) == 2 & AV_data(:,3) == 2);

RT_AV_Con_L = [AV_data(AVconLFilt,2) AV_data(AVconLFilt,4) AV_data(AVconLFilt,6) AV_data(AVconLFilt,8) AV_data(AVconLFilt,9)];
RT_AV_Con_R = [AV_data(AVconRFilt,2) AV_data(AVconRFilt,4) AV_data(AVconRFilt,6) AV_data(AVconLFilt,8) AV_data(AVconLFilt,9)];
RT_AV_Con_Total = [RT_AV_Con_L; RT_AV_Con_R];

% For each Auditory coherence level, get all congruent visual coherence performances
for A_cond = 1:5    
    for V_cond = 1:5        
        All_Congruent_RT_AV(A_cond,V_cond).RTs = RT_AV_Con_Total(RT_AV_Con_Total(:,1) == A_cond & RT_AV_Con_Total(:,2) == V_cond,3);        
        All_Congruent_medianRT_AV(A_cond,V_cond) = nanmedian(RT_AV_Con_Total(RT_AV_Con_Total(:,1) == A_cond & RT_AV_Con_Total(:,2) == V_cond,3));        
    end    
end

% Audiovisual incongruent
AVInconFilt = (AV_data(:,1) == 1 & AV_data(:,3) == 2) | (AV_data(:,1) == 2 & AV_data(:,3) == 1);
RT_AV_Incon_Total = [AV_data(AVInconFilt,2) AV_data(AVInconFilt,4) AV_data(AVInconFilt,6) AV_data(AVInconFilt,8) AV_data(AVInconFilt,9)];

% For each Auditory coherence level, get all congruent visual coherence performances
for A_cond = 1:5    
    for V_cond = 1:5        
        All_Incongruent_RT_AV(A_cond,V_cond).RTs = RT_AV_Incon_Total(RT_AV_Incon_Total(:,1) == A_cond & RT_AV_Incon_Total(:,2) == V_cond,3);        
        All_Incongruent_medianRT_AV(A_cond,V_cond) = nanmedian(RT_AV_Incon_Total(RT_AV_Incon_Total(:,1) == A_cond & RT_AV_Incon_Total(:,2) == V_cond,3));        
    end    
end

% Note: Filter RT NaNs later during race model analysis

%%% RMI Analysis

%% Outlier correction for RTs
for cond = 1:5  
    
    % Outlier correction unisensory
    [Out_RT_A,Correct_RT_A,Criteria_RT_A] = outCorrect(All_RT_A(cond,:));
    [Out_RT_V,Correct_RT_V,Criteria_RT_V] = outCorrect(All_RT_V(cond,:));
    
    RT_A(cond).RT_OutCorrect = Correct_RT_A(~isnan(Correct_RT_A));
    RT_V(cond).RT_OutCorrect = Correct_RT_V(~isnan(Correct_RT_V));
    
    % Outlier correction multisensory congruent and incongruent
    for cond2 = 1:5
        
        [Out_RT_AV_Con,Correct_RT_AV_Con,Criteria_RT_AV_Con] = outCorrect(All_Congruent_RT_AV(cond,cond2).RTs);
        [Out_RT_AV_Incon,Correct_RT_AV_Incon,Criteria_RT_AV_Incon] = outCorrect(All_Incongruent_RT_AV(cond,cond2).RTs);
        
        RT_AV_Con(cond,cond2).RT_OutCorrect = Correct_RT_AV_Con(~isnan(Correct_RT_AV_Con));
        RT_AV_Incon(cond,cond2).RT_OutCorrect = Correct_RT_AV_Incon(~isnan(Correct_RT_AV_Incon));
    end    
end

% Get number of trials across all conditions
for cond = 1:5  

    RT_A(cond).N_samples = length(RT_A(cond).RT_OutCorrect);
    RT_V(cond).N_samples = length(RT_V(cond).RT_OutCorrect);
    
    for cond2 = 1:5  
   
        RT_AV_Con(cond,cond2).N_samples = length(RT_AV_Con(cond,cond2).RT_OutCorrect);
        RT_AV_Incon(cond,cond2).N_samples = length(RT_AV_Incon(cond,cond2).RT_OutCorrect);
        
    end
end

% Downsample data to get same number of trials for all conditions
% Note for methods section: We take the condition with the fewest number of
% RTs to down sample all conditions, so this means A and V are downsamples
% to the fewest RTs across all A, V, AV con, AV incon conditions (cond2) for each A condition (cond) 

% Find condition with the fewest nr of RTs to downsample to
for cond = 1:5
    for cond2 = 1:5
        
        currentminNsamples = min([RT_A(cond).N_samples, RT_V(cond).N_samples, RT_AV_Con(cond,cond2).N_samples, RT_AV_Incon(cond,cond2).N_samples]);
        
        if (cond == 1 & cond2 == 1)
           n_samples_ConIncon = currentminNsamples; 
        end
        
        if (currentminNsamples < n_samples_ConIncon)
            n_samples_ConIncon = currentminNsamples;             
        end
    end
end

% Down sample RTs
for cond = 1:5
    for cond2 = 1:5   
        RT_A(cond).RT_ds = sampleDown(RT_A(cond).RT_OutCorrect,n_samples_ConIncon);
        RT_V(cond).RT_ds = sampleDown(RT_V(cond).RT_OutCorrect,n_samples_ConIncon);
        RT_AV_Con(cond,cond2).RT_ds_Con = sampleDown(RT_AV_Con(cond,cond2).RT_OutCorrect,n_samples_ConIncon);
        RT_AV_Incon(cond,cond2).RT_ds_Incon = sampleDown(RT_AV_Incon(cond,cond2).RT_OutCorrect,n_samples_ConIncon);        
    end
end

% Gather all data for RMI analysis and transform to milliseconds
for cond = 1:5
    for cond2 = 1:5
        RT_AV_Con(cond,cond2).RT_Final = [RT_A(cond).RT_ds, RT_V(cond2).RT_ds, RT_AV_Con(cond,cond2).RT_ds_Con] .* 1000;
        RT_AV_Incon(cond,cond2).RT_Final = [RT_A(cond).RT_ds, RT_V(cond2).RT_ds, RT_AV_Incon(cond,cond2).RT_ds_Incon] .* 1000;
        
        % Calculate Multisensory Response Enhancement (Gain)
        RT_AV_Con(cond,cond2).Gain = getGain(RT_AV_Con(cond,cond2).RT_Final);
        RT_AV_Incon(cond,cond2).Gain = getGain(RT_AV_Incon(cond,cond2).RT_Final);
        
        % Calculate RMI violation
        RT_AV_Con(cond,cond2).RMIV = getViolation(RT_AV_Con(cond,cond2).RT_Final);
        RT_AV_Incon(cond,cond2).RMIV = getViolation(RT_AV_Incon(cond,cond2).RT_Final);
    end
end

%%
if showplot
    
%     for Acond = 1:5
%         for Vcond = 1:5
%             
%             plotCDFs(RT_AV_Con(Acond,Vcond).RT_Final);
%             sgtitle(['PP ' num2str(ppNumber) ', Acoh: ' num2str(Acond) ', Vcoh: ' num2str(Vcond) ', Congruent']);
%         end
%     end
%     
    Acond = 5;
    Vcond = 5;
    plotCDFs(RT_AV_Con(Acond,Vcond).RT_Final);
            sgtitle(['PP ' num2str(ppNumber) ', Acoh: ' num2str(Acond) ', Vcoh: ' num2str(Vcond) ', Congruent']);
    
    figure;

    plot(All_medianRT_A,'o-g'); hold on;
    plot(All_medianRT_V,'o-r');
   
    plot(All_Congruent_medianRT_AV(:,5),'o-');
    plot(All_Incongruent_medianRT_AV(:,5),'o-');
      
    legend('A','V','AV Con V Coh 5','AV Incon V Coh 5');
    xlabel('Auditory coherence strength');
    ylabel('Median RT (sec)');
    axis([0 6 0.7 1.1]);
    beautifyplot;
end

%% Calculate proportion of rightward responses

% Auditory
for n = 1:length(AudCoh_all)
    A_propresp(n,1) = AudCoh_all(n);
    A_propresp(n,2) = (sum(A_data(:,6)==AudCoh_all(n) & A_data(:,3) == RightResp)) ...
        ./ sum(A_data(:,6)==AudCoh_all(n));
end

% Visual
for n = 1:length(VisCoh_all)
    V_propresp(n,1) = VisCoh_all(n);
    V_propresp(n,2) = (sum(V_data(:,6)==VisCoh_all(n) & V_data(:,3) == RightResp)) ...
        ./ sum(V_data(:,6)==VisCoh_all(n));
end

% Audiovisual

% For each Auditory coherence level, get all Visual coherence performances
for A_cond = 1:length(AudCoh_all)
    
    for V_cond = 1:length(VisCoh_all)        
        
        AV_propresp(V_cond,1) = VisCoh_all(V_cond);
        
        AV_propresp(V_cond,A_cond+1) = ...
            (sum(AV_data(:,8)==AudCoh_all(A_cond) & ...
            AV_data(:,9)==VisCoh_all(V_cond) & ...            
            AV_data(:,5) == RightResp)) ...
            ./ sum(AV_data(:,8)==AudCoh_all(A_cond) & ...
            AV_data(:,9)==VisCoh_all(V_cond));        
    end    
end

%% Fitting psychometric function to unisensory data

% Fit parameters
opts = optimset('MaxFunEvals',2000, 'MaxIter',2000);
chance = 0.5;

% x-values
Results_A.newx = min(A_propresp(:,1)):.01:max(A_propresp(:,1));
Results_V.newx = min(V_propresp(:,1)):.01:max(V_propresp(:,1));

% Starting estimates
Mu = 0;
Sigma = 0.2;
xnorm = [Mu,Sigma];

try 

    % Fit function to A data
    [A_coeffv,A_resv,A_jacv] = nlinfit(A_propresp(:,1),A_propresp(:,2),'PSYnorm', xnorm);
    Results_A.newy = PSYnorm(A_coeffv,Results_A.newx);

    % Fit function to V data
    [V_coeffv,V_resv,V_jacv] = nlinfit(V_propresp(:,1),V_propresp(:,2),'PSYnorm', xnorm);
    Results_V.newy = PSYnorm(V_coeffv,Results_V.newx);

    % Get PSS and SD of A data
    Results_A.PSS = A_coeffv(1);
    Results_A.SD = A_coeffv(2);
    Results_A.R2 = 1-sum(A_resv.^2)/sum((A_propresp(:,2)-mean(A_propresp(:,2))).^2); % R2 = 1 – SSresid / SStotal

    % Get PSS and SD of V data
    Results_V.PSS = V_coeffv(1);
    Results_V.SD = V_coeffv(2);
    Results_V.R2 = 1-sum(A_resv.^2)/sum((V_propresp(:,2)-mean(V_propresp(:,2))).^2); % R2 = 1 – SSresid / SStotal

    % Make a graph of data and fitline
    if showplot == 1
        figure;

        % Auditory      
        subplot(2,2,1),h1 = plot(A_propresp(:,1),A_propresp(:,2),'.g','MarkerSize',20); hold on;
        subplot(2,2,1),plot(Results_A.newx,Results_A.newy,'-g');

        % Visual       
        subplot(2,2,1),h2 = plot(V_propresp(:,1),V_propresp(:,2),'.r','MarkerSize',20);
        subplot(2,2,1),plot(Results_V.newx,Results_V.newy,'-r'); hold off;

        legend([h1 h2],{'A','V'});
        xlabel('Motion coherence (ms)');
        ylabel('Proportion rightward response');
        title(['PP ' num2str(ppNumber) ', Unisensory']);
        beautifyplot;
    end

catch
   disp(['Bad fit for pp ' num2str(ppNumber) '!']);
   
   if showplot == 1
       figure;
       title('Data and fit');
       
       % Auditory
       subplot(1,2,1),h1 = plot(A_propresp(:,1),A_propresp(:,2),'.g','MarkerSize',20); hold on;
              
       % Visual
       subplot(1,2,1),h2 = plot(V_propresp(:,1),V_propresp(:,2),'.r','MarkerSize',20); hold off;
              
       legend([h1 h2],{'A','V'});
       xlabel('Motion coherence (ms)');
       ylabel('Proportion rightward response');
       title(['PP ' num2str(ppNumber) ', Unisensory (no fit)']);
       beautifyplot;
   end
   
   Results.A_PSS = NaN;
   Results.A_SD = NaN;
   Results.A_R2 = NaN;
   
   Results.V_PSS = NaN;
   Results.V_SD = NaN;
   Results.V_R2 = NaN;
   
   return
end

%% Fitting psychometric function to multisensory data

% Fit parameters
opts = optimset('MaxFunEvals',2000, 'MaxIter',2000);
chance = 0.5;

% Starting estimates
Mu = 0;
Sigma = 0.2;
xnorm = [Mu,Sigma];

% Get PSS and SD per A Coherence using V Coherence values on x-axis 
for n = 1:length(AudCoh_all)
    
    % x values
    Results_AV(n).newx = min(AV_propresp(:,1)):.01:max(AV_propresp(:,1));
    
    try    
        [AV_coeffv,AV_resv,AV_jacv] = nlinfit(AV_propresp(:,1),AV_propresp(:,n+1),'PSYnorm', xnorm);
        Results_AV(n).newy = PSYnorm(AV_coeffv,Results_AV(n).newx);

        Results_AV(n).PSS = AV_coeffv(1);
        Results_AV(n).SD = AV_coeffv(2);
        Results_AV(n).R2 = 1-sum(AV_resv.^2)/sum((AV_propresp(:,n+1)-mean(AV_propresp(:,n+1))).^2); % R2 = 1 – SSresid / SStotal

    catch
        Results_AV(n).PSS = NaN;
        Results_AV(n).SD = NaN;
        Results_AV(n).R2 = NaN;
    end
            
end

%% Figures

if showplot

    line_colors = [0:0.1:1;0:0.1:1;0:0.1:1]';
    
     
    
    % Visual motion coherence performance per auditory motion coherence
    for n = 2:length(Results_AV)
        subplot(2,2,2),plot(Results_AV(n).newx,Results_AV(n).newy, ...
            '-','Color',line_colors(n,:)); 
        
        hold on;
        
        subplot(2,2,2),plot(AV_propresp(:,1),AV_propresp(:,n), ...
            '.','MarkerSize',20,'MarkerFaceColor',line_colors(n,:),...
            'MarkerEdgeColor',line_colors(n,:));
        
    end
    
    hold off;
    xlabel('Visual motion coherence (ms)');
    ylabel('Proportion rightward response');
    title(['PP ' num2str(ppNumber) ': Multisensory']);    
    beautifyplot;
    
    
    % Visual PSS per A motion coherence
    subplot(2,2,3),plot(AudCoh_all,vertcat(Results_AV.PSS),'.-k','MarkerSize',24);
    xlabel('Auditory motion coherence (ms)');
    ylabel('Visual PSS');
    title(['PP ' num2str(ppNumber) ': Multisensory']);    
    axis([-0.65 0.65 -1 1]);
    beautifyplot;
    
    % Visual SD per A motion coherence
    subplot(2,2,4),plot(AudCoh_all,vertcat(Results_AV.SD),'.-k','MarkerSize',24);
    xlabel('Auditory motion coherence (ms)');
    ylabel('Visual SD');
    title(['PP ' num2str(ppNumber) ': Multisensory']);    
    axis([-0.65 0.65 0 1.5]);
    beautifyplot;
end
    
%% Summary variables of psychometric fits

Results_Unisensory.A_PSS = Results_A.PSS;
Results_Unisensory.A_SD = Results_A.SD;
Results_Unisensory.A_R2 = Results_A.R2;
Results_Unisensory.A_newx = Results_A.newx;
Results_Unisensory.A_newy = Results_A.newy;

Results_Unisensory.V_PSS = Results_V.PSS;
Results_Unisensory.V_SD = Results_V.SD;
Results_Unisensory.V_R2 = Results_V.R2;
Results_Unisensory.V_newx = Results_V.newx;
Results_Unisensory.V_newy = Results_V.newy;


Results_Multisensory.AV_PSS = vertcat(Results_AV.PSS);
Results_Multisensory.AV_SD = vertcat(Results_AV.SD);
Results_Multisensory.AV_R2 = vertcat(Results_AV.R2);
Results_Multisensory.AV_newx = vertcat(Results_AV.newx);
Results_Multisensory.AV_newy = vertcat(Results_AV.newy);
Results_Multisensory.AV_newx2 = Results_AV(:).newx;

end

%% PsyNorm function
%function F = PSYnorm(x,xdata)

%chance = 0.5; % NLINFIT CANNOT WORK WITH ADDITIONAL VARIABLES
%F = chance * erfc( - (xdata - x(1)) ./ (x(2) * sqrt(2)));

%F = normcdf(xdata, x(1), x(2));

%end

function [Results_MLE] = MLE_Calculations_A_V(AUD_mdl, VIS_mdl, AUD_yData, VIS_yData, AUD_xData, VIS_xData)
% Adopted function of MLE_Calculations_A_V_AV, outputs predicted AV
% variance and weights based solely on the A and V data

% get residuals of unisensory models
AUD_fittedValues = feval(AUD_mdl, AUD_xData);
AUD_residuals = AUD_yData - AUD_fittedValues;
VIS_fittedValues = feval(VIS_mdl, VIS_xData);
VIS_residuals = VIS_yData - VIS_fittedValues;

%get measured AUD and VIS parameters
Results_MLE.AUD_R2 = 1-sum(AUD_residuals.^2)/sum((AUD_yData-mean(AUD_yData)).^2); % R2 = 1 – SSresid / SStotal
Results_MLE.AUD_Mu = AUD_mdl.Coefficients{1, 1};
Results_MLE.AUD_SD = AUD_mdl.Coefficients{2, 1};
Results_MLE.AUD_Variance = Results_MLE.AUD_SD^2;

Results_MLE.VIS_R2 = 1-sum(VIS_residuals.^2)/sum((VIS_yData-mean(VIS_yData)).^2); % R2 = 1 – SSresid / SStotal
Results_MLE.VIS_Mu = VIS_mdl.Coefficients{1, 1};
Results_MLE.VIS_SD = VIS_mdl.Coefficients{2, 1};
Results_MLE.VIS_Variance = Results_MLE.VIS_SD^2;

%Get MLE results
Results_MLE.AUD_Westimate= (1/Results_MLE.AUD_Variance)/((1/Results_MLE.AUD_Variance)+(1/Results_MLE.VIS_Variance));
Results_MLE.VIS_Westimate= (1/Results_MLE.VIS_Variance)/((1/Results_MLE.VIS_Variance)+(1/Results_MLE.AUD_Variance));
Results_MLE.AV_EstimatedVariance=(Results_MLE.AUD_Variance*Results_MLE.VIS_Variance)/(Results_MLE.AUD_Variance+Results_MLE.VIS_Variance);

Results_MLE.AV_EstimatedSD=sqrt(Results_MLE.AV_EstimatedVariance);

Results_MLE

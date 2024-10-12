%% AO VO Group data
clear; close all; clc;

dataAll = readtable('group_cue_data.xlsx',  'Sheet', 'all_AO_VO');

AO_Std = table2array(dataAll(:, 5));
AO_Mu = table2array(dataAll(:, 6));
VO_Std = table2array(dataAll(:, 7));
VO_Mu = table2array(dataAll(:, 8));

% Permutation test to see if two groups are different from each other
[p_std_PERM, observeddifference_stdPERM, effectsize_std_PERM] = permutationTest(AO_Std, VO_Std, 1000, 'plotresult', 1);
[p_mu_PERM, observeddifference_mu_PERM, effectsize_mu_PERM] = permutationTest(AO_Mu, VO_Std, 1000, 'plotresult', 1);

% Testing if distribution is significant from 0
[p_AO_mu, h_AO_mu] = signrank(AO_Mu);
[p_VO_mu, h_VO_mu] = signrank(VO_Mu);

% Difference between two conditions
delta_std = AO_Std - VO_Std;
delta_mu = AO_Mu - VO_Mu;

% Testing for normality in distribution
[h_SW_std, p_SW_std] = swtest(delta_std);
[h_SW_mu, p_SW_mu] = swtest(delta_mu);

% Power calculation for Cohen's D and sample size
[cohens_d_std, required_sample_size_std] = power_calculation(delta_std);
[cohens_d_mu, required_sample_size_mu] = power_calculation(delta_mu);

Cdelta_std = cliffs_delta(AO_Std, VO_Std);
Cdelta_mu = cliffs_delta(AO_Mu, VO_Mu);
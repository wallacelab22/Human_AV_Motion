%% TEST Human Multimodality Figures %%%%%%%%%%
% written on 02/21/23 - Adam Tiesman
clear;
close all;
sca;

% Version info
Version = 'TEST_Human_Visual_v.1.1' ; % after code changes, change version
file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/Psychometric_Function_Plot';
data_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/Psychometric_Function_Plot';
figure_file_directory = '/Users/a.tiesman/Documents/Research/Human_AV_Motion/Psychometric_Function_Plot/Human_Figures';

% Load the experimental data
load("PUT EXP DATA FOR AV TRIAL HERE")

% Provide specific variables
chosen_threshold = 0.72 % Ask Mark about threshold

% Replace all the 0s to 3s for catch trials for splitapply

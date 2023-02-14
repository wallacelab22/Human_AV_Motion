function MAT=at_RDKHoopMatrix_EEGAud(catchtrials,audtrials)

%% fill single columns
%condition definitions 
% variable names: 1. modlaity (a, v, av), 2. direction (l:left; u:up),
% 3.coherence (l:low, m:middle, h:high or ordianl number codes)
% matrix values: auditory direction, auditory coherence, visual direction,
% visual coherence

% catch trials
catchs=[0 0];

% audio [direction coherencelevel]
al1=[2 1];
ar1=[1 1];

al2=[2 2];
ar2=[1 2];

%% create Matrices
%catch trials
catchmat=repmat(catchs, catchtrials, 1);

% audio
matal1=repmat(al1, audtrials, 1);
matar1=repmat(ar1, audtrials, 1);

matal2=repmat(al2, audtrials, 1);
matar2=repmat(ar2, audtrials, 1);

%concatenate all conditions into 1 big matrix
trialStruc= cat(1, catchmat, matal1, matar1, matal2, matar2);

%% define single columns
% add trial order and response recording columns
nbtrials=size(trialStruc(:,1));

resp=zeros(nbtrials(1), 1); % will be randomized
rt=zeros(nbtrials(1), 1); % will be randomized
keys=zeros(nbtrials(1), 1);
%% create trial structure
rng('shuffle');
order=randperm(nbtrials(1));  %new trial order
trialOrder=trialStruc(order, :);

MAT=cat(2, trialOrder, resp, rt, keys);

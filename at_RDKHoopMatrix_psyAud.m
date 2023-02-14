function MAT=at_RDKHoopMatrix_psyAud(catchtrials,audtrials)

%% fill single columns
%condition definitions 
% variable names: 1. modlaity (a, v, av), 2. direction (l:left; u:up),
% 3.coherence (l:low, m:middle, h:high or ordianl number codes)
% matrix values: auditory direction, auditory coherence, visual direction,
% visual coherence

% catch trials
catchs=[0 0];

% visual [direction coherencelevel]
al1=[2 1];
ar1=[1 1];

al2=[2 2];
ar2=[1 2];

al3=[2 3];
ar3=[1 3];

al4=[2 4];
ar4=[1 4];

al5=[2 5];
ar5=[1 5];

%% create Matrices
%catch trials
catchmat=repmat(catchs, catchtrials, 1);

% visual
matal1=repmat(al1, audtrials, 1);
matar1=repmat(ar1, audtrials, 1);

matal2=repmat(al2, audtrials, 1);
matar2=repmat(ar2, audtrials, 1);

matal3=repmat(al3, audtrials, 1);
matar3=repmat(ar3, audtrials, 1);

matal4=repmat(al4, audtrials, 1);
matar4=repmat(ar4, audtrials, 1);

matal5=repmat(al5, audtrials, 1);
matar5=repmat(ar5, audtrials, 1);

%concatenate all conditions into 1 big matrix
trialStruc= cat(1, catchmat, matal1, matar1, matal2, matar2, matal3, matar3, matal4, matar4, matal5, matar5);

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

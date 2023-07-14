function MAT=at_RDKHoopMatrix_psyVis(catchtrials,vistrials)

%% fill single columns
%condition definitions 
% variable names: 1. modlaity (a, v, av), 2. direction (l:left; u:up),
% 3.coherence (l:low, m:middle, h:high or ordianl number codes)
% matrix values: auditory direction, auditory coherence, visual direction,
% visual coherence

% catch trials
catchs=[0 0];%direction, intensity/coherence level

% visual [direction coherencelevel]
vl1=[2 1]; %visual left 1..
vr1=[1 1];

vl2=[2 2];
vr2=[1 2];

vl3=[2 3];
vr3=[1 3];

vl4=[2 4];
vr4=[1 4];

vl5=[2 5];
vr5=[1 5];

vl6=[2 6];
vr6=[1 6];

vl7=[2 7];
vr7=[1 7];

%% create Matrices
%catch trials
catchmat=repmat(catchs, catchtrials, 1);

% visual
matvl1=repmat(vl1, vistrials, 1);
matvr1=repmat(vr1, vistrials, 1);

matvl2=repmat(vl2, vistrials, 1);
matvr2=repmat(vr2, vistrials, 1);

matvl3=repmat(vl3, vistrials, 1);
matvr3=repmat(vr3, vistrials, 1);

matvl4=repmat(vl4, vistrials, 1);
matvr4=repmat(vr4, vistrials, 1);

matvl5=repmat(vl5, vistrials, 1);
matvr5=repmat(vr5, vistrials, 1);

matvl6=repmat(vl6, vistrials, 1);
matvr6=repmat(vr6, vistrials, 1);

matvl7=repmat(vl7, vistrials, 1);
matvr7=repmat(vr7, vistrials, 1);

%concatenate all conditions into 1 big matrix
trialStruc= cat(1, catchmat, matvl1, matvr1, matvl2, matvr2, matvl3, matvr3, matvl4, matvr4, matvl5, matvr5, matvl6, matvr6, matvl7, matvr7);

%% define single columns
% add trial order and response recording columns
nbtrials=size(trialStruc(:,1));

resp=zeros(nbtrials(1), 1); % will be randomized %add a column where recording response and key press
rt=zeros(nbtrials(1), 1); % will be randomized
keys=zeros(nbtrials(1), 1);
%% create trial structure
rng('shuffle');
order=randperm(nbtrials(1));  %new trial order
trialOrder=trialStruc(order, :);

MAT=cat(2, trialOrder, resp, rt, keys);

function MAT=at_RDKHoopMatrix_psyAVexample(catchtrials, vistrials, audtrials, mstrials)

%% fill single columns
% catch trials
catchs=[0 0 0 0];

% visual [direction coherencelevel]
vl1=[0 0 2 1];
vr1=[0 0 1 1];

% auditory [direction coherencelevel]
al1=[2 1 0 0];
ar1=[1 1 0 0];


% multisensory [auditory visual]
al1vl1=[2 1 2 1]; % congreunt
ar1vr1=[1 1 1 1];

al1vr1=[2 1 1 1]; %incongreunt
ar1vl1=[1 1 2 1];


%% create Matrices
%catch trials
catchmat=repmat(catchs, catchtrials, 1);

% visual
matvl1=repmat(vl1, vistrials, 1);
matvr1=repmat(vr1, vistrials, 1);

% auditory
matal1=repmat(al1, audtrials, 1);
matar1=repmat(ar1, audtrials, 1);


% multisensory
% Auditory level 1
matal1vl1=repmat(al1vl1, mstrials, 1); % congreunt
matar1vr1=repmat(ar1vr1, mstrials, 1);

matal1vr1=repmat(al1vr1, mstrials, 1); %incongreunt
matar1vl1=repmat(ar1vl1, mstrials, 1);
%concatenate all conditions into 1 big matrix
trialStruc= cat(1, catchmat, matvl1, matvr1, matal1, matar1,matal1vl1, matar1vr1, matal1vr1, matar1vl1);

%% define single columns
% add trial order and response recording columns
nbtrials=size(trialStruc(:,1));

resp=zeros(nbtrials(1), 1); % will be randomized
rt=zeros(nbtrials(1), 1); % will be randomized
keys=zeros(nbtrials(1), 1);
%% create trial structure

MAT=cat(2, trialStruc, resp, rt, keys);

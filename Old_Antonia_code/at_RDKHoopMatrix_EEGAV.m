function MAT=at_RDKHoopMatrix_EEGAV(catchtrials, vistrials, audtrials, msfreq, msinfreq)

%% fill single columns
% catch trials
catchs=[0 0 0 0];

% visual [direction coherencelevel]
vl1=[0 0 2 1];
vr1=[0 0 1 1];

vl2=[0 0 2 2];
vr2=[0 0 1 2];

% auditory [direction coherencelevel]
al1=[2 1 0 0];
ar1=[1 1 0 0];

al2=[2 2 0 0];
ar2=[1 2 0 0];


% multisensory [auditory visual]
% Auditory level 1
al1vl1=[2 1 2 1]; % congreunt
ar1vr1=[1 1 1 1];

al1vr1=[2 1 1 1]; %incongreunt
ar1vl1=[1 1 2 1];

al1vl2=[2 1 2 2]; % congreunt
ar1vr2=[1 1 1 2];

al1vr2=[2 1 1 2]; %incongreunt
ar1vl2=[1 1 2 2];

% Auditory level 2
al2vl1=[2 2 2 1]; % congreunt
ar2vr1=[1 2 1 1];

al2vr1=[2 2 1 1]; %incongreunt
ar2vl1=[1 2 2 1];

al2vl2=[2 2 2 2]; % congreunt
ar2vr2=[1 2 1 2];

al2vr2=[2 2 1 2]; %incongreunt
ar2vl2=[1 2 2 2];

%% create Matrices
%catch trials
catchmat=repmat(catchs, catchtrials, 1);

% visual
matvl1=repmat(vl1, vistrials, 1);
matvr1=repmat(vr1, vistrials, 1);

matvl2=repmat(vl2, vistrials, 1);
matvr2=repmat(vr2, vistrials, 1);

% auditory
matal1=repmat(al1, audtrials, 1);
matar1=repmat(ar1, audtrials, 1);

matal2=repmat(al2, audtrials, 1);
matar2=repmat(ar2, audtrials, 1);


% multisensory
% Auditory level 1
matal1vl1=repmat(al1vl1, msfreq, 1); % congreunt
matar1vr1=repmat(ar1vr1, msfreq, 1);

matal1vr1=repmat(al1vr1, msfreq, 1); %incongreunt
matar1vl1=repmat(ar1vl1, msfreq, 1);

matal1vl2=repmat(al1vl2, msfreq, 1); % congreunt
matar1vr2=repmat(ar1vr2, msfreq, 1);

matal1vr2=repmat(al1vr2, msfreq, 1); %incongreunt
matar1vl2=repmat(ar1vl2, msfreq, 1);

% Auditory level 2
matal2vl1=repmat(al2vl1, msinfreq, 1); % congreunt
matar2vr1=repmat(ar2vr1, msinfreq, 1);

matal2vr1=repmat(al2vr1, msinfreq, 1); %incongreunt
matar2vl1=repmat(ar2vl1, msinfreq, 1);

matal2vl2=repmat(al2vl2, msinfreq, 1); % congreunt
matar2vr2=repmat(ar2vr2, msinfreq, 1);

matal2vr2=repmat(al2vr2, msinfreq, 1); %incongreunt
matar2vl2=repmat(ar2vl2, msinfreq, 1);

%concatenate all conditions into 1 big matrix
trialStruc= cat(1, catchmat, matvl1, matvr1, matvl2, matvr2, matal1, matar1, matal2, matar2, matal1vl1, matar1vr1, matal1vr1, matar1vl1, matal2vl1, matar2vr1, matal2vr1, matar2vl1,  matal1vl2, matar1vr2, matal1vr2, matar1vl2, matal2vl2, matar2vr2, matal2vr2, matar2vl2);

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

function MAT=at_RDKexperimentdesignmatrix(catchtrials,vistrials, audtrials, mstrials)

%% fill single columns
%condition definitions 
% variable names: 1. modlaity (a, v, av), 2. direction (l:left; u:up),
% 3.coherence (l:low, m:middle, h:high or ordianl number codes)
% matrix values: auditory direction, auditory coherence, visual direction,
% visual coherence

% catch trials
catchs=[0 0 0 0];

% visual-only 
vll=[0 0 1 1];
vrl=[0 0 2 1];

vlh=[0 0 1 2];
vrh=[0 0 2 2];

% auditory-only
al1=[1 1 0 0];
ar1=[2 1 0 0];

al2=[1 2 0 0];
ar2=[2 2 0 0];

al3=[1 3 0 0];
ar3=[2 3 0 0];

al4=[1 4 0 0];
ar4=[2 4 0 0];

al5=[1 5 0 0];
ar5=[2 5 0 0];

%multisensory trials
% auditory coherence 1
al1vll=[1 1 1 1];
al1vrl=[1 1 2 1];

al1vlh=[1 1 1 2];
al1vrh=[1 1 2 2];

ar1vll=[2 1 1 1];
ar1vrl=[2 1 2 1];

ar1vlh=[2 1 1 2];
ar1vrh=[2 1 2 2];

% auditory coherence 2
al2vll=[1 2 1 1];
al2vrl=[1 2 2 1];

al2vlh=[1 2 1 2];
al2vrh=[1 2 2 2];

ar2vll=[2 2 1 1];
ar2vrl=[2 2 2 1];

ar2vlh=[2 2 1 2];
ar2vrh=[2 2 2 2];

% auditory coherence 3
al3vll=[1 3 1 1];
al3vrl=[1 3 2 1];

al3vlh=[1 3 1 2];
al3vrh=[1 3 2 2];

ar3vll=[2 3 1 1];
ar3vrl=[2 3 2 1];

ar3vlh=[2 3 1 2];
ar3vrh=[2 3 2 2];

% auditory coherence 4
al4vll=[1 4 1 1];
al4vrl=[1 4 2 1];

al4vlh=[1 4 1 2];
al4vrh=[1 4 2 2];

ar4vll=[2 4 1 1];
ar4vrl=[2 4 2 1];

ar4vlh=[2 4 1 2];
ar4vrh=[2 4 2 2];

% auditory coherence 5
al5vll=[1 5 1 1];
al5vrl=[1 5 2 1];

al5vlh=[1 5 1 2];
al5vrh=[1 5 2 2];

ar5vll=[2 5 1 1];
ar5vrl=[2 5 2 1];

ar5vlh=[2 5 1 2];
ar5vrh=[2 5 2 2];

%% create Matrices
%catch trials
catchmat=repmat(catchs, catchtrials, 1);

% visual-only
matvll=repmat(vll, vistrials, 1);
matvrl=repmat(vrl, vistrials, 1);

matvlh=repmat(vlh, vistrials, 1);
matvrh=repmat(vrh, vistrials, 1);

% auditory-only
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

%multisensory trials
% auditory coherence 1
matal1vll=repmat(al1vll, mstrials, 1);
matal1vrl=repmat(al1vrl, mstrials, 1);
matal1vlh=repmat(al1vlh, mstrials, 1);
matal1vrh=repmat(al1vrh, mstrials, 1);

matar1vll=repmat(ar1vll, mstrials, 1);
matar1vrl=repmat(ar1vrl, mstrials, 1);
matar1vlh=repmat(ar1vlh, mstrials, 1);
matar1vrh=repmat(ar1vrh, mstrials, 1);

% auditory coherence 2
matal2vll=repmat(al2vll, mstrials, 1);
matal2vrl=repmat(al2vrl, mstrials, 1);
matal2vlh=repmat(al2vlh, mstrials, 1);
matal2vrh=repmat(al2vrh, mstrials, 1);

matar2vll=repmat(ar2vll, mstrials, 1);
matar2vrl=repmat(ar2vrl, mstrials, 1);
matar2vlh=repmat(ar2vlh, mstrials, 1);
matar2vrh=repmat(ar2vrh, mstrials, 1);

% auditory coherence 3
matal3vll=repmat(al3vll, mstrials, 1);
matal3vrl=repmat(al3vrl, mstrials, 1);
matal3vlh=repmat(al3vlh, mstrials, 1);
matal3vrh=repmat(al3vrh, mstrials, 1);

matar3vll=repmat(ar3vll, mstrials, 1);
matar3vrl=repmat(ar3vrl, mstrials, 1);
matar3vlh=repmat(ar3vlh, mstrials, 1);
matar3vrh=repmat(ar3vrh, mstrials, 1);

% auditory coherence 4
matal4vll=repmat(al4vll, mstrials, 1);
matal4vrl=repmat(al4vrl, mstrials, 1);
matal4vlh=repmat(al4vlh, mstrials, 1);
matal4vrh=repmat(al4vrh, mstrials, 1);

matar4vll=repmat(ar4vll, mstrials, 1);
matar4vrl=repmat(ar4vrl, mstrials, 1);
matar4vlh=repmat(ar4vlh, mstrials, 1);
matar4vrh=repmat(ar4vrh, mstrials, 1);

% auditory coherence 5
matal5vll=repmat(al5vll, mstrials, 1);
matal5vrl=repmat(al5vrl, mstrials, 1);
matal5vlh=repmat(al5vlh, mstrials, 1);
matal5vrh=repmat(al5vrh, mstrials, 1);

matar5vll=repmat(ar5vll, mstrials, 1);
matar5vrl=repmat(ar5vrl, mstrials, 1);
matar5vlh=repmat(ar5vlh, mstrials, 1);
matar5vrh=repmat(ar5vrh, mstrials, 1);

%concatenate all conditions into 1 big matrix
trialStruc= cat(1, catchmat, matvll, matvrl, matvlh, matvrh, matal1, matar1, matal2, matar2, matal3, matar3, matal4, matar4, matal5, matar5, matal1vll, matal1vrl, matal1vlh, matal1vrh, matar1vll, matar1vrl, matar1vlh, matar1vrh, matal2vll, matal2vrl, matal2vlh, matal2vrh, matar2vll, matar2vrl, matar2vlh, matar2vrh, matal3vll, matal3vrl, matal3vlh, matal3vrh, matar3vll, matar3vrl, matar3vlh, matar3vrh, matal4vll, matal4vrl, matal4vlh, matal4vrh, matar4vll, matar4vrl, matar4vlh, matar4vrh, matal5vll, matal5vrl, matal5vlh, matal5vrh, matar5vll, matar5vrl,  matar5vlh, matar5vrh);

%% define single columns
% add trial order and response recording columns
nbtrials=size(trialStruc(:,1));

resp=zeros(nbtrials(1), 1); % will be randomized
rt=zeros(nbtrials(1), 1); % will be randomized
keys=zeros(nbtrials(1), 1);
%% create trial structure
rng('default');
rng('shuffle');
order=randperm(nbtrials(1));  %new trial order
trialOrder=trialStruc(order, :);

MAT=cat(2, trialOrder, resp, rt, keys);

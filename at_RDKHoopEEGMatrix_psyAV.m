function MAT=at_RDKHoopEEGMatrix_psyAV(catchtrials, vistrials, audtrials, mstrials)

%% fill single columns
% catch trials
catchs=[0 0 0 0];

% visual [direction coherencelevel]
vl1=[0 0 2 1];
vr1=[0 0 1 1];

vl2=[0 0 2 2];
vr2=[0 0 1 2];

vl3=[0 0 2 3];
vr3=[0 0 1 3];

vl4=[0 0 2 4];
vr4=[0 0 1 4];

vl5=[0 0 2 5];
vr5=[0 0 1 5];

% auditory [direction coherencelevel]
al1=[2 1 0 0];
ar1=[1 1 0 0];

al2=[2 2 0 0];
ar2=[1 2 0 0];

al3=[2 3 0 0];
ar3=[1 3 0 0];

al4=[2 4 0 0];
ar4=[1 4 0 0];

al5=[2 5 0 0];
ar5=[1 5 0 0];

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

al1vl3=[2 1 2 3]; % congreunt
ar1vr3=[1 1 1 3];

al1vr3=[2 1 1 3]; %incongreunt
ar1vl3=[1 1 2 3];

al1vl4=[2 1 2 4]; % congreunt
ar1vr4=[1 1 1 4];

al1vr4=[2 1 1 4]; %incongreunt
ar1vl4=[1 1 2 4];

al1vl5=[2 1 2 5]; % congreunt
ar1vr5=[1 1 1 5];

al1vr5=[2 1 1 5]; %incongreunt
ar1vl5=[1 1 2 5];

% Auditory level 2
al2vl1=[2 2 2 1]; % congreunt
ar2vr1=[1 2 1 1];

al2vr1=[2 2 1 1]; %incongreunt
ar2vl1=[1 2 2 1];

al2vl2=[2 2 2 2]; % congreunt
ar2vr2=[1 2 1 2];

al2vr2=[2 2 1 2]; %incongreunt
ar2vl2=[1 2 2 2];

al2vl3=[2 2 2 3]; % congreunt
ar2vr3=[1 2 1 3];

al2vr3=[2 2 1 3]; %incongreunt
ar2vl3=[1 2 2 3];

al2vl4=[2 2 2 4]; % congreunt
ar2vr4=[1 2 1 4];

al2vr4=[2 2 1 4]; %incongreunt
ar2vl4=[1 2 2 4];

al2vl5=[2 2 2 5]; % congreunt
ar2vr5=[1 2 1 5];

al2vr5=[2 2 1 5]; %incongreunt
ar2vl5=[1 2 2 5];

% Auditory level 3
al3vl1=[2 3 2 1]; % congreunt
ar3vr1=[1 3 1 1];

al3vr1=[2 3 1 1]; %incongreunt
ar3vl1=[1 3 2 1];

al3vl2=[2 3 2 2]; % congreunt
ar3vr2=[1 3 1 2];

al3vr2=[2 3 1 2]; %incongreunt
ar3vl2=[1 3 2 2];

al3vl3=[2 3 2 3]; % congreunt
ar3vr3=[1 3 1 3];

al3vr3=[2 3 1 3]; %incongreunt
ar3vl3=[1 3 2 3];

al3vl4=[2 3 2 4]; % congreunt
ar3vr4=[1 3 1 4];

al3vr4=[2 3 1 4]; %incongreunt
ar3vl4=[1 3 2 4];

al3vl5=[2 3 2 5]; % congreunt
ar3vr5=[1 3 1 5];

al3vr5=[2 3 1 5]; %incongreunt
ar3vl5=[1 3 2 5];

% Auditory level 4
al4vl1=[2 4 2 1]; % congreunt
ar4vr1=[1 4 1 1];

al4vr1=[2 4 1 1]; %incongreunt
ar4vl1=[1 4 2 1];

al4vl2=[2 4 2 2]; % congreunt
ar4vr2=[1 4 1 2];

al4vr2=[2 4 1 2]; %incongreunt
ar4vl2=[1 4 2 2];

al4vl3=[2 4 2 3]; % congreunt
ar4vr3=[1 4 1 3];

al4vr3=[2 4 1 3]; %incongreunt
ar4vl3=[1 4 2 3];

al4vl4=[2 4 2 4]; % congreunt
ar4vr4=[1 4 1 4];

al4vr4=[2 4 1 4]; %incongreunt
ar4vl4=[1 4 2 4];

al4vl5=[2 4 2 5]; % congreunt
ar4vr5=[1 4 1 5];

al4vr5=[2 4 1 5]; %incongreunt
ar4vl5=[1 4 2 5];

% Auditory level 5
al5vl1=[2 5 2 1]; % congreunt
ar5vr1=[1 5 1 1];

al5vr1=[2 5 1 1]; %incongreunt
ar5vl1=[1 5 2 1];

al5vl2=[2 5 2 2]; % congreunt
ar5vr2=[1 5 1 2];

al5vr2=[2 5 1 2]; %incongreunt
ar5vl2=[1 5 2 2];

al5vl3=[2 5 2 3]; % congreunt
ar5vr3=[1 5 1 3];

al5vr3=[2 5 1 3]; %incongreunt
ar5vl3=[1 5 2 3];

al5vl4=[2 5 2 4]; % congreunt
ar5vr4=[1 5 1 4];

al5vr4=[2 5 1 4]; %incongreunt
ar5vl4=[1 5 2 4];

al5vl5=[2 5 2 5]; % congreunt
ar5vr5=[1 5 1 5];

al5vr5=[2 5 1 5]; %incongreunt
ar5vl5=[1 5 2 5];
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

% auditory
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


% multisensory
% Auditory level 1
matal1vl1=repmat(al1vl1, mstrials, 1); % congreunt
matar1vr1=repmat(ar1vr1, mstrials, 1);

matal1vr1=repmat(al1vr1, mstrials, 1); %incongreunt
matar1vl1=repmat(ar1vl1, mstrials, 1);

matal1vl2=repmat(al1vl2, mstrials, 1); % congreunt
matar1vr2=repmat(ar1vr2, mstrials, 1);

matal1vr2=repmat(al1vr2, mstrials, 1); %incongreunt
matar1vl2=repmat(ar1vl2, mstrials, 1);

matal1vl3=repmat(al1vl3, mstrials, 1); % congreunt
matar1vr3=repmat(ar1vr3, mstrials, 1);

matal1vr3=repmat(al1vr3, mstrials, 1); %incongreunt
matar1vl3=repmat(ar1vl3, mstrials, 1);

matal1vl4=repmat(al1vl4, mstrials, 1); % congreunt
matar1vr4=repmat(ar1vr4, mstrials, 1);

matal1vr4=repmat(al1vr4, mstrials, 1); %incongreunt
matar1vl4=repmat(ar1vl4, mstrials, 1);

matal1vl5=repmat(al1vl5, mstrials, 1); % congreunt
matar1vr5=repmat(ar1vr5, mstrials, 1);

matal1vr5=repmat(al1vr5, mstrials, 1); %incongreunt
matar1vl5=repmat(ar1vl5, mstrials, 1);

% Auditory level 2
matal2vl1=repmat(al2vl1, mstrials, 1); % congreunt
matar2vr1=repmat(ar2vr1, mstrials, 1);

matal2vr1=repmat(al2vr1, mstrials, 1); %incongreunt
matar2vl1=repmat(ar2vl1, mstrials, 1);

matal2vl2=repmat(al2vl2, mstrials, 1); % congreunt
matar2vr2=repmat(ar2vr2, mstrials, 1);

matal2vr2=repmat(al2vr2, mstrials, 1); %incongreunt
matar2vl2=repmat(ar2vl2, mstrials, 1);

matal2vl3=repmat(al2vl3, mstrials, 1); % congreunt
matar2vr3=repmat(ar2vr3, mstrials, 1);

matal2vr3=repmat(al2vr3, mstrials, 1); %incongreunt
matar2vl3=repmat(ar2vl3, mstrials, 1);

matal2vl4=repmat(al2vl4, mstrials, 1); % congreunt
matar2vr4=repmat(ar2vr4, mstrials, 1);

matal2vr4=repmat(al2vr4, mstrials, 1); %incongreunt
matar2vl4=repmat(ar2vl4, mstrials, 1);

matal2vl5=repmat(al2vl5, mstrials, 1); % congreunt
matar2vr5=repmat(ar2vr5, mstrials, 1);

matal2vr5=repmat(al2vr5, mstrials, 1); %incongreunt
matar2vl5=repmat(ar2vl5, mstrials, 1);

% Auditory level 3
matal3vl1=repmat(al3vl1, mstrials, 1); % congreunt
matar3vr1=repmat(ar3vr1, mstrials, 1);

matal3vr1=repmat(al3vr1, mstrials, 1); %incongreunt
matar3vl1=repmat(ar3vl1, mstrials, 1);

matal3vl2=repmat(al3vl2, mstrials, 1); % congreunt
matar3vr2=repmat(ar3vr2, mstrials, 1);

matal3vr2=repmat(al3vr2, mstrials, 1); %incongreunt
matar3vl2=repmat(ar3vl2, mstrials, 1);

matal3vl3=repmat(al3vl3, mstrials, 1); % congreunt
matar3vr3=repmat(ar3vr3, mstrials, 1);

matal3vr3=repmat(al3vr3, mstrials, 1); %incongreunt
matar3vl3=repmat(ar3vl3, mstrials, 1);

matal3vl4=repmat(al3vl4, mstrials, 1); % congreunt
matar3vr4=repmat(ar3vr4, mstrials, 1);

matal3vr4=repmat(al3vr4, mstrials, 1); %incongreunt
matar3vl4=repmat(ar3vl4, mstrials, 1);

matal3vl5=repmat(al3vl5, mstrials, 1); % congreunt
matar3vr5=repmat(ar3vr5, mstrials, 1);

matal3vr5=repmat(al3vr5, mstrials, 1); %incongreunt
matar3vl5=repmat(ar3vl5, mstrials, 1);

% Auditory level 4
matal4vl1=repmat(al4vl1, mstrials, 1); % congreunt
matar4vr1=repmat(ar4vr1, mstrials, 1);

matal4vr1=repmat(al4vr1, mstrials, 1); %incongreunt
matar4vl1=repmat(ar4vl1, mstrials, 1);

matal4vl2=repmat(al4vl2, mstrials, 1); % congreunt
matar4vr2=repmat(ar4vr2, mstrials, 1);

matal4vr2=repmat(al4vr2, mstrials, 1); %incongreunt
matar4vl2=repmat(ar4vl2, mstrials, 1);

matal4vl3=repmat(al4vl3, mstrials, 1); % congreunt
matar4vr3=repmat(ar4vr3, mstrials, 1);

matal4vr3=repmat(al4vr3, mstrials, 1); %incongreunt
matar4vl3=repmat(ar4vl3, mstrials, 1);

matal4vl4=repmat(al4vl4, mstrials, 1); % congreunt
matar4vr4=repmat(ar4vr4, mstrials, 1);

matal4vr4=repmat(al4vr4, mstrials, 1); %incongreunt
matar4vl4=repmat(ar4vl4, mstrials, 1);

matal4vl5=repmat(al4vl5, mstrials, 1); % congreunt
matar4vr5=repmat(ar4vr5, mstrials, 1);

matal4vr5=repmat(al4vr5, mstrials, 1); %incongreunt
matar4vl5=repmat(ar4vl5, mstrials, 1);

% Auditory level 5
matal5vl1=repmat(al5vl1, mstrials, 1); % congreunt
matar5vr1=repmat(ar5vr1, mstrials, 1);

matal5vr1=repmat(al5vr1, mstrials, 1); %incongreunt
matar5vl1=repmat(ar5vl1, mstrials, 1);

matal5vl2=repmat(al5vl2, mstrials, 1); % congreunt
matar5vr2=repmat(ar5vr2, mstrials, 1);

matal5vr2=repmat(al5vr2, mstrials, 1); %incongreunt
matar5vl2=repmat(ar5vl2, mstrials, 1);

matal5vl3=repmat(al5vl3, mstrials, 1); % congreunt
matar5vr3=repmat(ar5vr3, mstrials, 1);

matal5vr3=repmat(al5vr3, mstrials, 1); %incongreunt
matar5vl3=repmat(ar5vl3, mstrials, 1);

matal5vl4=repmat(al5vl4, mstrials, 1); % congreunt
matar5vr4=repmat(ar5vr4, mstrials, 1);

matal5vr4=repmat(al5vr4, mstrials, 1); %incongreunt
matar5vl4=repmat(ar5vl4, mstrials, 1);

matal5vl5=repmat(al5vl5, mstrials, 1); % congreunt
matar5vr5=repmat(ar5vr5, mstrials, 1);

matal5vr5=repmat(al5vr5, mstrials, 1); %incongreunt
matar5vl5=repmat(ar5vl5, mstrials, 1);

%concatenate all conditions into 1 big matrix
trialStruc= cat(1, catchmat, matvl1, matvr1, matvl2, matvr2, matvl3, matvr3, matvl4, matvr4, matvl5, matvr5, matal1, matar1, matal2, matar2, matal3, matar3, matal4, matar4, matal5, matar5, matal1vl1, matar1vr1, matal1vr1, matar1vl1, matal2vl1, matar2vr1, matal2vr1, matar2vl1, matal3vl1, matar3vr1, matal3vr1, matar3vl1, matal4vl1, matar4vr1, matal4vr1, matar4vl1, matal5vl1, matar5vr1, matal5vr1, matar5vl1, matal1vl2, matar1vr2, matal1vr2, matar1vl2, matal2vl2, matar2vr2, matal2vr2, matar2vl2, matal3vl2, matar3vr2, matal3vr2, matar3vl2, matal4vl2, matar4vr2, matal4vr2, matar4vl2, matal5vl2, matar5vr2, matal5vr2, matar5vl2,matal1vl3, matar1vr3, matal1vr3, matar1vl3, matal2vl3, matar2vr3, matal2vr3, matar2vl3, matal3vl3, matar3vr3, matal3vr3, matar3vl3, matal4vl3, matar4vr3, matal4vr3, matar4vl3, matal5vl3, matar5vr3, matal5vr3, matar5vl3,matal1vl4, matar1vr4, matal1vr4, matar1vl4, matal2vl4, matar2vr4, matal2vr4, matar2vl4, matal3vl4, matar3vr4, matal3vr4, matar3vl4, matal4vl4, matar4vr4, matal4vr4, matar4vl4, matal5vl4, matar5vr4, matal5vr4, matar5vl4,matal1vl5, matar1vr5, matal1vr5, matar1vl5, matal2vl5, matar2vr5, matal2vr5, matar2vl5, matal3vl5, matar3vr5, matal3vr5, matar3vl5, matal4vl5, matar4vr5, matal4vr5, matar4vl5, matal5vl5, matar5vr5, matal5vr5, matar5vl5);

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

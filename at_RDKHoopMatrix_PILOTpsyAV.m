function MAT=at_RDKHoopMatrix_PILOTpsyAV(catchtrials, vistrials, audtrials, mstrials)
%% fill single columns
% catch trials
catchs=[0 0 0 0];

% multisensory [auditory visual]
% Auditory and Visual level 1
al1vl1=[2 1 2 1]; % congreunt
ar1vr1=[1 1 1 1];

al1vr1=[2 1 1 1]; % incongreunt
ar1vl1=[1 1 2 1];

% Auditory and Visual level 2
al2vl2=[2 2 2 2]; % congreunt
ar2vr2=[1 2 1 2];

al2vr2=[2 2 1 2]; % incongreunt
ar2vl2=[1 2 2 2];

% Auditory and Visual level 3
al3vl3=[2 3 2 3]; % congreunt
ar1vr1=[1 3 1 3];

al3vr3=[2 3 1 3]; % incongreunt
ar3vl3=[1 3 2 3];

% Auditory and Visual level 4
al4vl4=[2 4 2 4]; % congreunt
ar1vr1=[1 4 1 4];

al4vr4=[2 4 1 4]; % incongreunt
ar4vl4=[1 4 2 4];

% Auditory and Visual level 5
al5vl5=[2 5 2 5]; % congreunt
ar1vr1=[1 5 1 5];

al5vr5=[2 5 1 5]; % incongreunt
ar5vl5=[1 5 2 5];

% Auditory and Visual level 6
al1vl1=[2 6 2 6]; % congreunt
ar1vr1=[1 6 1 6];

al6vr6=[2 6 1 6]; % incongreunt
ar6vl6=[1 6 2 6];

% Auditory and Visual level 7
al7vl7=[2 7 2 7]; % congreunt
ar7vr7=[1 7 1 7];

al7vr7=[2 7 1 7]; % incongreunt
ar7vl7=[1 7 2 7];

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

matal6=repmat(al6, audtrials, 1);
matar6=repmat(ar6, audtrials, 1);

matal7=repmat(al7, audtrials, 1);
matar7=repmat(ar7, audtrials, 1);

% multisensory
% Auditory and Visual level 1
matal1vl1=repmat(al1vl1, mstrials, 1); % congreunt
matar1vr1=repmat(ar1vr1, mstrials, 1);

matal1vr1=repmat(al1vr1, mstrials, 1); %incongreunt
matar1vl1=repmat(ar1vl1, mstrials, 1);

% Auditory and Visual level 2
matal2vl2=repmat(al2vl2, mstrials, 1); % congreunt
matar2vr2=repmat(ar2vr2, mstrials, 1);

matal2vr2=repmat(al2vr2, mstrials, 1); %incongreunt
matar2vl2=repmat(ar2vl2, mstrials, 1);

% Auditory and Visual level 3
matal3vl3=repmat(al3vl3, mstrials, 1); % congreunt
matar3vr3=repmat(ar3vr3, mstrials, 1);

matal3vr3=repmat(al3vr3, mstrials, 1); %incongreunt
matar3vl3=repmat(ar3vl3, mstrials, 1);

% Auditory and Visual level 4

matal4vl4=repmat(al4vl4, mstrials, 1); % congreunt
matar4vr4=repmat(ar4vr4, mstrials, 1);

matal4vr4=repmat(al4vr4, mstrials, 1); %incongreunt
matar4vl4=repmat(ar4vl4, mstrials, 1);

% Auditory and Visual level 5
matal5vl5=repmat(al5vl5, mstrials, 1); % congreunt
matar5vr5=repmat(ar5vr5, mstrials, 1);

matal5vr5=repmat(al5vr5, mstrials, 1); %incongreunt
matar5vl5=repmat(ar5vl5, mstrials, 1);

% Auditory and Visual level 6
matal6vl6=repmat(al6vl6, mstrials, 1); % congreunt
matar6vr6=repmat(ar6vr6, mstrials, 1);

matal6vr6=repmat(al6vr6, mstrials, 1); %incongreunt
matar6vl6=repmat(ar6vl6, mstrials, 1);

% Auditory and Visual level 7
matal7vl7=repmat(al7vl7, mstrials, 1); % congreunt
matar7vr7=repmat(ar7vr7, mstrials, 1);

matal7vr7=repmat(al7vr7, mstrials, 1); %incongreunt
matar7vl7=repmat(ar7vl7, mstrials, 1);

%concatenate all conditions into 1 big matrix
trialStruc= cat(1, catchmat,...
    matal1vl1, matar1vr1, matal1vr1, matar1vl1,...
    matal2vl2, matar2vr2, matal2vr2, matar2vl2,...
    matal3vl3, matar3vr3, matal3vr3, matar3vl3,...
    matal4vl4, matar4vr4, matal4vr4, matar4vl4,...
    matal5vl5, matar5vr5, matal5vr5, matar5vl5,...
    matal6vl6, matar6vr6, matal6vr6, matar6vl6,...
    matal7vl7, matar7vr7, matal7vr7, matar7vl7);

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

end
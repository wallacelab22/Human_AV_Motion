function MAT=at_RDKHoopMatrix_PILOTpsyAV(catchtrials, congruent_mstrials, incongruent_mstrials)

catchtrials = 25; congruent_mstrials = 30; incongruent_mstrials = 3;

%% fill single columns
% catch trials
catchs=[0 0 0 0];

% multisensory [auditory visual]
% Auditory and Visual level 1
al1vl1=[2 0.5 2 0.5]; % congreunt
ar1vr1=[1 0.5 1 0.5];

al1vr1=[2 0.5 1 0.5]; % incongruent
ar1vl1=[1 0.5 2 0.5];

% Auditory and Visual level 2
al2vl2=[2 0.3536 2 0.3536]; % congreunt
ar2vr2=[1 0.3536 1 0.3536];

al2vr2=[2 0.3536 1 0.3536]; % incongruent
ar2vl2=[1 0.3536 2 0.3536];

% Auditory and Visual level 3
al3vl3=[2 0.25 2 0.25]; % congreunt
ar3vr3=[1 0.25 1 0.25];

al3vr3=[2 0.25 1 0.25]; % incongruent
ar3vl3=[1 0.25 2 0.25];

% Auditory and Visual level 4
al4vl4=[2 0.1768 2 0.1768]; % congreunt
ar4vr4=[1 0.1768 1 0.1768];

al4vr4=[2 0.1768 1 0.1768]; % incongruent
ar4vl4=[1 0.1768 2 0.1768];

% Auditory and Visual level 5
al5vl5=[2 0.125 2 0.125]; % congreunt
ar5vr5=[1 0.125 1 0.125];

al5vr5=[2 0.125 1 0.125]; % incongruent
ar5vl5=[1 0.125 2 0.125];

% Auditory and Visual level 6
al6vl6=[2 0.0884 2 0.0884]; % congreunt
ar6vr6=[1 0.0884 1 0.0884];

al6vr6=[2 0.0884 1 0.0884]; % incongruent
ar6vl6=[1 0.0884 2 0.0884];

% Auditory and Visual level 7
al7vl7=[2 0.0625 2 0.0625]; % congreunt
ar7vr7=[1 0.0625 1 0.0625];

al7vr7=[2 0.0625 1 0.0625]; % incongruent
ar7vl7=[1 0.0625 2 0.0625];

%% create Matrices
%catch trials
catchmat=repmat(catchs, catchtrials, 1);

% multisensory
% Auditory and Visual level 1
matal1vl1=repmat(al1vl1, congruent_mstrials, 1); % congreunt
matar1vr1=repmat(ar1vr1, congruent_mstrials, 1);

matal1vr1=repmat(al1vr1, incongruent_mstrials, 1); % incongruent
matar1vl1=repmat(ar1vl1, incongruent_mstrials, 1);

% Auditory and Visual level 2
matal2vl2=repmat(al2vl2, congruent_mstrials, 1); % congreunt
matar2vr2=repmat(ar2vr2, congruent_mstrials, 1);

matal2vr2=repmat(al2vr2, incongruent_mstrials, 1); % incongruent
matar2vl2=repmat(ar2vl2, incongruent_mstrials, 1);

% Auditory and Visual level 3
matal3vl3=repmat(al3vl3, congruent_mstrials, 1); % congreunt
matar3vr3=repmat(ar3vr3, congruent_mstrials, 1);

matal3vr3=repmat(al3vr3, incongruent_mstrials, 1); % incongruent
matar3vl3=repmat(ar3vl3, incongruent_mstrials, 1);

% Auditory and Visual level 4

matal4vl4=repmat(al4vl4, congruent_mstrials, 1); % congreunt
matar4vr4=repmat(ar4vr4, congruent_mstrials, 1);

matal4vr4=repmat(al4vr4, incongruent_mstrials, 1); % incongruent
matar4vl4=repmat(ar4vl4, incongruent_mstrials, 1);

% Auditory and Visual level 5

matal5vl5=repmat(al5vl5, congruent_mstrials, 1); % congreunt
matar5vr5=repmat(ar5vr5, congruent_mstrials, 1);

matal5vr5=repmat(al5vr5, incongruent_mstrials, 1); % incongruent
matar5vl5=repmat(ar5vl5, incongruent_mstrials, 1);

% Auditory and Visual level 6

matal6vl6=repmat(al6vl6, congruent_mstrials, 1); % congreunt
matar6vr6=repmat(ar6vr6, congruent_mstrials, 1);

matal6vr6=repmat(al6vr6, incongruent_mstrials, 1); % incongruent
matar6vl6=repmat(ar6vl6, incongruent_mstrials, 1);

% Auditory and Visual level 7

matal7vl7=repmat(al7vl7, congruent_mstrials, 1); % congreunt
matar7vr7=repmat(ar7vr7, congruent_mstrials, 1);

matal7vr7=repmat(al7vr7, incongruent_mstrials, 1); % incongruent
matar7vl7=repmat(ar7vl7, incongruent_mstrials, 1);

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
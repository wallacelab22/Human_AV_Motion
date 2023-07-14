function data_output = at_generateMatrix(catchtrials, audtrials, audInfo)

%% fill single columns
%condition definitions 
% variable names: 1. modlaity (a, v, av), 2. direction (l:left; u:up),
% 3.coherence (l:low, m:middle, h:high or ordianl number codes)
% matrix values: auditory direction, auditory coherence, visual direction,
% visual coherence

left_var = 2;
right_var = 1;

% catch trials
catchs=[0 0];

% Stimulus [direction coherence]
for i = 1:length(audInfo.cohSet)
    right_var_name = strcat('stim_right_', num2str(i));
    eval([right_var_name, ' = [right_var audInfo.cohSet(i)];'])

    left_var_name = strcat('stim_left_', num2str(i));
    eval([left_var_name, ' = [left_var audInfo.cohSet(i)];'])
end
sl1=[2 audInfo.cohSet(1)];
sr1=[1 audInfo.cohSet(1)];

sl2=[2 audInfo.cohSet(2)];
sr2=[1 audInfo.cohSet(2)];

sl3=[2 audInfo.cohSet(3)];
sr3=[1 audInfo.cohSet(3)];

sl4=[2 audInfo.cohSet(4)];
sr4=[1 audInfo.cohSet(4)];

sl5=[2 audInfo.cohSet(5)];
sr5=[1 audInfo.cohSet(5)];

sl6=[2 audInfo.cohSet];
sr6=[1 6];

sl7=[2 7];
sr7=[1 7];

%% create Matrices
%catch trials
catchmat=repmat(catchs, catchtrials, 1);

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

%concatenate all conditions into 1 big matrix
trialStruc= cat(1, catchmat, matal1, matar1, matal2, matar2, matal3, matar3, matal4, matar4, matal5, matar5, matal6, matar6, matal7, matar7);

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

data_output = cat(2, trialOrder, resp, rt, keys);

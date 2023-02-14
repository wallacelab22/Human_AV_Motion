% function at_dataanalysis
% homedirectory='/home/thelena/Dropbox/scripts/RDK Antonia/';
homedirectory='Z:\Antonia\RDK\';
load([homedirectory 'RDKdata_02_01_1_29.mat']);


%% get audio data independently of rest
audioleft=find(MAT(:,1)==1);
audioright=find(MAT(:,1)==2);

tmp = zeros(size(audioleft,1), 6);
for ii = 1:length(tmp)
    tmp(ii,:) = MAT(audioleft(ii,:),:);
end
audioleft = tmp;

tmp = zeros(size(audioright,1), 6);
for ii = 1:length(tmp)
    tmp(ii,:) = MAT(audioright(ii,:),:);
end
audioright = tmp;

%% divide into unisensory & multisensory congruent and incongruent
audleft_novis = find(audioleft(:,3)==0);
audright_novis = find(audioleft(:,3)==0);

audleft_visleft = find(audioleft(:,3)==1);
audright_visright = find(audioright(:,3)==2);

audright_visleft = find(audioright(:,3)==1);
audleft_visright = find(audioleft(:,3)==2);

tmp = zeros(size(audleft_novis,1), 6);
for ii = 1:length(tmp)
    tmp(ii,:) = audioleft(audleft_novis(ii,:),:);
end
audleft_novis = tmp;

tmp = zeros(size(audright_novis,1), 6);
for ii = 1:length(tmp)
    tmp(ii,:) = audioright(audright_novis(ii,:),:);
end
audright_novis = tmp;

tmp = zeros(size(audleft_visleft,1), 6);
for ii = 1:length(tmp)
    tmp(ii,:) = audioleft(audleft_visleft(ii,:),:);
end
audleft_visleft = tmp;

tmp = zeros(size(audleft_visright,1), 6);
for ii = 1:length(tmp)
    tmp(ii,:) = audioleft(audleft_visright(ii,:),:);
end
audleft_visright = tmp;

tmp = zeros(size(audright_visleft,1), 6);
for ii = 1:length(tmp)
    tmp(ii,:) = audioright(audright_visleft(ii,:),:);
end
audright_visleft = tmp;

tmp = zeros(size(audright_visright,1), 6);
for ii = 1:length(tmp)
    tmp(ii,:) = audioright(audright_visright(ii,:),:);
end
audright_visright = tmp;

%% get the different coherence levels

audleft1_novis = find(audleft_novis(:,2)==1);
audleft2_novis = find(audleft_novis(:,2)==2);
audleft3_novis = find(audleft_novis(:,2)==3);
audleft4_novis = find(audleft_novis(:,2)==4);
audleft5_novis = find(audleft_novis(:,2)==5);

audright1_novis = find(audright_novis(:,2)==1);
audright2_novis = find(audright_novis(:,2)==2);
audright3_novis = find(audright_novis(:,2)==3);
audright4_novis = find(audright_novis(:,2)==4);
audright5_novis = find(audright_novis(:,2)==5);

tmp = zeros(size(audleft1_novis,1), 6);
for ii = 1:length(tmp)
    tmp(ii,:) = audleft_novis(audleft1_novis(ii,:),:);
end
audleft1_novis = tmp;

tmp = zeros(size(audleft2_novis,1), 6);
for ii = 1:length(tmp)
    tmp(ii,:) = audleft_novis(audleft2_novis(ii,:),:);
end
audleft2_novis = tmp;

tmp = zeros(size(audleft3_novis,1), 6);
for ii = 1:length(tmp)
    tmp(ii,:) = audleft_novis(audleft3_novis(ii,:),:);
end
audleft3_novis = tmp;

tmp = zeros(size(audleft4_novis,1), 6);
for ii = 1:length(tmp)
    tmp(ii,:) = audleft_novis(audleft4_novis(ii,:),:);
end
audleft4_novis = tmp;

tmp = zeros(size(audleft5_novis,1), 6);
for ii = 1:length(tmp)
    tmp(ii,:) = audleft_novis(audleft5_novis(ii,:),:);
end
audleft5_novis = tmp;

tmp = zeros(size(audright1_novis,1), 6);
for ii = 1:length(tmp)
    tmp(ii,:) = audright_novis(audright1_novis(ii,:),:);
end
audright1_novis = tmp;

tmp = zeros(size(audright2_novis,1), 6);
for ii = 1:length(tmp)
    tmp(ii,:) = audright_novis(audright2_novis(ii,:),:);
end
audright2_novis = tmp;

tmp = zeros(size(audright3_novis,1), 6);
for ii = 1:length(tmp)
    tmp(ii,:) = audright_novis(audright3_novis(ii,:),:);
end
audright3_novis = tmp;

tmp = zeros(size(audright4_novis,1), 6);
for ii = 1:length(tmp)
    tmp(ii,:) = audright_novis(audright4_novis(ii,:),:);
end
audright4_novis = tmp;

tmp = zeros(size(audright5_novis,1), 6);
for ii = 1:length(tmp)
    tmp(ii,:) = audright_novis(audright5_novis(ii,:),:);
end
audright5_novis = tmp;

%% get correct data only
aud1=cat(1, audleft1_novis, audright1_novis);
aud2=cat(1, audleft2_novis, audright2_novis);
aud3=cat(1, audleft3_novis, audright3_novis);
aud4=cat(1, audleft4_novis, audright4_novis);
aud5=cat(1, audleft5_novis, audright5_novis);


maud1=(length(find(aud1(:,1) == aud1(:,5))))/length(aud1);
maud2=(length(find(aud2(:,1) == aud2(:,5))))/length(aud1);
maud3=(length(find(aud3(:,1) == aud3(:,5))))/length(aud1);
maud4=(length(find(aud4(:,1) == aud4(:,5))))/length(aud1);
maud5=(length(find(aud5(:,1) == aud5(:,5))))/length(aud1);

maud(1)=maud1*100;
maud(2)=maud2*100;
maud(3)=maud3*100;
maud(4)=maud4*100;
maud(5)=maud5*100;

% creat plot
x = [5,10,20,30,40]; % actual Acoh levels, plotted below
figure;plot(x,maud,'ok-');
xlim([0 45]);
ylim([0 100]);
xlabel('Auditory coherence level');
ylabel('Percent correct');


%% VISUAL only trials
audionoise=find(MAT(:,1)==0);

tmp = zeros(size(audionoise,1), 6);
for ii = 1:length(tmp)
    tmp(ii,:) = MAT(audionoise(ii,:),:);
end
audionoise = tmp;

noaud_visleft=find(audionoise(:, 3)==1);
noaud_visright=find(audionoise(:, 3)==2);
function MAT=at_RDKracemodelprep(subject)

for sub=1:length(subject)
    thissub=subject(sub)
    if length(num2str(thissub))==2
        subID=num2str(thissub);
    elseif length(num2str(thissub)) < 2
        subID = strcat(['0' num2str(thissub)]);
        
    end

    filename=strcat(['RDKdata_' subID '.mat']);
    load(filename);
% Dir = uigetdir; cd(Dir); load(uigetfile);

Aalone = MAT(MAT(:,4)==0,:); % find all trials with Vcoh = 0
for kk = 1:5 % 5 Acoh levels not including 0, i.e. no catch trials, looping over each Acoh levels
    Acoh = Aalone(Aalone(:,2)==kk,:); %  each Acoh level
    y(:, kk) = Acoh(:,6);% mean RT for correct trials only
 end

%% add visual only
Valone = MAT(MAT(:,2)==0,:); % find all trials with Acoh = 0

for vv = 1:2 % 2 Vcoh levels not including 0, i.e. no catch trials, looping over each Vcoh levels
    Vcoh = Valone(Valone(:,4)==vv,:); %  each Acoh level
    v(:,vv) = Vcoh(:,6); % mean RT for correct trials only
end
%% same as above, now with congruent visual levels

Vlow = MAT(MAT(:,4)==1,:); % all trials with low Vcoh
Vhigh = MAT(MAT(:,4)==2,:); % all trials with high Vcoh

tmp = Vlow(Vlow(:,1) == Vlow(:,3),:); % all Vlow congruent trials
tmp1=Vhigh(Vhigh(:,1) == Vhigh(:,3),:); % all Vhigh congruent trials

for kk=1:5
    Acoh_Vlow = tmp(tmp(:,2)==kk,:); % find each A-level
    ylow(:, kk) = Acoh_Vlow(:,6);
    Acoh_Vhigh = tmp1(tmp1(:,2)==kk,:);
    yhigh(:, kk)= Acoh_Vhigh(:,6);
end

%% INCONGRUENT same as above, now with congruent visual levels

Vlow = MAT(MAT(:,4)==1,:); % all trials with low Vcoh
Vhigh = MAT(MAT(:,4)==2,:); % all trials with high Vcoh

tmp = Vlow(Vlow(:,1) ~= Vlow(:,3),:); % all Vlow incongruent trials
tmp1=Vhigh(Vhigh(:,1) ~= Vhigh(:,3),:); % all Vhigh incongruent trials

for kk=1:5
    Acoh_Vlow = tmp(tmp(:,2)==kk,:); % find each A-level
    ylow2(:, kk) = Acoh_Vlow(:,6);
    Acoh_Vhigh = tmp1(tmp1(:,2)==kk,:);
    yhigh2(:, kk)= Acoh_Vhigh(:,6);
end

%% Conditions of interest
%unisensory
A1=y(:,1);
A1=round(A1(~isnan(A1))*1000);

A2=y(:,2);
A2=round(A2(~isnan(A2))*1000);

A3=y(:,3);
A3=round(A3(~isnan(A3))*1000);

A4=y(:,4);
A4=round(A4(~isnan(A4))*1000);

A5=y(:,5);
A5=round(A5(~isnan(A5))*1000);

Vl=v(:,1); 
Vl=round(Vl(~isnan(Vl))*1000);

Vh=v(:,2);
Vh=round(Vh(~isnan(Vh))*1000);

%congreunt
A1Vl=ylow(:,1);
A1Vl=round(A1Vl(~isnan(A1Vl))*1000);

A2Vl=ylow(:,2);
A2Vl=round(A2Vl(~isnan(A2Vl))*1000);

A3Vl=ylow(:,3);
A3Vl=round(A3Vl(~isnan(A3Vl))*1000);

A4Vl=ylow(:,4);
A4Vl=round(A4Vl(~isnan(A4Vl))*1000);

A5Vl=ylow(:,5);
A5Vl=round(A5Vl(~isnan(A5Vl))*1000);

A1Vh=yhigh(:,1);
A1Vh=round(A1Vh(~isnan(A1Vh))*1000);

A2Vh=yhigh(:,2);
A2Vh=round(A2Vh(~isnan(A2Vh))*1000);

A3Vh=yhigh(:,3);
A3Vh=round(A3Vh(~isnan(A3Vh))*1000);

A4Vh=yhigh(:,4);
A4Vh=round(A4Vh(~isnan(A4Vh))*1000);

A5Vh=yhigh(:,5);
A5Vh=round(A5Vh(~isnan(A5Vh))*1000);

%incongreunt
A1Vli=ylow2(:,1);
A1Vli=round(A1Vli(~isnan(A1Vli))*1000);

A2Vli=ylow2(:,2);
A2Vli=round(A2Vli(~isnan(A2Vli))*1000);

A3Vli=ylow2(:,3);
A3Vli=round(A3Vli(~isnan(A3Vli))*1000);

A4Vli=ylow2(:,4);
A4Vli=round(A4Vli(~isnan(A4Vli))*1000);

A5Vli=ylow2(:,5);
A5Vli=round(A5Vli(~isnan(A5Vli))*1000);

A1Vhi=yhigh2(:,1);
A1Vhi=round(A1Vhi(~isnan(A1Vhi))*1000);

A2Vhi=yhigh2(:,2);
A2Vhi=round(A2Vhi(~isnan(A2Vhi))*1000);

A3Vhi=yhigh2(:,3);
A3Vhi=round(A3Vhi(~isnan(A3Vhi))*1000);

A4Vhi=yhigh2(:,4);
A4Vhi=round(A4Vhi(~isnan(A4Vhi))*1000);

A5Vhi=yhigh2(:,5);
A5Vhi=round(A5Vhi(~isnan(A5Vhi))*1000);

%% RaceModel

P=[1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
P=P/10;

%incongruent RACEMODEL

figure;
subplot(3, 2, 1);
[A1p, Vlp, A1Vlip, A1plusVli] = RaceModel(A1, Vl, A1Vli, P);
title('A(5%) - V(6%) incongruent', 'FontSize', 12)
subplot(3, 2, 2);
[A2p, Vlp, A2Vlip, A2plusVli] = RaceModel(A2, Vl, A2Vli, P);
title('A(10%) - V(6%) incongruent', 'FontSize', 12)
subplot(3,2,3);
[A3p, Vlp, A3Vlip, A3plusVli] = RaceModel(A3, Vl, A3Vli, P);
title('A(20%) - V(6%) incongruent', 'FontSize', 12)
subplot(3,2,4);
[A4p, Vlp, A4Vlip, A4plusVli] = RaceModel(A4, Vl, A4Vli, P);
title('A(30%) - V(6%) incongruent', 'FontSize', 12)
subplot(3,2,5);
[A5p, Vlp, A5Vlip, A5plusVli] = RaceModel(A5, Vl, A5Vli, P);
title('A(40%) - V(6%) incongruent', 'FontSize', 12)
% 
figure;
subplot(3,2,1);
[A1p, Vhp, A1Vhip, A1plusVhi] = RaceModel(A1, Vh, A1Vhi, P);
title('A(5%) - V(60%) incongruent', 'FontSize', 12)
subplot(3,2,2);
[A2p, Vhp, A2Vhip, A2plusVhi] = RaceModel(A2, Vh, A2Vhi, P);
title('A(10%) - V(60%) incongruent', 'FontSize', 12)
subplot(3,2,3);
[A3p, Vhp, A3Vhip, A3plusVhi] = RaceModel(A3, Vh, A3Vhi, P);
title('A20%) - V(60%) incongruent', 'FontSize', 12)
subplot(3,2,4);
[A4p, Vhp, A4Vhip, A4plusVhi] = RaceModel(A4, Vh, A4Vhi, P);
title('A(30%) - V(60%) incongruent', 'FontSize', 12)
subplot(3,2,5);
[A5p, Vhp, A5Vhip, A5plusVhi] = RaceModel(A5, Vh, A5Vhi, P);
title('A(40%) - V(60%) incongruent', 'FontSize', 12)


% %congruent RACEMODEL
figure;
subplot(3,2,1)
[A1p, Vlp, A1Vlp, A1plusVl] = RaceModel(A1, Vl, A1Vl, P);
title('A(5%) - V(6%) congruent', 'FontSize', 12)
subplot(3,2,2)
[A2p, Vlp, A2Vlp, A2plusVl] = RaceModel(A2, Vl, A2Vl, P);
title('A(10%) - V(6%) congruent', 'FontSize', 12)
subplot(3,2,3)
[A3p, Vlp, A3Vlp, A3plusVl] = RaceModel(A3, Vl, A3Vl, P);
title('A(20%) - V(6%) congruent', 'FontSize', 12)
subplot(3,2,4)
[A4p, Vlp, A4Vlp, A4plusVl] = RaceModel(A4, Vl, A4Vl, P);
title('A(30%) - V(6%) congruent', 'FontSize', 12)
subplot(3,2,5)
[A5p, Vlp, A5Vlp, A5plusVl] = RaceModel(A5, Vl, A5Vl, P);
title('A(40%) - V(6%) congruent', 'FontSize', 12)
% 
figure;
subplot(3,2,1)
[A1p, Vhp, A1Vhp, A1plusVh] = RaceModel(A1, Vh, A1Vh, P);
title('A(5%) - V(60%) congruent', 'FontSize', 12)
subplot(3,2,2)
[A2p, Vhp, A2Vhp, A2plusVh] = RaceModel(A2, Vh, A2Vh, P);
title('A(10%) - V(60%) congruent', 'FontSize', 12)
subplot(3,2,3)
[A3p, Vhp, A3Vhp, A3plusVh] = RaceModel(A3, Vh, A3Vh, P);
title('A(20%) - V(60%) congruent', 'FontSize', 12)
subplot(3,2,4)
[A4p, Vhp, A4Vhp, A4plusVh] = RaceModel(A4, Vh, A4Vh, P);
title('A(30%) - V(60%) congruent', 'FontSize', 12)
subplot(3,2,5)
[A5p, Vhp, A5Vhp, A5plusVh] = RaceModel(A5, Vh, A5Vh, P);
title('A(40%) - V(60%) congruent', 'FontSize', 12)

end

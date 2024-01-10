% function MAT=at_AV_congruent_pc_correct(subject)
% 
% for sub=1:length(subject)
%     thissub=subject(sub)
%     if length(num2str(thissub))==2
%         subID=num2str(thissub);
%     elseif length(num2str(thissub)) < 2
%         subID = strcat(['0' num2str(thissub)]);
%         
%     end
% 
%     filename=strcat(['RDKdata_' subID '.mat']);
%     load(filename);
% % % get directory with data, then select data file to load
Dir = uigetdir; cd(Dir); load(uigetfile);
   
% A alone condition, i.e. Vcoh = 0;
Aalone = MAT(MAT(:,4)==0,:); % find all trials with Vcoh = 0

for kk = 1:5 % 5 Acoh levels not including 0, i.e. no catch trials, looping over each Acoh levels
    Acoh = Aalone(Aalone(:,2)==kk,:); %  
    y(kk) = (length(find(Acoh(:,1)==Acoh(:,5)))/length(Acoh)); % %correct responses for each Acoh levels not including catch trials
end

x = [5,10,20,30,40]; % actual Acoh levels, plotted below
figure;subplot(2,1,1); plot(x,y,'ok-', 'LineWidth', 2);
xlim([0 45]); ylim([0 1]);
xlabel('Auditory coherence level');ylabel('p[Auditory Direction]');

%% same as above, now with congruent visual levels


Vlow = MAT(MAT(:,4)==1,:); % all trials with low Vcoh
Vhigh = MAT(MAT(:,4)==2,:); % all trials with high Vcoh

tmp = Vlow(Vlow(:,1) == Vlow(:,3),:); % all Vlow congruent trials
tmp1=Vhigh(Vhigh(:,1) == Vhigh(:,3),:); % all Vhigh congruent trials

for kk=1:5
    Acoh_Vlow = tmp(tmp(:,2)==kk,:); % find each A-level
    Acoh_Vhigh = tmp1(tmp1(:,2)==kk,:);
    ylow(kk) = length(find(Acoh_Vlow(:,1)==Acoh_Vlow(:,5)))/length(Acoh_Vlow); % correct trials
    yhigh(kk) = length(find(Acoh_Vhigh(:,1)==Acoh_Vhigh(:,5)))/length(Acoh_Vhigh);
end

hold on; plot(x,ylow,'ro-'); % V-low = red
subplot(2,1,1);plot(x,yhigh,'bo-'); % V-high = blue

%% multisensory incongruent


Vlow = MAT(MAT(:,4)==1,:); % all trials with low Vcoh
Vhigh = MAT(MAT(:,4)==2,:); % all trials with high Vcoh

tmp = Vlow(Vlow(:,1) ~= Vlow(:,3),:); % all Vlow congruent trials
tmp1=Vhigh(Vhigh(:,1) ~= Vhigh(:,3),:); % all Vhigh congruent trials

for kk=1:5
    Acoh_Vlow = tmp(tmp(:,2)==kk,:); % find each A-level
    Acoh_Vhigh = tmp1(tmp1(:,2)==kk,:);
    ylow2(kk) = length(find(Acoh_Vlow(:,1)==Acoh_Vlow(:,5)))/length(Acoh_Vlow); % correct trials
    yhigh2(kk) = length(find(Acoh_Vhigh(:,1)==Acoh_Vhigh(:,5)))/length(Acoh_Vhigh);
end

hold on; plot(x,ylow2,'ro-.'); % V-low = red
subplot(2,1,1);plot(x,yhigh2,'bo-.'); % V-high = blue
title('A-V trials');
legend('Auditory', 'AVc - visual low', 'AVc - visual high', 'AVi - visual low', 'AVi - visual high', 'Location', 'northwest')

%% V alone condition, i.e. Acoh = 0;

Valone = MAT(MAT(:,2)==0,:); % find all trials with Acoh = 0

for vv = 1:2 % 2 Vcoh levels not including 0, i.e. no catch trials, looping over each Vcoh levels
    Vcoh = Valone(Valone(:,4)==vv,:); %  
    v(vv) = (length(find(Vcoh(:,3)==Vcoh(:,5)))/length(Vcoh)); % %correct responses for each Acoh levels not including catch trials
end

x = [6, 60]; % actual Vcoh levels, plotted below
subplot(2,1,2);plot(x,v,'ok-', 'LineWidth', 2);
xlim([0 70]); ylim([0 1]);
xlabel('Visual Motion coherence level');ylabel('p[Visual Direction]');
legend('Visual', 'Location', 'northwest')
        
results=cat(2,v, y, ylow, yhigh, ylow2, yhigh2);


%% get response BIAS (button press on catch trials)
Catch = MAT(MAT(:,4)==0,:); % find all trials with Vcoh = 0
Zerocoh = Catch(Catch(:,2)==0,:); %     
c = length(Zerocoh(Zerocoh(:,5)==1))/length(Zerocoh(~isnan(Zerocoh(:,5)))); % %correct responses for each Acoh levels not including catch trials

b=1;
figure; H=bar(b,c);
ylim([0 1]);xlim([0 2]);
xlabel('Catch Trials');ylabel('p[LEFTARROW Response]');
% end


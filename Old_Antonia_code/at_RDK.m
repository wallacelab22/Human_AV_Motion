function MAT=at_RDK(subject)
% get directory with data, then select data file to load
% Dir = uigetdir; cd(Dir);

for sub=1:length(subject)
    thissub=subject(sub)
    if length(num2str(thissub))==2
        subID=num2str(thissub);
    elseif length(num2str(thissub)) < 2
        subID = strcat(['0' num2str(thissub)]);
        
    end

    filename=strcat(['RDKdata_' subID '.mat']);
    load(filename);
    % A alone condition, i.e. Vcoh = 0;
    Aalone = MAT(MAT(:,4)==0,:); % find all trials with Vcoh = 0
    
    for kk = 1:5 % 5 Acoh levels not including 0, i.e. no catch trials, looping over each Acoh levels
        Acoh = Aalone(Aalone(:,2)==kk,:); %
        y(kk) = (length(find(Acoh(:,1)==Acoh(:,5)))/length(Acoh)); % %correct responses for each Acoh levels not including catch trials
    end
    
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
    
    %% V alone condition, i.e. Acoh = 0;
    Valone = MAT(MAT(:,2)==0,:); % find all trials with Acoh = 0
    
    for vv = 1:2 % 2 Vcoh levels not including 0, i.e. no catch trials, looping over each Vcoh levels
        Vcoh = Valone(Valone(:,4)==vv,:); %
        v(vv) = (length(find(Vcoh(:,3)==Vcoh(:,5)))/length(Vcoh)); % %correct responses for each Acoh levels not including catch trials
    end
    
    %% get response BIAS (button press on catch trials)
    Catch = MAT(MAT(:,4)==0,:); % find all trials with Vcoh = 0
    Zerocoh = Catch(Catch(:,2)==0,:); %
    c = length(Zerocoh(Zerocoh(:,5)==1))/length(Zerocoh(~isnan(Zerocoh(:,5)))); % %correct responses for each Acoh levels not including catch trials
    
    Bias(sub, :)=c;
    Visual(sub,:)=v;
    Audio(sub,:)=y;
    AVc(sub,:)=cat(2,ylow, yhigh);
    AVi(sub,:)=cat(2,ylow2, yhigh2);
end
save('Bias_MS.mat', 'Bias')
save('Visual_MS.mat', 'Visual')
save('Auditory_MS.mat', 'Audio')
save('AVc_MS.mat', 'AVc')
save('AVi_MS.mat', 'AVi')
